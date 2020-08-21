EAPI=7

inherit cmake

DESCRIPTION="Radeon Open Compute Code Object Manager"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport"
SRC_URI="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

PATCHES=(
	"${FILESDIR}/${PN}-3.7.0-find-clang.patch"
	"${FILESDIR}/${PN}-3.7.0-find-lld-includes.patch"
	"${FILESDIR}/${PN}-3.7.0-dependencies.patch"
	"${FILESDIR}/${PN}-3.7.0-fix-tests.patch"
	"${FILESDIR}/${PN}-3.7.0-fix-lib_path.patch"
)

RDEPEND="dev-libs/rocm-device-libs
	sys-devel/llvm"
DEPEND="${RDEPEND}"

S="${WORKDIR}/ROCm-CompilerSupport-rocm-${PV}/lib/comgr"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DLLVM_DIR="${EPREFIX}/usr/lib/llvm/roc/$(ver_cut 1-2)/lib/cmake/llvm"
		-DClang_DIR="${EPREFIX}/usr/lib/llvm/roc/$(ver_cut 1-2)/lib/cmake/clang"

	)
	cmake_src_configure
}
