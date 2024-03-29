# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit python-single-r1

DESCRIPTION="Klipper is a 3d-Printer firmware"
HOMEPAGE="https://www.klipper3d.org/"

SRC_URI="https://github.com/Klipper3d/klipper/archive/refs/tags/v${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 arm amr64"

IUSE="doc examples +hostmcu"

DEPEND="
	dev-python/pyserial
	dev-python/greenlet
	dev-python/jinja
	dev-python/python-can
	dev-python/markupsafe
	dev-python/cffi
	acct-group/klipper
	acct-user/klipper
"
RDEPEND="${DEPEND}"
BDEPEND="
	acct-user/klipper
	acct-group/klipper
"

DOCS=( COPYING )

src_compile() {
	if use hostmcu
	then
		cp ${FILESDIR}/config.host .config
		emake CROSS_PREFIX="${CHOST}-"
		cp out/klipper.elf klipper-mcu
	fi

	cd klippy/chelper
	local cflags="-Wall -g -O2 -shared -fPIC -flto -fwhole-program -fno-use-linker-plugin"
	local sources="pyhelper.c serialqueue.c stepcompress.c itersolve.c trapq.c pollreactor.c msgblock.c trdispatch.c kin_cartesian.c kin_corexy.c kin_corexz.c kin_delta.c kin_deltesian.c kin_polar.c kin_rotary_delta.c kin_winch.c kin_extruder.c kin_shaper.c kin_idex.c"

	${CHOST}-gcc $cflags -o c_helper.so $sources
}

src_install() {
	if use doc; then
		dodoc -r ${DOCS[@]} docs/*.md docs/img docs/prints
	fi

	if use examples; then
		insinto "/usr/share/${PN}/examples"
		doins -r config/*
	fi

	insinto /etc/klipper
	doins ${FILESDIR}/printer.cfg

	if use hostmcu
	then
		dosbin klipper-mcu
		newinitd "${FILESDIR}/klipper-mcu.initd" klipper-mcu
	    newconfd "${FILESDIR}/klipper-mcu.confd" klipper-mcu
		insinto /etc/klipper
		doins ${FILESDIR}/hostmcu.cfg
		echo "[include hostmcu.cfg]" >> ${D}/etc/klipper/printer.cfg
	fi

	# currently only these are python3 compatible or have missing dependencies
	local required_scripts=( scripts/buildcommands.py \
		scripts/check-gcc.sh \
		scripts/flash-*.sh
	)

	insinto "/opt/${PN}"
	doins -r Makefile klippy lib src

	insinto "/opt/${PN}/scripts"
	insopts -m0755
	doins -r ${required_scripts[@]}
	python_fix_shebang --force "${D}/opt/${PN}/scripts/"

	# UPSTREAM-ISSUE https://github.com/KevinOConnor/klipper/issues/3689
	chmod 0755 "${D}/opt/${PN}/klippy/klippy.py"
	python_fix_shebang --force "${D}/opt/klipper/klippy/klippy.py"


	newinitd "${FILESDIR}/klipper.initd" klipper
	newconfd "${FILESDIR}/klipper.confd" klipper
	#systemd_newunit "${FILESDIR}/klipper.service" "klipper.service"

	dodir /etc/klipper
	keepdir /etc/klipper

	dodir /var/spool/klipper/virtual_sdcard
	keepdir /var/spool/klipper/virtual_sdcard

	dodir /var/log/klipper
	keepdir /var/log/klipper

	fowners -R klipper:klipper /opt/klipper /var/spool/klipper/ /etc/klipper /var/log/klipper

	doenvd "${FILESDIR}/99klipper"
}
