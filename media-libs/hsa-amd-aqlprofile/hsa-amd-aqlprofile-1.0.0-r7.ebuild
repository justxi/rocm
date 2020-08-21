EAPI=7
inherit unpacker

ROCM_VERSION="3.7.0"
DESCRIPTION="hsa-amd-aqlprofile"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm#closed-source-components"
SRC_URI="http://repo.radeon.com/rocm/apt/debian/pool/main/h/hsa-amd-aqlprofile${ROCM_VERSION}/hsa-amd-aqlprofile${ROCM_VERSION}_${PV}_amd64.deb"

LICENSE=""
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

QA_PREBUILT="/usr/lib*/*"

S="${WORKDIR}"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	dolib.so "${S}/opt/rocm-${ROCM_VERSION}/hsa-amd-aqlprofile/lib/libhsa-amd-aqlprofile64.so.1.0.30700"
	dosym "libhsa-amd-aqlprofile64.so.1.0.30700" "/usr/$(get_libdir)/libhsa-amd-aqlprofile64.so.1"
	dosym "libhsa-amd-aqlprofile64.so.1" "/usr/$(get_libdir)/libhsa-amd-aqlprofile64.so"
}
