# Copyright
#

EAPI=6
inherit git-r3 cmake-utils

DESCRIPTION="HCC - An open source C++ compiler for heterogeneous devices"
HOMEPAGE="https://github.com/RadeonOpenCompute/hcc"
SRC_URI="https://github.com/RadeonOpenCompute/hcc/archive/roc-${PV}.tar.gz -> rocm-hcc-${PV}.tar.gz
         https://github.com/RadeonOpenCompute/llvm/archive/roc-${PV}.tar.gz -> llvm-roc-${PV}.tar.gz
         https://github.com/RadeonOpenCompute/lld/archive/roc-${PV}.tar.gz -> lld-roc-${PV}.tar.gz
         https://github.com/RadeonOpenCompute/ROCm-Device-Libs/archive/roc-${PV}.tar.gz -> rocm-device-libs-${PV}.tar.gz"

LICENSE=""
SLOT="2.0"
KEYWORDS="~amd64"
IUSE=""
CMAKE_BUILD_TYPE=Release

RDEPEND="=dev-libs/rocr-runtime-${PV}*
	 dev-util/rocminfo"
DEPEND="${RDEPEND}
	dev-util/cmake
	dev-vcs/git"

src_unpack() {
	unpack ${A}
	mv hcc-roc-${PV} hcc-${PV}
	rm -R hcc-${PV}/clang hcc-${PV}/clang-tools-extra hcc-${PV}/compiler hcc-${PV}/compiler-rt hcc-${PV}/lld hcc-${PV}/rocdl
	mv llvm-roc-${PV} hcc-${PV}/compiler
	mv lld-roc-${PV} hcc-${PV}/lld
	mv ROCm-Device-Libs-roc-${PV} hcc-${PV}/rocdl
	git-r3_fetch "https://github.com/RadeonOpenCompute/hcc-clang-upgrade/" 6ec3c61e09fbb60373eaf5a40021eb862363ba2c
	git-r3_checkout "https://github.com/RadeonOpenCompute/hcc-clang-upgrade/" hcc-${PV}/clang
	git-r3_fetch "https://github.com/RadeonOpenCompute/clang-tools-extra/" 71604e0f7487732f3c77e0ec089a647a9cac5085
	git-r3_checkout "https://github.com/RadeonOpenCompute/clang-tools-extra/" hcc-${PV}/clang-tools-extra
	git-r3_fetch "https://github.com/RadeonOpenCompute/compiler-rt/" 638adb5bd55f84981257ee0a634cd414a9374021
	git-r3_checkout "https://github.com/RadeonOpenCompute/compiler-rt/" hcc-${PV}/compiler-rt
}

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
	doenvd 99hcc

	cmake-utils_src_install
}
