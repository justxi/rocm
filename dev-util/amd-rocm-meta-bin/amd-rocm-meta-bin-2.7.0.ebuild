# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

DESCRIPTION="AMD ROCm"
HOMEPAGE="https://github.com/RadeonOpenCompute/"
SRC_URI="
http://repo.radeon.com/rocm/yum/2.7/atmi-0.0.1--Linux.rpm -> ${PN}-${PV}-1.rpm
http://repo.radeon.com/rocm/yum/2.7/comgr-1.3.0-Linux.rpm -> ${PN}-${PV}-2.rpm
http://repo.radeon.com/rocm/yum/2.7/cxlactivitylogger-5.6.7259-gf50cd35.x86_64.rpm -> ${PN}-${PV}-3.rpm
http://repo.radeon.com/rocm/yum/2.7/half-1.12.0-Linux.rpm -> ${PN}-${PV}-4.rpm
http://repo.radeon.com/rocm/yum/2.7/hcc-2.7.19315-Linux.rpm -> ${PN}-${PV}-5.rpm
http://repo.radeon.com/rocm/yum/2.7/hip_base-1.5.19284.rpm -> ${PN}-${PV}-6.rpm
http://repo.radeon.com/rocm/yum/2.7/hipblas-0.12.6.202-rocm-rel-2.7-22-fd28d87-Linux.rpm -> ${PN}-${PV}-7.rpm
http://repo.radeon.com/rocm/yum/2.7/hipcub-2.6.0.71-rocm-rel-2.7-22-5f73bda-Linux.rpm -> ${PN}-${PV}-8.rpm
http://repo.radeon.com/rocm/yum/2.7/hip_doc-1.5.19284.rpm -> ${PN}-${PV}-9.rpm
http://repo.radeon.com/rocm/yum/2.7/hip_hcc-1.5.19284.rpm -> ${PN}-${PV}-10.rpm
http://repo.radeon.com/rocm/yum/2.7/hip_samples-1.5.19284.rpm -> ${PN}-${PV}-11.rpm
http://repo.radeon.com/rocm/yum/2.7/hipsparse-1.0.9.168-rocm-rel-2.7-22-5fea400-Linux.rpm -> ${PN}-${PV}-12.rpm
http://repo.radeon.com/rocm/yum/2.7/hsa-amd-aqlprofile-1.0.0-Linux.rpm -> ${PN}-${PV}-13.rpm
http://repo.radeon.com/rocm/yum/2.7/hsa-ext-rocr-dev-1.1.9-99-g835b876a-Linux.rpm -> ${PN}-${PV}-14.rpm
http://repo.radeon.com/rocm/yum/2.7/hsakmt-roct-1.0.9-194-gbcfdf35-Linux.rpm -> ${PN}-${PV}-15.rpm
http://repo.radeon.com/rocm/yum/2.7/hsakmt-roct-dev-1.0.9-194-gbcfdf35-Linux.rpm -> ${PN}-${PV}-16.rpm
http://repo.radeon.com/rocm/yum/2.7/hsa-rocr-dev-1.1.9-99-g835b876a-Linux.rpm -> ${PN}-${PV}-17.rpm
http://repo.radeon.com/rocm/yum/2.7/MIGraphX-0.3.0.2663-rocm-rel-2.7-22-15eb1987-Linux.rpm -> ${PN}-${PV}-18.rpm
http://repo.radeon.com/rocm/yum/2.7/miopengemm-1.1.6.645-rocm-rel-2.7-22-6275a87-Linux.rpm -> ${PN}-${PV}-19.rpm
http://repo.radeon.com/rocm/yum/2.7/MIOpen-HIP-2.0.1.7405-rocm-rel-2.7-22-4e39a83a-Linux.rpm -> ${PN}-${PV}-20.rpm
http://repo.radeon.com/rocm/yum/2.7/MIOpen-OpenCL-2.0.1.7405-rocm-rel-2.7-22-4e39a83a-Linux.rpm -> ${PN}-${PV}-21.rpm
http://repo.radeon.com/rocm/yum/2.7/mivisionx-1.3.0-1.x86_64.rpm -> ${PN}-${PV}-22.rpm
http://repo.radeon.com/rocm/yum/2.7/rccl-2.6.0.182-rocm-rel-2.7-22-1fee6f9-Linux.rpm -> ${PN}-${PV}-23.rpm
http://repo.radeon.com/rocm/yum/2.7/rocalution-1.4.6.419-rocm-rel-2.7-22-5355a65-Linux.rpm -> ${PN}-${PV}-24.rpm
http://repo.radeon.com/rocm/yum/2.7/rocblas-2.4.0.1471-rocm-rel-2.7-22-1ac2271-Linux.rpm -> ${PN}-${PV}-25.rpm
http://repo.radeon.com/rocm/yum/2.7/rocfft-0.9.5.697-rocm-rel-2.7-22-ed7760e-Linux.rpm -> ${PN}-${PV}-26.rpm
http://repo.radeon.com/rocm/yum/2.7/rock-dkms-2.7-22.el7.noarch.rpm -> ${PN}-${PV}-27.rpm
http://repo.radeon.com/rocm/yum/2.7/rocm_bandwidth_test-1.0.0-Linux.rpm -> ${PN}-${PV}-28.rpm
http://repo.radeon.com/rocm/yum/2.7/rocm-clang-ocl-0.4.0.35-rocm-rel-2.7-22-7ce124f-Linux.rpm -> ${PN}-${PV}-29.rpm
http://repo.radeon.com/rocm/yum/2.7/rocm-cmake-0.3.0.93-rocm-rel-2.7-22-b727cef-Linux.rpm -> ${PN}-${PV}-30.rpm
http://repo.radeon.com/rocm/yum/2.7/rocm-device-libs-0.0.1-Linux.rpm -> ${PN}-${PV}-31.rpm
http://repo.radeon.com/rocm/yum/2.7/rocminfo-1.0.0-Linux.rpm -> ${PN}-${PV}-32.rpm
http://repo.radeon.com/rocm/yum/2.7/rocm-opencl-1.2.0-2019080925.x86_64.rpm -> ${PN}-${PV}-33.rpm
http://repo.radeon.com/rocm/yum/2.7/rocm-opencl-devel-1.2.0-2019080925.x86_64.rpm -> ${PN}-${PV}-34.rpm
http://repo.radeon.com/rocm/yum/2.7/rocm-profiler-5.6.7262-g93fb592.x86_64.rpm -> ${PN}-${PV}-35.rpm
http://repo.radeon.com/rocm/yum/2.7/rocm-smi-1.0.0_167_ge14d23e-1.x86_64.rpm -> ${PN}-${PV}-36.rpm
http://repo.radeon.com/rocm/yum/2.7/rocm_smi_lib64-2.5.0.rpm -> ${PN}-${PV}-37.rpm
http://repo.radeon.com/rocm/yum/2.7/rocprim-2.6.0.922-rocm-rel-2.7-22-3e55501-Linux.rpm -> ${PN}-${PV}-38.rpm
http://repo.radeon.com/rocm/yum/2.7/rocprofiler-dev-1.0.0-Linux.rpm -> ${PN}-${PV}-39.rpm
http://repo.radeon.com/rocm/yum/2.7/rocrand-2.7.0.641-rocm-rel-2.7-22-dd953aa-Linux.rpm -> ${PN}-${PV}-40.rpm
http://repo.radeon.com/rocm/yum/2.7/rocr_debug_agent-1.0.0-Linux.rpm -> ${PN}-${PV}-41.rpm
http://repo.radeon.com/rocm/yum/2.7/rocsparse-1.1.10.573-rocm-rel-2.7-22-dc7baef-Linux.rpm -> ${PN}-${PV}-42.rpm
http://repo.radeon.com/rocm/yum/2.7/rocthrust-2.6.0.398-rocm-rel-2.7-22-ff6992a-Linux.rpm -> ${PN}-${PV}-43.rpm
http://repo.radeon.com/rocm/yum/2.7/roctracer-dev-1.0.0-Linux.rpm -> ${PN}-${PV}-44.rpm
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
