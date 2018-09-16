# Copyright
# 

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit git-r3 distutils-r1

DESCRIPTION="Stretching GPU performance for GEMMs and tensor contractions"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/Tensile"
EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/Tensile.git"
EGIT_BRANCH="develop"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="=dev-lang/python-2.7*
	dev-python/pyyaml"
DEPEND="dev-util/cmake"
	${RDPEND}
