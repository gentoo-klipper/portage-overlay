# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="NVRAM (Wireless RF configuration files) for Murata's Wi-Fi/Bluetooth modules"
HOMEPAGE="https://community.murata.com/"

inherit git-r3

EGIT_REPO_URI="https://github.com/murata-wireless/cyw-fmac-nvram.git"
EGIT_REPO_COMMIT="8710e74e79470f666912c3ccadf1e354d6fb209c"

SLOT="0"
KEYWORDS="arm"

DEPEND=""
RDEPEND="${DEPEND}
	dev-embedded/murata-1dx-firmware
"
BDEPEND=""

src_install() {
	insinto /lib/firmware/brcm/
	newins ${S}/cyfmac43430-sdio.1DX.txt brcmfmac43430-sdio.txt
	newins ${S}/cyfmac43430-sdio.1DX.txt brcmfmac43430-sdio.st,stm32mp157f-dk2.txt
	newins ${S}/cyfmac43430-sdio.1DX.txt brcmfmac43430-sdio.st,stm32mp157c-dk2.txt

}
