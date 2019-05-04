# Copyright
#

EAPI=6

inherit git-r3 cmake-utils eapi7-ver

DESCRIPTION="ROCm-CMake"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm-cmake"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocm-cmake"
EGIT_BRANCH="master"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

#CMAKE_BUILD_TYPE="Release"

#S="${WORKDIR}/ROCm-Device-Libs-roc-${PV}"

#src_configure() {
#	export LLVM_BUILD=/usr/lib/llvm/roc-${PV}
#	export CC=$LLVM_BUILD/bin/clang
#
#	local mycmakeargs=(
#		-DLLVM_DIR=$LLVM_BUILD
#		-DCMAKE_INSTALL_PREFIX=/usr/
#	)
#
#	cmake-utils_src_configure
#}
