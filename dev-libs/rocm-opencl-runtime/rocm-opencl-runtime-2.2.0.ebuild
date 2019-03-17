# Copyright
#

EAPI=6

inherit cmake-utils eapi7-ver

DESCRIPTION="ROCm OpenCL Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/"
SRC_URI="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/roc-${PV}.tar.gz -> rocm-opencl-runtime-${PV}.tar.gz
	 https://github.com/RadeonOpenCompute/ROCm-OpenCL-Driver/archive/roc-${PV}.tar.gz -> rocm-opencl-driver-${PV}.tar.gz
	 https://github.com/RadeonOpenCompute/ROCm-Device-Libs/archive/roc-${PV}.tar.gz -> rocm-device-libs-${PV}.tar.gz
	 https://github.com/justxi/OpenCL-ICD-Loader/archive/20180325.tar.gz -> OpenCL-ICD-Loader-20180325.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-cpp/gtest
        app-admin/chrpath"
RDEPEND="sys-devel/llvm-roc
	 dev-libs/rocr-runtime
	 !dev-libs/rocm-device-libs"

# should later depend on:
#	 dev-libs/rocm-device-libs

#PATCHES=(
#	"${FILESDIR}/rocm-opencl-driver-${PV}-add-link-libraries.patch"
#)

RESTRICT="strip"

S="${WORKDIR}/ROCm-OpenCL-Runtime-roc-${PV}"

BUILD_DIR="${WORKDIR}/build"

CMAKE_BUILD_TYPE="Release"

src_unpack() {
	unpack ${A}
	mkdir "${S}/library"
	ln -s "${WORKDIR}/ROCm-OpenCL-Driver-roc-${PV}" "${S}/compiler/driver"
	ln -s "${WORKDIR}/ROCm-Device-Libs-roc-${PV}" "${S}/library/amdgcn"
	ln -s "${WORKDIR}/OpenCL-ICD-Loader-20180325" "${S}/api/opencl/khronos/icd"
}

src_prepare() {
	# fails to build without that ...
	patch -d ../ROCm-OpenCL-Driver-roc-${PV}/ -p1 < ${FILESDIR}/rocm-opencl-driver-${PV}-add-link-libraries.patch || die
	 # remove unittest, because it loads additional software (googletest)
        sed -e "s:add_subdirectory(src/unittest):#add_subdirectory(src/unittest):" -i ${S}/compiler/driver/CMakeLists.txt || die

	# add path to /usr/lib/llvm/roc-${PV}/include ...
	patch -p1 < ${FILESDIR}/rocm-opencl-runtime-${PV}-add-paths.patch || die

	# remove the compiler subdirectory, we want to detect it from the system ...
	sed -e "s:add_subdirectory(compiler/llvm):#add_subdirectory(compiler/llvm):" -i CMakeLists.txt || die

	# change include directories to llvm/clang ...
	sed -e "s:\${CMAKE_SOURCE_DIR}/compiler/llvm/tools/clang/include:/usr/lib/llvm/roc-${PV}/include/:" -i CMakeLists.txt || die
	sed -e "s:\${CMAKE_SOURCE_DIR}/compiler/llvm/lib/Target/AMDGPU:/usr/lib/llvm/roc-${PV}/include/llvm/Target:" -i CMakeLists.txt || die

	# change path to "opencl-c.h"
	sed -e "s:< \${CMAKE_SOURCE_DIR}/compiler/llvm/tools/clang/lib/Headers/opencl-c.h:< /usr/lib/llvm/roc-${PV}/lib/clang/9.0.0/include/opencl-c.h:" -i runtime/device/rocm/CMakeLists.txt || die
	# remove dependency to cland directory inside build tree and change path to "opencl-c.h"
	sed -e "s:DEPENDS clang \${CMAKE_SOURCE_DIR}/compiler/llvm/tools/clang/lib/Headers/opencl-c.h:DEPENDS /usr/lib/llvm/roc-${PV}/lib/clang/9.0.0/include/opencl-c.h:" -i runtime/device/rocm/CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
                -DLLVM_DIR=/usr/lib/llvm/roc-${PV}/lib/cmake/llvm/
                -DClang_DIR=/usr/lib/llvm/roc-${PV}/lib/cmake/clang/
		-DCMAKE_INSTALL_PREFIX=/usr/
	)
	cmake-utils_src_configure
}

src_compile() {
	cd "${BUILD_DIR}/runtime/device/rocm"
	make -j1 || die

	cd ${BUILD_DIR}
	make -j1 || die
}

src_install() {

	cd ${BUILD_DIR}
	emake DESTDIR="${D}" install
	rm ${D}/usr/lib/libOpenCL.so.1.2

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

	# move headers to vendor directory
	mkdir "${D}${ROC_DIR}/include/"
	mv "${D}/usr/include/opencl2.2/CL" "${D}${ROC_DIR}/include/"
	rm -r "${D}/usr/include/opencl2.2"

	mv ${D}/usr/lib/x86_64/libamdocl64.so  ${D}/usr/lib64/
	rm -r ${D}/usr/lib/x86_64
	chrpath --delete "${D}/usr/lib64/libamdocl64.so"

	insinto /etc/OpenCL/vendors
        doins ${S}/api/opencl/config/amdocl64.icd

	# Do not install the program "clinfo", due to the fact it is already installable thru "dev-util/clinfo"
	rm ${D}/usr/bin/clinfo
}

pkg_postinst() {
        elog "If more than one OpenCL library is installed, set environment variable OCL_ICD_VENDORS:"
        elog "> export OCL_ICD_VENDORS=amdocl64.icd"
}
