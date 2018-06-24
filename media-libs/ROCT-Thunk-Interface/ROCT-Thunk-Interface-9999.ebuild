# Copyright
# 

EAPI=6
inherit cmake-utils git-r3

DESCRIPTION="ROCKT-Thunk-Interface"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface/"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface/"
EGIT_BRANCH="fxkamd/drm-next-wip"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-process/numactl"
RDEPEND="${DEPEND}"

#S="${WORKDIR}/${PN}-roc-${PV}/"

src_install() {

	dolib.so "${BUILD_DIR}/libhsakmt.so.1.0.6"
	dosym "libhsakmt.so.1.0.6" "/usr/$(get_libdir)/libhsakmt.so"
	dosym "libhsakmt.so.1.0.6" "/usr/$(get_libdir)/libhsakmt.so.1"

	insinto "/usr/include/libhsakmt"
	doins "include/hsakmt.h"
	doins "include/hsakmttypes.h"
}

pkg_postinst() {
	elog "ROCt library requires the correct ROCk driver set installed."
	elog "Compatibility and installation details are available in the ROCk github:"
	elog "-> https://github.com/RadeonOpenCompute/ROCK-Radeon-Open-Compute-Kernel-Driver"
	elog ""
	elog "User must be in the video group. run as root:"
	elog " > usermod -a -G video username"
}

