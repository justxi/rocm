# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="An OpenCL general matrix multiplication (GEMM) API and kernel generator"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpenGEMM"
SRC_URI="https://github.com/ROCmSoftwarePlatform/MIOpenGEMM/archive/rocm-${PV}.tar.gz -> miopengemm-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

IUSE="-benchmark"

RDEPEND="virtual/opencl"
DEPEND="dev-util/rocm-cmake
	sys-devel/llvm-roc"

S="${WORKDIR}/MIOpenGEMM-rocm-${PV}"

src_prepare() {
	sed -e "s:set( miopengemm_INSTALL_DIR miopengemm):set( miopengemm_INSTALL_DIR \"\"):" -i "${S}/miopengemm/CMakeLists.txt" || die
	sed -e "s:rocm_install_symlink_subdir(\${miopengemm_INSTALL_DIR}):#rocm_install_symlink_subdir(\${miopengemm_INSTALL_DIR}):" -i "${S}/miopengemm/CMakeLists.txt" || die

	cmake-utils_src_prepare
}

src_configure() {
	strip-flags
	filter-flags '*march*'

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/"
	)

	if use benchmark; then
		mycmakeargs+=( "-DAPI_BENCH_MIOGEMM=On" )
	fi
	cmake-utils_src_configure
}
