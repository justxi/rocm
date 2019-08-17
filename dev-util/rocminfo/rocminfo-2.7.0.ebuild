# Copyright
# 

EAPI=6
inherit cmake-utils epatch

DESCRIPTION="ROCm Application for Reporting System Info"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocminfo"
SRC_URI="https://github.com/RadeonOpenCompute/rocminfo/archive/roc-${PV}.tar.gz -> rocminfo-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
S="${WORKDIR}/rocminfo-roc-${PV}"

DEPEND=""
RDEPEND="dev-libs/rocm-cmake
	dev-libs/rocr-runtime"

PATCHES=(
        "${FILESDIR}/fix-libdir.patch"
)

src_configure() {
        local mycmakeargs=(
                -DROCM_DIR=/usr
        )

        cmake-utils_src_configure
}

src_install() {
	exeinto /usr/bin
	doexe ${BUILD_DIR}/rocminfo
	doexe ${BUILD_DIR}/rocm_agent_enumerator
}
