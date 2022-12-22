# Copyright
#

EAPI=7

inherit cmake

DESCRIPTION="ROCm BLAS marshalling library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipBLAS"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipBLAS/archive/rocm-$(ver_cut 1-2).tar.gz -> hipBLAS-$(ver_cut 1-2).tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
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

	eapply_user
	cmake_src_prepare
}

src_configure() {
	export hcc_DIR=/usr/lib/hcc/$(ver_cut 1-2)/lib/cmake/
	export hip_DIR=/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/
	export CXX=/usr/lib/hcc/$(ver_cut 1-2)/bin/hcc

	local mycmakeargs=(
		-DHIP_PLATFORM=hcc
		-DCMAKE_INSTALL_PREFIX=/usr
	)

	cmake_src_configure
}
