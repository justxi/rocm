# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit git-r3 distutils-r1

DESCRIPTION="Stretching GPU performance for GEMMs and tensor contractions"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/Tensile"
EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/Tensile.git"
EGIT_BRANCH="develop"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-python/pyyaml"
DEPEND="dev-util/cmake
	${RDEPEND}"
