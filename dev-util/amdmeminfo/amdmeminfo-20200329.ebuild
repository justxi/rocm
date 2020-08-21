EAPI=7

inherit eutils

DESCRIPTION="Get memory information and other information from AMD Radeon GPUs"
HOMEPAGE="https://github.com/minershive/amdmeminfo"
COMMIT="72c7112b45f18e70ec29678ac72e218d4765631d"
SRC_URI="https://github.com/minershive/amdmeminfo/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/pciutils"

S="${WORKDIR}/${PN}-${COMMIT}"
DOCS=( README.md )

PATCHES=( "${FILESDIR}"/amdmeminfo_c.patch )

src_prepare(){
	default
	sed -i -e "s|x86|x86_64|g" Makefile || die
}

src_install() {
	dobin ${PN}
}
