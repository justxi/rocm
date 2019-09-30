# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

DESCRIPTION="AMD ROCm"
HOMEPAGE="https://github.com/RadeonOpenCompute/"
SRC_URI="
http://repo.radeon.com/rocm/yum/2.7.2/atmi-0.3.7-51-gb4f479d-Linux.rpm -> ${P}-1.rpm
http://repo.radeon.com/rocm/yum/2.7.2/comgr-1.3.0-Linux.rpm -> ${P}-2.rpm
http://repo.radeon.com/rocm/yum/2.7.2/cxlactivitylogger-5.6.7259-gf50cd35.x86_64.rpm -> ${P}-3.rpm
http://repo.radeon.com/rocm/yum/2.7.2/half-1.12.0-Linux.rpm -> ${P}-4.rpm
http://repo.radeon.com/rocm/yum/2.7.2/hcc-2.7.19342-Linux.rpm -> ${P}-5.rpm
http://repo.radeon.com/rocm/yum/2.7.2/hip_base-1.5.19342.rpm -> ${P}-6.rpm
http://repo.radeon.com/rocm/yum/2.7.2/hipblas-0.12.6.202-rocm-rel-2.7-27-fd28d87-Linux.rpm -> ${P}-7.rpm
http://repo.radeon.com/rocm/yum/2.7.2/hipcub-2.6.0.71-rocm-rel-2.7-27-5f73bda-Linux.rpm -> ${P}-8.rpm
http://repo.radeon.com/rocm/yum/2.7.2/hip_doc-1.5.19342.rpm -> ${P}-9.rpm
http://repo.radeon.com/rocm/yum/2.7.2/hip_hcc-1.5.19342.rpm -> ${P}-10.rpm
http://repo.radeon.com/rocm/yum/2.7.2/hip_nvcc-1.5.19342.rpm -> ${P}-11.rpm
http://repo.radeon.com/rocm/yum/2.7.2/hipsparse-1.0.9.168-rocm-rel-2.7-27-5fea400-Linux.rpm -> ${P}-12.rpm
http://repo.radeon.com/rocm/yum/2.7.2/hsa-amd-aqlprofile-1.0.0-Linux.rpm -> ${P}-13.rpm
http://repo.radeon.com/rocm/yum/2.7.2/hsa-ext-rocr-dev-1.1.9-99-g835b876a-Linux.rpm -> ${P}-14.rpm
http://repo.radeon.com/rocm/yum/2.7.2/hsakmt-roct-1.0.9-194-gbcfdf35-Linux.rpm -> ${P}-15.rpm
http://repo.radeon.com/rocm/yum/2.7.2/hsakmt-roct-dev-1.0.9-194-gbcfdf35-Linux.rpm -> ${P}-16.rpm
http://repo.radeon.com/rocm/yum/2.7.2/hsa-rocr-dev-1.1.9-99-g835b876a-Linux.rpm -> ${P}-17.rpm
http://repo.radeon.com/rocm/yum/2.7.2/MIGraphX-0.3.0.2663-rocm-rel-2.7-27-15eb1987-Linux.rpm -> ${P}-18.rpm
http://repo.radeon.com/rocm/yum/2.7.2/miopengemm-1.1.6.645-rocm-rel-2.7-27-6275a87-Linux.rpm -> ${P}-19.rpm
http://repo.radeon.com/rocm/yum/2.7.2/MIOpen-HIP-2.0.1.7405-rocm-rel-2.7-27-4e39a83a-Linux.rpm -> ${P}-20.rpm
http://repo.radeon.com/rocm/yum/2.7.2/MIOpen-OpenCL-2.0.1.7405-rocm-rel-2.7-27-4e39a83a-Linux.rpm -> ${P}-21.rpm
http://repo.radeon.com/rocm/yum/2.7.2/mivisionx-1.3.0-1.x86_64.rpm -> ${P}-22.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rccl-2.6.0.182-rocm-rel-2.7-27-1fee6f9-Linux.rpm -> ${P}-23.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocalution-1.4.6.419-rocm-rel-2.7-27-5355a65-Linux.rpm -> ${P}-24.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocblas-2.4.0.1471-rocm-rel-2.7-27-1ac2271-Linux.rpm -> ${P}-25.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocfft-0.9.5.697-rocm-rel-2.7-27-ed7760e-Linux.rpm -> ${P}-26.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rock-dkms-2.7-27.el7.noarch.rpm -> ${P}-27.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocm_bandwidth_test-1.0.0-Linux.rpm -> ${P}-28.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocm-clang-ocl-0.4.0.35-rocm-rel-2.7-27-7ce124f-Linux.rpm -> ${P}-29.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocm-cmake-0.3.0.93-rocm-rel-2.7-27-b727cef-Linux.rpm -> ${P}-30.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocm-device-libs-0.0.1-Linux.rpm -> ${P}-31.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocminfo-1.0.0-Linux.rpm -> ${P}-32.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocm-opencl-1.2.0-2019082856.x86_64.rpm -> ${P}-33.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocm-opencl-devel-1.2.0-2019082856.x86_64.rpm -> ${P}-34.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocm-profiler-5.6.7262-g93fb592.x86_64.rpm -> ${P}-35.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocm-smi-1.0.0_167_ge14d23e-1.x86_64.rpm -> ${P}-36.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocm_smi_lib64-2.5.0.rpm -> ${P}-37.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocprim-2.6.1.925-rocm-rel-2.7-27-2c4a1f7-Linux.rpm -> ${P}-38.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocprofiler-dev-1.0.0-Linux.rpm -> ${P}-39.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocrand-2.7.0.641-rocm-rel-2.7-27-dd953aa-Linux.rpm -> ${P}-40.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocr_debug_agent-1.0.0-Linux.rpm -> ${P}-41.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocsparse-1.1.10.573-rocm-rel-2.7-27-dc7baef-Linux.rpm -> ${P}-42.rpm
http://repo.radeon.com/rocm/yum/2.7.2/rocthrust-2.6.0.398-rocm-rel-2.7-27-ff6992a-Linux.rpm -> ${P}-43.rpm
http://repo.radeon.com/rocm/yum/2.7.2/roctracer-dev-1.0.0-Linux.rpm -> ${P}-44.rpm
http://repo.radeon.com/rocm/yum/2.7.2/hip_samples-1.5.19342.rpm -> ${P}-45.rpm
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
