# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit rpm

DESCRIPTION="AMD ROCm"
HOMEPAGE="https://github.com/RadeonOpenCompute/"
SRC_URI="
http://repo.radeon.com/rocm/yum/2.8.0/atmi-0.7.1-0.7.1-553-gf785be6-Linux.rpm -> ${PN}-${PV}-1.rpm
http://repo.radeon.com/rocm/yum/2.10.0/comgr-1.6.0.104-rocm-rel-2.10-14-7c581b4-Linux.rpm -> ${PN}-${PV}-2.rpm
http://repo.radeon.com/rocm/yum/2.10.0/cxlactivitylogger-5.6.7259-gf50cd35.x86_64.rpm -> ${PN}-${PV}-3.rpm
http://repo.radeon.com/rocm/yum/2.10.0/half-1.12.0-Linux.rpm -> ${PN}-${PV}-4.rpm
http://repo.radeon.com/rocm/yum/2.10.0/hcc-2.10.19446-Linux.rpm -> ${PN}-${PV}-5.rpm
http://repo.radeon.com/rocm/yum/2.10.0/hip_base-2.10.19455.4184-rocm-rel-2.10-14-48a7ae6a.x86_64.rpm -> ${PN}-${PV}-6.rpm
http://repo.radeon.com/rocm/yum/2.10.0/hipblas-0.16.2.227-rocm-rel-2.10-14-140ff2c-el7.x86_64.rpm -> ${PN}-${PV}-7.rpm
http://repo.radeon.com/rocm/yum/2.10.0/hipcub-2.9.0.83-rocm-rel-2.10-14-5a9f2b1-el7.x86_64.rpm -> ${PN}-${PV}-8.rpm
http://repo.radeon.com/rocm/yum/2.10.0/hip_doc-2.10.19455.4184-rocm-rel-2.10-14-48a7ae6a.x86_64.rpm -> ${PN}-${PV}-9.rpm
http://repo.radeon.com/rocm/yum/2.10.0/hip_hcc-2.10.19455.4184-rocm-rel-2.10-14-48a7ae6a.x86_64.rpm -> ${PN}-${PV}-10.rpm
http://repo.radeon.com/rocm/yum/2.10.0/hip_samples-2.10.19455.4184-rocm-rel-2.10-14-48a7ae6a.x86_64.rpm -> ${PN}-${PV}-11.rpm
http://repo.radeon.com/rocm/yum/2.10.0/hipsparse-1.3.2.204-rocm-rel-2.10-14-31002c8-el7.x86_64.rpm -> ${PN}-${PV}-12.rpm
http://repo.radeon.com/rocm/yum/2.10.0/hsa-amd-aqlprofile-1.0.0-Linux.rpm -> ${PN}-${PV}-13.rpm
http://repo.radeon.com/rocm/yum/2.10.0/hsa-ext-rocr-dev-1.1.9-139-g0d1ca36b-Linux.rpm -> ${PN}-${PV}-14.rpm
http://repo.radeon.com/rocm/yum/2.10.0/hsakmt-roct-1.0.9-245-gc0e4b8d-Linux.rpm -> ${PN}-${PV}-15.rpm
http://repo.radeon.com/rocm/yum/2.10.0/hsakmt-roct-dev-1.0.9-245-gc0e4b8d-Linux.rpm -> ${PN}-${PV}-16.rpm
http://repo.radeon.com/rocm/yum/2.10.0/hsa-rocr-dev-1.1.9-139-g0d1ca36b-Linux.rpm -> ${PN}-${PV}-17.rpm
http://repo.radeon.com/rocm/yum/2.10.0/MIGraphX-0.4.0.3706-rocm-rel-2.10-14-51bd00b3-el7.x86_64.rpm -> ${PN}-${PV}-18.rpm
http://repo.radeon.com/rocm/yum/2.10.0/miopengemm-1.1.6.645-rocm-rel-2.10-14-6275a87-el7.x86_64.rpm -> ${PN}-${PV}-19.rpm
http://repo.radeon.com/rocm/yum/2.10.0/MIOpen-HIP-2.1.0.7487-rocm-rel-2.10-14-a5a4129f-el7.x86_64.rpm -> ${PN}-${PV}-20.rpm
http://repo.radeon.com/rocm/yum/2.10.0/MIOpen-OpenCL-2.1.0.7487-rocm-rel-2.10-14-a5a4129f-el7.x86_64.rpm -> ${PN}-${PV}-21.rpm
http://repo.radeon.com/rocm/yum/2.10.0/mivisionx-1.5.0-1.x86_64.rpm -> ${PN}-${PV}-22.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rccl-2.7.0.500-rocm-rel-2.10-14-fec743b-el7.x86_64.rpm -> ${PN}-${PV}-23.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocalution-1.6.2.452-rocm-rel-2.10-14-b40dcb7-el7.x86_64.rpm -> ${PN}-${PV}-24.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocblas-2.10.0.1633-rocm-rel-2.10-14-a417317-el7.x86_64.rpm -> ${PN}-${PV}-25.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocfft-0.9.8.744-rocm-rel-2.10-14-c03da03-el7.x86_64.rpm -> ${PN}-${PV}-26.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rock-dkms-2.10-14.el7.noarch.rpm -> ${PN}-${PV}-27.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocm_bandwidth_test-1.4.0.5-rocm-rel-2.10-14-gd1ac47c-Linux.rpm -> ${PN}-${PV}-28.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocm-clang-ocl-0.4.0.35-rocm-rel-2.10-14-7ce124f-el7.x86_64.rpm -> ${PN}-${PV}-29.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocm-cmake-0.3.0.125-rocm-rel-2.10-14-56c4221-el7.x86_64.rpm -> ${PN}-${PV}-30.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocm-device-libs-1.0.0.552-rocm-rel-2.10-14-1d2127c-Linux.rpm -> ${PN}-${PV}-31.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocminfo-1.0.0.0.rocm-rel-2.10-14-f1181e0.rpm -> ${PN}-${PV}-32.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocm-opencl-1.2.0-rocm-rel-2.10-14-31325c483-Linux.rpm -> ${PN}-${PV}-33.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocm-opencl-devel-1.2.0-rocm-rel-2.10-14-31325c483-Linux.rpm -> ${PN}-${PV}-34.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocm-profiler-5.6.7262-g93fb592.x86_64.rpm -> ${PN}-${PV}-35.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocm-smi-1.0.0_180_rocm_rel_2.10_14_gc49b55d-1.x86_64.rpm -> ${PN}-${PV}-36.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocm_smi_lib64-2.0.0.1.rocm-rel-2.10-14-68d25e8.rpm -> ${PN}-${PV}-37.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocprim-2.9.0.946-rocm-rel-2.10-14-22d413d-el7.x86_64.rpm -> ${PN}-${PV}-38.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocprofiler-dev-1.0.0-Linux.rpm -> ${PN}-${PV}-39.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocrand-2.10.0.653-rocm-rel-2.10-14-9d7cebf-Linux.rpm -> ${PN}-${PV}-40.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocr_debug_agent-1.0.0-Linux.rpm -> ${PN}-${PV}-41.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocsparse-1.4.3.644-rocm-rel-2.10-14-216216a-el7.x86_64.rpm -> ${PN}-${PV}-42.rpm
http://repo.radeon.com/rocm/yum/2.10.0/rocthrust-2.9.0.410-rocm-rel-2.10-14-c986b97-el7.x86_64.rpm -> ${PN}-${PV}-43.rpm
http://repo.radeon.com/rocm/yum/2.10.0/roctracer-dev-1.0.0-Linux.rpm -> ${PN}-${PV}-44.rpm
"

LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
S="${WORKDIR}"

RDEPEND="!dev-libs/rocr-runtime"

PATCHES=(
        "${FILESDIR}/fix-python.patch"
)

src_prepare() {
	default
}

src_install() {
	dodir /opt
	cp -ar opt/* "${D}"/opt/ || die

	insinto /etc/OpenCL/vendors
	doins "${FILESDIR}/amdocl64.icd"

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
