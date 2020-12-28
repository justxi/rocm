# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic check-reqs

DESCRIPTION="Next generation FFT implementation for ROCm"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocFFT"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocFFT/archive/rocm-${PV}.tar.gz -> rocFFT-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

IUSE="+gfx803 gfx900 gfx906 gfx908"
REQUIRED_USE="|| ( gfx803 gfx900 gfx906 gfx908 )"

RDEPEND="=dev-util/hip-$(ver_cut 1-2)*"
DEPEND="${RDEPEND}
	dev-util/cmake"

CHECKREQS_MEMORY="28G"

S="${WORKDIR}/rocFFT-rocm-${PV}"

pkg_pretend() {
	if [ "${MAKEOPTS}" != "" ] && [ "${MAKEOPTS}" != "-j1" ]; then
		einfo "-------------------------------------------------------------------"
		einfo " If the build takes too long or swaps too much, try MAKEOPTS=\"-j1\""
		einfo " e.g. override it in /etc/package/package.env "
		einfo "-------------------------------------------------------------------"
	fi
}

src_prepare() {
	sed -e "s: PREFIX rocfft:# PREFIX rocfft:" -i "${S}/library/src/CMakeLists.txt" || die
	sed -e "s:rocm_install_symlink_subdir( rocfft ):#rocm_install_symlink_subdir( rocfft ):" -i "${S}/library/src/CMakeLists.txt" || die
	sed -e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/rocFFT:" -i "${S}/library/src/CMakeLists.txt" || die

	sed "$!N;s:PREFIX\n  rocfft:# PREFIX rocfft\n:;P;D" -i "${S}/library/src/device/CMakeLists.txt" || die
	sed -e "s:rocm_install_symlink_subdir( rocfft ):#rocm_install_symlink_subdir( rocfft ):" -i "${S}/library/src/device/CMakeLists.txt" || die

	eapply_user
	cmake_src_prepare
}

src_configure() {
	# Process flags
	strip-flags
	filter-flags '*march*'

	# Grant access to the device
        addwrite /dev/kfd
        addpredict /dev/dri/

	# Compiler to use
	export CXX=hipcc

	# Select target
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

	local mycmakeargs=(
		-Wno-dev
		-DCMAKE_CXX_FLAGS="--rocm-path=/usr"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocFFT/"
		-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"
	)

	cmake_src_configure
}

src_install() {
        cmake_src_install
        chrpath --delete "${D}/usr/lib64/librocfft.so.0.1"
}
