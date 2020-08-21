EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="MIOpenGEMM"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpenGEMM"
SRC_URI="https://github.com/ROCmSoftwarePlatform/MIOpenGEMM/archive/rocm-${PV}.tar.gz -> miopengemm-${PV}.tar.gz"

KEYWORDS="amd64"
LICENSE="MIT"
SLOT="0"

ROCM_V="3.7.0"

RDEPEND="virtual/opencl"
DEPEND=">=dev-util/rocm-cmake-${ROCM_V}
	>=sys-devel/llvm-roc-${ROCM_V}"

S="${WORKDIR}/MIOpenGEMM-rocm-${PV}"

IUSE="-benchmark"

src_prepare() {
	sed -e "s:set( miopengemm_INSTALL_DIR miopengemm):set( miopengemm_INSTALL_DIR \"\"):" -i miopengemm/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir(\${miopengemm_INSTALL_DIR}):#rocm_install_symlink_subdir(\${miopengemm_INSTALL_DIR}):" -i miopengemm/CMakeLists.txt

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
