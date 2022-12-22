# Copyright
#

EAPI=7

inherit cmake

DESCRIPTION="OpenCL compilation with clang compiler"
HOMEPAGE="https://github.com/RadeonOpenCompute/clang-ocl.git"
SRC_URI="https://github.com/RadeonOpenCompute/clang-ocl/archive/roc-${PV}.tar.gz -> rocm-clang-ocl-${PV}.tar.gz"
S=${WORKDIR}/clang-ocl-roc-${PV}

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	${FILESDIR}/fix-directories.patch
	${FILESDIR}/${PV}-fix-paths.patch
)

RDEPEND="dev-libs/rocm-opencl-runtime"
DEPEND="dev-util/cmake
	dev-util/rocm-cmake
	${RDEPEND}"
