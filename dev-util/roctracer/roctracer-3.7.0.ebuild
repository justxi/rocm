# Copyright
#

EAPI=7

inherit cmake

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCm-Developer-Tools/roctracer.git"
SRC_URI="https://github.com/ROCm-Developer-Tools/roctracer/archive/rocm-${PV}.tar.gz -> rocm-tracer-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="dev-libs/rocr-runtime
	 sys-devel/llvm-roc
	 sys-devel/hip"
DEPEND="dev-util/cmake
	dev-python/CppHeaderParser
	dev-python/ply
	${RDEPEND}"

S="${WORKDIR}/roctracer-rocm-${PV}"

src_prepare() {
	# change lib to lib64
	sed -e "s:install ( TARGETS \${ROCTRACER_TARGET} LIBRARY DESTINATION \${DEST_NAME}/lib ):install ( TARGETS \${ROCTRACER_TARGET} LIBRARY DESTINATION lib64 ):" -i ${S}/CMakeLists.txt

	# do not build the tool and it´s library
	sed -e "s:add_subdirectory ( \${TEST_DIR} \${PROJECT_BINARY_DIR}/test ):#add_subdirectory ( \${TEST_DIR} \${PROJECT_BINARY_DIR}/test ):" -i ${S}/CMakeLists.txt

	# change destination for headers to include/roctracer
	sed -e "s:DESTINATION \${DEST_NAME}/include:DESTINATION include/roctracer:" -i ${S}/CMakeLists.txt

	# do not install a second set of header files
	sed -e "s:install ( FILES \${CMAKE_CURRENT_SOURCE_DIR}/inc/\${header} DESTINATION include/\${DEST_NAME}/\${header_subdir} ):#install ( FILES \${CMAKE_CURRENT_SOURCE_DIR}/inc/\${header} DESTINATION include/\${DEST_NAME}/\${header_subdir} ):" -i ${S}/CMakeLists.txt

	# do not install links and tool library
	sed -e "s:install ( FILES \${PROJECT_BINARY_DIR}/inc-link DESTINATION ../include RENAME \${ROCTRACER_NAME} ):#install ( FILES \${PROJECT_BINARY_DIR}/inc-link DESTINATION ../include RENAME \${ROCTRACER_NAME} ):" -i ${S}/CMakeLists.txt
	sed -e "s:install ( FILES \${PROJECT_BINARY_DIR}/so-link DESTINATION lib RENAME \${ROCTRACER_LIBRARY}.so ):#install ( FILES \${PROJECT_BINARY_DIR}/so-link DESTINATION lib RENAME \${ROCTRACER_LIBRARY}.so ):" -i ${S}/CMakeLists.txt
	sed -e "s:install ( FILES \${PROJECT_BINARY_DIR}/so-major-link DESTINATION lib RENAME \${ROCTRACER_LIBRARY}.so.\${LIB_VERSION_MAJOR} ):#install ( FILES \${PROJECT_BINARY_DIR}/so-link DESTINATION lib RENAME \${ROCTRACER_LIBRARY}.so.\${LIB_VERSION_MAJOR} ):" -i ${S}/CMakeLists.txt
	sed -e "s:install ( FILES \${PROJECT_BINARY_DIR}/so-patch-link DESTINATION lib RENAME \${ROCTRACER_LIBRARY}.so.\${LIB_VERSION_STRING} ):#install ( FILES \${PROJECT_BINARY_DIR}/so-link DESTINATION lib RENAME \${ROCTRACER_LIBRARY}.so.\${LIB_VERSION_STRING} ):" -i ${S}/CMakeLists.txt
	sed -e "s:install ( FILES \${PROJECT_BINARY_DIR}/test/libtracer_tool.so DESTINATION \${DEST_NAME}/tool ):#install ( FILES \${PROJECT_BINARY_DIR}/test/libtracer_tool.so DESTINATION \${DEST_NAME}/tool ):" -i ${S}/CMakeLists.txt

	# change lib to lib64
	sed -e "s:install ( TARGETS \"roctx64\" LIBRARY DESTINATION \${DEST_NAME}/lib ):install ( TARGETS \"roctx64\" LIBRARY DESTINATION lib64 ):" -i ${S}/CMakeLists.txt
	sed -e "s:install ( TARGETS \"kfdwrapper64\" LIBRARY DESTINATION \${DEST_NAME}/lib ):install ( TARGETS \"kfdwrapper64\" LIBRARY DESTINATION lib64 ):" -i ${S}/CMakeLists.txt

	# do not install links
	sed -e "s:install ( FILES \${PROJECT_BINARY_DIR}/so-roctx-link DESTINATION lib RENAME \${ROCTX_LIBRARY}.so ):#install ( FILES \${PROJECT_BINARY_DIR}/so-roctx-link DESTINATION lib RENAME \${ROCTX_LIBRARY}.so ):" -i ${S}/CMakeLists.txt
	sed -e "s:install ( FILES \${PROJECT_BINARY_DIR}/so-roctx-major-link DESTINATION lib RENAME \${ROCTX_LIBRARY}.so.\${LIB_VERSION_MAJOR} ):#install ( FILES \${PROJECT_BINARY_DIR}/so-roctx-link DESTINATION lib RENAME \${ROCTX_LIBRARY}.so.\${LIB_VERSION_MAJOR} ):" -i ${S}/CMakeLists.txt
	sed -e "s:install ( FILES \${PROJECT_BINARY_DIR}/so-roctx-patch-link DESTINATION lib RENAME \${ROCTX_LIBRARY}.so.\${LIB_VERSION_STRING} ):#install ( FILES \${PROJECT_BINARY_DIR}/so-roctx-link DESTINATION lib RENAME \${ROCTX_LIBRARY}.so.\${LIB_VERSION_STRING} ):" -i ${S}/CMakeLists.txt

	# do not download additional sources via git
	sed -e "s:execute_process ( COMMAND sh -xc \"if:#execute_process ( COMMAND sh -xc \"if:" -i ${S}/test/CMakeLists.txt

	# do not builds tests - no files downloaded via git
	sed -e "s:add_subdirectory ( \${TEST_DIR} \${PROJECT_BINARY_DIR}/test/hsa ):#add_subdirectory ( \${TEST_DIR} \${PROJECT_BINARY_DIR}/test/hsa ):" -i ${S}/test/CMakeLists.txt

	eapply_user
	cmake_src_prepare
}

src_configure() {
	export CMAKE_PREFIX_PATH=/usr/include/hsa:/usr/lib/

	if use debug; then
		export CMAKE_BUILD_TYPE=debug
#		export CMAKE_DEBUG_TRACE=1
#		export CMAKE_LD_AQLPROFILE=1
	fi

	cmake_src_configure
}
