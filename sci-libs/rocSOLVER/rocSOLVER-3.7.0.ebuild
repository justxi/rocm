EAPI=7

inherit cmake-utils

DESCRIPTION="Implementation of a subset of LAPACK functionality on the ROCm platform"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocSOLVER"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocSOLVER/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64"
SLOT="0/$(ver_cut 1-2)"

IUSE="gfx803 +gfx900 gfx906 gfx908"
REQUIRED_USE="|| ( gfx803 gfx900 gfx906 gfx908 )"

RDEPEND="sys-devel/hip
	>=sci-libs/rocBLAS-${PV}"
DEPEND="${RDEPEND}
	dev-util/rocm-cmake
	>=dev-util/ninja-1.9.0"

rocSOLVER_V="0.1"

S="${WORKDIR}/${PN}-rocm-${PV}"

src_prepare() {
	sed -e "s: PREFIX rocsolver:# PREFIX rocsolver:" -i rocsolver/library/src/CMakeLists.txt
	sed -e "s:\$<INSTALL_INTERFACE\:include>:\$<INSTALL_INTERFACE\:include/rocsolver>:" -i rocsolver/library/src/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir( rocsolver ):#rocm_install_symlink_subdir( rocsolver ):" -i rocsolver/library/src/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	strip-flags
	filter-flags '*march*'

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
		-DCMAKE_PREFIX_PATH="${HIP_PATH}"
		-DHIP_COMPILER=clang
		-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"
		-DBUILD_VERBOSE=OFF
		-DBUILD_CLIENTS_TESTS=OFF
		-DBUILD_CLIENTS_BENCHMARKS=OFF
		-Damd_comgr_DIR=/usr/lib/cmake/amd_comgr
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocsolver"
		-DCMAKE_INSTALL_LIBDIR="/usr/$(get_libdir)"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	chrpath --delete "${D}/usr/lib64/librocsolver.so.${rocSOLVER_V}"
}
