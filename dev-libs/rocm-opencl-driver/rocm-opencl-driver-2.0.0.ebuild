# Copyright
#

EAPI=7

DESCRIPTION="ROCm-OpenCL-Driver"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Driver"
SRC_URI="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Driver/archive/roc-2.0.0.tar.gz -> rocm-opencl-driver-2.0.0.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-libs/rocr-runtime
	 sys-devel/llvm-roc"

S="${WORKDIR}/ROCm-OpenCL-Driver-roc-2.0.0"

src_configure() {
        mkdir "${WORKDIR}/build"
        cd "${WORKDIR}/build"
	export LLVM_DIR=/opt/rocm/llvm/
	cmake -DLLVM_DIR=$LLVM_DIR -DCMAKE_INSTALL_PREFIX=/opt/rocm/ ${S}
}

src_compile() {
        cd "${WORKDIR}/build"
#        make VERBOSE=1 ${MAKEOPTS} || die "compile failed!"
        make VERBOSE=1 || die "compile failed!"
}

src_install() {
        cd "${WORKDIR}/build"
        emake DESTDIR="${D}" install || die "install failed!"
}

