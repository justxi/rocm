EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="ROCm Thrust - run Thrust dependent software on AMD GPUs"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocThrust"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocThrust/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64"
SLOT="0/$(ver_cut 1-2)"

IUSE=""

RDEPEND="sys-devel/hip
	>=sci-libs/rocPRIM-${PV}"
DEPEND="${RDEPEND}
	dev-util/rocm-cmake"

PATCHES=(
	"${FILESDIR}/master-3.7.0-disable2ndfindhcc.patch"
	"${FILESDIR}/VerifyCompiler-3.7.0.cmake.patch"
)

S="${WORKDIR}/${PN}-rocm-${PV}"

src_prepare() {
	sed -e "s:find_package(HIP:#find_package(HIP:" -i cmake/VerifyCompiler.cmake
	sed -e '/find_package(HIP/a message(STATUS "HIP_PLATFORM:" ${HIP_PLATFORM})' -i cmake/VerifyCompiler.cmake

	sed -e "s: PREFIX rocthrust:# PREFIX rocthrust:" -i ${S}/thrust/CMakeLists.txt
	sed -e "s:  DESTINATION rocthrust/include/thrust:  DESTINATION include/rocthrust/thrust:" -i ${S}/thrust/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir(rocthrust):#rocm_install_symlink_subdir(rocthrust):" -i ${S}/thrust/CMakeLists.txt
	sed -e "s:<INSTALL_INTERFACE\:rocthrust/include/:<INSTALL_INTERFACE\:include/rocthrust/:" -i ${S}/thrust/CMakeLists.txt
	sed -e "s:\${CMAKE_INSTALL_INCLUDEDIR}:&/rocthrust:" -i ${S}/cmake/ROCMExportTargetsHeaderOnly.cmake
	sed -e "s:\${ROCM_INSTALL_LIBDIR}:\${CMAKE_INSTALL_LIBDIR}:" -i ${S}/cmake/ROCMExportTargetsHeaderOnly.cmake

	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	export CXX="${HIP_PATH}/bin/hipcc"

	local mycmakeargs=(
		-DHIP_PLATFORM=rocclr
		-DHIP_COMPILER=clang
		-DCMAKE_INSTALL_PREFIX=/usr
		-Damd_comgr_DIR=/usr/lib/cmake/amd_comgr
		-DBUILD_TEST=OFF
	)

	cmake-utils_src_configure
}
