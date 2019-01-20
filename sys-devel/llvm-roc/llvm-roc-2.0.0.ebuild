# Copyright
#

EAPI=7

DESCRIPTION="ROCm llvm,lld,clang"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm/"
SRC_URI="https://github.com/RadeonOpenCompute/llvm/archive/roc-2.0.0.tar.gz -> llvm-roc-2.0.0.tar.gz
         https://github.com/RadeonOpenCompute/clang/archive/roc-2.0.0.tar.gz -> clang-roc-2.0.0.tar.gz
         https://github.com/RadeonOpenCompute/lld/archive/roc-2.0.0.tar.gz -> lld-roc-2.0.0.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-libs/rocr-runtime"

src_unpack() {
	unpack ${A}
	ln -s "${WORKDIR}/clang-roc-2.0.0" "${WORKDIR}/llvm-roc-2.0.0/tools/clang"
	ln -s "${WORKDIR}/lld-roc-2.0.0" "${WORKDIR}/llvm-roc-2.0.0/tools/lld"
}

src_configure() {
        mkdir "${WORKDIR}/build"
        cd "${WORKDIR}/build"
        cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/rocm/llvm -DLLVM_TARGETS_TO_BUILD="AMDGPU;X86" ${S}
}

src_compile() {
        cd "${WORKDIR}/build"
        make VERBOSE=1 ${MAKEOPTS}
}

src_install() {
        cd "${WORKDIR}/build"
        emake DESTDIR="${D}" install
}

