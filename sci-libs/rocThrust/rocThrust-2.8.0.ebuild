# Copyright
#

EAPI=7

inherit cmake-utils
DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocThrust"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocThrust/archive/${PV}.tar.gz -> rocThrust-$(ver_cut 1-2).tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

#S="${WORKDIR}/rocThrust-rocm-$(ver_cut 1-2)"

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
	cmake-utils_src_prepare
}

src_configure() {
	export hcc_DIR=/usr/lib/hcc/$(ver_cut 1-2)/lib/cmake/
	export hip_DIR=/usr/lib/hip/lib/cmake/
	export CXX=/usr/lib/hcc/$(ver_cut 1-2)/bin/hcc

	local mycmakeargs=(
		-DHIP_PLATFORM=hcc
		-DBUILD_TEST=OFF
	)

	cmake-utils_src_configure
}
