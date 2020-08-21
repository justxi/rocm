EAPI=7

inherit cmake

DESCRIPTION="Radeon Open Compute CMake Modules"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm-cmake"
SRC_URI="https://github.com/RadeonOpenCompute/rocm-cmake/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
RESTRICT="test"

S="${WORKDIR}/rocm-cmake-rocm-${PV}"

src_prepare() {
	sed -e "s:set(ROCM_INSTALL_LIBDIR lib):set(ROCM_INSTALL_LIBDIR $(get_libdir)):" -i "${S}/share/rocm/cmake/ROCMInstallTargets.cmake" || die
	cmake_src_prepare
}
