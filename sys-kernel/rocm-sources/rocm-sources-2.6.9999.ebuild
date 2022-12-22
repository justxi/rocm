# Copyright
#

EAPI=7
inherit git-r3

DESCRIPTION="ROCm kernel sources"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCK-Kernel-Driver"
EGIT_BRANCH="roc-2.6.x"

LICENSE=""
SLOT="2.6"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

KERNEL_VERSION="5.0.0-rc1"

src_unpack() {
        git-r3_fetch ${EGIT_REPO_URI}
        git-r3_checkout ${EGIT_REPO_URI} "${S}/linux-${KERNEL_VERSION}_roc${SLOT}"
}

src_compile() {
	einfo "Nothing to compile..."
}

src_install() {
	dodir "/usr/src/"
	insinto "/usr/src/"
	doins -r "${S}/linux-${KERNEL_VERSION}_roc${SLOT}" || die "Install failed!"
}


