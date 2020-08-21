EAPI=7

inherit cmake

DESCRIPTION="Radeon Open Compute Device Libraries"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-Device-Libs"
SRC_URI="https://github.com/RadeonOpenCompute/ROCm-Device-Libs/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND=">=sys-devel/llvm-roc-${PV}"
DEPEND="${RDEPEND}"

S="${WORKDIR}/ROCm-Device-Libs-rocm-${PV}"

src_configure() {
	local mycmakeargs=(
		-DLLVM_DIR="${EPREFIX}/usr/lib/llvm/roc/$(ver_cut 1-2)/lib/cmake/llvm"
	)
	cmake_src_configure
}
