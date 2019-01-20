# Copyright
#

EAPI=7

DESCRIPTION="ROCm-Device-Libs"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-Device-Libs"
SRC_URI="https://github.com/RadeonOpenCompute/ROCm-Device-Libs/archive/roc-2.0.0.tar.gz -> rocm-device-libs-2.0.0.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-libs/rocr-runtime
	 sys-devel/llvm-roc"

S="${WORKDIR}/ROCm-Device-Libs-roc-2.0.0"

src_configure() {
        mkdir "${WORKDIR}/build"
        cd "${WORKDIR}/build"
	export LLVM_BUILD=/opt/rocm/llvm/
	CC=$LLVM_BUILD/bin/clang cmake -DLLVM_DIR=$LLVM_BUILD -DCMAKE_INSTALL_PREFIX=/opt/rocm/ ${S}
}

src_compile() {
        cd "${WORKDIR}/build"
        make VERBOSE=1 ${MAKEOPTS}
}

src_install() {
        cd "${WORKDIR}/build"
        emake DESTDIR="${D}" install
}

