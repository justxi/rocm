EAPI=7
inherit unpacker

DESCRIPTION="half"
HOMEPAGE="http://half.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/project/half/half/${PV}/half-${PV}.zip"

LICENSE="MIT"
KEYWORDS="amd64"
SLOT="0"

DEPEND="app-arch/unzip"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack(){
	default
	unpack_zip ${A}
}

src_install() {
	insinto /usr/include
	doins include/half.hpp
}
