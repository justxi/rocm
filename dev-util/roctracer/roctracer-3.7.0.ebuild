EAPI=7

DESCRIPTION="ROCm Tracer Callback/Activity Library for Performance tracing AMD GPU's"
HOMEPAGE="https://github.com/ROCm-Developer-Tools/roctracer"
SRC_URI="https://github.com/ROCm-Developer-Tools/roctracer/archive/rocm-${PV}.tar.gz -> rocm-tracer-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="amd64"
IUSE="debug"

RDEPEND=">=dev-libs/rocr-runtime-${PV}
	>=sys-devel/llvm-roc-${PV}
	>=sys-devel/hip-${PV}"
DEPEND=">dev-util/rocm-cmake-${PV}
	>=dev-lang/python-3.7
	dev-python/CppHeaderParser
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	mv roctracer-rocm-${PV} roctracer-${PV}
}

src_prepare() {
	# do not add "roctracer" to CMAKE_INSTALL_PREFIX
	sed -e "s:set ( CMAKE_INSTALL_PREFIX \${CMAKE_INSTALL_PREFIX}/\${ROCTRACER_NAME} ):#set ( CMAKE_INSTALL_PREFIX \${CMAKE_INSTALL_PREFIX}/\${ROCTRACER_NAME} ):" -i ${S}/CMakeLists.txt

	# change lib to lib64
	sed -e "s:install ( TARGETS \${ROCTRACER_TARGET} LIBRARY DESTINATION lib ):install ( TARGETS \${ROCTRACER_TARGET} LIBRARY DESTINATION lib64 ):" -i ${S}/CMakeLists.txt

	# do not build the tool and it´s library
	sed -e "s:add_subdirectory ( \${TEST_DIR} \${PROJECT_BINARY_DIR}/test ):#add_subdirectory ( \${TEST_DIR} \${PROJECT_BINARY_DIR}/test ):" -i ${S}/CMakeLists.txt

	# change destination for headers to include/roctracer
	sed -e "s:DESTINATION include:DESTINATION include/roctracer:" -i ${S}/CMakeLists.txt

	# do not install links and tool library
	sed -e "s:install ( FILES \${PROJECT_BINARY_DIR}/inc-link DESTINATION ../include RENAME \${ROCTRACER_NAME} ):#install ( FILES \${PROJECT_BINARY_DIR}/inc-link DESTINATION ../include RENAME \${ROCTRACER_NAME} ):" -i ${S}/CMakeLists.txt
	sed -e "s:install ( FILES \${PROJECT_BINARY_DIR}/so-link DESTINATION ../lib RENAME \${ROCTRACER_LIBRARY}.so ):#install ( FILES \${PROJECT_BINARY_DIR}/so-link DESTINATION ../lib RENAME \${ROCTRACER_LIBRARY}.so ):" -i ${S}/CMakeLists.txt
	sed -e "s:install ( FILES \${PROJECT_BINARY_DIR}/test/libtracer_tool.so DESTINATION tool ):#install ( FILES \${PROJECT_BINARY_DIR}/test/libtracer_tool.so DESTINATION tool ):" -i ${S}/CMakeLists.txt

	# change lib to lib64
	sed -e "s:install ( TARGETS \"roctx64\" LIBRARY DESTINATION lib ):install ( TARGETS \"roctx64\" LIBRARY DESTINATION lib64 ):" -i ${S}/CMakeLists.txt
	sed -e "s:install ( TARGETS \"kfdwrapper64\" LIBRARY DESTINATION lib ):install ( TARGETS \"kfdwrapper64\" LIBRARY DESTINATION lib64 ):" -i ${S}/CMakeLists.txt

	# do not install links
	sed -e "s:install ( FILES \${PROJECT_BINARY_DIR}/so-roctx-link DESTINATION ../lib RENAME \${ROCTX_LIBRARY}.so ):#install ( FILES \${PROJECT_BINARY_DIR}/so-roctx-link DESTINATION ../lib RENAME \${ROCTX_LIBRARY}.so ):" -i ${S}/CMakeLists.txt

	# do not builds tests - downloading in src_unpack does not work
	sed -e "s:add_subdirectory ( ${TEST_DIR} ${PROJECT_BINARY_DIR}/test ):#add_subdirectory ( ${TEST_DIR} ${PROJECT_BINARY_DIR}/test ):" -i ${S}/test/CMakeLists.txt

	# do not download additional sources via git - moved to src_unpack
	sed -e "s:execute_process ( COMMAND sh -xc \"if:#execute_process ( COMMAND sh -xc \"if:" -i ${S}/test/CMakeLists.txt

	eapply_user
}

src_configure() {
	mkdir -p "${WORKDIR}/build/"
	cd "${WORKDIR}/build/"

	export CMAKE_PREFIX_PATH=/usr/include/hsa:/usr/lib/

	if use debug; then
		export CMAKE_BUILD_TYPE=debug
	fi

	cmake -DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr" ${S}
}

src_compile() {
	cd "${WORKDIR}/build/"
	make
}

src_install() {
	cd "${WORKDIR}/build/"
	emake DESTDIR="${D}" install
}
