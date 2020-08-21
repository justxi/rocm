EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="GTK GUI to view, monitor, and overclock a Radeon GPU on Linux"
HOMEPAGE="https://github.com/BoukeHaarsma23/WattmanGTK"
MY_PN="WattmanGTK"
COMMIT="54d248237362d38a0953c11e81ca99fbb0f556e6"
SRC_URI="https://github.com/BoukeHaarsma23/${MY_PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="GPLv2"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-python/pygobject:3
	dev-python/matplotlib
	dev-python/pycairo
"
RDEPEND=""

S="${WORKDIR}/${MY_PN}-${COMMIT}"

src_install() {
	distutils-r1_src_install
	# Copy license over
	insinto /usr/share/wattman-gtk
	doins LICENSE
	# Copy README over
	dodoc README.md
}