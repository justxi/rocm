# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils eapi7-ver

DESCRIPTION="ROCKT-Thunk-Interface"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface/"
SRC_URI="https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface/archive/roc-${PV}.tar.gz -> ROCTThunkInterface-2.0.0.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-process/numactl
	>=sys-kernel/gentoo-sources-4.17"
RDEPEND="${DEPEND}"

S="${WORKDIR}/ROCT-Thunk-Interface-roc-${PV}"

MY_PVM=$(ver_cut 1)

src_prepare() {
	cd ${WORKDIR}
	eapply "${FILESDIR}/changeVersion2.patch"
	eapply_user
}

src_install() {
	dolib.so "${BUILD_DIR}/libhsakmt.so.${PV}"
	dosym "libhsakmt.so.${PV}" "/usr/$(get_libdir)/libhsakmt.so"
	dosym "libhsakmt.so.${PV}" "/usr/$(get_libdir)/libhsakmt.so.${MY_PVM}"

	insinto "/usr/include/libhsakmt"
	doins "include/hsakmt.h"
	doins "include/hsakmttypes.h"
}

pkg_postinst() {
	elog "ROCT library requires the correct ROCk driver set installed."
	elog "Compatibility and installation details are available in the ROCk github:"
	elog "-> https://github.com/RadeonOpenCompute/ROCK-Radeon-Open-Compute-Kernel-Driver"
	elog ""
	elog "User must be in the video group. run as root:"
	elog " > usermod -a -G video username"
}

