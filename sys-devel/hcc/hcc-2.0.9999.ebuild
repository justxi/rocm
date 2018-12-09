# Copyright
#

EAPI=6

DESCRIPTION="HCC - An open source C++ compiler for heterogeneous devices"
HOMEPAGE="https://github.com/RadeonOpenCompute/hcc"

LICENSE=""
SLOT="2.0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="=media-libs/ROCR-Runtime-1.9*
	 dev-util/rocminfo"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-vcs/git"

src_unpack() {
	git clone --recursive -b roc-2.0.x https://github.com/RadeonOpenCompute/hcc.git ${S}
}

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
