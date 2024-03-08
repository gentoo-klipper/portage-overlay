# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYPI_NO_NORMALIZE=1
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Python parser for parsing multipart/form-data input chunks"
HOMEPAGE="
	https://github.com/siddhantgoel/streaming-form-data
"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 arm64 x86 arm"

RDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/requests-toolbelt[${PYTHON_USEDEP}]
	dev-python/urllib3[${PYTHON_USEDEP}]
	dev-python/wheel[${PYTHON_USEDEP}]
	dev-python/wrapt[${PYTHON_USEDEP}]
"

#  dev-python/moto[${PYTHON_USEDEP}]
# dev-python/ruff?
# dev-python/mypy[${PYTHON_USEDEP}]
# dev-python/black[${PYTHON_USEDEP}]
#  dev-python/mkdocs[${PYTHON_USEDEP}]
#   dev-python/twine[${PYTHON_USEDEP}]


BDEPEND="
	dev-python/packaging[${PYTHON_USEDEP}]
"


python_compile() {
	if [ "${CHOST}" != "${CBUILD}" ]
    then
		export PREFIX=${ESYSROOT}
    fi

	distutils-r1_python_compile
}

