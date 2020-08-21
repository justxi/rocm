EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="ROCm SPARSE marshalling library"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipSPARSE"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipSPARSE/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64"
SLOT="0/$(ver_cut 1-2)"

IUSE="gfx803 +gfx900 gfx906 gfx908 debug"
REQUIRED_USE="^^ ( gfx803 gfx900 gfx906 gfx908 )"

RDEPEND="dev-util/rocminfo
	sys-devel/hip
	>=sci-libs/rocSPARSE-${PV}"
DEPEND="${RDPEND}
	dev-util/rocm-cmake"

hipSPARSE_V="0.1"

S="${WORKDIR}/${PN}-rocm-${PV}"

src_prepare() {
	sed -e "s: PREFIX hipsparse):):" -i library/CMakeLists.txt || die
	sed -e "s: PREFIX hipsparse:# PREFIX hipsparse:g" -i library/CMakeLists.txt
	sed -e "s:\$<INSTALL_INTERFACE\:include/>:\$<INSTALL_INTERFACE\:include/hipsparse/>:" -i library/CMakeLists.txt || die
	sed -e "s:rocm_install_symlink_subdir(hipsparse):#rocm_install_symlink_subdir(hipsparse):" -i library/CMakeLists.txt || die

	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	strip-flags
	filter-flags '*march*'

	if use debug; then
		buildtype="Debug"
	else
		buildtype="Release"
	fi

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
		-DCMAKE_BUILD_TYPE=${buildtype}
		-DCMAKE_PREFIX_PATH="${HIP_PATH}"
		-DHIP_COMPILER=clang
		-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"
		-DBUILD_VERBOSE=ON
		-DBUILD_CLIENTS_SAMPLES=OFF
		-DBUILD_CLIENTS_TESTS=OFF
		-DCMAKE_INSTALL_PREFIX=/usr
		-DCMAKE_INSTALL_INCLUDEDIR="include/hipsparse"
		-DCMAKE_INSTALL_LIBDIR="/usr/$(get_libdir)"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
	chrpath --delete "${D}/usr/lib64/libhipsparse.so.${hipSPARSE_V}"
}
