# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Stretching GPU performance for GEMMs and tensor contractions"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/Tensile"
SRC_URI="https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${PV}.tar.gz -> rocm-Tensile-${PV}.tar.gz"

S=${WORKDIR}/${PN}-rocm-${PV}
LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/pyyaml"
DEPEND="dev-util/cmake
	${RDEPEND}"

src_install() {
        distutils-r1_src_install

        dodir "/usr/lib"
        mv "${D}/usr/cmake" "${D}/usr/lib/"
}

