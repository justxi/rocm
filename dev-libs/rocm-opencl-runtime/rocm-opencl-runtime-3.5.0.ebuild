# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

OPENCL_ICD_COMMIT="6c03f8b58fafd9dd693eaac826749a5cfad515f8"
SRC_URI="https://github.com/KhronosGroup/OpenCL-ICD-Loader/archive/${OPENCL_ICD_COMMIT}.tar.gz -> OpenCL-ICD-Loader-${OPENCL_ICD_COMMIT}.tar.gz"
if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/"
	inherit git-r3
else
	SRC_URI+=" https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime/archive/roc-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/ROCm-OpenCL-Runtime-roc-${PV}"
fi

DESCRIPTION="Radeon Open Compute OpenCL Compatible Runtime"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-OpenCL-Runtime"

LICENSE="Apache-2.0 MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND=">=dev-libs/rocr-runtime-${PV}
	>=dev-libs/rocm-comgr-${PV}
	>=dev-libs/rocm-device-libs-${PV}
	>=virtual/opencl-3
	media-libs/mesa"
DEPEND="${RDEPEND}
	dev-lang/ocaml
	dev-ml/findlib"
BDEPEND=">=dev-util/rocm-cmake-${PV}"

PATCHES=(
	"${FILESDIR}/${PN}-3.5.0-change-install-location.patch"
	"${FILESDIR}/${PN}-3.5.0-amdocl64icd.patch"
)

src_prepare() {
	# Do we need this?
	mkdir -p "${S}"/api/opencl/khronos/ || die
	mv "${WORKDIR}/OpenCL-ICD-Loader-${OPENCL_ICD_COMMIT}" "${S}"/api/opencl/khronos/icd || die

	# Remove "clinfo" - use "dev-util/clinfo" instead
	[ -d tools/clinfo ] && rm -rf tools/clinfo || die

	# Wrong position of a " results in a list of strings instead of a single string
	sed -e "s:set(CMAKE_SHARED_LINKER_FLAGS \${CMAKE_SHARED_LINKER_FLAGS} \":set(CMAKE_SHARED_LINKER_FLAGS \"\${CMAKE_SHARED_LINKER_FLAGS} :" -i ${S}/amdocl/CMakeLists.txt

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DUSE_COMGR_LIBRARY=yes
		-DROCclr_DIR=/usr/include/rocclr
		-DLIBROCclr_STATIC_DIR=/usr/lib64/
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	# This should be removed in CMakeLists.txt - but where?
	rm ${D}/usr/lib64/libOpenCL.so*
}
