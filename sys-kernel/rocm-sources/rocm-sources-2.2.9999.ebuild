# Copyright
#

EAPI=6
inherit git-r3

DESCRIPTION="ROCm kernel sources"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver"
EGIT_BRANCH="roc-2.2.x"

LICENSE=""
SLOT="2.2"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
        git-r3_fetch ${EGIT_REPO_URI}
        git-r3_checkout ${EGIT_REPO_URI} "${S}/linux-4.18_roc2.2"
}

src_compile() {
	einfo "Nothing to compile..."
}

src_install() {
	dodir "/usr/src/"
	insinto "/usr/src/"
	doins -r "${S}/linux-4.18_roc2.2" || die "Install failed!"
}


