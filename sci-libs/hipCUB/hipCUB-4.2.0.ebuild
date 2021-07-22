# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A thin wrapper library on top of rocPRIM or CUB"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipCUB"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipCUB/archive/rocm-${PV}.tar.gz -> hipCUB-${PV}.tar.gz"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

RDEPEND="=dev-util/hip-$(ver_cut 1-2)*
         =sci-libs/rocPRIM-${PV}*"
DEPEND="${RDEPEND}
	dev-util/cmake"

S="${WORKDIR}/hipCUB-rocm-${PV}"

src_prepare() {
	sed -e "s:HIP_PLATFORM STREQUAL \"hcc\":HIP_PLATFORM STREQUAL \"rocclr\":" -i "${S}/cmake/VerifyCompiler.cmake" || die
        sed -e "s:find_package(HIP 1.5.18263 REQUIRED):find_package(HIP 3.5.20250 REQUIRED):" -i "${S}/cmake/VerifyCompiler.cmake" || die

	sed -e "s: PREFIX hipcub:# PREFIX hipcub:" -i "${S}/hipcub/CMakeLists.txt" || die
	sed -e "s:  DESTINATION hipcub/include/:  DESTINATION include/:" -i "${S}/hipcub/CMakeLists.txt" || die
	sed -e "s:rocm_install_symlink_subdir(hipcub):#rocm_install_symlink_subdir(hipcub):" -i "${S}/hipcub/CMakeLists.txt" || die
	sed -e "s:<INSTALL_INTERFACE\:hipcub/include/:<INSTALL_INTERFACE\:include/hipcub/:" -i "${S}/hipcub/CMakeLists.txt" || die

	sed -e "s:set(ROCM_INSTALL_LIBDIR lib:set(ROCM_INSTALL_LIBDIR \${CMAKE_INSTALL_LIBDIR}:" -i "${S}/cmake/ROCMExportTargetsHeaderOnly.cmake" || die

	eapply_user
	cmake_src_prepare
}

src_configure() {
	# Grant access to the device
        addwrite /dev/kfd
        addpredict /dev/dri/

	# Compiler to use
	export CXX=hipcc

	local mycmakeargs=(
		-DBUILD_TEST=OFF
		-DCMAKE_CXX_FLAGS="--rocm-path=/usr"
		-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr
	)

	cmake_src_configure
}
