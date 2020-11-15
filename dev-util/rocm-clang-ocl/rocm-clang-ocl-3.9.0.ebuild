# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="OpenCL compilation with clang compiler"
HOMEPAGE="https://github.com/RadeonOpenCompute/clang-ocl.git"
SRC_URI="https://github.com/RadeonOpenCompute/clang-ocl/archive/rocm-${PV}.tar.gz -> rocm-clang-ocl-${PV}.tar.gz"
S=${WORKDIR}/clang-ocl-rocm-${PV}

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-libs/rocm-opencl-runtime"
DEPEND="dev-util/cmake
	dev-util/rocm-cmake
	${RDEPEND}"

src_prepare() {
	sed -e "s:HINTS \${CXX_COMPILER_PATH}/bin:NO_DEFAULT_PATH:" -i "${S}/CMakeLists.txt"
	sed -e "s:/opt/rocm/llvm/bin:/usr/lib/llvm/roc/bin:" -i "${S}/CMakeLists.txt"

	sed -e "s:AMDDeviceLibs PATHS /opt/rocm:AMDDeviceLibs PATHS /usr/lib/cmake/AMDDeviceLibs/:" -i "${S}/CMakeLists.txt"
	sed -e "s:\${AMD_DEVICE_LIBS_PREFIX}/amdgcn/bitcode:\${AMD_DEVICE_LIBS_PREFIX}/lib/amdgcn/bitcode:" -i "${S}/CMakeLists.txt"

	cmake-utils_src_prepare
}
