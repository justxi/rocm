# Copyright
#

EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="MIOpen"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpen"
SRC_URI="https://github.com/ROCmSoftwarePlatform/MIOpen/archive/roc-${PV}.tar.gz -> MIOpen-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="=sys-devel/hip-${PV}*
	>=dev-libs/half-1.12.0
	=dev-util/rocm-clang-ocl-${PV}*
	dev-libs/boost"
DEPEND="${RDEPEND}
	dev-util/cmake
	sci-libs/rocBLAS"

S="${WORKDIR}/MIOpen-roc-${PV}"

PATCHES=(
	"${FILESDIR}/${P}-remove-static-boost.patch"
)

src_configure() {
	strip-flags
	CMAKE_MAKEFILE_GENERATOR=emake
	CXX="/usr/lib/hcc/$(ver_cut 1-2)/bin/hcc"
	cmake-utils_src_configure
}
