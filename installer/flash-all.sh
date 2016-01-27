#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "Provide the right /dev/ttyUSBX specific to recovery device"
    exit
fi

if [ ! -e $1 ]
  then
    echo "device: $1 does not exist"
    exit
fi

PTABLE=ptable-aosp-8g.img
if [ $# -gt 1 ]
  then
    if [ $2 == '4g' ]
      then
        PTABLE=ptable-aosp-4g.img
    fi
fi

INSTALLER_DIR="`dirname $0`"
ANDROID_TOP=${INSTALLER_DIR}/../../../../
python ${INSTALLER_DIR}/hisi-idt.py --img1=${INSTALLER_DIR}/l-loader.bin -d ${1}
fastboot flash ptable ${INSTALLER_DIR}/${PTABLE}
fastboot flash fastboot ${INSTALLER_DIR}/fip.bin
fastboot flash nvme ${INSTALLER_DIR}/nvme.img
fastboot flash boot ${ANDROID_TOP}/out/target/product/hikey/boot_fat.uefi.img
fastboot flash system ${ANDROID_TOP}/out/target/product/hikey/system.img
fastboot flash cache ${ANDROID_TOP}/out/target/product/hikey/cache.img
fastboot flash userdata ${ANDROID_TOP}/out/target/product/hikey/userdata.img
