# Copyright
#

EAPI=6

inherit git-r3

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocFFT"
EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocFFT.git"
EGIT_BRANCH="master-rocm-2.5"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="=sys-devel/hip-2.5*"
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

	export PATH=$PATH:/usr/lib/hcc/2.5/bin
	export hcc_DIR=/usr/lib/hcc/2.5/lib/cmake/
	export hip_DIR=/usr/lib/hip/2.5/lib/cmake/
	export HIP_DIR=/usr/lib/hip/2.5/lib/cmake/
	export CXX=/usr/lib/hcc/2.5/bin/hcc

	cmake -DHIP_PLATFORM=hcc -DHIP_ROOT_DIR=/usr/lib/hip/2.5/ -DBUILD_TEST=OFF -DCMAKE_INSTALL_PREFIX="/usr/lib/" ${S}
}

src_compile() {
	cd "${WORKDIR}/build/"
	make VERBOSE=1
}

src_install() {
	cd "${WORKDIR}/build/"
	emake DESTDIR="${D}" install
}
