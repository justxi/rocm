# Copyright
#

EAPI=7

inherit cmake-utils

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipSPARSE"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipSPARSE/archive/rocm-${PV}.tar.gz -> hipSPARSE-$(ver_cut 1-2).tar.gz"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

IUSE=""

RDEPEND=">dev-util/rocminfo-$(ver_cut 1-2)
         =sys-devel/hip-$(ver_cut 1-2)*
         =sci-libs/rocSPARSE-${PV}*"
DEPEND="${RDPEND}
	dev-util/cmake"

S="${WORKDIR}/hipSPARSE-rocm-${PV}"

#CMAKE_MAKEFILE_GENERATOR="emake"

src_prepare() {
	sed -e "s: PREFIX hipsparse):):" -i ${S}/library/CMakeLists.txt || die
	sed -e "s: PREFIX hipsparse:# PREFIX hipsparse:" -i ${S}/library/CMakeLists.txt || die
	sed -e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/hipsparse/:" -i ${S}/library/CMakeLists.txt || die
	sed -e "s:rocm_install_symlink_subdir(hipsparse):#rocm_install_symlink_subdir(hipsparse):" -i ${S}/library/CMakeLists.txt || die

	eapply_user
	cmake-utils_src_prepare
}

src_configure() {

	export CXX=hipcc

	local mycmakeargs=(
		-DHIP_RUNTIME="ROCclr"
		-DBUILD_CLIENTS_TESTS=OFF
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr
		-DCMAKE_INSTALL_INCLUDEDIR=include/hipsparse
	)

        # this is necessary to omit a sandbox vialation,
        # but it does not seem to affect the targets list...
        echo "gfx803" >> ${WORKDIR}/target.lst
        export ROCM_TARGET_LST="${WORKDIR}/target.lst"

	cmake-utils_src_configure
}
