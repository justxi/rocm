# Copyright
#

EAPI=6

inherit git-r3

DESCRIPTION=""
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/rocPRIM"
EGIT_REPO_URI="https://github.com/ROCmSoftwarePlatform/rocPRIM.git"
EGIT_BRANCH="master"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="=sys-devel/hip-1.9*"
DEPEND="${RDPEND}
	dev-util/cmake"

src_prepare() {
	cd ${S}
        eapply "${FILESDIR}/master-disable2ndfindhcc.patch"
        eapply_user
}

src_configure() {
        mkdir -p "${WORKDIR}/build/"
        cd "${WORKDIR}/build/"

	export PATH=$PATH:/usr/lib/hcc/1.9/bin
	export hcc_DIR=/usr/lib/hcc/1.9/lib/cmake/
	export hip_DIR=/usr/lib/hip/1.9/lib/cmake/
	export HIP_DIR=/usr/lib/hip/1.9/lib/cmake/
	export CXX=/usr/lib/hcc/1.9/bin/hcc

	cmake -DHIP_PLATFORM=hcc -DHIP_ROOT_DIR=/usr/lib/hip/1.9/ -DBUILD_TEST=OFF -DCMAKE_INSTALL_PREFIX=/usr/lib/ ${S}
}

src_compile() {
        cd "${WORKDIR}/build/"
        make VERBOSE=1
}

src_install() {
        cd "${WORKDIR}/build/"
	emake DESTDIR="${D}" install

	rm -r ${D}/usr/lib/include
	rm -r ${D}/usr/lib/lib

	# rocprim
	mkdir -p ${D}/usr/include/rocprim
	cd ${D}/usr/include/rocprim/
	ln -s -t . ../../lib/rocprim/include/rocprim/*.hpp

	mkdir -p ${D}/usr/include/rocprim/iterator
	cd ${D}/usr/include/rocprim/iterator/
	ln -s -t . ../../../lib/rocprim/include/rocprim/iterator/*.hpp

	mkdir -p ${D}/usr/include/rocprim/iterator/detail
	cd ${D}/usr/include/rocprim/iterator/detail/
	ln -s -t . ../../../../lib/rocprim/include/rocprim/iterator/*.hpp

	mkdir -p ${D}/usr/include/rocprim/warp
	cd ${D}/usr/include/rocprim/warp/
	ln -s -t . ../../../lib/rocprim/include/rocprim/warp/*.hpp

	mkdir -p ${D}/usr/include/rocprim/warp/detail
	cd ${D}/usr/include/rocprim/warp/detail/
	ln -s -t . ../../../../lib/rocprim/include/rocprim/warp/detail/*.hpp

	mkdir -p ${D}/usr/include/rocprim/detail
	cd ${D}/usr/include/rocprim/detail/
	ln -s -t . ../../../lib/rocprim/include/rocprim/detail/*.hpp

	mkdir -p ${D}/usr/include/rocprim/device
	cd ${D}/usr/include/rocprim/device/
	ln -s -t . ../../../lib/rocprim/include/rocprim/device/*.hpp

	mkdir -p ${D}/usr/include/rocprim/device/detail
	cd ${D}/usr/include/rocprim/device/detail/
	ln -s -t . ../../../../lib/rocprim/include/rocprim/device/detail/*.hpp

	mkdir -p ${D}/usr/include/rocprim/intrinsics
	cd ${D}/usr/include/rocprim/intrinsics/
	ln -s -t . ../../../lib/rocprim/include/rocprim/intrinsics/*.hpp

	mkdir -p ${D}/usr/include/rocprim/block
	cd ${D}/usr/include/rocprim/block/
	ln -s -t . ../../../lib/rocprim/include/rocprim/block/*.hpp

	mkdir -p ${D}/usr/include/rocprim/block/detail
	cd ${D}/usr/include/rocprim/block/detail/
	ln -s -t . ../../../../lib/rocprim/include/rocprim/block/detail/*.hpp

	mkdir -p ${D}/usr/include/rocprim/types
	cd ${D}/usr/include/rocprim/types/
	ln -s -t . ../../../lib/rocprim/include/rocprim/types/*.hpp

	# hibcub
	mkdir -p ${D}/usr/include/hipcub
	cd ${D}/usr/include/hipcub/
	ln -s -t . ../../lib/hipcub/include/hipcub/*.hpp

	mkdir -p ${D}/usr/include/hipcub/cub/
	cd ${D}/usr/include/hipcub/cub/
	ln -s -t . ../../../lib/hipcub/include/hipcub/cub/*.hpp

	mkdir -p ${D}/usr/include/hipcub/cub/device
	cd ${D}/usr/include/hipcub/cub/device/
	ln -s -t . ../../../../lib/hipcub/include/hipcub/cub/device/*.hpp

	mkdir -p ${D}/usr/include/hipcub/rocprim
	cd ${D}/usr/include/hipcub/rocprim/
	ln -s -t . ../../../lib/hipcub/include/hipcub/rocprim/*.hpp

	mkdir -p ${D}/usr/include/hipcub/rocprim/iterator
	cd ${D}/usr/include/hipcub/rocprim/iterator/
	ln -s -t . ../../../../lib/hipcub/include/hipcub/rocprim/iterator/*.hpp

	mkdir -p ${D}/usr/include/hipcub/rocprim/warp
	cd ${D}/usr/include/hipcub/rocprim/warp/
	ln -s -t . ../../../../lib/hipcub/include/hipcub/rocprim/warp/*.hpp

	mkdir -p ${D}/usr/include/hipcub/rocprim/device
	cd ${D}/usr/include/hipcub/rocprim/device/
	ln -s -t . ../../../../lib/hipcub/include/hipcub/rocprim/device/*.hpp

	mkdir -p ${D}/usr/include/hipcub/rocprim/thread
	cd ${D}/usr/include/hipcub/rocprim/thread/
	ln -s -t . ../../../../lib/hipcub/include/hipcub/rocprim/thread/*.hpp

	mkdir -p ${D}/usr/include/hipcub/rocprim/block
	cd ${D}/usr/include/hipcub/rocprim/block/
	ln -s -t . ../../../../lib/hipcub/include/hipcub/rocprim/block/*.hpp

        # create cmake symlink
        dosym "../rocprim/lib/cmake/rocprim" "/usr/lib/cmake/rocprim"
}


