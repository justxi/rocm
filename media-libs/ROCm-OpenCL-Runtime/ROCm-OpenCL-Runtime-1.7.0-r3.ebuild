# Copyright
# 

EAPI=6
inherit cmake-utils 

DESCRIPTION="ROCm-OpenCL-Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime"
SRC_URI="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/roc-${PV}.tar.gz -> ${P}.tar.gz
         https://github.com/RadeonOpenCompute/ROCm-Device-Libs/archive/roc-1.7.0.tar.gz -> ROCm-Device-Libs-1.7.0.tar.gz
         https://github.com/RadeonOpenCompute/ROCm-OpenCL-Driver/archive/roc-1.7.0.tar.gz -> ROCm-OpenCL-Driver-1.7.0.tar.gz
         https://github.com/RadeonOpenCompute/llvm/archive/roc-1.7.0.tar.gz -> llvm-roc-1.7.0.tar.gz
         https://github.com/RadeonOpenCompute/clang/archive/roc-1.7.0.tar.gz -> clang-roc-1.7.0.tar.gz
         https://github.com/RadeonOpenCompute/lld/archive/roc-1.7.0.tar.gz -> lld-roc-1.7.0.tar.gz
         https://github.com/justxi/OpenCL-ICD-Loader/archive/20180325.tar.gz -> ocl-icd-20180325.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/ocaml
	dev-vcs/git
	app-admin/chrpath"
RDEPEND="media-libs/ROCR-Runtime"

S="${WORKDIR}/${PN}-roc-${PV}/"

CMAKE_BUILD_TYPE="RelWithDebInfo"

src_unpack() {
	unpack ${A}
	mkdir "${S}/library"
	ln -s "${WORKDIR}/ROCm-Device-Libs-roc-1.7.0" "${S}/library/amdgcn"
	ln -s "${WORKDIR}/ROCm-OpenCL-Driver-roc-1.7.0" "${S}/compiler/driver"
	ln -s "${WORKDIR}/llvm-roc-1.7.0" "${S}/compiler/llvm"
	ln -s "${WORKDIR}/clang-roc-1.7.0" "${WORKDIR}/llvm-roc-1.7.0/tools/clang"
	ln -s "${WORKDIR}/lld-roc-1.7.0" "${WORKDIR}/llvm-roc-1.7.0/tools/lld"
	ln -s "${WORKDIR}/OpenCL-ICD-Loader-20180325" "${S}/api/opencl/khronos/icd"
}

src_install() {
	chrpath --delete "${BUILD_DIR}/lib/libamdocl64.so"
	dolib.so "${BUILD_DIR}/lib/libamdocl64.so"

        ROC_DIR=/usr/"$(get_libdir)"/OpenCL/vendors/roc/
	dodir "${ROC_DIR}"

	dolib.so "${BUILD_DIR}/lib/libOpenCL.so.1.2"
	chrpath --delete "${BUILD_DIR}/lib/libOpenCLDriverStub.so"
	dolib.so "${BUILD_DIR}/lib/libOpenCLDriverStub.so"
	mv ${D}/usr/"$(get_libdir)"/libOpenCL* ${D}"${ROC_DIR}"

	dolib.so "${BUILD_DIR}/lib/libIcdLog.so"
	mv ${D}/usr/"$(get_libdir)"/libIcdLog* ${D}"${ROC_DIR}"

	into "${ROC_DIR}"
	dosym "libOpenCL.so.1.2" "${ROC_DIR}/libOpenCL.so"
	dosym "libOpenCL.so.1.2" "${ROC_DIR}/libOpenCL.so.1"

	insinto /etc/OpenCL/vendors
        doins ${S}/api/opencl/config/amdocl64.icd 
}

pkg_postinst() {
        elog "If more than one OpenCL library is installed, set environment variable OCL_ICD_VENDORS:"
        elog "> export OCL_ICD_VENDORS=amdocl64.icd"
}

