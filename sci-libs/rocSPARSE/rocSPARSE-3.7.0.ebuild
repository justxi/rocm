EAPI=7

inherit cmake-utils

DESCRIPTION="Common interface that provides Basic Linear Algebra Subroutines for sparse computation"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocSPARSE"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocSPARSE/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64"
SLOT="0/$(ver_cut 1-2)"

IUSE="debug gfx803 -gfx900 gfx906 gfx908"
REQUIRED_USE="|| ( gfx803 gfx900 gfx906 gfx908 )"

RDEPEND="sys-devel/hip
	>=sci-libs/rocPRIM-${PV}"
DEPEND="${RDEPEND}
	>=dev-util/rocm-cmake-3.5.0"

PATCHES=(
	"${FILESDIR}/rocSPARSE-3.7.0-rocsparse_module.f90.patch"
)

rocSPARSE_V="0.1"

BUILD_DIR="${S}/build/release"

S="${WORKDIR}/${PN}-rocm-${PV}"

src_prepare() {
	sed -e "s: PREFIX rocsparse:# PREFIX rocsparse:" -i library/CMakeLists.txt
	sed -e "s:<INSTALL_INTERFACE\:include:<INSTALL_INTERFACE\:include/rocsparse/:" -i library/CMakeLists.txt
	sed -e "s:rocm_install_symlink_subdir(rocsparse):#rocm_install_symlink_subdir(rocsparse):" -i library/CMakeLists.txt
	sed -e "s:rocsparse/include:include/rocsparse:g" -i library/CMakeLists.txt

	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	strip-flags
	filter-flags '*march*'

	AMDGPU_TARGETS=""
	if use gfx803; then
		AMDGPU_TARGETS+="gfx803;"
	fi
	if use gfx900; then
		AMDGPU_TARGETS+="gfx900;"
	fi
	if use gfx906; then
		AMDGPU_TARGETS+="gfx906;"
	fi
	if use gfx908; then
		AMDGPU_TARGETS+="gfx908;"
	fi

	export CXX="${HIP_PATH}/bin/hipcc"

	local mycmakeargs=(
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DCMAKE_INSTALL_INCLUDEDIR="include/rocsparse"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	chrpath --delete "${D}/usr/lib64/librocsparse.so.${rocSPARSE_V}"
}
