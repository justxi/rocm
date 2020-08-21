EAPI=7

inherit unpacker

ROCM_VERSION="3.5.0"
MY_PV="${PV}-rocm-rel-$(ver_cut 1-2 ${ROCM_VERSION})-30-def83d8_amd64.deb"

DESCRIPTION="Proprietary image-support library for Radeon Open Compute"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm#closed-source-components"
SRC_URI="http://repo.radeon.com/rocm/apt/debian/pool/main/h/${PN}-dev${ROCM_VERSION}/${PN}-dev${ROCM_VERSION}_${MY_PV}"
#	 http://repo.radeon.com/rocm/apt/debian/pool/main/h/hsa-ext-rocr-dev3.5.0/hsa-ext-rocr-dev3.5.0_1.1.30500.0-rocm-rel-3.5-30-def83d8_amd64.deb

LICENSE="AMD-GPU-PRO-EULA"
SLOT="0"
KEYWORDS="amd64"
IUSE="-deprecated"

RESTRICT="bindist strip"

QA_PREBUILT="/usr/lib*/*"

S="${WORKDIR}"

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	local soversion=$(ver_cut 1-3)
	local somajor=$(ver_cut 1)

	local solibs_to_install=( "libhsa-ext-image64.so" )
	if use deprecated; then
		solibs_to_install+=( "libhsa-runtime-tools64.so" )
	fi

	for solib in ${solibs_to_install[@]}; do
		dolib.so "opt/rocm-${ROCM_VERSION}/hsa/lib/${solib}.${soversion}"
		dosym "${solib}.${soversion}" "/usr/$(get_libdir)/${solib}.1"
		dosym "${solib}.1" "/usr/$(get_libdir)/${solib}"
	done
}
