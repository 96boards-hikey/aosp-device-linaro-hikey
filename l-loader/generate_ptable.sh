#!/bin/sh
#
# Generate partition table for HiKey eMMC or HiKey960 UFS
#
# tiny: for testing purpose.
# aosp: (same as linux with userdata).
# linux: (same as aosp without userdata).
# swap: (similar to asop, drop reserved, 1.5G of swap)

PTABLE=${PTABLE:-aosp}
SECTOR_SIZE=${SECTOR_SIZE:-512}
SGDISK=${SGDISK:-sgdisk}
TEMP_FILE=$(mktemp /tmp/${PTABLE}.XXXXXX)
# 128 entries at most
ENTRIES_IN_SECTOR=$(expr ${SECTOR_SIZE} / 128)
ENTRY_SECTORS=$(expr 128 / ${ENTRIES_IN_SECTOR})
PRIMARY_SECTORS=$(expr ${ENTRY_SECTORS} + 2)
SECONDARY_SECTORS=$(expr ${ENTRY_SECTORS} + 1)

case ${PTABLE} in
  tiny)
    SECTOR_NUMBER=81920
    ;;
  aosp-4g|linux-4g)
    SECTOR_NUMBER=7471104
    ;;
  aosp-8g|linux-8g|swap-8g)
    SECTOR_NUMBER=15269888
    ;;
  aosp-32g*|linux-32g)
    SECTOR_NUMBER=62447650    # count with 512-byte block size
    ;;
  aosp-64g|linux-64g)
    SECTOR_NUMBER=124895300   # count with 512-byte block size
    ;;
esac

SECTOR_ALIGNMENT=$(expr ${SECTOR_SIZE} / 512)
SECTOR_NUMBER=$(expr '(' ${SECTOR_NUMBER} '*' 512 + ${SECTOR_SIZE} - 1 ')' / ${SECTOR_SIZE})

# get the partition table
case ${PTABLE} in
  tiny)
    dd if=/dev/zero of=${TEMP_FILE} bs=${SECTOR_SIZE} count=${SECTOR_NUMBER} conv=sparse
    fakeroot ${SGDISK} -U -R -v ${TEMP_FILE}
    fakeroot ${SGDISK} -n 1:2048:4095 -t 1:0700 -u 1:F9F21F01-A8D4-5F0E-9746-594869AEC3E4 -c 1:"vrl" -p ${TEMP_FILE}
    fakeroot ${SGDISK} -n 2:4096:6143 -t 2:0700 -u 2:F9F21F02-A8D4-5F04-9746-594869AEC3E4 -c 2:"vrl_backup" -p ${TEMP_FILE}
    ;;
  aosp-4g|aosp-8g)
    dd if=/dev/zero of=${TEMP_FILE} bs=${SECTOR_SIZE} count=${SECTOR_NUMBER} conv=sparse
    fakeroot ${SGDISK} -U 2CB85345-6A91-4043-8203-723F0D28FBE8 -v ${TEMP_FILE}
    #[1: vrl: 1M-2M]
    fakeroot ${SGDISK} -n 1:0:+1M -t 1:0700 -u 1:496847AB-56A1-4CD5-A1AD-47F4ACF055C9 -c 1:"vrl" ${TEMP_FILE}
    #[2: vrl_backup: 2M-3M]
    fakeroot ${SGDISK} -n 2:0:+1M -t 2:0700 -u 2:61A36FC1-8EFB-4899-84D8-B61642EFA723 -c 2:"vrl_backup" ${TEMP_FILE}
    #[3: mcuimage: 3M-4M]
    fakeroot ${SGDISK} -n 3:0:+1M -t 3:0700 -u 3:65007411-962D-4781-9B2C-51DD7DF22CC3 -c 3:"mcuimage" ${TEMP_FILE}
    #[4: fastboot: 4M-12M]
    fakeroot ${SGDISK} -n 4:0:+8M -t 4:EF02 -u 4:496847AB-56A1-4CD5-A1AD-47F4ACF055C9 -c 4:"fastboot" ${TEMP_FILE}
    #[5: nvme: 12M-14M]
    fakeroot ${SGDISK} -n 5:0:+2M -t 5:0700 -u 5:00354BCD-BBCB-4CB3-B5AE-CDEFCB5DAC43 -c 5:"nvme" ${TEMP_FILE}
    #[6: boot: 14M-78M]
    fakeroot ${SGDISK} -n 6:0:+64M -t 6:EF00 -u 6:5C0F213C-17E1-4149-88C8-8B50FB4EC70E -c 6:"boot" ${TEMP_FILE}
    #[7: reserved: 78M-334M]
    fakeroot ${SGDISK} -n 7:0:+256M -t 7:0700 -u 7:BED8EBDC-298E-4A7A-B1F1-2500D98453B7 -c 7:"reserved" ${TEMP_FILE}
    #[8: cache: 334M-590M]
    fakeroot ${SGDISK} -n 8:0:+256M -t 8:8301 -u 8:A092C620-D178-4CA7-B540-C4E26BD6D2E2 -c 8:"cache" ${TEMP_FILE}
    #[9: system: 590M-2126M]
    fakeroot ${SGDISK} -n 9:0:+1536M -t 9:8300 -u 9:FC56E345-2E8E-49AE-B2F8-5B9D263FE377 -c 9:"system" ${TEMP_FILE}
    #[10: userdata: 2126M-End]
    fakeroot ${SGDISK} -n -E -t 10:8300 -u 10:064111F6-463B-4CE1-876B-13F3684CE164 -c 10:"userdata" -p ${TEMP_FILE}
    ;;
  linux-4g|linux-8g)
    dd if=/dev/zero of=${TEMP_FILE} bs=${SECTOR_SIZE} count=${SECTOR_NUMBER} conv=sparse
    fakeroot ${SGDISK} -U 2CB85345-6A91-4043-8203-723F0D28FBE8 -v ${TEMP_FILE}
    #[1: vrl: 1M-2M]
    fakeroot ${SGDISK} -n 1:0:+1M -t 1:0700 -u 1:496847AB-56A1-4CD5-A1AD-47F4ACF055C9 -c 1:"vrl" ${TEMP_FILE}
    #[2: vrl_backup: 2M-3M]
    fakeroot ${SGDISK} -n 2:0:+1M -t 2:0700 -u 2:61A36FC1-8EFB-4899-84D8-B61642EFA723 -c 2:"vrl_backup" ${TEMP_FILE}
    #[3: mcuimage: 3M-4M]
    fakeroot ${SGDISK} -n 3:0:+1M -t 3:0700 -u 3:65007411-962D-4781-9B2C-51DD7DF22CC3 -c 3:"mcuimage" ${TEMP_FILE}
    #[4: fastboot: 4M-12M]
    fakeroot ${SGDISK} -n 4:0:+8M -t 4:EF02 -u 4:496847AB-56A1-4CD5-A1AD-47F4ACF055C9 -c 4:"fastboot" ${TEMP_FILE}
    #[5: nvme: 12M-14M]
    fakeroot ${SGDISK} -n 5:0:+2M -t 5:0700 -u 5:00354BCD-BBCB-4CB3-B5AE-CDEFCB5DAC43 -c 5:"nvme" ${TEMP_FILE}
    #[6: boot: 14M-78M]
    fakeroot ${SGDISK} -n 6:0:+64M -t 6:EF00 -u 6:5C0F213C-17E1-4149-88C8-8B50FB4EC70E -c 6:"boot" ${TEMP_FILE}
    #[7: reserved: 78M-334M]
    fakeroot ${SGDISK} -n 7:0:+256M -t 7:0700 -u 7:BED8EBDC-298E-4A7A-B1F1-2500D98453B7 -c 7:"reserved" ${TEMP_FILE}
    #[8: cache: 334M-590M]
    fakeroot ${SGDISK} -n 8:0:+256M -t 8:8301 -u 8:A092C620-D178-4CA7-B540-C4E26BD6D2E2 -c 8:"cache" ${TEMP_FILE}
    #[9: system: 590M-End]
    fakeroot ${SGDISK} -n -E -t 9:8300 -u 9:FC56E345-2E8E-49AE-B2F8-5B9D263FE377 -c 9:"system" ${TEMP_FILE}
    ;;
  swap-8g)
    dd if=/dev/zero of=${TEMP_FILE} bs=${SECTOR_SIZE} count=${SECTOR_NUMBER} conv=sparse
    fakeroot ${SGDISK} -U 2CB85345-6A91-4043-8203-723F0D28FBE8 -v ${TEMP_FILE}
    #[1: vrl: 1M-2M]
    fakeroot ${SGDISK} -n 1:0:+1M -t 1:0700 -u 1:496847AB-56A1-4CD5-A1AD-47F4ACF055C9 -c 1:"vrl" ${TEMP_FILE}
    #[2: vrl_backup: 2M-3M]
    fakeroot ${SGDISK} -n 2:0:+1M -t 2:0700 -u 2:61A36FC1-8EFB-4899-84D8-B61642EFA723 -c 2:"vrl_backup" ${TEMP_FILE}
    #[3: mcuimage: 3M-4M]
    fakeroot ${SGDISK} -n 3:0:+1M -t 3:0700 -u 3:65007411-962D-4781-9B2C-51DD7DF22CC3 -c 3:"mcuimage" ${TEMP_FILE}
    #[4: fastboot: 4M-12M]
    fakeroot ${SGDISK} -n 4:0:+8M -t 4:EF02 -u 4:496847AB-56A1-4CD5-A1AD-47F4ACF055C9 -c 4:"fastboot" ${TEMP_FILE}
    #[5: nvme: 12M-14M]
    fakeroot ${SGDISK} -n 5:0:+2M -t 5:0700 -u 5:00354BCD-BBCB-4CB3-B5AE-CDEFCB5DAC43 -c 5:"nvme" ${TEMP_FILE}
    #[6: boot: 14M-78M]
    fakeroot ${SGDISK} -n 6:0:+64M -t 6:EF00 -u 6:5C0F213C-17E1-4149-88C8-8B50FB4EC70E -c 6:"boot" ${TEMP_FILE}
    #[7: cache: 78M-384M]
    fakeroot ${SGDISK} -n 7:0:+256M -t 7:8301 -u 7:A092C620-D178-4CA7-B540-C4E26BD6D2E2 -c 7:"cache" ${TEMP_FILE}
    #[8: swap: 384M-1920M]
    fakeroot ${SGDISK} -n 8:0:+1536M -t 8:8200 -u 8:FC56E344-2E8E-49AE-B2F8-5B9D263FE377 -c 8:"swap" ${TEMP_FILE}
    #[9: system: 1920M-3556M]
    fakeroot ${SGDISK} -n 9:0:+1536M -t 9:8300 -u 9:FC56E345-2E8E-49AE-B2F8-5B9D263FE377 -c 9:"system" ${TEMP_FILE}
    #[10: userdata: 3556M-End]
    fakeroot ${SGDISK} -n -E -t 10:8300 -u 10:064111F6-463B-4CE1-876B-13F3684CE164 -c 10:"userdata" -p ${TEMP_FILE}
    ;;
  aosp-32g*|aosp-64g)
    dd if=/dev/zero of=${TEMP_FILE} bs=${SECTOR_SIZE} count=${SECTOR_NUMBER} conv=sparse
    fakeroot ${SGDISK} -U 2CB85345-6A91-4043-8203-723F0D28FBE8 -v ${TEMP_FILE}
    #[1: xloader_reserved1: 1M-2M]
    fakeroot ${SGDISK} -n 1:0:+1M -t 1:0700 -u 1:697c41e0-7a59-4dfa-a9a6-aa43ac5be684 -c 1:"xloader_reserved1" ${TEMP_FILE}
    #[2: fastboot: 2M-14M]
    fakeroot ${SGDISK} -n 2:0:+12M -t 2:0700 -u 2:3f5f8c48-4402-4ace-9058-30bfea4fa53f -c 2:"fastboot" ${TEMP_FILE}
    #[3: nvme: 14M-20M]
    fakeroot ${SGDISK} -n 3:0:+6M -t 3:0700 -u 3:e2f5e2a9-c9b7-4089-9859-4498f1d3ef7e -c 3:"nvme" ${TEMP_FILE}
    #[4: fip: 20M-32M]
    fakeroot ${SGDISK} -n 4:0:+12M -t 3:0700 -u 4:dc1a888e-f17c-4964-92d6-f8fcc402ed8b -c 4:"fip" ${TEMP_FILE}
    #[5: cache: 32M-288M]
    fakeroot ${SGDISK} -n 5:0:+256M -t 5:0700 -u 5:10cc3268-05f0-4db2-aa00-707361427fc8 -c 5:"cache" ${TEMP_FILE}
    #[6: fw_lpm3: 288M-289M]
    fakeroot ${SGDISK} -n 6:0:+1M -t 6:0700 -u 6:5d8481d4-c170-4aa8-9438-8743c73ea8f5 -c 6:"fw_lpm3" ${TEMP_FILE}
    #[7: boot: 289M-353M]
    fakeroot ${SGDISK} -n 7:0:+64M -t 7:EF00 -u 7:d3340696-9b95-4c64-8df6-e6d4548fba41 -c 7:"boot" ${TEMP_FILE}
    #[8: dts: 353M-369M]
    fakeroot ${SGDISK} -n 8:0:+16M -t 8:0700 -u 8:6e53b0bb-fa7e-4206-b607-5ae699e9f066 -c 8:"dts" ${TEMP_FILE}
    #[9: trustfirmware: 369M-371M]
    fakeroot ${SGDISK} -n 9:0:+2M -t 9:0700 -u 9:f1e126a6-ceef-45c1-aace-29f33ac9cf13 -c 9:"trustfirmware" ${TEMP_FILE}
    #[10: system: 371M-5059M]
    fakeroot ${SGDISK} -n 10:0:+4688M -t 10:8300 -u 10:c3e50923-fb85-4153-b925-759614d4dfcd -c 10:"system" ${TEMP_FILE}
    #[11: vendor: 5059M-5843M]
    fakeroot ${SGDISK} -n 11:0:+784M -t 11:0700 -u 11:919d7080-d71a-4ae1-9227-e4585210c837 -c 11:"vendor" ${TEMP_FILE}
    #[12: reserved: 5843M-5844M]
    fakeroot ${SGDISK} -n 12:0:+1M -t 12:0700 -u 12:611eac6b-bc42-4d72-90ac-418569c8e9b8 -c 12:"reserved" ${TEMP_FILE}
    case ${PTABLE} in
      aosp-32g)
        #[13: userdata: 5844M-End]
        fakeroot ${SGDISK} -n -E -t 13:8300 -u 13:fea80d9c-f3e3-45d9-aed0-1d06e4abd77f -c 13:"userdata" ${TEMP_FILE}
        ;;
      aosp-32g-spare)
        #[13: userdata: 5844M-9844M]
        fakeroot ${SGDISK} -n 13:0:+1000M -t 13:8300 -u 13:fea80d9c-f3e3-45d9-aed0-1d06e4abd77f -c 13:"userdata" ${TEMP_FILE}
        #[14: swap: 9844M-End]
        fakeroot ${SGDISK} -n -E -t 14:8300 -u 14:9501eade-20fb-4bc7-83d3-62c1be3ed92d -c 14:"swap" ${TEMP_FILE}
        ;;
    esac
    ;;
  linux-32g|linux-64g)
    dd if=/dev/zero of=${TEMP_FILE} bs=${SECTOR_SIZE} count=${SECTOR_NUMBER} conv=sparse
    fakeroot ${SGDISK} -U 2CB85345-6A91-4043-8203-723F0D28FBE8 -v ${TEMP_FILE}
    #[1: vrl: 1M-2M]
    fakeroot ${SGDISK} -n 1:0:+1M -t 1:0700 -u 1:697c41e0-7a59-4dfa-a9a6-aa43ac5be684 -c 1:"vrl" ${TEMP_FILE}
    #[2: fastboot: 2M-14M]
    fakeroot ${SGDISK} -n 2:0:+12M -t 2:0700 -u 2:3f5f8c48-4402-4ace-9058-30bfea4fa53f -c 2:"fastboot" ${TEMP_FILE}
    #[3: nvme: 14M-20M]
    fakeroot ${SGDISK} -n 3:0:+6M -t 3:0700 -u 3:e2f5e2a9-c9b7-4089-9859-4498f1d3ef7e -c 3:"nvme" ${TEMP_FILE}
    #[4: fip: 20M-32M]
    fakeroot ${SGDISK} -n 4:0:+12M -t 3:0700 -u 4:dc1a888e-f17c-4964-92d6-f8fcc402ed8b -c 4:"fip" ${TEMP_FILE}
    #[5: cache: 32M-288M]
    fakeroot ${SGDISK} -n 5:0:+256M -t 5:0700 -u 5:10cc3268-05f0-4db2-aa00-707361427fc8 -c 5:"cache" ${TEMP_FILE}
    #[6: fw_lpm3: 288M-289M]
    fakeroot ${SGDISK} -n 6:0:+1M -t 6:0700 -u 6:5d8481d4-c170-4aa8-9438-8743c73ea8f5 -c 6:"fw_lpm3" ${TEMP_FILE}
    #[7: boot: 289M-353M]
    fakeroot ${SGDISK} -n 7:0:+64M -t 7:EF00 -u 7:d3340696-9b95-4c64-8df6-e6d4548fba41 -c 7:"boot" ${TEMP_FILE}
    #[8: dts: 353M-369M]
    fakeroot ${SGDISK} -n 8:0:+16M -t 8:0700 -u 8:6e53b0bb-fa7e-4206-b607-5ae699e9f066 -c 8:"dts" ${TEMP_FILE}
    #[9: trustfirmware: 369M-371M]
    fakeroot ${SGDISK} -n 9:0:+2M -t 9:0700 -u 9:f1e126a6-ceef-45c1-aace-29f33ac9cf13 -c 9:"trustfirmware" ${TEMP_FILE}
    #[10: system: 371M-5059M]
    fakeroot ${SGDISK} -n 10:0:+4688M -t 10:8300 -u 10:c3e50923-fb85-4153-b925-759614d4dfcd -c 10:"system" ${TEMP_FILE}
    #[11: vendor: 5059M-5843M]
    fakeroot ${SGDISK} -n 11:0:+784M -t 11:0700 -u 11:919d7080-d71a-4ae1-9227-e4585210c837 -c 11:"vendor" ${TEMP_FILE}
    #[12: reserved: 5843M-5844M]
    fakeroot ${SGDISK} -n 12:0:+1M -t 12:0700 -u 12:611eac6b-bc42-4d72-90ac-418569c8e9b8 -c 12:"reserved" ${TEMP_FILE}
    ;;
esac

# get the primary partition table
dd if=${TEMP_FILE} of=prm_ptable.img bs=${SECTOR_SIZE} count=${PRIMARY_SECTORS}

BK_PTABLE_LBA=$(expr ${SECTOR_NUMBER} - ${SECONDARY_SECTORS})
dd if=${TEMP_FILE} of=sec_ptable.img skip=${BK_PTABLE_LBA} bs=${SECTOR_SIZE} count=${SECONDARY_SECTORS}

rm -f ${TEMP_FILE}
