# Copyright
#

EAPI=7

inherit cmake-utils flag-o-matic

LIB_VER="0.9.4"

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocFFT"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocFFT/archive/v${LIB_VER}.tar.gz -> rocFFT-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="+gfx803 gfx900 gfx906"
REQUIRED_USE="^^ ( gfx803 gfx900 gfx906 )"

RDEPEND="=sys-devel/hip-${PV}*"
DEPEND="${RDEPEND}
	dev-util/cmake"

S="${WORKDIR}/rocFFT-${LIB_VER}"

src_prepare() {
	strip-flags
	#eapply "${FILESDIR}/rocFFT-library_src_CMakeListstxt.patch"
	#eapply "${FILESDIR}/rocFFT-library_src_device_CMakeListstxt.patch"

	#sed -e "s:rocm_install_symlink_subdir( rocfft ):#rocm_install_symlink_subdir( rocfft ):" -i ${S}/library/src/CMakeLists.txt
	#sed -e "s: PREFIX rocfft:# PREFIX rocfft:" -i ${S}/library/src/CMakeLists.txt

	#sed -e "s: PREFIX rocfft:# PREFIX rocfft:" -i ${S}/library/src/device/CMakeLists.txt
	#sed -e "s:rocm_install_symlink_subdir( rocfft ):#rocm_install_symlink_subdir( rocfft ):" -i ${S}/library/src/device/CMakeLists.txt
	eapply_user
	cmake-utils_src_prepare
}

src_configure() {

	#mkdir -p "${WORKDIR}/build/"
	#cd "${WORKDIR}/build/"

	# if the ISA is not set previous to the autodetection,
	# /opt/rocm/bin/rocm_agent_enumerator is executed,
	# this leads to a sandbox violation
	if use gfx803; then
		CurrentISA="gfx803"
	fi
	if use gfx900; then
		CurrentISA="gfx900"
	fi
	if use gfx906; then
		CurrentISA="gfx906"
	fi

	#export PATH=$PATH:/usr/lib/hcc/$(ver_cut 1-2)/bin
	#export hcc_DIR=/usr/lib/hcc/$(ver_cut 1-2)/lib/cmake/
	#export hip_DIR=/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/
	#export HIP_DIR=/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/

	CXX=/usr/lib/hcc/$(ver_cut 1-2)/bin/hcc
	CMAKE_PREFIX_PATH="/usr/lib/hcc/$(ver_cut 1-2)/lib/cmake/hcc:/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/hip"

	local mycmakeargs=(
		-DHIP_PLATFORM=hcc
		-DAMDGPU_TARGETS="${CurrentISA}"
#		-DCMAKE_INSTALL_PREFIX="/usr/"
#		-DCMAKE_INSTALL_INCLUDEDIR="include/rocFFT/"
	)
	cmake-utils_src_configure
}

#src_compile() {
#	cd "${WORKDIR}/build/"
#	make VERBOSE=1
#}

#src_install() {
#	cd "${WORKDIR}/build/"
#	emake DESTDIR="${D}" install
#}
