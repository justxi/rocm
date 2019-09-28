# Copyright
#

EAPI=7
inherit cmake-utils flag-o-matic

DESCRIPTION="C++ Heterogeneous-Compute Interface for Portability"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/HIP"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm-Developer-Tools/HIP.git"
	EGIT_BRANCH="master"
	inherit git-r3
	S="${WORKDIR}/${P}"
	KEYWORDS="**"
else
	SRC_URI="https://github.com/ROCm-Developer-Tools/HIP/archive/roc-${PV}.tar.gz -> rocm-hip-${PV}.tar.gz"
	S="${WORKDIR}/HIP-roc-${PV}"
	KEYWORDS="~amd64"
fi


LICENSE=""
SLOT="0/$(ver_cut 1-2)"
IUSE="debug +hipify +hcc-backend llvm-roc-backend"
CMAKE_BUILD_TYPE=Release

REQUIRED_USE="^^ ( hcc-backend llvm-roc-backend )"

DEPEND=">=dev-libs/rocm-comgr-${PV}
	>=sys-devel/hcc-${PV}
	hipify? ( >=sys-devel/clang-8.0.0 )
	llvm-roc-backend? ( =dev-libs/rocm-device-libs-${PV}* )
	llvm-roc-backend? ( =sys-devel/llvm-roc-${PV}* )
"
RDEPEND="${DEPEND}"

src_prepare() {
	eapply "${FILESDIR}/DisableTest.patch"
	eapply "${FILESDIR}/HIP-2.7.0-ROCM_PATH-LIB_PATH.patch"
	sed -e "s:#!/usr/bin/python:#!/usr/bin/python2:" -i hip_prof_gen.py || die
	eapply_user
	cmake-utils_src_prepare
}

src_configure() {
	strip-flags
	if ! use debug; then
		append-cflags "-DNDEBUG"
		append-cxxflags "-DNDEBUG"
	fi

	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/lib/hip"
		-DBUILD_HIPIFY_CLANG=$(usex hipify)
		-DHIP_PLATFORM=hcc
		-DHIP_COMPILER=$(usex llvm-roc-backend "clang" "hcc")
		-DHCC_HOME=${HCC_HOME}
		-DHSA_PATH="/usr"
	)

	if use llvm-roc-backend; then
		mycmakeargs+=( 
			-DCMAKE_PREFIX_PATH="/usr/lib/llvm/roc" 
		)
	fi

	cmake-utils_src_configure
}

src_install() {
	echo "HIP_PLATFORM=hcc" > 99hip || die
	echo "PATH=/usr/lib/hip/bin" >> 99hip || die
	echo "HIP_PATH=/usr/lib/hip" >> 99hip || die
	echo "LDPATH=/usr/lib/hip/lib" >> 99hip || die
	echo "ROOTPATH=/usr/lib/hip/bin" >> 99hip || die

	if use llvm-roc-backend; then
		echo "HIP_COMPILER=clang" >> 99hip || die
		echo "HIP_CLANG_PATH=/usr/lib/llvm/roc/bin" >> 99hip || die
		echo "DEVICE_LIB_PATH=/usr/lib/" >> 99hip || die
	fi

	doenvd 99hip

	cmake-utils_src_install
}
