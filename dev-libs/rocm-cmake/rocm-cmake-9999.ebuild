# Copyright
#

EAPI=6

inherit git-r3 cmake-utils eapi7-ver

DESCRIPTION="ROCm-CMake"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm-cmake"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocm-cmake"
EGIT_BRANCH="master"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	sed -e "s:set(ROCM_INSTALL_LIBDIR lib):set(ROCM_INSTALL_LIBDIR lib64):" -i "${S}/share/rocm/cmake/ROCMInstallTargets.cmake" || die
	eapply_user
}
