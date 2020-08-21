EAPI=7
inherit cmake-utils

DESCRIPTION="User space interface for applications to monitor and control GPU applications."
HOMEPAGE="https://github.com/RadeonOpenCompute/rocm_smi_lib"
SRC_URI="https://github.com/RadeonOpenCompute/rocm_smi_lib/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND=""

PATCHES=(
	"${FILESDIR}/${P}-omit-git-output.patch"
	"${FILESDIR}/${P}-utils-no-repository.patch"
#	"${FILESDIR}/${P}-do-not-create-top-level-symlinks.patch"
)

S="${WORKDIR}/rocm_smi_lib-rocm-${PV}"

src_prepare() {
	sed -e "s:LIBRARY DESTINATION \${ROCM_SMI}/lib COMPONENT \${ROCM_SMI_COMPONENT}):LIBRARY DESTINATION lib64 COMPONENT \${ROCM_SMI_COMPONENT}):" -i ${S}/CMakeLists.txt
	sed -e "s:DESTINATION rocm_smi/include/rocm_smi):DESTINATION include):" -i ${S}/CMakeLists.txt

	eapply_user
	cmake-utils_src_prepare
}

src_install() {
	cmake-utils_src_install

	dodoc rocm_smi/docs/README.md rocm_smi/docs/ROCm_SMI_Manual.pdf

	rm -rf ${D}/usr/rocm_smi || die
}