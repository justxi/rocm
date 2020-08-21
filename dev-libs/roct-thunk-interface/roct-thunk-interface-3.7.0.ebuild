EAPI=7

inherit cmake linux-info

DESCRIPTION="Radeon Open Compute Thunk Interface"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface"
SRC_URI="https://github.com/RadeonOpenCompute/ROCT-Thunk-Interface/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

CONFIG_CHECK="~HSA_AMD ~HMM_MIRROR ~ZONE_DEVICE ~DRM_AMDGPU ~DRM_AMDGPU_USERPTR"
KEYWORDS="amd64"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND="sys-process/numactl
	sys-apps/pciutils"
DEPEND="${RDEPEND}"

S="${WORKDIR}/ROCT-Thunk-Interface-rocm-${PV}"

src_prepare() {
	sed -e "s:get_version ( \"1.0.0\" ):get_version ( \"${PV}\" ):" -i CMakeLists.txt || die
	cmake_src_prepare
}
src_configure() {
	local mycmakeargs=(
		-DCPACK_PACKAGING_INSTALL_PREFIX="${EPREFIX}/usr"
	)
	cmake_src_configure
}
