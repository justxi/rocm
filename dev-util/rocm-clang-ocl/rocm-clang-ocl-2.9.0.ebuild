# Copyright
#

EAPI=6

inherit cmake-utils

DESCRIPTION="OpenCL compilation with clang compiler"
HOMEPAGE="https://github.com/RadeonOpenCompute/clang-ocl.git"
SRC_URI="https://github.com/RadeonOpenCompute/clang-ocl/archive/roc-${PV}.tar.gz -> rocm-clang-ocl-${PV}.tar.gz"
S=${WORKDIR}/clang-ocl-roc-${PV}

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"

PATCHES=(
	${FILESDIR}/${PV}-clang-ocl.patch
)

RDEPEND="dev-libs/rocm-opencl-runtime"
DEPEND="dev-util/cmake
	dev-util/rocm-cmake
	${RDEPEND}"

src_configure() {
	echo
}

src_compile() {
	echo
}

src_install() {
	exeinto /usr/bin
	doexe ${S}/clang-ocl
}
