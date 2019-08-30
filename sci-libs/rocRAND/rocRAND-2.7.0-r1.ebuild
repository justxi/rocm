# Copyright
#

EAPI=7

inherit cmake-utils

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocRAND"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocRAND/archive/rocm-2.7.tar.gz -> rocRAND-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="=sys-devel/hip-$(ver_cut 1-2)*[hcc-backend]"
DEPEND="${RDPEND}
	dev-util/cmake
	=dev-util/rocm-cmake-$(ver_cut 1-2)*"

S="${WORKDIR}/rocRAND-rocm-$(ver_cut 1-2)"

src_prepare() {
        cd ${S}

	eapply "${FILESDIR}/master-disable2ndfindhcc.patch"

        sed -e "s:LIBRARY DESTINATION hiprand/lib:LIBRARY DESTINATION lib64:" -i library/CMakeLists.txt
        sed -e "s:DESTINATION hiprand/include:DESTINATION include/hiprand:" -i library/CMakeLists.txt
        sed -e "s:DESTINATION hiprand/lib/cmake/hiprand:DESTINATION lib64/cmake/hiprand:" -i library/CMakeLists.txt
        sed -e "s:\$<INSTALL_INTERFACE\:hiprand/include:\$<INSTALL_INTERFACE\:include/hiprand/:" -i library/CMakeLists.txt
	sed -e "s:set(INCLUDE_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/hiprand/include\"):set(INCLUDE_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/include/hiprand\"):" -i library/CMakeLists.txt

        sed -e "s:LIBRARY DESTINATION rocrand/lib:LIBRARY DESTINATION lib64:" -i library/CMakeLists.txt
        sed -e "s:DESTINATION rocrand/include:DESTINATION include/rocrand:" -i library/CMakeLists.txt
        sed -e "s:DESTINATION rocrand/lib/cmake/rocrand:DESTINATION lib64/cmake/rocrand:" -i library/CMakeLists.txt
        sed -e "s:\$<INSTALL_INTERFACE\:rocrand/include:\$<INSTALL_INTERFACE\:include/rocrand/:" -i library/CMakeLists.txt
	sed -e "s:set(INCLUDE_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/rocrand/include\"):set(INCLUDE_INSTALL_DIR \"\${CMAKE_INSTALL_PREFIX}/include/rocrand\"):" -i library/CMakeLists.txt

        eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	local HCC_ROOT=/usr/lib/hcc/$(ver_cut 1-2)

	export PATH=$PATH:${HCC_ROOT}/bin
	export hcc_DIR=${HCC_ROOT}/lib/cmake/
	export hip_DIR=/usr/lib/hip/lib/cmake/
	export HIP_DIR=/usr/lib/hip/lib/cmake/
	export CXX=${HCC_ROOT}/bin/hcc

	local mycmakeargs=(
		-DHIP_PLATFORM=hcc
		-DHIP_ROOT_DIR=/usr/lib/hip
		-DBUILD_TEST=OFF
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DCMAKE_CXX_FLAGS:STRING="-I${HCC_ROOT}/include"
	)

	cmake-utils_src_configure
}
