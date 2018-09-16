# Copyright
#

EAPI=6
inherit git-r3

DESCRIPTION="ROCm kernel sources"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver"
EGIT_BRANCH="roc-1.7.x"

LICENSE=""
SLOT="1.7"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_unpack() {
        git-r3_fetch ${EGIT_REPO_URI}
        git-r3_checkout ${EGIT_REPO_URI} "${S}/linux-4.13_roc1.7"
}

src_compile() {
	einfo "Nothing to compile..."
}

src_install() {
	dodir "/usr/src/"
	insinto "/usr/src/"
	doins -r "${S}/linux-4.13_roc1.7" || die "Install failed!"
}


