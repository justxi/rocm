# Copyright
#

EAPI=7

inherit cmake

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipSPARSE"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipSPARSE/archive/rocm-$(ver_cut 1-2).tar.gz -> hipSPARSE-$(ver_cut 1-2).tar.gz"

LICENSE=""
KEYWORDS="~amd64"
SLOT="0"

IUSE=""
S="${WORKDIR}/hipSPARSE-rocm-$(ver_cut 1-2)"

RDEPEND=">dev-util/rocminfo-$(ver_cut 1-2)
         =sys-devel/hip-$(ver_cut 1-2)*
         =sci-libs/rocSPARSE-${PV}*"
DEPEND="${RDPEND}
	dev-util/cmake"

#CMAKE_MAKEFILE_GENERATOR="emake"

src_prepare() {
	sed -e "s: PREFIX hipsparse:# PREFIX hipsparse:" -i ${S}/library/CMakeLists.txt || die
	sed -e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/hipsparse/:" -i ${S}/library/CMakeLists.txt || die
	sed -e "s:rocm_install_symlink_subdir(hipsparse):#rocm_install_symlink_subdir(hipsparse):" -i ${S}/library/CMakeLists.txt || die

	eapply_user
	cmake_src_prepare
}

src_configure() {

#	if use gfx803; then
#		echo "gfx803" >> ${TEMP}/target.lst
#	fi
#	export ROCM_TARGET_LST=${TEMP}/target.lst
#	/usr/bin/rocm_agent_enumerator


	export HCC_ROOT=/usr/lib/hcc/$(ver_cut 1-2)
	export hcc_DIR=${HCC_ROOT}/lib/cmake/
	export CXX=${HCC_ROOT}/bin/hcc

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_INSTALL_INCLUDEDIR=include/hipsparse
	)

	cmake_src_configure
}
