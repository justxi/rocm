# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )

inherit git-r3 distutils-r1

DESCRIPTION="Stretching GPU performance for GEMMs and tensor contractions"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/Tensile"
EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/Tensile.git"
EGIT_COMMIT="af71ea890a893e647bf2cf4571a90297d65689ca"
# taken from rocBLAS tensile_tag.txt

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

RDEPEND="dev-python/pyyaml"
DEPEND="dev-util/cmake
	${RDEPEND}"

src_install() {
	distutils-r1_src_install

	dodir "/usr/lib"
	mv "${D}/usr/cmake" "${D}/usr/lib/"
}
