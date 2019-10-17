# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION="MIOpenGEMM"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpenGEMM"
SLOT="0"

EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/MIOpenGEMM.git"
KEYWORDS=""
LICENSE="MIT"

RDEPEND="virtual/opencl"
DEPEND="dev-util/rocm-cmake"

src_prepare() {
	sed -e "s:set( miopengemm_INSTALL_DIR miopengemm):set( miopengemm_INSTALL_DIR \"\"):" -i miopengemm/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir(\${miopengemm_INSTALL_DIR}):#rocm_install_symlink_subdir(\${miopengemm_INSTALL_DIR}):" -i miopengemm/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/"
	)
	cmake-utils_src_configure
}
