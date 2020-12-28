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
        sed -e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/hipblas/:" -i "${S}/library/src/CMakeLists.txt" || die
        sed -e "s: PREFIX hipblas:# PREFIX hipblas:" -i "${S}/library/src/CMakeLists.txt" || die
        sed -e "s:rocm_install_symlink_subdir( hipblas ):#rocm_install_symlink_subdir( hipblas ):" -i "${S}/library/src/CMakeLists.txt" || die
	sed -e "s:get_target_property( HIPHCC_LOCATION hip\:\:hip_hcc IMPORTED_LOCATION_RELEASE ):get_target_property( HIPHCC_LOCATION hip\:\:hip_hcc IMPORTED_LOCATION_GENTOO ):" -i "${S}/library/src/CMakeLists.txt" || die
	sed -e "s:hipblas/include:include/hipblas:" -i "${S}/library/src/CMakeLists.txt" || die

	eapply_user
	cmake_src_prepare
}

src_configure() {
	# Grant access to the device
        addwrite /dev/kfd
        addpredict /dev/dri/

	# Compiler to use
	export CXX="/usr/lib/hip/bin/hipcc"

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_CXX_FLAGS="--rocm-path=/usr"
		-DCMAKE_PREFIX_PATH="${HIP_PATH}"
	)

	cmake_src_configure
}
