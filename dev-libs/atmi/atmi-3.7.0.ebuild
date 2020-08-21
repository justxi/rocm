EAPI=7

inherit cmake-utils

DESCRIPTION="Asynchronous Task and Memory Interface"
HOMEPAGE="https://github.com/RadeonOpenCompute/atmi/"
SRC_URI="https://github.com/RadeonOpenCompute/atmi/archive/rocm-${PV}.tar.gz -> rocm-${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="amd64"
SLOT="0/$(ver_cut 1-2)"
IUSE="debug"

RDEPEND="virtual/libelf"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-cmake_library_hint.patch"
)

S="${WORKDIR}/atmi-rocm-${PV}/src"

CMAKE_MAKEFILE_GENERATOR="emake"

src_prepare() {
	sed -e "s:DESTINATION lib COMPONENT device_runtime:DESTINATION lib64 COMPONENT device_runtime:" -i ${S}/device_runtime/CMakeLists.txt
	sed -e "s:TARGETS atmi_runtime LIBRARY DESTINATION \"lib\" COMPONENT runtime:TARGETS atmi_runtime LIBRARY DESTINATION \"lib64\" COMPONENT runtime:" -i ${S}/runtime/core/CMakeLists.txt
	cmake-utils_src_prepare
}

src_configure() {

	if use debug; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi

	export GFXLIST="gfx803 gfx900 gfx906"

	export ROC_DIR="/usr"
	export ROCR_DIR="/usr"

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/"
		-DLLVM_DIR="${EPREFIX}/usr/lib/llvm/roc/"
		-DHSA_DIR=/usr
		-DROCM_VERSION="${PV}"
		-DATMI_DEVICE_RUNTIME=ON
		-DATMI_HSA_INTEROP=ON
		-DATMI_C_EXTENSION=OFF
	)
	cmake-utils_src_configure
}
