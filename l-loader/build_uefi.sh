#!/bin/sh
#BUILD_OPTION=DEBUG
BUILD_OPTION=RELEASE
SELECT_GCC=LINARO_GCC_7_1    # Prefer to use Linaro GCC 7.1.1. Otherwise, user may meet some toolchain issues.
#GENERATE_PTABLE=1

# Setup environment variables that are used in uefi-tools
case "${SELECT_GCC}" in
"ARNDROID_GCC_4_9")
	AARCH64_GCC_4_9=/opt/toolchain/aarch64-linux-android-4.9.git/bin/
	PATH=${AARCH64_GCC_4_9}:${PATH} && export PATH
	export AARCH64_TOOLCHAIN=GCC49
	CROSS_COMPILE=aarch64-linux-android-
	;;
"LINARO_GCC_4_8")
	AARCH64_GCC_4_8=/opt/toolchain/gcc-linaro-aarch64-linux-gnu-4.8-2014.04_linux/bin/
	PATH=${AARCH64_GCC_4_8}:${PATH} && export PATH
	export AARCH64_TOOLCHAIN=GCC48
	CROSS_COMPILE=aarch64-linux-gnu-
	;;
"LINARO_GCC_4_9")
	AARCH64_GCC_4_9=/opt/toolchain/gcc-linaro-4.9-2014.11-x86_64_aarch64-linux-gnu/bin/
	PATH=${AARCH64_GCC_4_9}:${PATH} && export PATH
	export AARCH64_TOOLCHAIN=GCC49
	CROSS_COMPILE=aarch64-linux-gnu-
	;;
"LINARO_GCC_5_3")
	AARCH64_GCC_5_3=/opt/toolchain/gcc-linaro-5.3.1-2016.05-x86_64_aarch64-linux-gnu/bin/
	PATH=${AARCH64_GCC_5_3}:${PATH} && export PATH
	export AARCH64_TOOLCHAIN=GCC5
	CROSS_COMPILE=aarch64-linux-gnu-
	;;
"LINARO_GCC_5_4")
	AARCH64_GCC_5_4=/opt/toolchain/gcc-linaro-5.4.1-2017.05-i686_aarch64-linux-gnu/bin/
	PATH=${AARCH64_GCC_5_4}:${PATH} && export PATH
	export AARCH64_TOOLCHAIN=GCC5
	CROSS_COMPILE=aarch64-linux-gnu-
	;;
"LINARO_GCC_6_4")
	AARCH64_GCC_6_4=/opt/toolchain/gcc-linaro-6.4.1-2017.08-x86_64_aarch64-linux-gnu/bin/
	PATH=${AARCH64_GCC_6_4}:${PATH} && export PATH
	export AARCH64_TOOLCHAIN=GCC5
	CROSS_COMPILE=aarch64-linux-gnu-
	;;
"LINARO_GCC_7_1")
	AARCH64_GCC_7_1=/opt/toolchain/gcc-linaro-7.1.1-2017.08-x86_64_aarch64-linux-gnu/bin/
	PATH=${AARCH64_GCC_7_1}:${PATH} && export PATH
	export AARCH64_TOOLCHAIN=GCC5
	CROSS_COMPILE=aarch64-linux-gnu-
	;;
*)
	echo "Not supported toolchain:${SELECT_GCC}"
	exit
	;;
esac

case "$1" in
"hikey")
	PLATFORM=hikey
	;;
"hikey960")
	PLATFORM=hikey960
	;;
"hikey970")
	PLATFORM=hikey970
	;;
"")
	# If $1 is empty, set ${PLATFORM} as hikey960 by default.
	PLATFORM=hikey960
	;;
*)
	echo "Not supported platform:$1"
	exit
	;;
esac

if [ -d "${PWD}/edk2" ] && [ -d "${PWD}/uefi-tools" ] && [ -d "${PWD}/arm-trusted-firmware" ] && [ -d "${PWD}/l-loader" ]; then
	# Check whether source code are available in ${PWD}
	BUILD_PATH=${PWD}
	echo "Find source code in ${PWD}"
elif [ -d "${PWD}/../edk2" ] && [ -d "${PWD}/../uefi-tools" ] && [ -d "${PWD}/../arm-trusted-firmware" ] && [ -d "${PWD}/../l-loader" ]; then
	# Check whether source code are available in parent of ${PWD}
	BUILD_PATH=$(dirname ${PWD})
	echo "Find source code in parent directory of ${PWD}"
elif [ -d "${PWD}/device/linaro/bootloader/edk2" ] && [ -d "${PWD}/device/linaro/hikey/uefi-tools" ] && [ -d "${PWD}/device/linaro/bootloader/arm-trusted-firmware" ] && [ -d "${PWD}/device/linaro/hikey/l-loader" ]; then
	# Check whether source code are available in the other of ${PWD}
	BUILD_PATH=${PWD}
	echo "Find source code in parent directory of ${PWD}"
else
	echo "Warning: Can't find source code to build."
	exit
fi

# Setup environment variables that are used in uefi-tools
export UEFI_TOOLS_DIR=${BUILD_PATH}/device/linaro/hikey/uefi-tools

EDK2_DIR=${BUILD_PATH}/device/linaro/bootloader/edk2
echo "edk2 dir:${EDK2_DIR}"
export EDK2_DIR

case "$PLATFORM" in
"hikey")
	# Check whether fastboot source code is available in ${BUILD_PATH}
	if [ ! -d "${BUILD_PATH}/device/linaro/bootloader/atf-fastboot" ]; then
		echo "Warning: Can't find fastboot source code to build"
		exit
	fi
	EDK2_OUTPUT_DIR=${EDK2_DIR}/Build/HiKey/${BUILD_OPTION}_${AARCH64_TOOLCHAIN}
	cd ${BUILD_PATH}
	;;
"hikey960")
	EDK2_OUTPUT_DIR=${EDK2_DIR}/Build/HiKey960/${BUILD_OPTION}_${AARCH64_TOOLCHAIN}
	cd ${BUILD_PATH}
	;;
"hikey970")
	EDK2_OUTPUT_DIR=${EDK2_DIR}/Build/HiKey970/${BUILD_OPTION}_${AARCH64_TOOLCHAIN}
	cd ${BUILD_PATH}
	;;
esac

# Fip.bin is produced in ${EDK2_OUTPUT_DIR}. And ${EDK2_OUTPUT_DIR} is local environment variable.
echo $EDK2_OUTPUT_DIR

# Always clean build EDK2
rm -f ${BUILD_PATH}/device/linaro/hikey/l-loader/l-loader.bin
rm -fr ${BUILD_PATH}/device/linaro/bootloader/arm-trusted-firmware/build
rm -fr ${BUILD_PATH}/atf-fastboot/build
cd ${EDK2_DIR}/BaseTools
make clean
rm -fr ${EDK2_DIR}/Build/
rm -f ${EDK2_OUTPUT_DIR}/FV/bl1.bin
rm -f ${EDK2_OUTPUT_DIR}/FV/fip.bin
rm -f ${EDK2_OUTPUT_DIR}/FV/BL33_AP_UEFI.fd
sync

echo "Start to build ${PLATFORM} Bootloader..."

case "${BUILD_OPTION}" in
"DEBUG")
	echo "Debug build"
	BUILD_DEBUG=1
	;;
"RELEASE")
	echo "Release build"
	BUILD_DEBUG=0
	;;
* )
	echo "Invalid build mode"
	exit
	;;
esac

# Build fastboot for HiKey
case "${PLATFORM}" in
"hikey")
	cd ${BUILD_PATH}/atf-fastboot
	CROSS_COMPILE=${CROSS_COMPILE} make PLAT=${PLATFORM} DEBUG=${BUILD_DEBUG}
	if [ $? != 0 ]; then
		echo "Fail to build fastboot ($?)"
		exit
	fi
	# Convert "DEBUG"/"RELEASE" to "debug"/"release"
	FASTBOOT_BUILD_OPTION=$(echo ${BUILD_OPTION} | tr '[A-Z]' '[a-z]')
	if [ -f ${BUILD_PATH}/atf-fastboot/build/${PLATFORM}/${FASTBOOT_BUILD_OPTION}/bl1.bin ]; then
		cd ${BUILD_PATH}/l-loader
		ln -sf ${BUILD_PATH}/atf-fastboot/build/${PLATFORM}/${FASTBOOT_BUILD_OPTION}/bl1.bin fastboot.bin
	else
		echo "ERROR: Can't find fastboot binary"
		exit
	fi
	;;
esac

# Build UEFI & ARM Trusted Firmware
cd ${EDK2_DIR}
ln -sf ../OpenPlatformPkg
#${UEFI_TOOLS_DIR}/uefi-build.sh -b $BUILD_OPTION -a ../arm-trusted-firmware -s ../optee_os $PLATFORM
${UEFI_TOOLS_DIR}/uefi-build.sh -b $BUILD_OPTION -a ../arm-trusted-firmware $PLATFORM
if [ $? != 0 ]; then
	echo "Fail to build UEFI & ARM Trusted Firmware ($?)"
	exit
fi

# Locate output files of UEFI & Arm Trust Firmware
cd ${BUILD_PATH}/device/linaro/hikey/l-loader
ln -sf ${EDK2_OUTPUT_DIR}/FV/bl1.bin
ln -sf ${EDK2_OUTPUT_DIR}/FV/fip.bin
if [ -f ${EDK2_OUTPUT_DIR}/FV/BL33_AP_UEFI.fd ]; then
	ln -sf ${EDK2_OUTPUT_DIR}/FV/BL33_AP_UEFI.fd
fi

case "${PLATFORM}" in
"hikey")
	# Patch ARM64 mode by l-loader
	make -f ${PLATFORM}.mk l-loader.bin

	# Generate partition table
	if [ $GENERATE_PTABLE ]; then
		PTABLE=aosp-8g SECTOR_SIZE=512 bash -x generate_ptable.sh
	fi

	;;
"hikey960")
	# Pack bl1.bin and BL33 together
	make -f ${PLATFORM}.mk l-loader.bin

	# Generate partition table with a patched sgdisk to force
	# default alignment (2048) and sector size (4096)
	if [ $GENERATE_PTABLE ]; then
		PTABLE=aosp-32g SECTOR_SIZE=4096 SGDISK=./sgdisk bash -x generate_ptable.sh
	fi
	;;
"hikey970")
	# Pack bl1.bin and BL33 together
	make -f ${PLATFORM}.mk

	# Generate partition table with a patched sgdisk to force
	# default alignment (2048) and sector size (4096)
	if [ $GENERATE_PTABLE ]; then
		PTABLE=aosp-32g SECTOR_SIZE=4096 SGDISK=./sgdisk bash -x generate_ptable.sh
	fi
	;;
esac
