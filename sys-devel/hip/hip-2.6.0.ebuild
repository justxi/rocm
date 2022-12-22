# Copyright
#

EAPI=7
inherit cmake

DESCRIPTION="C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIP"
SRC_URI="https://github.com/ROCm-Developer-Tools/HIP/archive/roc-${PV}.tar.gz -> rocm-hip-${PV}.tar.gz"

LICENSE=""
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="debug"
CMAKE_BUILD_TYPE=Release

DEPEND="=sys-devel/hcc-${PV}
	dev-libs/rocm-comgr
	sys-devel/llvm-roc"
RDEPEND="${DEPEND}"

src_unpack() {
	unpack ${A}
	mv HIP-roc-${PV} hip-${PV}
}

src_prepare() {
	eapply "${FILESDIR}/${PV}-DisableTest.patch"
	sed -e "s:#!/usr/bin/python:#!/usr/bin/python2:" -i hip_prof_gen.py || die
	eapply_user
	cmake_src_prepare
}

src_configure() {
	export LLVM_BUILD=/usr/lib/llvm/roc-${PV}
	if ! use debug; then
		append-cflags "-DNDEBUG"
		append-cxxflags "-DNDEBUG"
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/hip/$(ver_cut 1-2)" ${S}
		-DCMAKE_PREFIX_PATH=${LLVM_BUILD}
		-DHIP_PLATFORM=hcc
		-DBUILD_HIPIFY_CLANG=ON
		-DHIP_COMPILER=hcc
		-DHCC_HOME=/usr/lib/hcc/$(ver_cut 1-2)/
		-DHSA_PATH=/opt/rocm
	)

	cmake_src_configure
}

src_install() {
	echo "HIP_PLATFORM=hcc" > 99hip || die
	echo "PATH=/usr/lib/hip/$(ver_cut 1-2)/bin" >> 99hip || die
	echo "HIP_PATH=/usr/lib/hip/$(ver_cut 1-2)" >> 99hip || die
	echo "LDPATH=/usr/lib/hip/$(ver_cut 1-2)/lib" >> 99hip || die
	echo "CMAKE_PREFIX_PATH=/usr/lib/hip/$(ver_cut 1-2)/lib/cmake/hip" >> 99hip || die
	doenvd 99hip

	cmake_src_install
}
