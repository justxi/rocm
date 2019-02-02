# Copyright
#

EAPI=6

inherit cmake-utils eapi7-ver

DESCRIPTION="ROCm OpenCL Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/"
SRC_URI="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/roc-2.0.0.tar.gz -> rocm-opencl-runtime-${PV}.tar.gz
	 https://github.com/RadeonOpenCompute/ROCm-OpenCL-Driver/archive/roc-2.0.0.tar.gz -> rocm-opencl-driver-${PV}.tar.gz
	 https://github.com/RadeonOpenCompute/ROCm-Device-Libs/archive/roc-2.0.0.tar.gz -> rocm-device-libs-${PV}.tar.gz
	 https://github.com/justxi/OpenCL-ICD-Loader/archive/20180325.tar.gz -> OpenCL-ICD-Loader-20180325.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="sys-devel/llvm-roc
	 dev-libs/rocm-device-libs
	 dev-libs/rocr-runtime"

#PATCHES=(
#	"${FILESDIR}/rocm-opencl-driver-2.0.0-add-link-libraries.patch"
#)

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
	patch -d ../ROCm-OpenCL-Driver-roc-2.0.0/ -p1 < ${FILESDIR}/rocm-opencl-driver-2.0.0-add-link-libraries.patch || die

	# add path to /usr/lib/llvm/roc-2.0.0/include ...
	patch -p1 < ${FILESDIR}/rocm-opencl-runtime-2.0.0-add-path.patch || die

	# remove the compiler subdirectory, we want to detect it from the system ...
	sed -e "s:add_subdirectory(compiler/llvm):#add_subdirectory(compiler/llvm):" -i CMakeLists.txt || die

	# change include directories to llvm/clang ...
	sed -e "s:\${CMAKE_SOURCE_DIR}/compiler/llvm/tools/clang/include:/usr/lib/llvm/roc-${PV}/include/:" -i CMakeLists.txt || die
	sed -e "s:\${CMAKE_SOURCE_DIR}/compiler/llvm/lib/Target/AMDGPU:/usr/lib/llvm/roc-${PV}/include/llvm/Target:" -i CMakeLists.txt || die

	# change path to "opencl-c.h"
	sed -e "s:< \${CMAKE_SOURCE_DIR}/compiler/llvm/tools/clang/lib/Headers/opencl-c.h:< /usr/lib/llvm/roc-${PV}/lib/clang/8.0.0/include/opencl-c.h:" -i runtime/device/rocm/CMakeLists.txt || die
	# remove dependency to cland directory inside build tree and change path to "opencl-c.h"
	sed -e "s:DEPENDS clang \${CMAKE_SOURCE_DIR}/compiler/llvm/tools/clang/lib/Headers/opencl-c.h:DEPENDS /usr/lib/llvm/roc-${PV}/lib/clang/8.0.0/include/opencl-c.h:" -i runtime/device/rocm/CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
        export LLVM_DIR=/usr/lib/llvm/roc-${PV}

	local mycmakeargs=(
#                -DLLVM_DIR=$LLVM_DIR
                -DLLVM_DIR=/usr/lib/llvm/roc-2.0.0/lib/cmake/llvm/
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
