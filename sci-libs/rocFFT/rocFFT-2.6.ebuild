# Copyright
#

EAPI=7

#inherit git-r3

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocFFT"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocFFT/archive/v0.9.4.tar.gz -> rocFFT-2.6.0.tar.gz"
#EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocFFT.git"
#EGIT_COMMIT="rocm-$(ver_cut 1-2)"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="=sys-devel/hip-${PV}*"
DEPEND="${RDPEND}
	dev-util/cmake"

S="${WORKDIR}/rocFFT-0.9.4"

src_prepare() {
	cd ${S}

#	sed -e "s:target_link_libraries( rocfft-device PRIVATE --amdgpu-target=\${target} ):target_compile_options( rocfft-device PRIVATE --amdgpu-target=\${target} ):" -i library/src/device/CMakeLists.txt
#	sed -e "s:target_link_libraries( rocfft PRIVATE --amdgpu-target=\${target} ):target_compile_options( rocfft PRIVATE --amdgpu-target=\${target} ):" -i library/src/CMakeLists.txt

	eapply "${FILESDIR}/rocFFT-library_src_CMakeListstxt.patch"
	eapply "${FILESDIR}/rocFFT-library_src_device_CMakeListstxt.patch"

	eapply_user
}

src_configure() {
	mkdir -p "${WORKDIR}/build/"
	cd "${WORKDIR}/build/"

	export PATH=$PATH:/usr/lib/hcc/$(ver_cut 1-2)/bin
	export hcc_DIR=/usr/lib/hcc/$(ver_cut 1-2)/lib/cmake/
	export hip_DIR=/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/
	export HIP_DIR=/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/
	export CXX=/usr/lib/hcc/$(ver_cut 1-2)/bin/hcc

	cmake -DHIP_PLATFORM=hcc -DCMAKE_INSTALL_PREFIX="/usr/lib/" -DAMDGPU_TARGETS="gfx803"  ${S}
}

src_compile() {
	cd "${WORKDIR}/build/"
	make VERBOSE=1
}

src_install() {
	cd "${WORKDIR}/build/"
	emake DESTDIR="${D}" install
}
