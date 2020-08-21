EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="HIP parallel primitives for developing performant GPU-accelerated code on AMD ROCm platform"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocPRIM"
SRC_URI="https://github.com/ROCmSoftwarePlatform/rocPRIM/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64"
SLOT="0/$(ver_cut 1-2)"

IUSE=""

RDEPEND="sys-devel/hip"
DEPEND="${RDEPEND}
	dev-util/rocm-cmake"

PATCHES=(
	"${FILESDIR}/master-3.7.0-disable2ndfindhcc.patch"
)

S="${WORKDIR}/${PN}-rocm-${PV}"

src_prepare() {
	sed -e "s:find_package(HIP 1.5.18263 REQUIRED):find_package(HIP 3.6.20280 REQUIRED):" -i cmake/VerifyCompiler.cmake || die
	sed -e "s:HIP_PLATFORM STREQUAL \"hcc\":HIP_PLATFORM STREQUAL \"rocclr\":" -i cmake/VerifyCompiler.cmake || die

	sed -e "s: PREFIX rocprim:# PREFIX rocprim:" -i rocprim/CMakeLists.txt || die
	sed -e "s:\$<INSTALL_INTERFACE\:rocprim/include/>:\$<INSTALL_INTERFACE\:include/rocprim/>:" -i rocprim/CMakeLists.txt || die
	sed -e "s: DESTINATION rocprim/include/: DESTINATION include/:" -i rocprim/CMakeLists.txt || die
	sed -e "s:rocm_install_symlink_subdir(rocprim):#rocm_install_symlink_subdir(rocprim):" -i rocprim/CMakeLists.txt || die

	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	export CXX="${HIP_PATH}/bin/hipcc"
	export DEVICE_LIB_PATH="/usr/lib"

	local mycmakeargs=(
		-DHIP_PLATFORM=rocclr
		-DCMAKE_INSTALL_PREFIX=/usr
		-DBUILD_TEST=OFF
		-DBUILD_BENCHMARK=OFF
		-DBUILD_VERBOSE=ON
	)

	cmake-utils_src_configure
}
