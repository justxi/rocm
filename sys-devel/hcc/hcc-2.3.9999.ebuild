# Copyright
#

EAPI=6
inherit cmake-utils

DESCRIPTION="HCC - An open source C++ compiler for heterogeneous devices"
HOMEPAGE="https://github.com/RadeonOpenCompute/hcc"

LICENSE=""
SLOT="2.3"
KEYWORDS="~amd64"
IUSE=""

CMAKE_BUILD_TYPE=Release

RDEPEND="dev-libs/rocr-runtime
	 dev-util/rocminfo"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-vcs/git"

src_unpack() {
	git clone --recursive -b roc-2.3.x https://github.com/RadeonOpenCompute/hcc.git ${S}
}

src_configure() {
        if ! use debug; then
                append-cflags "-DNDEBUG"
                append-cxxflags "-DNDEBUG"
        fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/hcc/${SLOT}"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/hcc/${SLOT}/share/man"
	)

	cmake-utils_src_configure
}

src_install() {
	echo "HCC_HOME=/usr/lib/hcc/${SLOT}" > 99hcc || die
	echo "HSA_PATH=/usr/lib" >> 99hcc || die
	echo "LDPATH=/usr/lib/hcc/${SLOT}/lib" >> 99hcc || die
	doenvd 99hcc

	cmake-utils_src_install
}

pkg_postinst() {
        elog "HCC is marked depracated, see:"
        elog "https://github.com/RadeonOpenCompute/hcc#deprecation-notice"
}

