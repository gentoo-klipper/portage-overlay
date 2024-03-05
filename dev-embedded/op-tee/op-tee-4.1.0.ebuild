# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Trusted side of the TEE"
HOMEPAGE="http://optee.readthedocs.io"
SRC_URI="https://github.com/OP-TEE/optee_os/archive/refs/tags/4.1.0.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="arm"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	sys-apps/dtc
	dev-python/pyelftools
"

IUSE="debug"

S="${WORKDIR}/optee_os-${PV}"

src_compile() {
	flags=""
	if [ "${CHOST}" != "${CBUILD}" ]
    then
		flags="${flags} CROSS_COMPILE=${CHOST}-"
	fi

	if use debug
	then
		flags="${flags} CFG_TEE_CORE_LOG_LEVEL=4"
	fi

	emake ${flags} PLATFORM=stm32mp1-157C_DK2 all
}

src_install() {
	insinto /opt/op-tee/
	doins ${S}/out/arm-plat-stm32mp1/core/tee-header_v2.bin
	doins ${S}/out/arm-plat-stm32mp1/core/tee-pager_v2.bin
	doins ${S}/out/arm-plat-stm32mp1/core/tee-pageable_v2.bin
}
