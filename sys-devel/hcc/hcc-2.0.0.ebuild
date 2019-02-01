# Copyright
#

EAPI=6
inherit git-r3

DESCRIPTION="HCC - An open source C++ compiler for heterogeneous devices"
HOMEPAGE="https://github.com/RadeonOpenCompute/hcc"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/hcc.git"
EGIT_COMMIT="roc-2.0.0"

LICENSE=""
SLOT="2.0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="=dev-libs/rocr-runtime-2.0.0*
	 dev-util/rocminfo"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-vcs/git"

src_configure() {
	mkdir "${WORKDIR}/build"
	cd "${WORKDIR}/build"
	cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/hcc/${SLOT}" -DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/hcc/${SLOT}/share/man"  ${S}
}

src_compile() {
	cd "${WORKDIR}/build"
	make VERBOSE=1 ${MAKEOPTS}
}

src_install() {
        cd "${WORKDIR}/build"
	emake DESTDIR="${D}" install
}
