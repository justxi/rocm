# Copyright
#

EAPI=6
inherit cmake-utils git-r3

DESCRIPTION="ROCm-OpenCL-Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/ocaml
	dev-ml/findlib
	app-admin/chrpath
        dev-cpp/gtest"

RDEPEND="virtual/blas
         >=dev-libs/rocr-runtime-${PV}"

CMAKE_BUILD_TYPE="RelWithDebInfo"

src_unpack() {
	EGIT_COMMIT="roc-2.3.0"
	git-r3_fetch ${EGIT_REPO_URI}

	EGIT_COMMIT="roc-2.3.0"
	git-r3_fetch "https://github.com/RadeonOpenCompute/ROCm-Device-Libs"

	EGIT_COMMIT="roc-2.3.0"
	git-r3_fetch "https://github.com/RadeonOpenCompute/ROCm-OpenCL-Driver"

	EGIT_COMMIT="roc-2.3.0"
	git-r3_fetch "https://github.com/RadeonOpenCompute/clang"

	EGIT_COMMIT="roc-ocl-2.3.0"
	git-r3_fetch "https://github.com/RadeonOpenCompute/llvm"

	EGIT_COMMIT="roc-ocl-2.3.0"
	git-r3_fetch "https://github.com/RadeonOpenCompute/lld"

	EGIT_COMMIT="d0f452d8480416b3b44838b5790a27dc02e766f5"
	git-r3_fetch "https://github.com/KhronosGroup/OpenCL-ICD-Loader"

	git-r3_checkout ${EGIT_REPO_URI}
	git-r3_checkout https://github.com/RadeonOpenCompute/ROCm-Device-Libs "${S}"/library/amdgcn
	git-r3_checkout https://github.com/RadeonOpenCompute/ROCm-OpenCL-Driver "${S}"/compiler/driver
	git-r3_checkout https://github.com/RadeonOpenCompute/llvm "${S}"/compiler/llvm
	git-r3_checkout https://github.com/RadeonOpenCompute/clang "${S}"/compiler/llvm/tools/clang
	git-r3_checkout https://github.com/RadeonOpenCompute/lld "${S}"/compiler/llvm/tools/lld
	git-r3_checkout https://github.com/KhronosGroup/OpenCL-ICD-Loader "${S}"/api/opencl/khronos/icd
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


