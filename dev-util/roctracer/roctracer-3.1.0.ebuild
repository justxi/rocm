# Copyright
#

EAPI=6

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCm-Developer-Tools/roctracer.git"
SRC_URI="https://github.com/ROCm-Developer-Tools/roctracer/archive/roc-${PV}.tar.gz -> rocm-tracer-${PV}.tar.gz"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

RDEPEND="dev-libs/rocr-runtime
	 sys-devel/llvm-roc
	 sys-devel/hip"
DEPEND="dev-util/cmake
	dev-lang/python:2.7
	dev-python/CppHeaderParser
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	mv roctracer-roc-${PV} roctracer-${PV}

	git clone https://github.com/ROCmSoftwarePlatform/hsa-class.git ${S}/test/hsa
	cd ${S}/test/hsa
	git fetch origin && git checkout 7defb6d;
}

src_prepare() {
	eapply "${FILESDIR}/roctracer-${PV}-python.patch"

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

	# do not download additional sources via git - moved to src_unpack
	sed -e "s:execute_process ( COMMAND sh -xc \"if:#execute_process ( COMMAND sh -xc \"if:" -i ${S}/test/CMakeLists.txt

	# do not autodetect hardware
#	sed -e "s:GFXIP=\$(:GFXIP=gfx803 #\$:" -i ${S}/test/hsa/script/build_kernel.sh

	# replace hardcoded paths
#	sed -e "s:/opt/rocm/opencl/bin/x86_64/clang:/usr/lib/llvm/roc/bin/clang:"  -i ${S}/test/hsa/script/build_kernel.sh
#	sed -e "s:/opt/rocm/opencl/include/opencl-c.h:/usr/lib/llvm/roc/lib/clang/10.0.0/include/opencl-c.h:" -i ${S}/test/hsa/script/build_kernel.sh
#	sed -e "s:/opt/rocm/opencl/lib/x86_64/bitcode/opencl.amdgcn.bc:/usr/lib/opencl.amdgcn.bc:" -i ${S}/test/hsa/script/build_kernel.sh
#	sed -e "s:/opt/rocm/opencl/lib/x86_64/bitcode/ockl.amdgcn.bc:/usr/lib/ockl.amdgcn.bc:" -i ${S}/test/hsa/script/build_kernel.sh

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
