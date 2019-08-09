# Copyright
#

EAPI=6
inherit cmake-utils git-r3

DESCRIPTION="User space interface for applications to monitor and control GPU applications."
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm_smi_lib"
EGIT_REPO_URI="https://github.com/RadeonOpenCompute/rocm_smi_lib"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND=""

src_prepare() {
	sed -e "s:LIBRARY DESTINATION \${ROCM_SMI}/lib COMPONENT \${ROCM_SMI_COMPONENT}):LIBRARY DESTINATION lib64 COMPONENT \${ROCM_SMI_COMPONENT}):" -i ${S}/CMakeLists.txt
	sed -e "s:DESTINATION rocm_smi/include/rocm_smi):DESTINATION include):" -i ${S}/CMakeLists.txt
	eapply_user
}
