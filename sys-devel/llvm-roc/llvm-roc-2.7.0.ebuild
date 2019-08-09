# Copyright
#

EAPI=7

inherit cmake-utils

DESCRIPTION="ROCm llvm,lld,clang"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm/"
SRC_URI="https://github.com/RadeonOpenCompute/llvm/archive/roc-ocl-${PV}.tar.gz -> llvm-roc-ocl-${PV}.tar.gz
         https://github.com/RadeonOpenCompute/clang/archive/roc-${PV}.tar.gz -> clang-roc-${PV}.tar.gz
         https://github.com/RadeonOpenCompute/lld/archive/roc-ocl-${PV}.tar.gz -> lld-roc-ocl-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="virtual/cblas
	 dev-libs/rocr-runtime"

CMAKE_BUILD_TYPE=RelWithDebInfo

S="${WORKDIR}/llvm-roc-ocl-${PV}"

src_unpack() {
	unpack ${A}
	ln -s "${WORKDIR}/clang-roc-${PV}" "${WORKDIR}/llvm-roc-ocl-${PV}/tools/clang"
	ln -s "${WORKDIR}/lld-roc-ocl-${PV}" "${WORKDIR}/llvm-roc-ocl-${PV}/tools/lld"
}

src_configure() {
	
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DBUILD_SHARED_LIBS=Off
		-DCMAKE_INSTALL_PREFIX=/usr/lib/llvm/roc-${PV}
		-DLLVM_TARGETS_TO_BUILD="AMDGPU;X86"
	)
	cmake-utils_src_configure
}
