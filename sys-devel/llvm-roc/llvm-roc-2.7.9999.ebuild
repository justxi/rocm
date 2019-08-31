# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Radeon Open Compute llvm,lld,clang"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm/"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO="https://github.com/RadeonOpenCompute/llvm"
	EGIT_BRANCH="amd-common"
	inherit git-r3
	S="${WORKDIR}/${P}"
	KEYWORDS="**"
else
	SRC_URI="https://github.com/RadeonOpenCompute/llvm/archive/roc-ocl-${PV}.tar.gz -> llvm-roc-ocl-${PV}.tar.gz
		https://github.com/RadeonOpenCompute/clang/archive/roc-${PV}.tar.gz -> clang-roc-${PV}.tar.gz
		https://github.com/RadeonOpenCompute/lld/archive/roc-ocl-${PV}.tar.gz -> lld-roc-ocl-${PV}.tar.gz"
	S="${WORKDIR}/llvm-roc-ocl-${PV}"
	KEYWORDS="~amd64"
fi

LICENSE="UoI-NCSA rc BSD public-domain"
SLOT="0"
IUSE="debug"

RDEPEND="virtual/cblas
	 dev-libs/rocr-runtime"
DEPEND="${RDEPEND}"

CMAKE_BUILD_TYPE=RelWithDebInfo

src_unpack() {
	if [[ ${PV} == *9999 ]]; then
		EGIT_COMMIT="cadd94b2be2654fbf5dc751b689bf219f34e9758"
		git-r3_fetch ${EGIT_REPO}
		git-r3_checkout ${EGIT_REPO}

		EGIT_COMMIT="acfb9c8dbb68e01b51fadf9eeec9421cb309a319"
		git-r3_fetch "https://github.com/RadeonOpenCompute/clang"
		git-r3_checkout "https://github.com/RadeonOpenCompute/clang" "${S}/tools/compiler"

		EGIT_COMMIT="2733326d1399d18ccf802c7cfbb044cc36d5b8c4"
		git-r3_fetch "https://github.com/RadeonOpenCompute/lld"
		git-r3_checkout "https://github.com/RadeonOpenCompute/lld" "${S}/tools/lld"
	else
		unpack ${A}
		ln -s "${WORKDIR}/clang-roc-${PV}" "${WORKDIR}/llvm-roc-ocl-${PV}/tools/clang"
		ln -s "${WORKDIR}/lld-roc-ocl-${PV}" "${WORKDIR}/llvm-roc-ocl-${PV}/tools/lld"
	fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/roc"
		-DLLVM_TARGETS_TO_BUILD="AMDGPU;X86"
		-DLLVM_BUILD_DOCS=NO
		-DLLVM_ENABLE_OCAMLDOC=OFF
		-DLLVM_ENABLE_SPHINX=NO
		-DLLVM_ENABLE_DOXYGEN=OFF
		-DLLVM_INSTALL_UTILS=ON
		-DLLVM_VERSION_SUFFIX=roc
		-DOCAMLFIND=NO
		-DLLVM_ENABLE_EH=ON
                -DLLVM_ENABLE_RTTI=ON
	)

	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	cmake-utils_src_configure
}

src_install(){
	cmake-utils_src_install
	cat > "99${PN}" <<-EOF
		LDPATH="${EROOT}/usr/lib/llvm/roc/lib"
	EOF
	doenvd "99${PN}"
}
