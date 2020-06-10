# Copyright
#

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
