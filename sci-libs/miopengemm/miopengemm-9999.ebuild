# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION="MIOpenGEMM"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpenGEMM"
SLOT="0"

EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/MIOpenGEMM.git"
EGIT_COMMIT="6275a879995b58a6e0b8cca7b1ad8421a5e02ade"
KEYWORDS="~amd64"
LICENSE="MIT"

RDEPEND="virtual/opencl"
DEPEND="dev-util/rocm-cmake"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/"
	)
	cmake-utils_src_configure
}
