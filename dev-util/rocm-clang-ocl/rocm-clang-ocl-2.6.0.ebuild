# Copyright
#

EAPI=6

inherit cmake-utils

DESCRIPTION="OpenCL compilation with clang compiler"
HOMEPAGE="https://github.com/RadeonOpenCompute/clang-ocl.git"
SRC_URI="https://github.com/RadeonOpenCompute/clang-ocl/archive/roc-${PV}.tar.gz -> rocm-clang-ocl-${PV}.tar.gz"
S=${WORKDIR}/clang-ocl-roc-${PV}

PATCHES=(
        "${FILESDIR}/fix-directories.patch"
)

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="dev-libs/rocm-opencl-runtime"
DEPEND="dev-util/cmake
		${RDEPEND}"
