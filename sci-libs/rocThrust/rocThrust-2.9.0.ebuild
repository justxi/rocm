# Copyright
#

EAPI=7

inherit cmake

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocThrust"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocThrust/archive/${PV}.tar.gz -> rocThrust-${PV}.tar.gz"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

IUSE=""

RDEPEND=">=sys-devel/hip-${PV}
	 =sci-libs/rocPRIM-${PV}*"
DEPEND="${RDEPEND}
	dev-util/cmake"

src_prepare() {
	eapply "${FILESDIR}/master-disable2ndfindhcc.patch"
	eapply "${FILESDIR}/rocThrust-2.7-disable-rocPRIM-download.patch"

	sed -e "s: PREFIX rocthrust:# PREFIX rocthrust:" -i ${S}/thrust/CMakeLists.txt
	sed -e "s:  DESTINATION rocthrust/include/thrust:  DESTINATION include/rocthrust/thrust:" -i ${S}/thrust/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir(rocthrust):#rocm_install_symlink_subdir(rocthrust):" -i ${S}/thrust/CMakeLists.txt
	sed -e "s:<INSTALL_INTERFACE\:rocthrust/include/:<INSTALL_INTERFACE\:include/rocthrust/:" -i ${S}/thrust/CMakeLists.txt
	sed -e "s:\${CMAKE_INSTALL_INCLUDEDIR}:&/rocthrust:" -i ${S}/cmake/ROCMExportTargetsHeaderOnly.cmake
	sed -e "s:\${ROCM_INSTALL_LIBDIR}:\${CMAKE_INSTALL_LIBDIR}:" -i ${S}/cmake/ROCMExportTargetsHeaderOnly.cmake

	eapply_user
	cmake_src_prepare
}

src_configure() {
	export hip_DIR=/usr/lib/hip/lib/cmake/

	export HCC_ROOT=/usr/lib/hcc/$(ver_cut 1-2)
	export hcc_DIR=${HCC_ROOT}/lib/cmake/
	export CXX=${HCC_ROOT}/bin/hcc

	local mycmakeargs=(
		-DHIP_PLATFORM=hcc
		-DBUILD_TEST=OFF
	)

	cmake_src_configure
}
