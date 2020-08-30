# Copyright
#

EAPI=7

inherit cmake-utils flag-o-matic check-reqs

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocFFT"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocFFT/archive/rocm-${PV}.tar.gz -> rocFFT-${PV}.tar.gz"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

IUSE="+gfx803 gfx900 gfx906 gfx908"
REQUIRED_USE="|| ( gfx803 gfx900 gfx906 gfx908 )"

RDEPEND="=sys-devel/hip-$(ver_cut 1-2)*"
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
	cd ${S}

	sed -e "s: PREFIX rocfft:# PREFIX rocfft:" -i ${S}/library/src/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir( rocfft ):#rocm_install_symlink_subdir( rocfft ):" -i ${S}/library/src/CMakeLists.txt
	sed -e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/rocFFT:" -i ${S}/library/src/CMakeLists.txt

	sed "$!N;s:PREFIX\n  rocfft:# PREFIX rocfft\n:;P;D" -i ${S}/library/src/device/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir( rocfft ):#rocm_install_symlink_subdir( rocfft ):" -i ${S}/library/src/device/CMakeLists.txt

	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	strip-flags
	filter-flags '*march*'

	# Tested in ROCm 3.3:
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

	export CXX=hipcc

	local mycmakeargs=(
		-Wno-dev
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocFFT/"
		-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"
	)

        # this is necessary to omit a sandbox vialation,
        # but it does not seem to affect the targets list...
        echo "gfx803" >> ${WORKDIR}/target.lst
        export ROCM_TARGET_LST="${WORKDIR}/target.lst"

	cmake-utils_src_configure
}

src_install() {
        cmake-utils_src_install
        chrpath --delete "${D}/usr/lib64/librocfft.so.0.1"
}
