EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="Next generation library for iterative sparse solvers for ROCm platform"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocALUTION"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocALUTION/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64"
SLOT="0/$(ver_cut 1-2)"

IUSE="hipify +openmp mpi gfx803 +gfx900 gfx906 gfx908"
REQUIRED_USE="|| ( hipify openmp mpi )"
REQUIRED_USE="|| ( gfx803 gfx900 gfx906 gfx908 )"

RDEPEND="sys-devel/hip
	>=sci-libs/rocSPARSE-${PV}
	>=sci-libs/rocBLAS-${PV}
	>=sci-libs/rocPRIM-${PV}
	mpi? ( virtual/mpi )
	openmp? ( sys-devel/gcc[openmp] )"
DEPEND="${RDEPEND}
	dev-util/rocm-cmake"

CMAKE_BUILD_TYPE="Release"

rocALUTION_V="0.1"

S="${WORKDIR}/${PN}-rocm-${PV}"

src_prepare() {
	sed -e "s: PREFIX rocalution):):g" -i src/CMakeLists.txt
	sed -e "s: PREFIX rocalution:# PREFIX rocalution:g" -i src/CMakeLists.txt
	sed -e "s:\$<INSTALL_INTERFACE\:include/>:\$<INSTALL_INTERFACE\:include/rocalution/>:" -i src/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir( rocalution ):#rocm_install_symlink_subdir( rocalution ):" -i src/CMakeLists.txt

	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	strip-flags
	filter-flags '*march*'

	# if the ISA is not set previous to the autodetection,
	# /opt/rocm/bin/rocm_agent_enumerator is executed,
	# this leads to a sandbox violation
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
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS=OFF
		-DSUPPORT_HIP=OFF
		-DAMDDeviceLibs_DIR=${HIP_PATH}/lib/cmake/AMDDeviceLibs
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocalution"
		-DCMAKE_INSTALL_LIBDIR="/usr/$(get_libdir)"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	chrpath --delete "${D}/usr/lib64/librocalution.so.${rocALUTION_V}"
}
