EAPI=7

DESCRIPTION="ROCm System Management Interface"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROC-smi"
SRC_URI="https://github.com/RadeonOpenCompute/ROC-smi/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE=""

DEPEND=""
RDEPEND="dev-libs/rocr-runtime"

S="${WORKDIR}/ROC-smi-rocm-${PV}"

src_compile() {
	einfo "Nothing todo"
}

src_install() {
	exeinto /usr/bin
	doexe ${S}/rocm_smi.py
	dosym ./rocm_smi.py /usr/bin/rocm-smi
}
