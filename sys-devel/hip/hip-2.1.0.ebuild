# Copyright
# 

EAPI=6
inherit cmake-utils

DESCRIPTION="C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIP"
SRC_URI="https://github.com/ROCm-Developer-Tools/HIP/archive/roc-${PV}.tar.gz -> rocm-hip-${PV}.tar.gz"

LICENSE=""
SLOT="2.1"
KEYWORDS="~amd64"
IUSE=""
CMAKE_BUILD_TYPE=Release

DEPEND="=sys-devel/hcc-${PV}*"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	mv HIP-roc-${PV} hip-${PV}
}

src_prepare() {
	eapply "${FILESDIR}/${PV}-DisableTest.patch"
	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/hip/${SLOT}" ${S}
		-DHIP_PLATFORM=hcc
		-DBUILD_HIPIFY_CLANG=ON
		-DHIP_COMPILER=hcc
		-DHCC_HOME=/usr/lib/hcc/${SLOT}/
		-DHSA_PATH=/usr/lib
	)

        cmake-utils_src_configure
}

src_install() {
        echo "HIP_PLATFORM=hcc" > 99hip || die
        echo "PATH=/usr/lib/hip/${SLOT}/bin" >> 99hip || die
        echo "HIP_PATH=/usr/lib/hip/${SLOT}" >> 99hip || die
        echo "LDPATH=/usr/lib/hip/${SLOT}/lib" >> 99hip || die
        doenvd 99hip

        cmake-utils_src_install
}
