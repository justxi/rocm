# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Common interface that provides Basic Linear Algebra Subroutines for sparse computation"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocSPARSE"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocSPARSE/archive/rocm-${PV}.tar.gz -> rocSPARSE-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

IUSE="debug +gfx803 gfx900 gfx906 gfx908"
REQUIRED_USE="|| ( gfx803 gfx900 gfx906 gfx908 )"

RDEPEND="=dev-util/hip-$(ver_cut 1-2)*
	 =sci-libs/rocPRIM-$(ver_cut 1-2)*"
DEPEND="${RDEPEND}
	dev-util/cmake"

S="${WORKDIR}/rocSPARSE-rocm-${PV}"

rocSPARSE_V="0.1"

BUILD_DIR="${S}/build/release"

src_prepare() {
        sed -e "s: PREFIX rocsparse:# PREFIX rocsparse:" -i "${S}/library/CMakeLists.txt" || die
	sed -e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/rocsparse/:" -i "${S}/library/CMakeLists.txt" || die
        sed -e "s:rocm_install_symlink_subdir(rocsparse):#rocm_install_symlink_subdir(rocsparse):" -i "${S}/library/CMakeLists.txt" || die
	sed -e "s:rocsparse/include:include/rocsparse:" -i "${S}/library/CMakeLists.txt" || die

        eapply_user
	cmake_src_prepare
}

src_configure() {
        # Grant access to the device to omit a sandbox violation
        addwrite /dev/kfd
        addpredict /dev/dri/

	# Compiler to use
	export CXX=hipcc

	# Target to use
	CurrentISA=""
        if use gfx803; then
                CurrentISA+="gfx803;"
        fi
        if use gfx900; then
                CurrentISA+="gfx900;"
        fi
        if use gfx906; then
                CurrentISA+="gfx906;"
        fi
        if use gfx906; then
                CurrentISA+="gfx908;"
        fi

	local mycmakeargs=(
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DAMDGPU_TARGETS="${CurrentISA}"
		-DCMAKE_CXX_FLAGS="--rocm-path=/usr"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocsparse"
	)

	cmake_src_configure
}

src_install() {
	cmake_src_install
	chrpath --delete "${D}/usr/lib64/librocsparse.so.${rocSPARSE_V}"
}
