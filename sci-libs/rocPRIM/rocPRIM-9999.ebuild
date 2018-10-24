# Copyright
#

EAPI=6

inherit git-r3

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocPRIM"
EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocPRIM.git"
EGIT_BRANCH="master"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="=sys-devel/hip-1.9*"
DEPEND="${RDPEND}
	dev-util/cmake"

src_prepare() {
	cd ${S}
        eapply "${FILESDIR}/master-disable2ndfindhcc.patch"
        eapply_user
}

src_configure() {
        mkdir -p "${WORKDIR}/build/"
        cd "${WORKDIR}/build/"

	export PATH=$PATH:/usr/lib/hcc/1.9/bin
	export hcc_DIR=/usr/lib/hcc/1.9/lib/cmake/
	export hip_DIR=/usr/lib/hip/1.9/lib/cmake/
	export HIP_DIR=/usr/lib/hip/1.9/lib/cmake/
	export CXX=/usr/lib/hcc/1.9/bin/hcc

	cmake -DHIP_PLATFORM=hcc -DHIP_ROOT_DIR=/usr/lib/hip/1.9/ -DBUILD_TEST=OFF -DCMAKE_INSTALL_PREFIX=/usr/ ${S}
}

src_compile() {
        cd "${WORKDIR}/build/"
        make VERBOSE=1
}

src_install() {
        cd "${WORKDIR}/build/"
	emake DESTDIR="${D}" install
}


