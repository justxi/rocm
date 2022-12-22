# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake linux-info

SRC_URI="https://github.com/ROCm-Developer-Tools/rocr_debug_agent/archive/roc-${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/rocr_debug_agent-roc-${PV}/src"
KEYWORDS="~amd64"

DESCRIPTION="Radeon Open Compute Debug Agent"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/rocr_debug_agent/"
CONFIG_CHECK="~HSA_AMD"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

#PATCHES=(
#        "${FILESDIR}/rocr-debug-agent-3.1.0-cmake.patch"
#)

RDEPEND="dev-libs/rocr-runtime
	dev-libs/roct-thunk-interface
	dev-util/systemtap"
DEPEND="${RDEPEND}"

S="${WORKDIR}/rocr_debug_agent-roc-${PV}/src"

src_prepare() {
	sed -e "s:HINTS /opt/rocm/include:HINTS /usr/include:" -i "${S}/CMakeLists.txt"
	sed -e "s:install(TARGETS \${TARGET_NAME} DESTINATION lib):install(TARGETS \${TARGET_NAME} DESTINATION lib64):" -i "${S}/CMakeLists.txt"

	cmake_src_prepare
}
