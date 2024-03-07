# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{11..12} )

inherit python-single-r1

DESCRIPTION="API Web Server for Klipper"
HOMEPAGE="https://github.com/Arksine/moonraker"
SRC_URI="https://github.com/Arksine/moonraker/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="arm"
IUSE="doc"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="
	acct-group/klipper
	acct-user/klipper"

RDEPEND="${DEPEND}
	${PYTHON_DEPS}
	app-misc/klipper
	$(python_gen_cond_dep '
		>=dev-python/pillow-8.0.1[${PYTHON_USEDEP}]
		>=dev-python/pyserial-3.4[${PYTHON_USEDEP}]
		>=dev-python/tornado-6.2[${PYTHON_USEDEP}]')"

DOCS=( LICENSE docs/api_changes.md )

src_prepare() {
	sed -i -e 's|^DEFAULT_KLIPPY_LOG_PATH.*|DEFAULT_KLIPPY_LOG_PATH = "/var/log/klipper/klipper.log"|g' moonraker/app.py || die

	default
}

src_install() {
	if use doc; then
		dodoc -r ${DOCS[@]} docs/api_changes.md docs/configuration.md docs/dev_changelog.md docs/plugins.md docs/printer_objects.md docs/user_changes.md docs/web_api.md
	fi

	diropts -o klipper -g klipper
	insopts -o klipper -g klipper
	insinto "/opt/${PN}"
	dodir "/opt/${PN}"
	doins -r moonraker
	insinto "/opt/${PN}/scripts"
	dodir "/opt/${PN}/scripts"
	doins "${FILESDIR}/update_manager.conf"

	python_fix_shebang "${D}/opt/moonraker/moonraker/moonraker.py" || die

	newinitd "${FILESDIR}/moonraker.initd" moonraker
	newconfd "${FILESDIR}/moonraker.confd" moonraker
}

pkg_postinst() {
	echo
	elog "Moonraker depends on the following configuration items in the printer.cfg of klipper for full functionality:"
	elog "    [display_status]"
	elog "    [pause_resume]"
	elog "    [virtual_sdcard]"
	echo
	elog "Provide an API Key at /etc/klipper/api_key with owner and group klipper and permissions 0640"
}
