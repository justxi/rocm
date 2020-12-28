# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

DESCRIPTION="AMD's Machine Intelligence Library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpen"
SRC_URI="https://github.com/ROCmSoftwarePlatform/MIOpen/archive/rocm-${PV}.tar.gz -> MIOpen-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

IUSE="-static-boost -opencl"

RDEPEND="
	>=dev-util/hip-${PV}
	>=dev-libs/half-1.12.0
	dev-libs/ocl-icd
	opencl? (
		sys-devel/llvm-roc
		sci-libs/miopengemm )
	!opencl? (
		=dev-util/rocm-clang-ocl-${PV}*
		sci-libs/rocBLAS[tensile] )
	!static-boost? ( =dev-libs/boost-1.72* )
	static-boost? ( =dev-libs/boost-1.72*[static-libs] )"

DEPEND="${RDEPEND}
	dev-util/cmake"

S="${WORKDIR}/MIOpen-rocm-${PV}"

src_prepare() {
	sed -e "s:PATHS /opt/rocm/llvm:PATHS /usr/lib/llvm/roc/ NO_DEFAULT_PATH:" -i "${S}/CMakeLists.txt" || die
	sed -e "s:set( MIOPEN_INSTALL_DIR miopen):set( MIOPEN_INSTALL_DIR \"\"):" -i "${S}/CMakeLists.txt" || die
	sed -e "s:set( DATA_INSTALL_DIR \${MIOPEN_INSTALL_DIR}/\${CMAKE_INSTALL_DATAROOTDIR}/miopen ):set( DATA_INSTALL_DIR \${CMAKE_INSTALL_PREFIX}/\${CMAKE_INSTALL_DATAROOTDIR}/miopen ):" -i "${S}/CMakeLists.txt" || die
	sed -e "s:set(MIOPEN_SYSTEM_DB_PATH \"\${CMAKE_INSTALL_PREFIX}/\${DATA_INSTALL_DIR}/db\":set(MIOPEN_SYSTEM_DB_PATH \"\${DATA_INSTALL_DIR}/db\":" -i "${S}/CMakeLists.txt" || die

	sed -e "s:DESTINATION \${MIOPEN_INSTALL_DIR}/bin:DESTINATION \${CMAKE_INSTALL_PREFIX}/bin:" -i "${S}/driver/CMakeLists.txt" || die

	sed -e "s:rocm_install_symlink_subdir(\${MIOPEN_INSTALL_DIR}):#rocm_install_symlink_subdir(\${MIOPEN_INSTALL_DIR}):" -i "${S}/src/CMakeLists.txt" || die

	sed -e "s:\${AMD_DEVICE_LIBS_PREFIX}/lib:/usr/lib/amdgcn/bitcode:" -i "${S}/cmake/hip-config.cmake" || die

	cmake_src_prepare
}

src_configure() {
	strip-flags
	filter-flags '*march*'

	CXX="${EPREFIX}/usr/lib/llvm/roc/bin/clang++"

	local mycmakeargs=(
		-DMIOPEN_AMDGCN_ASSEMBLER_PATH="/usr/lib/llvm/roc/bin"
		-DCMAKE_CXX_FLAGS="--rocm-path=/usr -I/${EPREFIX}/usr/lib/llvm/roc/lib/clang/12.0.0"
		-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr/
		-DCMAKE_BUILD_TYPE=Release
	)

	if use opencl; then
		mycmakeargs+=( "-DMIOPEN_BACKEND=OpenCL" )
	else
		mycmakeargs+=( "-DMIOPEN_BACKEND=HIP" )
	fi

	if ! use static-boost; then
		mycmakeargs+=( "-DBoost_USE_STATIC_LIBS=Off" )
	fi

	cmake_src_configure
}

src_install() {
        cmake_src_install
	chrpath --delete "${D}/usr/bin/MIOpenDriver"
        chrpath --delete "${D}/usr/lib64/libMIOpen.so.1.0"
}
