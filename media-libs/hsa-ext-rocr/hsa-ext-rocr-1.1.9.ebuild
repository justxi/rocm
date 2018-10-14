# Copyright
# 

EAPI=6
inherit unpacker

DESCRIPTION="hsa-ext-rocr"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm"
SRC_URI="http://repo.radeon.com/rocm/apt/debian/pool/main/h/hsa-ext-rocr-dev/hsa-ext-rocr-dev_1.1.9-9-ge4ab040_amd64.deb"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack(){
        unpack_deb ${A}
}

src_install() {
	dolib.so "${S}/opt/rocm/hsa/lib/libhsa-ext-image64.so.1.1.9"
	dosym "libhsa-ext-image64.so.1.1.9" "/usr/$(get_libdir)/libhsa-ext-image64.so.1"

	dolib.so "${S}/opt/rocm/hsa/lib/libhsa-runtime-tools64.so.1.1.9"
	dosym "libhsa-runtime-tools64.so.1.1.9" "/usr/$(get_libdir)/libhsa-runtime-tools64.so.1"
}
