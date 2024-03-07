# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit python-single-r1

DESCRIPTION="GUI for Klipper"
HOMEPAGE="https://klipperscreen.github.io/KlipperScreen/"
SRC_URI="https://github.com/KlipperScreen/KlipperScreen/archive/refs/tags/v${PV}.tar.gz"

SLOT="0"
KEYWORDS="arm"

DEPEND="
	acct-user/klipper
	acct-group/klipper

	dev-python/jinja
	dev-python/requests
	dev-python/netifaces
	dev-python/six
	dev-python/python-mpv
	dev-python/pygobject
	dev-python/websocket-client
	dev-python/dbus-python
	dev-python/pycairo

	x11-base/xorg-server
"

RDEPEND="${DEPEND}"
BDEPEND="
	acct-user/klipper
	acct-group/klipper
"

IUSE="doc"


src_install() {
	if use doc; then
		dodoc -r LICENSE docs/*.md
	fi

	diropts -o klipper -g klipper
	insopts -o klipper -g klipper
	insinto "/opt/${PN}"
	dodir "/opt/${PN}"
	doins -r ks_includes
	doins -r panels
	doins -r styles
	doins screen.py

	python_fix_shebang "${D}/opt/${PN}/screen.py" || die
}
