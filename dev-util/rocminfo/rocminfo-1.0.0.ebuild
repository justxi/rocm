# Copyright
# 

EAPI=6
inherit cmake-utils epatch

DESCRIPTION="ROCm Application for Reporting System Info"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocminfo"
SRC_URI="https://github.com/RadeonOpenCompute/rocminfo/archive/${PV}.tar.gz -> rocminfo-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="dev-libs/rocm-cmake
	dev-libs/rocr-runtime
	dev-lang/python:2.7"

PATCHES=(
	"${FILESDIR}/rocminfo-python2.patch"
)

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
