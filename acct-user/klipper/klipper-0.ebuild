# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit acct-user

DESCRIPTION="User for app-misc/klipper"
ACCT_USER_ID="-1"
ACCT_USER_GROUPS=( dialout klipper )

acct-user_add_deps

DEPEND+=" acct-group/dialout acct-group/klipper "
RDEPEND+=" acct-group/dialout acct-group/klipper "
