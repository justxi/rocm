# Copyright
#

EAPI=7

inherit cmake-utils
#git-r3

DESCRIPTION="HIP parallel primitives for developing performant GPU-accelerated code on AMD ROCm platform"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocPRIM"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocPRIM/archive/${PV}.tar.gz -> rocPRIM-${PV}.tar.gz"
#EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocPRIM"
#EGIT_BRANCH="master-rocm-2.9"
#EGIT_COMMIT=""

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND=">=sys-devel/hip-${PV}
	>=dev-util/rocm-cmake-${PV}"
DEPEND="${RDEPEND}
	dev-util/cmake"

S="${WORKDIR}/rocPRIM-${PV}"

src_prepare() {
	eapply "${FILESDIR}/master-disable2ndfindhcc.patch"

	sed -e "s:find_package(HIP 1.5.18263 REQUIRED):find_package(HIP 2.8.19386 REQUIRED):" -i cmake/VerifyCompiler.cmake

	sed -e "s: PREFIX rocprim:# PREFIX rocprim:" -i rocprim/CMakeLists.txt
	sed -e "s:\$<INSTALL_INTERFACE\:rocprim/include/>:\$<INSTALL_INTERFACE\:include/rocprim/>:" -i rocprim/CMakeLists.txt
	sed -e "s: DESTINATION rocprim/include/: DESTINATION include/:" -i rocprim/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir(rocprim):#rocm_install_symlink_subdir(rocprim):" -i rocprim/CMakeLists.txt

        eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	export hip_DIR=/usr/lib/hip/cmake/
	export HIP_DIR=/usr/lib/hip/cmake/
	export hcc_DIR=${HCC_HOME}/lib/cmake/hcc/
	export CXX=${HCC_HOME}/bin/hcc
	export HIP_IGNORE_HCC_VERSION=1

	local mycmakeargs=(
		-DCMAKE_CXX_COMPILER_FORCED=1
		-DHIP_ROOT_DIR=/usr/lib/hip/
		-DBUILD_TEST=OFF
		-DHIP_PLATFORM=hcc
		-DCMAKE_INSTALL_PREFIX=/usr/
	)

	cmake-utils_src_configure
}
