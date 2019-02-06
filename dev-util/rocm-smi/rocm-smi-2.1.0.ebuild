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
	mv ROC-smi-roc-2.1.0 rocm-smi-2.1.0
}

src_compile() {
	einfo "Nothing todo"
}

src_install() {
	exeinto /opt/rocm/bin
	doexe ${S}/rocm_smi.py
	dosym ./rocm_smi.py /opt/rocm/bin/rocm-smi
}
