# Copyright
#

EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="MIOpen"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/MIOpen"
SRC_URI="https://github.com/ROCmSoftwarePlatform/MIOpen/archive/roc-${PV}.tar.gz -> MIOpen-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="=sys-devel/hip-${PV}*
	>=dev-libs/half-1.12.0
	=dev-util/rocm-clang-ocl-${PV}*
	dev-libs/boost"
DEPEND="${RDEPEND}
	dev-util/cmake
	sci-libs/rocBLAS"

S="${WORKDIR}/MIOpen-roc-${PV}"

src_prepare() {
	eapply "${FILESDIR}"/${P}-remove-static-boost.patch

	sed -e "s:set( MIOPEN_INSTALL_DIR miopen):set( MIOPEN_INSTALL_DIR \"\"):" -i CMakeLists.txt
	sed -e "s:set( DATA_INSTALL_DIR \${MIOPEN_INSTALL_DIR}/\${CMAKE_INSTALL_DATAROOTDIR}/miopen ):set( DATA_INSTALL_DIR \${CMAKE_INSTALL_PREFIX}/\${CMAKE_INSTALL_DATAROOTDIR}/miopen ):" -i CMakeLists.txt
	sed -e "s:set(MIOPEN_SYSTEM_DB_PATH \"\${CMAKE_INSTALL_PREFIX}/\${DATA_INSTALL_DIR}/db\":set(MIOPEN_SYSTEM_DB_PATH \"\${DATA_INSTALL_DIR}/db\":" -i CMakeLists.txt
	sed -e "s:DESTINATION \${MIOPEN_INSTALL_DIR}/bin:DESTINATION \${CMAKE_INSTALL_PREFIX}/bin:" -i driver/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir(\${MIOPEN_INSTALL_DIR}):#rocm_install_symlink_subdir(\${MIOPEN_INSTALL_DIR}):" -i src/CMakeLists.txt

	cmake-utils_src_prepare
}

src_configure() {
	strip-flags

	CMAKE_MAKEFILE_GENERATOR=emake
	CXX="/usr/lib/hcc/$(ver_cut 1-2)/bin/hcc"

	local mycmakeargs=(
                -DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/"
	)

	cmake-utils_src_configure
}
