EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Stretching GPU performance for GEMMs and tensor contractions"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/Tensile"
SRC_URI="https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${PV}.tar.gz -> ${P}-2.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64"

IUSE=""
REQUIRED_USE=""

DEPEND=""
RDEPEND="dev-python/pyyaml
	>=dev-util/rocm-cmake-${PV}"

PATCHES=(
	"${FILESDIR}/Tensile-3.7.0-add_HIP_include_path.patch"
)

S="${WORKDIR}"/${PN}-rocm-${PV}

src_prepare() {
	find . -type f -exec sed -i -e "s:opt/rocm/hip:usr/lib/hip/3.7:g" {} \;
	find . -type f -exec sed -i -e "s:opt/rocm/hip:usr/lib/hcc/3.7:g" {} \; # hcc deprecated TODO DEL
	find . -type f -exec sed -i -e "s:opt/rocm:usr:g" {} \;

	eapply_user

	distutils-r1_src_prepare
}
