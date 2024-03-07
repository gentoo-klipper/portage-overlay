# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="The can package provides controller area network support for Python developers"
HOMEPAGE="
	https://github.com/hardbyte/python-can
"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64 x86 arm"

RDEPEND="
	dev-python/wrapt[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-3.10.0[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
"

