EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="AMD's library for BLAS on ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocBLAS"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocBLAS/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64"
SLOT="0/$(ver_cut 1-2)"

IUSE="gfx803 +gfx900 gfx906 gfx908 debug"
REQUIRED_USE="^^ ( gfx803 gfx900 gfx906 gfx908 )"

RDEPEND="sys-devel/hip
	>=sci-libs/rocFFT-${PV}"
DEPEND="${RDEPEND}
	app-admin/chrpath
	dev-perl/File-Which"

# stripped library is not working
RESTRICT="strip"

PATCHES=(
	"${FILESDIR}/CMakeLists.txt-3.7.0.patch"
	"${FILESDIR}/CMAKE_PREFIX_PATH.patch"
)

rocBLAS_V="0.1"

S="${WORKDIR}/${PN}-rocm-${PV}"

src_prepare() {
	sed -e "s: PREFIX rocblas:# PREFIX rocblas:" -i library/src/CMakeLists.txt || die
	sed -e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/rocblas:" -i library/src/CMakeLists.txt || die

	sed -e "s:\\\\\${CPACK_PACKAGING_INSTALL_PREFIX}rocblas/lib:/usr/lib64/rocblas:" -i library/src/CMakeLists.txt || die
	sed -e "s:rocm_install_symlink_subdir( rocblas ):#rocm_install_symlink_subdir( rocblas ):" -i library/src/CMakeLists.txt || die
	sed -e "s:rocblas/include:include/rocblas:g" -i library/src/CMakeLists.txt

	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	strip-flags
	filter-flags '*march*'

	if use debug; then
		buildtype="Debug"
	else
		buildtype="Release"
	fi

	AMDGPU_TARGETS=""
	if use gfx803; then
		AMDGPU_TARGETS+="gfx803;"
	fi
	if use gfx900; then
		AMDGPU_TARGETS+="gfx900;"
	fi
	if use gfx906; then
		AMDGPU_TARGETS+="gfx906;"
	fi
	if use gfx908; then
		AMDGPU_TARGETS+="gfx908;"
	fi

	export CXX="${HIP_PATH}/bin/hipcc"

	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=${buildtype}
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_INSTALL_LIBDIR="/usr/$(get_libdir)/"
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocblas"
		-DCMAKE_PREFIX_PATH=/usr/lib/llvm/roc/$(ver_cut 1-2)/lib/cmake/llvm
		-Damd_comgr_DIR=/usr/lib/cmake/amd_comgr
		-DBUILD_WITH_TENSILE=OFF
		-DBUILD_CLIENTS_TESTS=OFF
		-DBUILD_CLIENTS_BENCHMARKS=OFF
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_TESTING=OFF
		-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"
		-DBUILD_VERBOSE=ON
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	chrpath --delete "${D}/usr/lib64/librocblas.so.${rocBLAS_V}"
}
