# Copyright
#

EAPI=6

inherit cmake-utils eapi7-ver

DESCRIPTION="ROCm-OpenCL-Driver"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Driver"
SRC_URI="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Driver/archive/roc-${PV}.tar.gz -> rocm-opencl-driver-${PV}.tar.gz"

LICENSE="MIT"
#SLOT="0/$(ver_cut 1-2)"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-libs/rocr-runtime
	 sys-devel/llvm-roc"

#PATCHES=(
#        "${FILESDIR}/${P}-add-link-libraries.patch"
#)

CMAKE_BUILD_TYPE="Release"

S="${WORKDIR}/ROCm-OpenCL-Driver-roc-${PV}"


src_prepare() {
	# remove unittest, because it downloads additional file from github.com
	sed -e "s:add_subdirectory(src/unittest):#add_subdirectory(src/unittest):" -i CMakeLists.txt || die

	eapply "${FILESDIR}/${P}-add-link-libraries.patch"

	eapply_user
}

src_configure() {
	export LLVM_DIR=/usr/lib/llvm/roc-${PV}

	local mycmakeargs=(
		-DLLVM_DIR=$LLVM_DIR
		-DCMAKE_INSTALL_PREFIX=/usr/
	)

	cmake-utils_src_configure
}
