# Copyright
#

EAPI=6
inherit cmake-utils

DESCRIPTION="User space interface for applications to monitor and control GPU applications."
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm_smi_lib"
SRC_URI="https://github.com/RadeonOpenCompute/rocm_smi_lib/archive/rocm-${PV}.tar.gz -> rocm-smi-lib-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

PATCHES=(
	"${FILESDIR}/rocm-smi-lib-2.9.0-omit-git-output.patch"
	"${FILESDIR}/rocm-smi-lib-2.9.0-utils-no-repository.patch"
)

S="${WORKDIR}/rocm_smi_lib-rocm-${PV}"

src_prepare() {
	sed -e "s:LIBRARY DESTINATION \${ROCM_SMI}/lib COMPONENT \${ROCM_SMI_COMPONENT}):LIBRARY DESTINATION lib64 COMPONENT \${ROCM_SMI_COMPONENT}):" -i ${S}/CMakeLists.txt
	sed -e "s:DESTINATION rocm_smi/include/rocm_smi):DESTINATION include):" -i ${S}/CMakeLists.txt
	eapply_user
	cmake-utils_src_prepare
}
