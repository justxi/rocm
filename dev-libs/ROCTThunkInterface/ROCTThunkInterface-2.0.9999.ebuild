# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils git-r3

DESCRIPTION="ROCKT-Thunk-Interface"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface/"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface/"
EGIT_BRANCH="roc-2.0.x"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-process/numactl
	>=sys-kernel/gentoo-sources-4.17"
RDEPEND="${DEPEND}"

src_install() {

	dolib.so "${BUILD_DIR}/libhsakmt.so.2.0.0"
	dosym "libhsakmt.so.2.0.0" "/usr/$(get_libdir)/libhsakmt.so"
	dosym "libhsakmt.so.2.0.0" "/usr/$(get_libdir)/libhsakmt.so.2"

	insinto "/usr/include/libhsakmt"
	doins "include/hsakmt.h"
	doins "include/hsakmttypes.h"
}

pkg_postinst() {
	elog "ROCk library requires the correct ROCk driver set installed."
	elog "Compatibility and installation details are available in the ROCk github:"
	elog "-> https://github.com/RadeonOpenCompute/ROCK-Radeon-Open-Compute-Kernel-Driver"
	elog ""
	elog "User must be in the video group. run as root:"
	elog " > usermod -a -G video username"
}

