# Copyright
# 

EAPI=6
inherit cmake-utils git-r3

DESCRIPTION="ROCm Application for Reporting System Info"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocminfo"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocminfo"
EGIT_COMMIT="1.0.0"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-libs/rocr-runtime"

src_configure() {
        local mycmakeargs=(
                -DROCM_DIR=/usr
        )

        cmake-utils_src_configure
}

src_install() {
	exeinto /opt/rocm/bin
	doexe ${BUILD_DIR}/rocminfo
	doexe ${BUILD_DIR}/rocm_agent_enumerator
}
