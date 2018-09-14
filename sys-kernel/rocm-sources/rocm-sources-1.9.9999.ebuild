# Copyright
#

EAPI=6
inherit git-r3

DESCRIPTION="ROCm-OpenCL-Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver"
EGIT_BRANCH="roc-1.9.x"

LICENSE=""
SLOT="1.9"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
        git-r3_fetch ${EGIT_REPO_URI}
        git-r3_checkout ${EGIT_REPO_URI} "${S}/linux-4.15_roc1.9"
}

src_compile() {
	einfo "Nothing to compile..."
}

src_install() {
	dodir "/usr/src/"
	insinto "/usr/src/"
	doins -r "${S}/linux-4.15_roc1.9" || die "Install failed!"
}


