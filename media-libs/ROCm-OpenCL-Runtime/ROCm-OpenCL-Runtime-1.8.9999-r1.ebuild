# Copyright
#

EAPI=6

DESCRIPTION="ROCm-OpenCL-Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/ocaml
	dev-ml/findlib
	app-admin/chrpath
	dev-util/repo
        dev-cpp/gtest"

RDEPEND="media-libs/ROCR-Runtime"

BUILD_DIR="${WORKDIR}/build"

src_unpack() {
	mkdir ${S}
	cd ${S}
	repo init -u https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime.git -b roc-1.8.x -m opencl.xml
	repo sync
}

src_configure() {
	mkdir ${BUILD_DIR}
	cd ${BUILD_DIR}
	cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo "${S}/opencl"
}

src_compile() {
	cd ${BUILD_DIR}
	make VERBOSE=1 ${MAKEOPTS}
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
        doins ${S}/opencl/api/opencl/config/amdocl64.icd 
}

pkg_postinst() {
        elog "If more than one OpenCL library is installed, set environment variable OCL_ICD_VENDORS:"
        elog "> export OCL_ICD_VENDORS=amdocl64.icd"
}


