EAPI=7

inherit eutils

DESCRIPTION="AMD Memory Tweak. Read and modify memory timings on the fly"
HOMEPAGE="https://github.com/Eliovp/amdmemorytweak"
SRC_URI="https://github.com/Eliovp/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="UoI-NCSA"

SLOT="$(ver_cut 1)"

KEYWORDS="amd64"
IUSE=""

RDEPEND="sys-apps/pciutils"
DEPEND="${RDEPEND}"
RDEPEND="${RDEPEND}"

DOCS=( README.md )

src_compile(){
	g++ linux/AmdMemTweak.cpp -lpci -lresolv -o ${PN}
}

src_install() {
	dobin ${PN}
	default
}
