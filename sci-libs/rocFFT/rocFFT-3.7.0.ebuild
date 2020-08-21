EAPI=7

inherit cmake-utils flag-o-matic check-reqs

DESCRIPTION="Next generation FFT implementation for ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocFFT"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocFFT/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64"
SLOT="0/$(ver_cut 1-2)"

IUSE="gfx803 +gfx900 gfx906 gfx908"
REQUIRED_USE="|| ( gfx803 gfx900 gfx906 gfx908 )"

RDEPEND="sys-devel/hip"
DEPEND="${RDEPEND}
	dev-util/rocm-cmake"

CHECKREQS_MEMORY="28G"

PATCHES=(
	"${FILESDIR}/rocFFT-library_src_CMakeListstxt.patch"
)

rocFFT_V="0.1"

S="${WORKDIR}/${PN}-rocm-${PV}"

pkg_pretend() {
	if [ "${MAKEOPTS}" != "" ] && [ "${MAKEOPTS}" != "-j1" ]; then
		einfo "-------------------------------------------------------------------"
		einfo " If the build takes too long or swaps too much, try MAKEOPTS=\"-j1\""
		einfo " e.g. override it in /etc/package/package.env "
		einfo "-------------------------------------------------------------------"
	fi
}

src_prepare() {
	sed -e "s: PREFIX rocfft:# PREFIX rocfft:" -i library/src/CMakeLists.txt
	sed -e "s:\$<INSTALL_INTERFACE\:include>:\$<INSTALL_INTERFACE\:include/rocFFT>:" -i library/src/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir( rocfft ):#rocm_install_symlink_subdir( rocfft ):" -i library/src/CMakeLists.txt

	sed "$!N;s:PREFIX\n  rocfft:# PREFIX rocfft\n:;P;D" -i library/src/device/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir( rocfft ):#rocm_install_symlink_subdir( rocfft ):" -i library/src/device/CMakeLists.txt

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
		-DUSE_HIP_CLANG=ON
		-DHIP_COMPILER=clang
		-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"
		-DBUILD_VERBOSE=ON
		-DBUILD_CLIENTS_RIDER=OFF
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS=OFF
		-DAMDDeviceLibs_DIR="${HIP_PATH}/lib/cmake/AMDDeviceLibs"
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocfft"
		-DCMAKE_INSTALL_LIBDIR="/usr/$(get_libdir)"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	chrpath --delete "${D}/usr/lib64/librocfft.so.${rocFFT_V}"
}
