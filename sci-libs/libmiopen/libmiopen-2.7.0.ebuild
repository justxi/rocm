# Copyright
#

EAPI=6

inherit cmake-utils

DESCRIPTION="MIOpen"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpen"
SRC_URI="https://github.com/ROCmSoftwarePlatform/MIOpen/archive/roc-${PV}.tar.gz -> MIOpen-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="=sys-devel/hip-${PV}
	>=dev-libs/half-1.12.0
	=dev-util/rocm-clang-ocl-${PV}
	dev-libs/boost"
DEPEND="${RDPEND}
	dev-util/cmake"

S="${WORKDIR}/MIOpen-roc-${PV}"

src_prepare() {
	eapply "${FILESDIR}"/${P}-remove-static-boost.patch
	cmake-utils_src_prepare
}

src_configure() {
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
}
