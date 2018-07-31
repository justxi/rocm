# Copyright
# 

EAPI=6
#inherit cmake-utils 
#git-r3

DESCRIPTION="HCC - An open source C++ compiler for heterogeneous devices"
HOMEPAGE="https://github.com/RadeonOpenCompute/hcc"
#EGIT_REPO_URI="https://github.com/RadeonOpenCompute/hcc.git"
#EGIT_SUBMODULES=()
#EGIT_BRANCH="roc-1.9.x"

LICENSE=""
SLOT="1.9"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
#RDEPEND="=media-libs/ROCR-Runtime-1.9*
#         sys-libs/libunwind"

#CMAKE_BUILD_TYPE="Release"

src_unpack() {
#	EGIT_BRANCH="roc-1.8.x"
#	git-r3_fetch ${EGIT_REPO_URI}
#	EGIT_BRANCH="amd-hcc"
#	EGIT_BRANCH="amd-common"
#	git-r3_fetch "https://github.com/RadeonOpenCompute/llvm"
#	EGIT_BRANCH="amd-common"
#	git-r3_fetch "https://github.com/RadeonOpenCompute/lld"
#	EGIT_BRANCH="clang_tot_upgrade"
#	git-r3_fetch "https://github.com/RadeonOpenCompute/hcc-clang-upgrade"
#	EGIT_BRANCH="amd-hcc"
#	EGIT_BRANCH="master"
#	git-r3_fetch "https://github.com/RadeonOpenCompute/compiler-rt"
#	EGIT_BRANCH="master"
#	git-r3_fetch "https://github.com/RadeonOpenCompute/ROCm-Device-Libs"
#	EGIT_BRANCH="amd-hcc"
#	EGIT_BRANCH="master"
#	git-r3_fetch "https://github.com/RadeonOpenCompute/clang-tools-extra"

#	git-r3_checkout ${EGIT_REPO_URI}
#	git-r3_checkout https://github.com/RadeonOpenCompute/llvm "${S}/compiler"
#	git-r3_checkout https://github.com/RadeonOpenCompute/lld "${S}/lld"
#	git-r3_checkout https://github.com/RadeonOpenCompute/hcc-clang-upgrade "${S}/clang"
#	git-r3_checkout https://github.com/RadeonOpenCompute/compiler-rt "${S}/compiler-rt"
#	git-r3_checkout https://github.com/RadeonOpenCompute/ROCm-Device-Libs "${S}/rocdl"
#	git-r3_checkout https://github.com/RadeonOpenCompute/clang-tools-extra "${S}/clang-tools-extra"

	git clone --recursive -b roc-1.9.x https://github.com/RadeonOpenCompute/hcc.git ${S}
}

src_configure() {

#        local mycmakeargs=(
#               -DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/hcc/${SLOT}"
#               -DCMAKE_INSTALL_MANDIR="${EPREFIX}/usr/lib/hcc/${SLOT}/share/man"
#        )

#        cmake-utils_src_configure

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
