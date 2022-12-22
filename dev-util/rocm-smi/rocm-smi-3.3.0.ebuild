# Copyright
#

EAPI=7

DESCRIPTION="ROCm System Management Interface"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROC-smi"

if [[ ${PV} == *9999 ]] ; then
	KEYWORDS="**"
	inherit git-r3
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROC-smi"
	EGIT_BRANCH="master"
else
	SRC_URI="https://github.com/RadeonOpenCompute/ROC-smi/archive/roc-${PV}.tar.gz -> rocm-smi-${PV}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/ROC-smi-roc-${PV}"
fi

LICENSE=""
SLOT="0"
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
