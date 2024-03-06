# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8


DESCRIPTION="Linux kernel with ST patches"
HOMEPAGE=""
SRC_URI="https://github.com/STMicroelectronics/linux/archive/refs/heads/v${PV}-stm32mp.zip"

LICENSE=""
SLOT="0"
KEYWORDS="arm"

DEPEND="
	sys-kernel/linux-firmware
"
RDEPEND="${DEPEND}"
BDEPEND=""

S=${WORKDIR}/linux-${PV}-stm32mp

CROSS="ARCH=arm CROSS_COMPILE=armv7a-hardfloat-linux-gnueabi-"

IUSE="+dummy1"

src_configure() {
	cd ${S}
	emake ${CROSS} multi_v7_defconfig fragment-01-multiv7_cleanup.config fragment-02-multiv7_addons.config
	./scripts/kconfig/merge_config.sh -m .config ${FILESDIR}/config
	emake ${CROSS} olddefconfig
}

src_compile() {
	cd ${S}
	emake ${CROSS} zImage
	emake ${CROSS} modules
	emake ${CROSS} dtbs
}

src_install() {
	cd ${S}
	emake ${CROSS} modules_install INSTALL_MOD_PATH=${D}/lib/modules/
	emake ${CROSS} dtbs_install INSTALL_DTBS_PATH=${D}/boot/dtbs
	emake ${CROSS} install INSTALL_PATH=${D}/boot/
	cp arch/arm/boot/zImage ${D}/boot/vmlinuz
	emake ${CROSS} headers_install INSTALL_HDR_PATH=${D}/usr/src/st-linux-${PV}
}
