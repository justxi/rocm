# Copyright
#

EAPI=7

#inherit cmake

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocRAND"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocRAND/archive/rocm-$(ver_cut 1-2).tar.gz -> rocRAND-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="=sys-devel/hip-$(ver_cut 1-2)*"
DEPEND="${RDEPEND}
	dev-util/cmake
	=dev-util/rocm-cmake-$(ver_cut 1-2)*"

S="${WORKDIR}/rocRAND-rocm-$(ver_cut 1-2)"

src_prepare() {
        cd ${S}

	eapply "${FILESDIR}/master-disable2ndfindhcc.patch"

        sed -e "s:LIBRARY DESTINATION hiprand/lib:LIBRARY DESTINATION \${CMAKE_INSTALL_LIBDIR}:" -i library/CMakeLists.txt
        sed -e "s:DESTINATION hiprand/include:DESTINATION include/hiprand:" -i library/CMakeLists.txt
        sed -e "s:DESTINATION hiprand/lib/cmake/hiprand:DESTINATION \${CMAKE_INSTALL_LIBDIR}/cmake/hiprand:" -i library/CMakeLists.txt
        sed -e "s:\$<INSTALL_INTERFACE\:hiprand/include:\$<INSTALL_INTERFACE\:include/hiprand/:" -i library/CMakeLists.txt

        sed -e "s:LIBRARY DESTINATION rocrand/lib:LIBRARY DESTINATION \${CMAKE_INSTALL_LIBDIR}:" -i library/CMakeLists.txt
        sed -e "s:DESTINATION rocrand/include:DESTINATION include/rocrand:" -i library/CMakeLists.txt
        sed -e "s:DESTINATION rocrand/lib/cmake/rocrand:DESTINATION \${CMAKE_INSTALL_LIBDIR}/cmake/rocrand:" -i library/CMakeLists.txt
        sed -e "s:\$<INSTALL_INTERFACE\:rocrand/include:\$<INSTALL_INTERFACE\:include/rocrand/:" -i library/CMakeLists.txt

        eapply_user
}

src_configure() {
	mkdir -p "${WORKDIR}/build/"
	cd "${WORKDIR}/build/"

	export PATH=$PATH:/usr/lib/hcc/$(ver_cut 1-2)/bin
	export hcc_DIR=/usr/lib/hcc/$(ver_cut 1-2)/lib/cmake/
	export hip_DIR=/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/
	export HIP_DIR=/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/
	export CXX=/usr/lib/hcc/$(ver_cut 1-2)/bin/hcc

#	local mycmakeargs=(
#		-DHIP_PLATFORM=hcc
#		-DHIP_ROOT_DIR=/usr/lib/hip/$(ver_cut 1-2)/
#		-DBUILD_TEST=OFF
#		-DCMAKE_INSTALL_PREFIX="/usr/lib/"
#	)

	cmake -DHIP_PLATFORM=hcc -DHIP_ROOT_DIR=/usr/lib/hip/$(ver_cut 1-2)/ -DBUILD_TEST=OFF ${S}
#	cmake_src_configure
}

src_compile() {
	cd "${WORKDIR}/build/"
	make VERBOSE=1
}

src_install() {
	cd "${WORKDIR}/build/"
	emake DESTDIR="${D}" install
}
