EAPI=7

inherit cmake

DESCRIPTION="Radeon Open Compute Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCR-Runtime"
SRC_URI="https://github.com/RadeonOpenCompute/ROCR-Runtime/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="non-free"

COMMON_DEPEND="sys-process/numactl"
RDEPEND="${COMMON_DEPEND}
	dev-libs/rocm-device-libs"
#	non-free? ( dev-libs/hsa-ext-rocr )"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/roct-thunk-interface-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-3.7.0-cmake-install-paths.patch"
	"${FILESDIR}/hsa-ext-finalize-3.7.0.patch"
)

S="${WORKDIR}/ROCR-Runtime-rocm-${PV}/src"

src_prepare() {
	sed -e "s:get_version ( \"1.0.0\" ):get_version ( \"${PV}\" ):" -i CMakeLists.txt || die
	sed -e "s:DESTINATION lib:DESTINATION lib64:g" -i CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBITCODE_DIR="${EPREFIX}/usr/lib"
	)
	cmake_src_configure
}
