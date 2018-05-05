# Copyright
# 

EAPI=6
inherit cmake-utils git-r3

DESCRIPTION="ROCm Application for Reporting System Info"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocminfo"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocminfo"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="media-libs/ROCR-Runtime"

src_unpack() {
	git-r3_fetch ${EGIT_REPO_URI}
        git-r3_fetch "https://github.com/RadeonOpenCompute/rocm-cmake/"

	git-r3_checkout ${EGIT_REPO_URI}
        git-r3_checkout https://github.com/RadeonOpenCompute/rocm-cmake/ "${S}/rocm-cmake"

	ln -s "${S}/rocm-cmake/share/rocm/cmake/" "${S}/cmake-modules"
	sed -i -e "s/find_package(ROCM PATHS \/opt\/rocm)*/find_package(ROCM PATHS \${PROJECT_SOURCE_DIR}\/cmake-modules)/" "${S}/CMakeLists.txt"
}

src_install() {
	exeinto /opt/rocm/bin
	doexe ${BUILD_DIR}/rocminfo
	doexe ${BUILD_DIR}/rocm_agent_enumerator
}
