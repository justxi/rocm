EAPI=7

inherit cmake-utils

DESCRIPTION="OpenCL compilation with clang compiler"
HOMEPAGE="https://github.com/RadeonOpenCompute/clang-ocl"
SRC_URI="https://github.com/RadeonOpenCompute/clang-ocl/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/clang-ocl-rocm-${PV}"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64"

RDEPEND="dev-libs/rocm-opencl-runtime"
DEPEND="dev-util/rocm-cmake
	${RDEPEND}"
