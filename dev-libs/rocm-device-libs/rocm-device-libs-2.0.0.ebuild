	# Copyright
#

EAPI=6

inherit cmake-utils eapi7-ver

DESCRIPTION="ROCm-Device-Libs"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-Device-Libs"
SRC_URI="https://github.com/RadeonOpenCompute/ROCm-Device-Libs/archive/roc-${PV}.tar.gz -> rocm-device-libs-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-libs/rocr-runtime
	 sys-devel/llvm-roc"

CMAKE_BUILD_TYPE="Release"

S="${WORKDIR}/ROCm-Device-Libs-roc-${PV}"

src_configure() {
	export LLVM_BUILD=/usr/lib/llvm/roc-${PV}
	export CC=$LLVM_BUILD/bin/clang

	local mycmakeargs=(
		-DLLVM_DIR=$LLVM_BUILD
		-DCMAKE_INSTALL_PREFIX=/usr/
	)

	cmake-utils_src_configure
}
