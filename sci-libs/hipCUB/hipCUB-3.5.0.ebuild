# Copyright
#

EAPI=7

inherit cmake

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipCUB"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipCUB/archive/rocm-${PV}.tar.gz -> hipCUB-${PV}.tar.gz"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

IUSE=""

RDEPEND="=sys-devel/hip-$(ver_cut 1-2)*
         =sci-libs/rocPRIM-${PV}*"
DEPEND="${RDEPEND}
	dev-util/cmake"

S="${WORKDIR}/hipCUB-rocm-${PV}"

src_prepare() {
	eapply "${FILESDIR}/master-disable2ndfindhcc.patch"

	# sed -e "s:HIP_PLATFORM STREQUAL \"hcc\":HIP_PLATFORM STREQUAL \"rocclr\":" -i cmake/VerifyCompiler.cmake
        sed -e "s:find_package(HIP 1.5.18263 REQUIRED):find_package(HIP 3.5.20250 REQUIRED):" -i cmake/VerifyCompiler.cmake

	sed -e "s: PREFIX hipcub:# PREFIX hipcub:" -i ${S}/hipcub/CMakeLists.txt
	sed -e "s:  DESTINATION hipcub/include/:  DESTINATION include/:" -i ${S}/hipcub/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir(hipcub):#rocm_install_symlink_subdir(hipcub):" -i ${S}/hipcub/CMakeLists.txt
	sed -e "s:<INSTALL_INTERFACE\:hipcub/include/:<INSTALL_INTERFACE\:include/hipcub/:" -i ${S}/hipcub/CMakeLists.txt

	sed -e "s:set(ROCM_INSTALL_LIBDIR lib:set(ROCM_INSTALL_LIBDIR \${CMAKE_INSTALL_LIBDIR}:" -i ${S}/cmake/ROCMExportTargetsHeaderOnly.cmake

	eapply_user
	cmake_src_prepare
}

src_configure() {
	export CXX=hipcc

	local mycmakeargs=(
		-DHIP_PLATFORM=hcc
		-DBUILD_TEST=OFF
		-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr
	)

	cmake_src_configure
}
