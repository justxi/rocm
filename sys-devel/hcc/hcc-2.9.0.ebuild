# Copyright
#

EAPI=7
inherit git-r3 cmake flag-o-matic

DESCRIPTION="HCC - An open source C++ compiler for heterogeneous devices"
HOMEPAGE="https://github.com/RadeonOpenCompute/hcc"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/hcc.git"
EGIT_COMMIT="roc-hcc-${PV}"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"

IUSE="debug"

RDEPEND="=dev-libs/rocr-runtime-${PV}*
	 dev-util/rocminfo"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-vcs/git"

CMAKE_BUILD_TYPE=Release

src_configure() {
	strip-flags
	append-cxxflags '-O2'

	if ! use debug; then
		append-cflags "-DNDEBUG"
		append-cxxflags "-DNDEBUG"
	fi

	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=OFF
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/hcc/$(ver_cut 1-2)"
		-DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/hcc/$(ver_cut 1-2)/share/man"
	)

	cmake_src_configure
}

src_install() {
	echo "HCC_HOME=/usr/lib/hcc/$(ver_cut 1-2)" > 99hcc || die
	echo "HSA_PATH=/usr" >> 99hcc || die
	echo "LDPATH=/usr/lib/hcc/$(ver_cut 1-2)/lib" >> 99hcc || die
	echo "ROOTPATH=/usr/lib/hcc/$(ver_cut 1-2)/bin" >> 99hcc || die
	echo "ROCM_PATH=/usr" >> 99hcc || die
	doenvd 99hcc

	cmake_src_install
}

pkg_postinst() {
        elog "HCC is marked depracated, see:"
        elog "https://github.com/RadeonOpenCompute/hcc#deprecation-notice"
}
