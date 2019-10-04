# Copyright
#

EAPI=7

inherit cmake-utils

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipSPARSE"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipSPARSE/archive/rocm-$(ver_cut 1-2).tar.gz -> hipSPARSE-$(ver_cut 1-2).tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""
S="${WORKDIR}/hipSPARSE-rocm-$(ver_cut 1-2)"

#RDEPEND="=sys-devel/hip-$(ver_cut 1-2)*
#         =sci-libs/rocSPARSE-${PV}*"
RDEPEND="=sys-devel/hip-2.8*
         =sci-libs/rocSPARSE-${PV}*"
DEPEND="${RDPEND}
	dev-util/cmake"

src_prepare() {
	sed -e "s: PREFIX hipsparse:# PREFIX hipsparse:" -i ${S}/library/CMakeLists.txt || die
	sed -e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/hipsparse/:" -i ${S}/library/CMakeLists.txt || die
	sed -e "s:rocm_install_symlink_subdir(hipsparse):#rocm_install_symlink_subdir(hipsparse):" -i ${S}/library/CMakeLists.txt || die

	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
#	export hip_DIR=/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/

#	export HCC_ROOT=/usr/lib/hcc/$(ver_cut 1-2)
	export HCC_ROOT=/usr/lib/hcc/2.8
	export hcc_DIR=${HCC_ROOT}/lib/cmake/
	export CXX=${HCC_ROOT}/bin/hcc

	local mycmakeargs=(
#		-DHIP_PLATFORM=hcc
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_INSTALL_INCLUDEDIR=include/hipsparse
	)

	cmake-utils_src_configure
}
