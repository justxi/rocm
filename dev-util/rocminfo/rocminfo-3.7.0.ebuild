EAPI=7

inherit cmake

DESCRIPTION="ROCm Application for Reporting System Info"
HOMEPAGE="https://github.com/RadeonOpenCompute/rocminfo"
SRC_URI="https://github.com/RadeonOpenCompute/rocminfo/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND="dev-libs/rocr-runtime"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/rocminfo-3.7.0-uname.patch" )

S="${WORKDIR}/rocminfo-rocm-${PV}"

src_configure() {
	local mycmakeargs=(
		-DROCM_DIR="${ESYSROOT}/usr"
		-DROCR_INC_DIR="${ESYSROOT}/usr/include"
		-DROCR_LIB_DIR="${EPREFIX}/usr/$(get_libdir)"
	)
	cmake_src_configure
}
