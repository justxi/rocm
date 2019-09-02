# Copyright
#

EAPI=6

DESCRIPTION="A performance analysis tool that gathers data from the API run-time and GPU for OpenCL™ and ROCm/HSA applications"
HOMEPAGE="https://github.com/GPUOpen-Tools/RCP"
SRC_URI="https://github.com/GPUOpen-Tools/RCP/archive/v${PV}.tar.gz -> rcp-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-util/rocprofiler"
DEPEND="dev-util/cmake
	dev-lang/python:2.7
	dev-libs/boost[static-libs]
	${RDEPEND}"

S="${WORKDIR}/RCP-${PV}"

src_unpack() {
#	unpack ${A}

	# RCP-5.6 compilied against ROCm 2.6 misses a header file,
	# current version on git repository does not result in a failure,
	# need to find the patch to apply it to the RCP-5.6.tar.gz source archiv,
	# -> in the meantime we use the state from git repository
	git clone https://github.com/GPUOpen-Tools/RCP.git "${WORKDIR}/RCP-5.6"
	cd "${WORKDIR}/RCP-5.6"
	git checkout e5b26032e56599d176c8e75c556ad2ede68edd2b

	# RCP need a lot of additional packages,
	# currently we use RCPs own script to download them...
	cd ${S}
	python2.7 ./Scripts/UpdateCommon.py || die "Download of additional sources failed!"
}

src_prepare() {
	cd ${WORKDIR}
	# apply parenthesis to the python scripts
	eapply "${FILESDIR}/RCP-5.6-Common_Src_Scons_CXLinitpy.patch"

	# add "-Wno-cast-function-type" see https://github.com/GPUOpen-Tools/RCP/issues/28
	eapply "${FILESDIR}/RCP-5.6-Common_Src_AMDTActivityLogger_SConscript.patch"

	# add a static_cast<>
	eapply "${FILESDIR}/RCP-5.6-Common_Src_ComgrUtils_Src_ComgrUtilscpp.patch"


	cd ${S}
	# add parenthesis to python script
	eapply "${FILESDIR}/RCP-5.6-Build_Linux_SConstruct.patch"

	# change path to HSA and BOOST libraries
	eapply "${FILESDIR}/RCP-5.6-Build_Linux_Commonmk.patch"

	# remove std::move()
	eapply "${FILESDIR}/RCP-5.6-Src_CLTraceAgent_CLEventManagercpp.patch"

	# remove "-isystem"
	eapply "${FILESDIR}/RCP-5.6-Src_HSAUtils_makefile.patch"
	eapply "${FILESDIR}/RCP-5.6-Src_sprofile_makefile.patch"

	eapply_user
}

src_compile() {
	cd "${S}/Build/Linux"
	bash ./build_rcp.sh || die "Compiling RCP failed!"
}

src_install() {
	cd "${S}"

	# maybe install the following libraries to a subdirectory,
	# e.g. "/usr/lib64/rcp"?
	BIN_DIR="${S}/Output/bin"
	dolib.so "${BIN_DIR}/libGPUPerfAPICL.so"
	dolib.so "${BIN_DIR}/libGPUPerfAPIROCm.so"
	dolib.so "${BIN_DIR}/libRCPCLProfileAgent.so"
	dolib.so "${BIN_DIR}/libRCPHSAProfileAgent.so"
	dolib.so "${BIN_DIR}/libRCPPreloadXInitThreads.so"
	dolib.so "${BIN_DIR}/libGPUPerfAPICounters.so"
	dolib.so "${BIN_DIR}/libRCPCLOccupancyAgent.so"
	dolib.so "${BIN_DIR}/libRCPCLTraceAgent.so"
	dolib.so "${BIN_DIR}/libRCPHSATraceAgent.so"
	dolib.so "${BIN_DIR}/libRCPProfileDataParser.so"

	exeinto "/usr/bin"
	doexe "${BIN_DIR}/rcprof"

	# the following depends on libvulkan.so.1
#       doexe "${BIN_DIR}/VkStableClocks"
}
