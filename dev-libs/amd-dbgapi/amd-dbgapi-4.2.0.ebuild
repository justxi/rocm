# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="AMD Debugger API"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/ROCdbgapi"
SRC_URI="https://github.com/ROCm-Developer-Tools/ROCdbgapi/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"

RDEPEND=">=dev-libs/rocm-comgr-${PV}"
DEPEND="${RDEPEND}"

S="${WORKDIR}/ROCdbgapi-rocm-${PV}/"

src_prepare() {
	sed -e "s:DESTINATION lib:DESTINATION lib64:" -i "CMakeLists.txt" || die
	sed -e "s:DESTINATION share/doc/amd-dbgapi:DESTINATION share/doc/amd-dbgapi-${PV}:" -i "CMakeLists.txt" || die

	cmake_src_prepare
}


