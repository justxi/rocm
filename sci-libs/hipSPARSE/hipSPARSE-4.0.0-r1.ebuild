# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="ROCm SPARSE marshalling library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipSPARSE"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipSPARSE/archive/rocm-${PV}.tar.gz -> hipSPARSE-$(ver_cut 1-2).tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"
IUSE=""

RDEPEND=">dev-util/rocminfo-$(ver_cut 1-2)
         =dev-util/hip-$(ver_cut 1-2)*
         =sci-libs/rocSPARSE-${PV}*"
DEPEND="${RDPEND}
	dev-util/cmake"

S="${WORKDIR}/hipSPARSE-rocm-${PV}"

src_prepare() {
	sed -e "s: PREFIX hipsparse):):" -i "${S}/library/CMakeLists.txt" || die
	sed -e "s: PREFIX hipsparse:# PREFIX hipsparse:" -i "${S}/library/CMakeLists.txt" || die
	sed -e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/hipsparse/:" -i "${S}/library/CMakeLists.txt" || die
	sed -e "s:rocm_install_symlink_subdir(hipsparse):#rocm_install_symlink_subdir(hipsparse):" -i "${S}/library/CMakeLists.txt" || die

	eapply_user
	cmake_src_prepare
}

src_configure() {
       # Grant access to the device
        addwrite /dev/kfd
        addpredict /dev/dri/

	# Compiler to use
	export CXX=hipcc

	local mycmakeargs=(
		-DHIP_RUNTIME="ROCclr"
		-DBUILD_CLIENTS_TESTS=OFF
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DCMAKE_CXX_FLAGS="--rocm-path=/usr"
		-DCMAKE_INSTALL_PREFIX=${EPREFIX}/usr
		-DCMAKE_INSTALL_INCLUDEDIR=include/hipsparse
	)

	cmake_src_configure
}
