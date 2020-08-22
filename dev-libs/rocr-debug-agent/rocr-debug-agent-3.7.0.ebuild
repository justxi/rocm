# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils linux-info

DESCRIPTION="Radeon Open Compute Debug Agent"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/rocr_debug_agent/"
SRC_URI="https://github.com/ROCm-Developer-Tools/rocr_debug_agent/archive/roc-${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

CONFIG_CHECK="~HSA_AMD"

RDEPEND="dev-libs/rocr-runtime
	dev-libs/roct-thunk-interface
	dev-libs/amd-dbgapi
	sys-devel/hip
	dev-util/systemtap"
DEPEND="${RDEPEND}"

S="${WORKDIR}/rocr_debug_agent-roc-${PV}/"

#src_prepare() {
#	sed -e "s:HINTS /opt/rocm/include:HINTS /usr/include:" -i "${S}/CMakeLists.txt"
#	sed -e "s:install(TARGETS \${TARGET_NAME} DESTINATION lib):install(TARGETS \${TARGET_NAME} DESTINATION lib64):" -i "${S}/CMakeLists.txt"
#
#	cmake-utils_src_prepare
#}
