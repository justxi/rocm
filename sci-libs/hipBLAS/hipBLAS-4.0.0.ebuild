# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="ROCm BLAS marshalling library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipBLAS"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipBLAS/archive/rocm-${PV}.tar.gz -> hipBLAS-$(ver_cut 1-2).tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

RDEPEND="=dev-util/hip-$(ver_cut 1-2)*
         =sci-libs/rocBLAS-${PV}*
         =sci-libs/rocSOLVER-${PV}*"
DEPEND="${RDPEND}
	dev-util/cmake"

S="${WORKDIR}/hipBLAS-rocm-${PV}"

src_prepare() {
        sed -e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/hipblas/:" -i ${S}/library/src/CMakeLists.txt || die
        sed -e "s: PREFIX hipblas:# PREFIX hipblas:" -i ${S}/library/src/CMakeLists.txt || die
        sed -e "s:rocm_install_symlink_subdir( hipblas ):#rocm_install_symlink_subdir( hipblas ):" -i ${S}/library/src/CMakeLists.txt || die
	sed -e "s:get_target_property( HIPHCC_LOCATION hip\:\:hip_hcc IMPORTED_LOCATION_RELEASE ):get_target_property( HIPHCC_LOCATION hip\:\:hip_hcc IMPORTED_LOCATION_GENTOO ):" -i ${S}/library/src/CMakeLists.txt
	sed -e "s:hipblas/include:include/hipblas:" -i ${S}/library/src/CMakeLists.txt || die

	eapply_user
	cmake_src_prepare
}

src_configure() {
	export CXX="/usr/lib/hip/bin/hipcc"

	local mycmakeargs=(
		-DTRY_CUDA=OFF
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_CXX_FLAGS="--rocm-path=/usr"
		-DCMAKE_PREFIX_PATH="${HIP_PATH}"
	)

        # this is necessary to omit a sandbox vialation,
        # but it does not seem to affect the targets list...
        echo "gfx803" >> ${WORKDIR}/target.lst
        export ROCM_TARGET_LST="${WORKDIR}/target.lst"

	cmake_src_configure
}
