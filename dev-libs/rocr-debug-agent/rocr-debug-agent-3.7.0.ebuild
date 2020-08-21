EAPI=7

inherit cmake-utils linux-info

DESCRIPTION="Radeon Open Compute Debug Agent"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/rocr_debug_agent/"
SRC_URI="https://github.com/ROCm-Developer-Tools/rocr_debug_agent/archive/roc-${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64"

CONFIG_CHECK="~HSA_AMD"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"


RDEPEND="=dev-libs/rocr-runtime-${PV}*
	=dev-libs/roct-thunk-interface-${PV}*
	dev-util/systemtap
	>=sys-devel/hcc-${PV}"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-cmake.patch"
)

S="${WORKDIR}/rocr_debug_agent-rocm-${PV}/src"

src_prepare() {
	sed -e "s:HINTS /opt/rocm/include:HINTS /usr/include:" -i "${S}/CMakeLists.txt"
	sed -e "s:install(TARGETS \${TARGET_NAME} DESTINATION lib):install(TARGETS \${TARGET_NAME} DESTINATION lib64):" -i "${S}/CMakeLists.txt"

	cmake-utils_src_prepare
}
