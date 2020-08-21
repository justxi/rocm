EAPI=7

inherit eutils

DESCRIPTION="Control AMD Overdrive settings with or without X."
HOMEPAGE="https://github.com/matszpk/amdcovc"
COMMIT="e5ad5cd5334613a16b8c44b34a02a9baa51b6a83"
SRC_URI="https://github.com/OhGodAPet/OhGodATool/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSEe="GPL"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""

S="${WORKDIR}"/OhGodATool-${COMMIT}

src_install() {
	dobin ${PN}
	dodoc README.md
}
