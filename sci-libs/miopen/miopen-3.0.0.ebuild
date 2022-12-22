# Copyright
#

EAPI=7

inherit cmake flag-o-matic

DESCRIPTION="MIOpen"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpen"
SRC_URI="https://github.com/ROCmSoftwarePlatform/MIOpen/archive/roc-${PV}.tar.gz -> MIOpen-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

IUSE="-static-boost -opencl"

RDEPEND="
	=sys-devel/hip-${PV}*
	>=dev-libs/half-1.12.0
	dev-libs/khronos-ocl-icd
	opencl? (
		sys-devel/llvm-roc
		sci-libs/miopengemm )
	!opencl? (
		=dev-util/rocm-clang-ocl-${PV}*
		sci-libs/rocBLAS )
	!static-boost? ( dev-libs/boost )
	static-boost? ( dev-libs/boost[static-libs] )"
DEPEND="${RDEPEND}
	dev-util/cmake"

S="${WORKDIR}/MIOpen-roc-${PV}"

src_prepare() {
	sed -e "s:set( MIOPEN_INSTALL_DIR miopen):set( MIOPEN_INSTALL_DIR \"\"):" -i CMakeLists.txt
	sed -e "s:set( DATA_INSTALL_DIR \${MIOPEN_INSTALL_DIR}/\${CMAKE_INSTALL_DATAROOTDIR}/miopen ):set( DATA_INSTALL_DIR \${CMAKE_INSTALL_PREFIX}/\${CMAKE_INSTALL_DATAROOTDIR}/miopen ):" -i CMakeLists.txt
	sed -e "s:set(MIOPEN_SYSTEM_DB_PATH \"\${CMAKE_INSTALL_PREFIX}/\${DATA_INSTALL_DIR}/db\":set(MIOPEN_SYSTEM_DB_PATH \"\${DATA_INSTALL_DIR}/db\":" -i CMakeLists.txt
	sed -e "s:DESTINATION \${MIOPEN_INSTALL_DIR}/bin:DESTINATION \${CMAKE_INSTALL_PREFIX}/bin:" -i driver/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir(\${MIOPEN_INSTALL_DIR}):#rocm_install_symlink_subdir(\${MIOPEN_INSTALL_DIR}):" -i src/CMakeLists.txt

	cmake_src_prepare
}

src_configure() {
	strip-flags
	filter-flags '*march*'

	CMAKE_MAKEFILE_GENERATOR=emake

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr/
		-DCMAKE_BUILD_TYPE=Release
	)

	if use opencl; then
		mycmakeargs+=( "-DMIOPEN_BACKEND=OpenCL" )
	else
		CXX="${HCC_HOME}/bin/hcc"
		mycmakeargs+=( "-DMIOPEN_BACKEND=HIP" )
	fi

	if ! use static-boost; then
		mycmakeargs+=( "-DBoost_USE_STATIC_LIBS=Off" )
	fi

	cmake_src_configure
}
