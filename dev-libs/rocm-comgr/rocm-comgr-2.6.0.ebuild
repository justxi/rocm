# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3

DEPEND="sys-devel/llvm-roc
        dev-libs/rocm-device-libs"
RDEPEND=${DEPEND}

EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport"
S="${WORKDIR}/${P}/lib/comgr"

DESCRIPTION="Radeon Open Compute CompilerSupport"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport"

KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

PATCHES=(
        "${FILESDIR}/2.6-unknown-function.patch"
        "${FILESDIR}/2.6-deps.patch"
)

CMAKE_BUILD_TYPE=RelWithDebInfo

src_configure() {
        export LLVM_BUILD=/usr/lib/llvm/roc-${PV}

        local mycmakeargs=(
                -DCMAKE_BUILD_TYPE=Release
                -DCMAKE_PREFIX_PATH=${LLVM_BUILD}
        )
        cmake-utils_src_configure
}

