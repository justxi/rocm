# Copyright
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake flag-o-matic

DESCRIPTION="CU / ROCM agnostic hip FFT implementation"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipFFT"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipFFT/archive/refs/tags/rocm-${PV}.tar.gz -> hipFFT-rocm-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

IUSE="+gfx803 gfx900 gfx906 gfx908"
REQUIRED_USE="|| ( gfx803 gfx900 gfx906 gfx908 )"

RDEPEND="=dev-util/hip-$(ver_cut 1-2)*
	=sci-libs/rocFFT-$(ver_cut 1-2)*"
DEPEND="${RDEPEND}
	dev-util/cmake"


S="${WORKDIR}/hipFFT-rocm-${PV}"

PATCHES=(
	"${FILESDIR}/hipFFT-4.2.0-gentoo-install-locations.patch"
)

src_prepare() {
	#sed -e "s: PREFIX rocfft:# PREFIX rocfft:" -i "${S}/library/src/CMakeLists.txt" || die
	#sed -e "s:rocm_install_symlink_subdir( rocfft ):#rocm_install_symlink_subdir( rocfft ):" -i "${S}/library/src/CMakeLists.txt" || die
	#sed -e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/rocFFT:" -i "${S}/library/src/CMakeLists.txt" || die

	#sed "$!N;s:PREFIX\n  rocfft:# PREFIX rocfft\n:;P;D" -i "${S}/library/src/device/CMakeLists.txt" || die
	#sed -e "s:rocm_install_symlink_subdir( rocfft ):#rocm_install_symlink_subdir( rocfft ):" -i "${S}/library/src/device/CMakeLists.txt" || die

	eapply_user
	cmake_src_prepare
}

src_configure() {
	# Process flags
	strip-flags
	filter-flags '*march*'

	# Grant access to the device
    addwrite /dev/kfd
    addpredict /dev/dri/

	# Compiler to use
	export CXX=hipcc

	local mycmakeargs=(
		-Wno-dev
		-DCMAKE_CXX_FLAGS="--rocm-path=/usr"
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_INSTALL_INCLUDEDIR="include/hipfft"
	)

	cmake_src_configure
}

src_install() {
        cmake_src_install
}
