EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="Reusable software components for rocm developers"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/hipCUB"
SRC_URI="https://github.com/ROCmSoftwarePlatform/hipCUB/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64"
SLOT="0/$(ver_cut 1-2)"

IUSE="gfx803 +gfx900 gfx906 gfx908 debug"
REQUIRED_USE="^^ ( gfx803 gfx900 gfx906 gfx908 )"

RDEPEND="sys-devel/hip
	>=sci-libs/rocPRIM-${PV}"
DEPEND="${RDEPEND}
	dev-util/rocm-cmake"

#PATCHES=(
#	"${FILESDIR}/master-disable2ndfindhcc.patch"
#)

S="${WORKDIR}/${PN}-rocm-${PV}"

src_prepare() {
	sed -e "s:HIP_PLATFORM STREQUAL \"hcc\":HIP_PLATFORM STREQUAL \"rocclr\":" -i cmake/VerifyCompiler.cmake || die
	sed -e "s:find_package(HIP 1.5.18263 REQUIRED):find_package(HIP 3.6.20280 REQUIRED):" -i cmake/VerifyCompiler.cmake || die

	sed -e "s: PREFIX hipcub:# PREFIX hipcub:" -i ${S}/hipcub/CMakeLists.txt || die
	sed -e "s:  DESTINATION hipcub/include/:  DESTINATION include/:" -i ${S}/hipcub/CMakeLists.txt || die
	sed -e "s:rocm_install_symlink_subdir(hipcub):#rocm_install_symlink_subdir(hipcub):" -i ${S}/hipcub/CMakeLists.txt || die
	sed -e "s:<INSTALL_INTERFACE\:hipcub/include/:<INSTALL_INTERFACE\:include/hipcub/:" -i ${S}/hipcub/CMakeLists.txt || die

	sed -e "s:set(ROCM_INSTALL_LIBDIR lib:set(ROCM_INSTALL_LIBDIR \${CMAKE_INSTALL_LIBDIR}:" -i ${S}/cmake/ROCMExportTargetsHeaderOnly.cmake || die

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
		-DHIP_PLATFORM=rocclr
		-DHIP_COMPILER=clang
		-DBUILD_TEST=OFF
		-DCMAKE_INSTALL_PREFIX=/usr
		-DAMDGPU_TARGETS="${AMDGPU_TARGETS}"
	)

	cmake-utils_src_configure
}
