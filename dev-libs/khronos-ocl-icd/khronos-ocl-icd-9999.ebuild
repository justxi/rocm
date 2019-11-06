# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3 flag-o-matic

DESCRIPTION="Khronos official OpenCL ICD Loader"
HOMEPAGE="https://github.com/KhronosGroup/OpenCL-ICD-Loader"

EGIT_REPO_URI="https://github.com/KhronosGroup/OpenCL-ICD-Loader.git"
EGIT_COMMIT="978b4b3a29a3aebc86ce9315d5c5963e88722d03"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="app-eselect/eselect-opencl"
RDEPEND="${DEPEND}"
BDEPEND="dev-util/cmake"

src_configure() {
	strip-flags
	cmake-utils_src_configure
}

src_install() {
	into /usr/lib64/OpenCL/vendors/amd
	dolib.so ${BUILD_DIR}/libOpenCL.so.1.2
	dosym lib64/libOpenCL.so.1.2 /usr/lib64/OpenCL/vendors/amd/libOpenCL.so.1
	dosym lib64/libOpenCL.so.1.2 /usr/lib64/OpenCL/vendors/amd/libOpenCL.so
}
