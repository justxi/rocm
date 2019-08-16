# Copyright
# 

EAPI=6
inherit git-r3

DESCRIPTION="ROCm System Management Interface"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROC-smi"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROC-smi"
EGIT_BRANCH="master"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-libs/rocr-runtime"

src_compile() {
	einfo "Nothing todo"
}

src_install() {
	exeinto /usr/bin
	doexe ${S}/rocm_smi.py
	dosym ./rocm_smi.py /usr/bin/rocm-smi
}
