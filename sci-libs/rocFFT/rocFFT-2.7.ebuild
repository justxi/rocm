# Copyright
#

EAPI=7

inherit git-r3

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocFFT"
EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocFFT.git"
EGIT_COMMIT="rocm-$(ver_cut 1-2)"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

#RDEPEND="=sys-devel/hip-${PV}*"
RDEPEND=""
DEPEND="${RDPEND}
	dev-util/cmake"

src_prepare() {
	CFLAGS=""
	CXXFLAGS=""
	LDFLAGS=""
	cd ${S}
	eapply_user
}

src_configure() {
	mkdir -p "${WORKDIR}/build/"
	cd "${WORKDIR}/build/"

#	export PATH=$PATH:/usr/lib/hcc/$(ver_cut 1-2)/bin
#	export hcc_DIR=/usr/lib/hcc/$(ver_cut 1-2)/lib/cmake/
#	export hip_DIR=/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/
#	export HIP_DIR=/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/
#	export CXX=/usr/lib/hcc/$(ver_cut 1-2)/bin/hcc

	export PATH=$PATH:/usr/lib/hcc/2.6/bin
	export hcc_DIR=/usr/lib/hcc/2.6/lib/cmake/
	export hip_DIR=/usr/lib/hip/2.6/lib/cmake/
	export HIP_DIR=/usr/lib/hip/2.6/lib/cmake/
	export CXX=/usr/lib/hcc/2.6/bin/hcc

	cmake -DHIP_PLATFORM=hcc -DCMAKE_INSTALL_PREFIX="/usr/lib/" ${S}
}

src_compile() {
	cd "${WORKDIR}/build/"
	make VERBOSE=1
}

src_install() {
	cd "${WORKDIR}/build/"
	emake DESTDIR="${D}" install
}
