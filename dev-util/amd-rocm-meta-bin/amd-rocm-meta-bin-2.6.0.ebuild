# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

DESCRIPTION="AMD ROCm"
HOMEPAGE="https://github.com/RadeonOpenCompute/"
SRC_URI="
http://repo.radeon.com/rocm/yum/2.6/atmi-0.3.7-51-gb4f479d-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/comgr-1.3.0-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/cxlactivitylogger-5.6.7259-gf50cd35.x86_64.rpm
http://repo.radeon.com/rocm/yum/2.6/half-1.12.0-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/hcc-1.3.19242-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/hip_base-1.5.19255.rpm
http://repo.radeon.com/rocm/yum/2.6/hipblas-0.12.6.0-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/hipcub-2.6.0.0-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/hip_doc-1.5.19255.rpm
http://repo.radeon.com/rocm/yum/2.6/hip_hcc-1.5.19255.rpm
http://repo.radeon.com/rocm/yum/2.6/hip_samples-1.5.19255.rpm
http://repo.radeon.com/rocm/yum/2.6/hipsparse-1.0.8.0-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/hip-thrust-1.8.2-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/hsa-amd-aqlprofile-1.0.0-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/hsa-ext-rocr-dev-1.1.9-87-g1566fdd4-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/hsakmt-roct-1.0.9-171-g4be439e-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/hsakmt-roct-dev-1.0.9-171-g4be439e-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/hsa-rocr-dev-1.1.9-87-g1566fdd4-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/MIGraphX-0.3.0-15eb1987-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/miopengemm-1.1.5-9547fb9-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/MIOpen-HIP-2.0.0-7a8f7878-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/MIOpen-OpenCL-2.0.0-7a8f7878-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/mivisionx-1.3.0-1.x86_64.rpm
http://repo.radeon.com/rocm/yum/2.6/rccl-2.6.0.0-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/rocalution-1.4.5.0-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/rocblas-2.2.11.0-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/rocfft-0.9.4.0-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/rocm_bandwidth_test-1.0.0-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/rocm-clang-ocl-0.4.0-7ce124f-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/rocm-cmake-0.2.0-91316f9-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/rocm-device-libs-0.0.1-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/rocminfo-1.0.0-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/rocm-opencl-1.2.0-2019070400.x86_64.rpm
http://repo.radeon.com/rocm/yum/2.6/rocm-opencl-devel-1.2.0-2019070400.x86_64.rpm
http://repo.radeon.com/rocm/yum/2.6/rocm-profiler-5.6.7262-g93fb592.x86_64.rpm
http://repo.radeon.com/rocm/yum/2.6/rocm-smi-1.0.0_157_g8d290c1-1.x86_64.rpm
http://repo.radeon.com/rocm/yum/2.6/rocm_smi_lib64-1.9.0.rpm
http://repo.radeon.com/rocm/yum/2.6/rocprim-2.6.0.0-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/rocprofiler-dev-1.0.0-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/rocrand-2.6.0-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/rocr_debug_agent-1.0.0-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/rocsparse-1.1.6.0-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/rocthrust-2.6.0.0-Linux.rpm
http://repo.radeon.com/rocm/yum/2.6/roctracer-dev-1.0.0-Linux.rpm
"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
S="${WORKDIR}"

RDEPEND="!dev-libs/rocr-runtime"

PATCHES=(
        "${FILESDIR}/fix-python.patch"
)

src_install() {
	dodir /opt
	cp -ar opt/* "${D}"/opt/ || die

	echo "HSA_PATH=/opt/rocm" > 99rocm || die
	echo "ROCM_PATH=/opt/rocm" >> 99rocm || die
	echo "ROCM_AGENT_ENUM=/opt/rocm/bin/rocm_agent_enumerator" >> 99rocm || die
	echo "HCC_HOME=/opt/rocm/hcc" >> 99rocm || die
	echo "HIP_PATH=/opt/rocm/hip" >> 99rocm || die
	echo "HIP_PLATFORM=hcc" >> 99rocm || die
	echo "LDPATH=/opt/rocm/lib:/opt/rocm/lib64:/opt/rocm/hcc/lib:/opt/rocm/hip/lib:/opt/rocm/hsa/lib:/opt/rocm/opencl/lib/x86_64:/opt/rocm/rocrand/lib" >> 99rocm || die
	echo "PATH=/opt/rocm/bin:/opt/rocm/hcc/bin:/opt/rocm/hip/bin" >> 99rocm || die
	echo "ROOTPATH=/opt/rocm/bin:/opt/rocm/hcc/bin:/opt/rocm/hip/bin" >> 99rocm || die
	doenvd 99rocm
}
