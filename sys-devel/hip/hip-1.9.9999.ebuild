# Copyright
# 

EAPI=6
inherit cmake-utils git-r3

DESCRIPTION="C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIP"
EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/HIP.git"
EGIT_BRANCH="roc-1.9.x"

LICENSE=""
SLOT="1.9"
KEYWORDS="~amd64"
IUSE=""

DEPEND=">=sys-devel/hcc-1.9"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply "${FILESDIR}/${PV}-DisableTest.patch"
	eapply_user
}

src_configure() {
        mkdir "${WORKDIR}/build"
        cd "${WORKDIR}/build"
	cmake -DHCC_HOME=/usr/lib/hcc/1.9/ -DHSA_PATH=/usr/lib -DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/hip/${SLOT}" ${S}
}

src_compile() {
        cd "${WORKDIR}/build"
        make VERBOSE=1 ${MAKEOPTS}
}

src_install() {
        cd "${WORKDIR}/build"
        emake DESTDIR="${D}" install
}

pkg_postinst() {
	elog "Possibly, set HCC_HOME=/usr/lib/hcc/1.9/"
}

