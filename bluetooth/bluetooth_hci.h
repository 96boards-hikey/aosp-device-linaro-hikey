//
// Copyright 2017 The Android Open Source Project
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

#pragma once

#include <android/hardware/bluetooth/1.0/IBluetoothHci.h>

#include <hidl/MQDescriptor.h>

#include "async_fd_watcher.h"
#include "hci_packetizer_hikey.h"

namespace android {
namespace hardware {
namespace bluetooth {
namespace V1_0 {
namespace hikey {

using ::android::hardware::Return;
using ::android::hardware::hidl_vec;

class BluetoothHci : public IBluetoothHci {
 public:
  Return<void> initialize(
      const ::android::sp<IBluetoothHciCallbacks>& cb) override;
  Return<void> sendHciCommand(const hidl_vec<uint8_t>& packet) override;
  Return<void> sendAclData(const hidl_vec<uint8_t>& packet) override;
  Return<void> sendScoData(const hidl_vec<uint8_t>& packet) override;
  Return<void> close() override;

  static void OnPacketReady();

  static BluetoothHci* get();

 private:
  ::android::sp<IBluetoothHciCallbacks> event_cb_;
  int hci_tty_fd_;

  void HandleIncomingPacket();

  async::AsyncFdWatcher fd_watcher_;

  HciPacketizerHikey hci_packetizer_{BluetoothHci::OnPacketReady};
};

}  // namespace hikey
}  // namespace V1_0
}  // namespace bluetooth
}  // namespace hardware
}  // namespace android
