//
// Copyright 2016 The Android Open Source Project
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#define LOG_TAG "android.hardware.bluetooth@1.0.hikey"

#include "bluetooth_hci.h"

#include <utils/Log.h>

#include <android-base/logging.h>

#include "hci_internals.h"

namespace {

using android::hardware::bluetooth::V1_0::hikey::BluetoothHci;
using android::hardware::hidl_vec;

BluetoothHci* g_bluetooth_hci = nullptr;

size_t write_safely(int fd, const uint8_t* data, size_t length) {
  size_t transmitted_length = 0;
  while (length > 0) {
    ssize_t ret =
        TEMP_FAILURE_RETRY(write(fd, data + transmitted_length, length));

    if (ret == -1) {
      if (errno == EAGAIN) continue;
      ALOGE("%s error writing to UART (%s)", __func__, strerror(errno));
      break;

    } else if (ret == 0) {
      // Nothing written :(
      ALOGE("%s zero bytes written - something went wrong...", __func__);
      break;
    }

    transmitted_length += ret;
    length -= ret;
  }

  return transmitted_length;
}

}  // namespace

namespace android {
namespace hardware {
namespace bluetooth {
namespace V1_0 {
namespace hikey {

Return<void> BluetoothHci::initialize(
    const ::android::sp<IBluetoothHciCallbacks>& cb) {
  ALOGI("BluetoothHci::initialize()");

  CHECK(cb != nullptr);
  event_cb_ = cb;

  hci_tty_fd_ = open("/dev/hci_tty", O_RDWR);
  if (hci_tty_fd_ < 0) {
    ALOGE("%s: Can't open hci_tty", __func__);
    event_cb_->initializationComplete(Status::INITIALIZATION_ERROR);
  }

  CHECK(g_bluetooth_hci == nullptr) << __func__ << " is not reentrant";
  g_bluetooth_hci = this;

  fd_watcher_.WatchFdForNonBlockingReads(
      hci_tty_fd_, [this](int fd) { hci_packetizer_.OnDataReadyHikey(fd); });

  event_cb_->initializationComplete(Status::SUCCESS);
  return Void();
}

Return<void> BluetoothHci::close() {
  ALOGW("BluetoothHci::close()");
  ::close(hci_tty_fd_);
  hci_tty_fd_ = -1;
  g_bluetooth_hci = nullptr;
  return Void();
}

Return<void> BluetoothHci::sendHciCommand(const hidl_vec<uint8_t>& packet) {
  uint8_t type = HCI_PACKET_TYPE_COMMAND;
  int rv = write_safely(hci_tty_fd_, &type, sizeof(type));
  if (rv == sizeof(type))
    rv = write_safely(hci_tty_fd_, packet.data(), packet.size());
  return Void();
}

Return<void> BluetoothHci::sendAclData(const hidl_vec<uint8_t>& packet) {
  uint8_t type = HCI_PACKET_TYPE_ACL_DATA;
  int rv = write_safely(hci_tty_fd_, &type, sizeof(type));
  if (rv == sizeof(type))
    rv = write_safely(hci_tty_fd_, packet.data(), packet.size());
  return Void();
}

Return<void> BluetoothHci::sendScoData(const hidl_vec<uint8_t>& packet) {
  uint8_t type = HCI_PACKET_TYPE_SCO_DATA;
  int rv = write_safely(hci_tty_fd_, &type, sizeof(type));
  if (rv == sizeof(type))
    rv = write_safely(hci_tty_fd_, packet.data(), packet.size());
  return Void();
}

BluetoothHci* BluetoothHci::get() { return g_bluetooth_hci; }

void BluetoothHci::OnPacketReady() {
  BluetoothHci::get()->HandleIncomingPacket();
}

void BluetoothHci::HandleIncomingPacket() {
  HciPacketType hci_packet_type = hci_packetizer_.GetPacketType();
  hidl_vec<uint8_t> hci_packet = hci_packetizer_.GetPacket();

  switch (hci_packet_type) {
    case HCI_PACKET_TYPE_EVENT:
      event_cb_->hciEventReceived(hci_packet);
      break;
    case HCI_PACKET_TYPE_ACL_DATA:
      event_cb_->aclDataReceived(hci_packet);
      break;
    case HCI_PACKET_TYPE_SCO_DATA:
      event_cb_->scoDataReceived(hci_packet);
      break;
    default: {
      bool hci_packet_type_corrupted = true;
      CHECK(hci_packet_type_corrupted == false);
    }
  }
}

}  // namespace hikey
}  // namespace V1_0
}  // namespace bluetooth
}  // namespace hardware
}  // namespace android
