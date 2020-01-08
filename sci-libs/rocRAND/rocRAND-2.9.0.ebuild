# Copyright
#

EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="Generate pseudo-random and quasi-random numbers"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocRAND"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocRAND/archive/${PV}.tar.gz -> rocRAND-${PV}.tar.gz"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="=sys-devel/hip-$(ver_cut 1-2)*[hcc-backend]"
DEPEND="${RDEPEND}
	dev-util/cmake
	=dev-util/rocm-cmake-$(ver_cut 1-2)*"

src_prepare() {
	cd ${S}

	eapply "${FILESDIR}/master-disable2ndfindhcc.patch"

	sed -e "s:LIBRARY DESTINATION hiprand/lib:LIBRARY DESTINATION lib64:" -i library/CMakeLists.txt
	sed -e "s:DESTINATION hiprand/include:DESTINATION include/hiprand:" -i library/CMakeLists.txt
	sed -e "s:DESTINATION hiprand/lib/cmake/hiprand:DESTINATION lib64/cmake/hiprand:" -i library/CMakeLists.txt
	sed -e "s:\$<INSTALL_INTERFACE\:hiprand/include:\$<INSTALL_INTERFACE\:include/hiprand/:" -i library/CMakeLists.txt
	sed -e "s:set(INCLUDE_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/hiprand/include\"):set(PACKAGE_INCLUDE_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/include/hiprand\"):" -i library/CMakeLists.txt
	sed -e "s:set(LIB_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/hiprand/lib\"):set(LIB_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/lib64\"):" -i library/CMakeLists.txt

	sed -e "s:LIBRARY DESTINATION rocrand/lib:LIBRARY DESTINATION lib64:" -i library/CMakeLists.txt
	sed -e "s:DESTINATION rocrand/include:DESTINATION include/rocrand:" -i library/CMakeLists.txt
	sed -e "s:DESTINATION rocrand/lib/cmake/rocrand:DESTINATION lib64/cmake/rocrand:" -i library/CMakeLists.txt
	sed -e "s:\$<INSTALL_INTERFACE\:rocrand/include:\$<INSTALL_INTERFACE\:include/rocrand/:" -i library/CMakeLists.txt
	sed -e "s:set(INCLUDE_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/rocrand/include\"):set(INCLUDE_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/include/rocrand\"):" -i library/CMakeLists.txt
	sed -e "s:set(LIB_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/rocrand/lib\"):set(LIB_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/lib64\"):" -i library/CMakeLists.txt

	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	strip-flags
	filter-flags '*march*'

	CXX=${HCC_HOME}/bin/hcc

	local mycmakeargs=(
		-DHIP_PLATFORM=hcc
		-DBUILD_TEST=OFF
		-DCMAKE_INSTALL_PREFIX="/usr"
	)

	cmake-utils_src_configure
}
