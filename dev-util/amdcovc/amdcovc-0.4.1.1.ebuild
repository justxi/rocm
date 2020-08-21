EAPI=7

inherit eutils

DESCRIPTION="Control AMD Overdrive settings with or without X."
HOMEPAGE="https://github.com/matszpk/amdcovc"
SRC_URI="https://github.com/matszpk/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSEe="GPL"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-libs/ocl-icd
	sys-apps/pciutils"
RDEPEND="dev-util/opencl-headers"

src_install() {
	dobin ${PN}
	dodoc README.md
}
