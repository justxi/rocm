EAPI=7

inherit cmake

DESCRIPTION="Radeon Open Compute llvm,lld,clang"
HOMEPAGE="https://github.com/RadeonOpenCompute/llvm-project/"
SRC_URI="https://github.com/RadeonOpenCompute/llvm-project/archive/rocm-${PV}.tar.gz -> llvm-rocm-ocl-${PV}.tar.gz"

LICENSE="UoI-NCSA rc BSD public-domain"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64"
IUSE="debug doc"

RDEPEND="virtual/cblas
	dev-libs/rocr-runtime"
DEPEND="${RDEPEND}"

CMAKE_BUILD_TYPE=Release

S="${WORKDIR}/llvm-project-rocm-${PV}/llvm"

src_prepare() {
	cd "${WORKDIR}/llvm-project-rocm-${PV}" || die
	eapply "${FILESDIR}/${PN}-3.7.0-add_libraries.patch"
	eapply "${FILESDIR}/cuda11.patch"
	eapply_user
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/llvm/roc/$(ver_cut 1-2)"
		-DLLVM_ENABLE_PROJECTS="clang;lld"
		-DLLVM_TARGETS_TO_BUILD="AMDGPU;X86"
		-DLLVM_BUILD_DOCS=$(usex doc)
		-DLLVM_ENABLE_OCAMLDOC=OFF
		-DLLVM_ENABLE_SPHINX=$(usex doc)
		-DLLVM_ENABLE_DOXYGEN=OFF
		-DLLVM_INSTALL_UTILS=ON
		-DLLVM_VERSION_SUFFIX=roc
		-DOCAMLFIND=NO
	)

	use debug || local -x CPPFLAGS="${CPPFLAGS} -DNDEBUG"

	cmake_src_configure
}

src_install() {
	cmake_src_install
	echo "LDPATH=${EROOT}/usr/lib/llvm/roc/$(ver_cut 1-2)/lib" > 99llvm-roc
	doenvd 99llvm-roc
}
