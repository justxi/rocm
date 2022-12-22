# Copyright
#

EAPI=7

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocprofiler.git"
SRC_URI="https://github.com/ROCm-Developer-Tools/rocprofiler/archive/roc-${PV}.tar.gz -> rocm-profiler-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="media-libs/hsa-amd-aqlprofile
         dev-libs/rocr-runtime"
DEPEND="dev-util/cmake
	${RDEPEND}"

#PATCHES=(
#        "${FILESDIR}/remove-test.patch"
#)

src_unpack() {
	unpack ${A}
	mv rocprofiler-roc-${PV} rocprofiler-${PV}
}

src_prepare() {
	eapply "${FILESDIR}/remove-test.patch"
	sed -e "s:set ( CMAKE_INSTALL_PREFIX \"\${CMAKE_INSTALL_PREFIX}/\${ROCPROFILER_NAME}\" ):#set ( CMAKE_INSTALL_PREFIX \"\${CMAKE_INSTALL_PREFIX}/\${ROCPROFILER_NAME}\" ):" -i ${S}/CMakeLists.txt
	sed -e "s:install ( TARGETS \${ROCPROFILER_TARGET} LIBRARY DESTINATION lib ):install ( TARGETS \${ROCPROFILER_TARGET} LIBRARY DESTINATION lib64 ):" -i ${S}/CMakeLists.txt
	sed -e "s:install ( FILES \${PROJECT_BINARY_DIR}/inc-link DESTINATION ../include RENAME \${ROCPROFILER_NAME} ):#install ( FILES \${PROJECT_BINARY_DIR}/inc-link DESTINATION ../include RENAME \${ROCPROFILER_NAME} ):" -i ${S}/CMakeLists.txt
	sed -e "s:install ( FILES \${PROJECT_BINARY_DIR}/so-link DESTINATION ../lib RENAME \${ROCPROFILER_LIBRARY}.so ):#install ( FILES \${PROJECT_BINARY_DIR}/so-link DESTINATION ../lib RENAME \${ROCPROFILER_LIBRARY}.so ):" -i ${S}/CMakeLists.txt
	eapply_user
}

src_configure() {
        mkdir -p "${WORKDIR}/build/"
        cd "${WORKDIR}/build/"

	export CMAKE_PREFIX_PATH=/usr/include/hsa:/usr/lib/

	if use debug; then
		export CMAKE_BUILD_TYPE=debug
#		export CMAKE_DEBUG_TRACE=1
#		export CMAKE_LD_AQLPROFILE=1
	fi

	cmake -DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr/"  ${S}
}

src_compile() {
        cd "${WORKDIR}/build/"
        make
}

src_install() {
        cd "${WORKDIR}/build/"
	emake DESTDIR="${D}" install

	rm -r "${D}/bin"
	exeinto /usr/bin
        dosym ./rpl_run.sh /usr/bin/rocprof
}

pkg_postinst() {
        elog "If there is an error about \"aqlprofile ...\", try to preload the library libhsa-amd-aqlprofile64.so"
        elog "> LD_PRELOAD=/usr/lib64/libhsa-amd-aqlprofile64.so.1.0.0 [command]"
}

