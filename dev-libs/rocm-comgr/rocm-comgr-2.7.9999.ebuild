# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/"
	# 21.08.2019
	EGIT_COMMIT="b020b945ed3c630e39bdf8efd3956871e5961785"
	inherit git-r3
	S="${WORKDIR}/${P}/lib/comgr"
else
	SRC_URI="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/archive/roc-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/ROCm-CompilerSupport-roc-${PV}/lib/comgr"
	KEYWORDS="~amd64"
fi
PATCHES=(
	"${FILESDIR}/${PN}-2.6.0-find-clang.patch"
	"${FILESDIR}/${PN}-2.6.0-find-lld-includes.patch"
	"${FILESDIR}/${PN}-2.6.0-dependencies.patch"
)

DESCRIPTION="Radeon Open Compute Code Object Manager"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND=">=dev-libs/rocm-device-libs-${PV}
	dev-cpp/yaml-cpp:=
	>=sys-devel/llvm-roc-${PV}:="
DEPEND="${RDEPEND}"

src_prepare() {
	rm -rf yaml-cpp || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLLVM_DIR="${EPREFIX}/usr/lib/llvm/roc/"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/"
	)
	cmake-utils_src_configure
}
