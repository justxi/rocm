# Copyright
#

EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="Generate pseudo-random and quasi-random numbers"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocRAND"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocRAND/archive/rocm-${PV}.tar.gz -> rocRAND-${PV}.tar.gz"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="=sys-devel/hip-$(ver_cut 1-2)*"
DEPEND="${RDEPEND}
	dev-util/cmake
	=dev-util/rocm-cmake-$(ver_cut 1-2)*"

S="${WORKDIR}/rocRAND-rocm-${PV}"

src_prepare() {
	cd ${S}

	sed -e "s:LIBRARY DESTINATION hiprand/lib:LIBRARY DESTINATION \${CMAKE_INSTALL_LIBDIR}:" -i library/CMakeLists.txt
	sed -e "s:DESTINATION hiprand/include:DESTINATION include/hiprand:" -i library/CMakeLists.txt
	sed -e "s:DESTINATION hiprand/lib/cmake/hiprand:DESTINATION \${CMAKE_INSTALL_LIBDIR}/cmake/hiprand:" -i library/CMakeLists.txt
	sed -e "s:\$<INSTALL_INTERFACE\:hiprand/include:\$<INSTALL_INTERFACE\:include/hiprand/:" -i library/CMakeLists.txt
	sed -e "s:set(INCLUDE_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/hiprand/include\"):set(PACKAGE_INCLUDE_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/include/hiprand\"):" -i library/CMakeLists.txt
	sed -e "s:set(LIB_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/hiprand/lib\"):set(LIB_INSTALL_DIR \"\${CMAKE_INSTALL_FULL_LIBDIR}\"):" -i library/CMakeLists.txt

	sed -e "s:LIBRARY DESTINATION rocrand/lib:LIBRARY DESTINATION \${CMAKE_INSTALL_LIBDIR}:" -i library/CMakeLists.txt
	sed -e "s:DESTINATION rocrand/include:DESTINATION include/rocrand:" -i library/CMakeLists.txt
	sed -e "s:DESTINATION rocrand/lib/cmake/rocrand:DESTINATION \${CMAKE_INSTALL_LIBDIR}/cmake/rocrand:" -i library/CMakeLists.txt
	sed -e "s:\$<INSTALL_INTERFACE\:rocrand/include:\$<INSTALL_INTERFACE\:include/rocrand/:" -i library/CMakeLists.txt
	sed -e "s:set(INCLUDE_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/rocrand/include\"):set(INCLUDE_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/include/rocrand\"):" -i library/CMakeLists.txt
	sed -e "s:set(LIB_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/rocrand/lib\"):set(LIB_INSTALL_DIR \"\${CMAKE_INSTALL_FULL_LIBDIR}\"):" -i library/CMakeLists.txt
	sed -e "s:INSTALL_RPATH \"\${CMAKE_INSTALL_PREFIX}:#&:" -i library/CMakeLists.txt

	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	# Is this needed anymore?
	strip-flags
	filter-flags '*march*'

	# Compiler to use...
	export CXX="/usr/lib/hip/3.5/bin/hipcc"

	# Let "hipcc" know where the bitcode files are located
	export DEVICE_LIB_PATH="/usr/lib64"

	local mycmakeargs=(
		-DBUILD_TEST=OFF
	)

	cmake-utils_src_configure
}
