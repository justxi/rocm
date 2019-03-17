# Copyright
#

EAPI=6
inherit git-r3 cmake-utils

DESCRIPTION="HCC - An open source C++ compiler for heterogeneous devices"
HOMEPAGE="https://github.com/RadeonOpenCompute/hcc"

EGIT_REPO_URI="https://github.com/RadeonOpenCompute/hcc.git"
EGIT_COMMIT="roc-${PV}"

LICENSE=""
SLOT="2.2"
KEYWORDS="~amd64"
IUSE=""
CMAKE_BUILD_TYPE=Release

RDEPEND="=dev-libs/rocr-runtime-${PV}*
	 dev-util/rocminfo"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-vcs/git"

src_configure() {
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
