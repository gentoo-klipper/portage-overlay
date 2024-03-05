# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Read-only mirror of Trusted Firmware-A"
HOMEPAGE="https://developer.trustedfirmware.org/dashboard/view/6/"
SRC_URI="https://github.com/ARM-software/arm-trusted-firmware/archive/refs/tags/v${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="arm"

DEPEND="
	dev-embedded/u-boot
	dev-embedded/op-tee
"
RDEPEND="${DEPEND}"
BDEPEND=""

IUSE="debug"


src_compile() {
	flags=""
	if [ "${CHOST}" != "${CBUILD}" ]
	then
		flags="${flags} CROSS_COMPILE=${CHOST}-"
	fi

	flags="${flags} PLAT=stm32mp1 ARCH=aarch32 ARM_ARCH_MAJOR=7 STM32MP_SDMMC=1 STM32MP_EMMC=1"
	flags="${flags} AARCH32_SP=optee"
	flags="${flags} DTB_FILE_NAME=stm32mp157c-dk2.dtb"
	flags="${flags} BL32=${ROOT}/opt/op-tee/4.1.0/stm32mp1/tee-header_v2.bin"
	flags="${flags} BL32_EXTRA1=${ROOT}/opt/op-tee/4.1.0/stm32mp1/tee-pager_v2.bin"
	flags="${flags} BL32_EXTRA2=${ROOT}/opt/op-tee/4.1.0/stm32mp1/tee-pageable_v2.bin"
	flags="${flags} BL33=${ROOT}/opt/u-boot/u-boot-nodtb.bin"
	flags="${flags} BL33_CFG=${ROOT}/opt/u-boot/u-boot.dtb"
	flags="${flags} ARM_TSP_RAM_LOCATION=dram"

	if use debug
	then
		flags="${flags} DEBUG=1"
	fi
	cd ${S}
	emake ${flags} all fip
}

src_install() {
	insinto /opt/arm-trusted-firmware/
	build_type=release
	if use debug
	then
		build_type=debug
	fi
	doins ${S}/build/stm32mp1/${build_type}/fip.bin
	doins ${S}/build/stm32mp1/${build_type}/tf-a-stm32mp157c-dk2.stm32
}
