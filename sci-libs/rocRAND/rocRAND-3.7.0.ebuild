EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="Generate pseudo-random and quasi-random numbers"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocRAND"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocRAND/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64"
SLOT="0/$(ver_cut 1-2)"

RDEPEND="sys-devel/hip"
DEPEND="${RDEPEND}
	dev-util/rocm-cmake"

PATCHES=(
	"${FILESDIR}/VerifyCompiler.cmake.patch"
)

rocRAND_V="1.1"

S="${WORKDIR}/${PN}-rocm-${PV}"

src_prepare() {

	sed -e "s:LIBRARY DESTINATION hiprand/lib:LIBRARY DESTINATION \${CMAKE_INSTALL_LIBDIR}:" -i library/CMakeLists.txt || die
	sed -e "s:DESTINATION hiprand/include:DESTINATION include/hiprand:" -i library/CMakeLists.txt || die
	sed -e "s:DESTINATION hiprand/lib/cmake/hiprand:DESTINATION \${CMAKE_INSTALL_LIBDIR}/cmake/hiprand:" -i library/CMakeLists.txt || die
	sed -e "s:\$<INSTALL_INTERFACE\:hiprand/include:\$<INSTALL_INTERFACE\:include/hiprand/:" -i library/CMakeLists.txt || die
	sed -e "s:set(INCLUDE_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/hiprand/include\"):set(PACKAGE_INCLUDE_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/include/hiprand\"):" -i library/CMakeLists.txt || die
	sed -e "s:set(LIB_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/hiprand/lib\"):set(LIB_INSTALL_DIR \"\${CMAKE_INSTALL_FULL_LIBDIR}\"):" -i library/CMakeLists.txt || die

	sed -e "s:LIBRARY DESTINATION rocrand/lib:LIBRARY DESTINATION \${CMAKE_INSTALL_LIBDIR}:" -i library/CMakeLists.txt || die
	sed -e "s:DESTINATION rocrand/include:DESTINATION include/rocrand:" -i library/CMakeLists.txt || die
	sed -e "s:DESTINATION rocrand/lib/cmake/rocrand:DESTINATION \${CMAKE_INSTALL_LIBDIR}/cmake/rocrand:" -i library/CMakeLists.txt || die
	sed -e "s:\$<INSTALL_INTERFACE\:rocrand/include:\$<INSTALL_INTERFACE\:include/rocrand/:" -i library/CMakeLists.txt || die
	sed -e "s:set(INCLUDE_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/rocrand/include\"):set(INCLUDE_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/include/rocrand\"):" -i library/CMakeLists.txt || die
	sed -e "s:set(LIB_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/rocrand/lib\"):set(LIB_INSTALL_DIR \"\${CMAKE_INSTALL_FULL_LIBDIR}\"):" -i library/CMakeLists.txt || die
	sed -e "s:INSTALL_RPATH \"\${CMAKE_INSTALL_PREFIX}:#&:" -i library/CMakeLists.txt || die

	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	strip-flags
	filter-flags '*march*'

	export CXX="${HIP_PATH}/bin/hipcc"

	export DEVICE_LIB_PATH="/usr/lib"

	local mycmakeargs=(
		-DBUILD_TEST=OFF
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	chrpath --delete "${D}/usr/lib64/libhiprand.so.${rocRAND_V}"
}
