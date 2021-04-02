# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake linux-info

DESCRIPTION="Radeon Open Compute Debug Agent"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/rocr_debug_agent/"
SRC_URI="https://github.com/ROCm-Developer-Tools/rocr_debug_agent/archive/rocm-${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

CONFIG_CHECK="~HSA_AMD"

RDEPEND="dev-libs/rocr-runtime
	dev-libs/roct-thunk-interface
	dev-libs/amd-dbgapi
	dev-util/hip
	dev-util/systemtap"
DEPEND="${RDEPEND}"

S="${WORKDIR}/rocr_debug_agent-rocm-${PV}/"

src_prepare() {
	sed -e "s:/opt/rocm/hip/cmake:/usr/lib/hip/4.0/cmake/:" -i "${S}/test/CMakeLists.txt"

	sed -e "s:enable_testing:#enable_testing:" -i "${S}/CMakeLists.txt"
	sed -e "s:add_subdirectory(test):#add_subdirectory(test):" -i "${S}/CMakeLists.txt"

	sed -e "s:DESTINATION lib:DESTINATION lib64:" -i "${S}/CMakeLists.txt"
	sed -e "s:DESTINATION share/doc/rocm-debug-agent:DESTINATION share/doc/rocm-debug-agent-${PV}:" -i "${S}/CMakeLists.txt"

	cmake_src_prepare
}
