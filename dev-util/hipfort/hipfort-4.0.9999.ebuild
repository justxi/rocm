# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION="Fortran Interface For GPU Kernel Libraries"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipfort"
EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/hipfort"
EGIT_BRANCH="rocm-4.0.x"

KEYWORDS=""
LICENSE="MITx11"
SLOT="0"
IUSE="debug"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}"


CMAKE_BUILD_TYPE="RELEASE"

src_prepare() {

	sed -e "s:ADD_SUBDIRECTORY(\${CMAKE_SOURCE_DIR}/test):#ADD_SUBDIRECTORY(\${CMAKE_SOURCE_DIR}/test):" -i ${S}/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
        local mycmakeargs=(
                -DCMAKE_BUILD_TYPE=$(usex debug "DEBUG" "RELEASE")
        )

        cmake-utils_src_configure
}


