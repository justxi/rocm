# Copyright
#

EAPI=7

DESCRIPTION="ROCm llvm,lld,clang"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm/"
SRC_URI="https://github.com/RadeonOpenCompute/llvm/archive/roc-${PV}.tar.gz -> llvm-roc-${PV}.tar.gz
         https://github.com/RadeonOpenCompute/clang/archive/roc-${PV}.tar.gz -> clang-roc-${PV}.tar.gz
         https://github.com/RadeonOpenCompute/lld/archive/roc-${PV}.tar.gz -> lld-roc-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="virtual/cblas
	 dev-libs/rocr-runtime"

src_unpack() {
	unpack ${A}
	ln -s "${WORKDIR}/clang-roc-${PV}" "${WORKDIR}/llvm-roc-${PV}/tools/clang"
	ln -s "${WORKDIR}/lld-roc-${PV}" "${WORKDIR}/llvm-roc-${PV}/tools/lld"
}

src_configure() {
        mkdir "${WORKDIR}/build"
        cd "${WORKDIR}/build"
        cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/lib/llvm/roc-${PV} -DLLVM_TARGETS_TO_BUILD="AMDGPU;X86" ${S}
}

src_compile() {
        cd "${WORKDIR}/build"
        make VERBOSE=1 ${MAKEOPTS}
}

src_install() {
        cd "${WORKDIR}/build"
        emake DESTDIR="${D}" install
}

