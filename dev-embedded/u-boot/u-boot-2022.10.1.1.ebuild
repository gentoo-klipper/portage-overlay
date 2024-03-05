# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Das U-Boot"
HOMEPAGE="https://github.com/STMicroelectronics/u-boot"
SRC_URI="https://github.com/STMicroelectronics/u-boot/archive/refs/tags/v$(ver_rs 2 '-stm32mp-r').tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="arm"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	dev-lang/swig
"

S=${WORKDIR}/u-boot-$(ver_rs 2 '-stm32mp-r')

src_configure() {
	flags="ARCH=arm"
	if [ "${CHOST}" != "${CBUILD}" ]
	then
		flags="${flags} CROSS_COMPILE=${CHOST}-"
	fi

	platform=stm32mp15

	emake ${flags} ${platform}_defconfig
	./scripts/kconfig/merge_config.sh -m .config ${FILESDIR}/${platform}.config
	emake ${flags} KCONFIG_ALLCONFIG=.config alldefconfig
}

src_compile() {
	flags="ARCH=arm"
	if [ "${CHOST}" != "${CBUILD}" ]
	then
		flags="${flags} CROSS_COMPILE=${CHOST}-"
	fi

	platform=stm32mp157f-dk2
	emake ${flags} DEVICE_TREE=${platform} all
}

src_install() {
	insinto /opt/u-boot/
	doins ${S}/u-boot.dtb
	doins ${S}/u-boot-nodtb.bin
}
