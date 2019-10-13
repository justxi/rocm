# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="MIOpenGEMM"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpenGEMM"
SRC_URI="https://github.com/ROCmSoftwarePlatform/MIOpenGEMM/archive/${PV}.tar.gz -> miopengemm-${PV}.tar.gz"

KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0"

RDEPEND="virtual/opencl"
DEPEND="dev-util/rocm-cmake"

S="${WORKDIR}/MIOpenGEMM-${PV}"

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
