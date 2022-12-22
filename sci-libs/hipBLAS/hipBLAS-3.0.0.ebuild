# Copyright
#

EAPI=7

inherit cmake

DESCRIPTION="ROCm BLAS marshalling library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipBLAS"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipBLAS/archive/rocm-$(ver_cut 1-2).tar.gz -> hipBLAS-$(ver_cut 1-2).tar.gz"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

IUSE=""

S="${WORKDIR}/hipBLAS-rocm-$(ver_cut 1-2)"

RDEPEND="=sys-devel/hip-$(ver_cut 1-2)*
         =sci-libs/rocBLAS-${PV}*"
DEPEND="${RDPEND}
	dev-util/cmake"

src_prepare() {
        sed -e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/hipblas/:" -i ${S}/library/src/CMakeLists.txt || die
        sed -e "s: PREFIX hipblas:# PREFIX hipblas:" -i ${S}/library/src/CMakeLists.txt || die
        sed -e "s:rocm_install_symlink_subdir( hipblas ):#rocm_install_symlink_subdir( hipblas ):" -i ${S}/library/src/CMakeLists.txt || die
	sed -e "s:get_target_property( HIPHCC_LOCATION hip\:\:hip_hcc IMPORTED_LOCATION_RELEASE ):get_target_property( HIPHCC_LOCATION hip\:\:hip_hcc IMPORTED_LOCATION_GENTOO ):" -i ${S}/library/src/CMakeLists.txt

	eapply_user
	cmake_src_prepare
}

src_configure() {
	export HCC_HOME=/usr/lib/hcc/$(ver_cut 1-2)
	export hcc_DIR=${HCC_HOME}/lib/cmake/
	export CXX=${HCC_HOME}/bin/hcc

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr
	)

	cmake_src_configure
}
