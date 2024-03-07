# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Cypress' WLAN firmware with customized 'CLM Blob' for murata 1DX"
HOMEPAGE="https://community.murata.com/"

inherit git-r3

EGIT_REPO_URI="https://github.com/murata-wireless/cyw-fmac-fw.git"
EGIT_COMMIT="ba140e42c3320262fc52e185c3af93eeb10117df"

SLOT="0"
KEYWORDS="arm"

DEPEND=""
RDEPEND="${DEPEND}
	net-wireless/wireless-regdb
"
BDEPEND=""

src_install() {
	insinto /lib/firmware/brcm
	newins ${S}/cyfmac43430-sdio.bin brcmfmac43430-sdio.bin
	newins ${S}/cyfmac43430-sdio.bin brcmfmac43430-sdio.st,stm32mp157c-dk2.bin
	newins ${S}/cyfmac43430-sdio.bin brcmfmac43430-sdio.st,stm32mp157f-dk2.bin
	newins ${S}/cyfmac43430-sdio.1DX.clm_blob brcmfmac43430-sdio.clm_blob
}
