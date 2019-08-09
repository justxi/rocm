# Copyright
# 

EAPI=6

DESCRIPTION="ROCm System Management Interface"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROC-smi"
SRC_URI="https://github.com/RadeonOpenCompute/ROC-smi/archive/roc-${PV}.tar.gz -> rocm-smi-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-libs/rocr-runtime"

src_unpack() {
	unpack ${A}
	mv ROC-smi-roc-${PV} rocm-smi-${PV}
}

src_compile() {
	einfo "Nothing todo"
}

src_install() {
	exeinto /usr/bin
	doexe ${S}/rocm_smi.py
	dosym ./rocm_smi.py /usr/bin/rocm-smi
}
