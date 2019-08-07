# Copyright
#

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="ROCm OpenCL Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/"
SRC_URI="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/roc-${PV}.tar.gz -> rocm-opencl-runtime-${PV}.tar.gz
	 https://github.com/RadeonOpenCompute/ROCm-OpenCL-Driver/archive/roc-${PV}.tar.gz -> rocm-opencl-driver-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="system-llvm-roc"

PATCHES=(
	"${FILESDIR}/roct-include-path.patch"
	"${FILESDIR}/remove-installs.patch"
	"${FILESDIR}/fix-clang-custom-command.patch"
	"${FILESDIR}/fix-dependency.patch"
	"${FILESDIR}/fix-libs.patch"
	"${FILESDIR}/hack-disable-function.patch"
#	"${FILESDIR}/add-rpath.patch"
)

DEPEND="dev-lang/ocaml
	dev-ml/findlib
	app-admin/chrpath
	dev-cpp/gtest
	dev-libs/rocr-runtime
	dev-libs/ocl-icd
	system-llvm-roc? ( =dev-libs/rocm-device-libs-${PV}* )
	system-llvm-roc? ( =sys-devel/llvm-roc-${PV}* )
"
RDEPEND="$DEPEND"

RESTRICT="strip"

S="${WORKDIR}/ROCm-OpenCL-Runtime-roc-${PV}"

BUILD_DIR="${WORKDIR}/build"

CMAKE_BUILD_TYPE="Release"

src_unpack() {
	unpack ${A}
	ln -s "${WORKDIR}/ROCm-OpenCL-Driver-roc-${PV}" "${S}/compiler/driver"
	
	EGIT_COMMIT="d0f452d8480416b3b44838b5790a27dc02e766f5"
	git-r3_fetch "https://github.com/KhronosGroup/OpenCL-ICD-Loader"
	git-r3_checkout https://github.com/KhronosGroup/OpenCL-ICD-Loader "${S}"/api/opencl/khronos/icd
	
	if ! use system-llvm-roc; then
		EGIT_COMMIT="roc-ocl-${PV}"
		git-r3_fetch "https://github.com/RadeonOpenCompute/llvm"
		git-r3_checkout https://github.com/RadeonOpenCompute/llvm "${S}"/compiler/llvm

		EGIT_COMMIT="roc-${PV}"
		git-r3_fetch "https://github.com/RadeonOpenCompute/clang"
		git-r3_checkout https://github.com/RadeonOpenCompute/clang "${S}"/compiler/llvm/tools/clang

		EGIT_COMMIT="roc-ocl-${PV}"
		git-r3_fetch "https://github.com/RadeonOpenCompute/lld"
		git-r3_checkout https://github.com/RadeonOpenCompute/lld "${S}"/compiler/llvm/tools/lld
		
		EGIT_COMMIT="roc-ocl-${PV}"
		git-r3_fetch "https://github.com/RadeonOpenCompute/ROCm-Device-Libs"
		git-r3_checkout https://github.com/RadeonOpenCompute/ROCm-Device-Libs "${S}"/library/amdgcn
	fi
}

src_prepare() {
	if use system-llvm-roc; then
		# remove unittest, because it loads additional software (googletest)
		sed -e "s:add_subdirectory(src/unittest):#add_subdirectory(src/unittest):" -i ${S}/compiler/driver/CMakeLists.txt || die

		# remove the compiler subdirectory, we want to detect it from the system ...
		sed -e "s:add_subdirectory(compiler/llvm.*)::" -i CMakeLists.txt || die
		# remove device libs subdirectory
		sed -e "s:add_subdirectory(library/.*)::" -i CMakeLists.txt || die
		# remove khronos ICD
		sed -e "s:add_subdirectory(api/opencl/khronos/icd.*)::" -i CMakeLists.txt || die

		# change include directories to llvm/clang ...
		sed -e "s:\${CMAKE_SOURCE_DIR}/compiler/llvm/tools/clang/include:/usr/lib/llvm/roc-${PV}/include/:" -i CMakeLists.txt || die
		sed -e "s:\${CMAKE_SOURCE_DIR}/compiler/llvm/lib/Target/AMDGPU:/usr/lib/llvm/roc-${PV}/include/llvm/Target:" -i CMakeLists.txt || die
	fi
	cmake-utils_src_prepare
}

src_configure() {
	if use system-llvm-roc; then
		local mycmakeargs=(
			-DLLVM_DIR=/usr/lib/llvm/roc-${PV}/lib/cmake/llvm
			-DClang_DIR=/usr/lib/llvm/roc-${PV}/
			-DCMAKE_INSTALL_PREFIX=/usr/
		)
	fi
	cmake-utils_src_configure
}

src_install() {
	chrpath --delete "${BUILD_DIR}/lib/libamdocl64.so"
	dolib.so "${BUILD_DIR}/lib/libamdocl64.so"

	insinto /etc/OpenCL/vendors
	doins ${S}/api/opencl/config/amdocl64.icd
	
	# We do not install libOpenCL.so, etc. since they are available from ocl-icd
}
