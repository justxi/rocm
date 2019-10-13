Ebuilds to install ROCm on Gentoo Linux

-> https://github.com/RadeonOpenCompute/ROCm

**Please report all problems here first, if you tried ebuilds of this repository.**<br>
All ebuilds which are already exist in Gentoo portage will be removed from this repository.<br>
If you have a problem with an ebuild from Gentoo portage then submit a bugreport at https://bugs.gentoo.org/.

**The ebuilds for ROCm 2.8.0 are in a good state now.**<br>

**All 2.9.0 ebuilds in this repository are preliminary versions no fully tested.**

**All *9999 ebuilds in this repository, as expected, are in an experimental state!**<br>

**Thanks to all contributors.**

The following tables show all ebuilds tested (2019-10-13) in this repository. <br>
All other ebuilds can be out of date!

Kernel, driver, libraries, compiler and tools:

|Ebuild|Current Version|State| FHS | in Gentoo portage| 
|---|---|---|---|---|
|sys-kernel/rocm-sources| 2.9 | based on linux kernel 5.0.0-rc1 | (ok) |  |
|dev-util/rocm-cmake| 2.9 | | Yes | :heavy_check_mark:<br> 0.2, 2.7.0, 2.8.0, 2.9.0 |
|dev-libs/roct-thunk-interface| 2.9 |  | Yes | :heavy_check_mark:<br> 2.6.0, 2.7.0, 2.8.0, 2.9.0 |
|dev-libs/rocr-runtime| 2.9 | | Yes | :heavy_check_mark:<br> 2.6.0, 2.7.0, 2.8.0, 2.9.0 |
|dev-libs/rocm-device-libs | 2.9 | | Yes | :heavy_check_mark:<br> 2.6.0, 2.7.0, 2.8.0, 2.9.0 |
|dev-libs/rocm-opencl-driver | 2.9 | | Yes | :heavy_check_mark:<br> 2.6.0, 2.7.0, 2.8.0, 2.9.0 |
|dev-libs/rocm-opencl-runtime| 2.9 | "clinfo" reports suitable informations.<br> Simple "Hello World" program from "OpenCL Programming Guide" works. | Yes | :heavy_check_mark:<br> 2.6.0, 2.8.0, 2.9.0 |
|dev-libs/RCCL | 2.9 |  | (ok) | |
|media-libs/hsa-amd-aqlprofile| 1.0.0 | | (ok) | |
|media-libs/hsa-ext-rocr| 1.1.9.99 | | Yes | :heavy_check_mark:<br> V1.1.9.99 |
|dev-util/rocm-bandwidth-test| 2.9 | Reports suitable informations. | (ok) |  |
|dev-util/rocprofiler| 2.9 |  | (ok) | |
|dev-libs/rocm-smi-lib| 2.9 |  | (ok) | |
|dev-util/rocm-smi| 2.9 | Reports suitable informations. | (ok) | |
|dev-util/rocminfo| 2.9 | Reports suitable informations. | Yes | :heavy_check_mark:<br> 2.6.0, 2.7.0, 2.8.0, 2.9.0 |
|dev-libs/rocm-comgr| 2.9 | | Yes | :heavy_check_mark:<br> 2.6.0, 2.7.0, 2.8.0, 2.9.0 | 
|dev-libs/rocr-debug-agent | 2.9 |  | (ok) | |
|dev-util/roctracer| 2.9 | | (ok) | |
|dev-util/rocm-clang-ocl| 2.9 | | (ok) | |
|dev-util/rcp| 5.6 |   | (ok) | |
|sys-devel/llvm-roc | 2.9 | | Yes |:heavy_check_mark:<br> 2.6.0, 2.7.0, 2.8.0, 2.9.0 | |
|sys-devel/hcc| 2.9 |  | (ok) | |
|sys-devel/hip| 2.9 | currently depends on HCC, building based on clang (HIP-clang) is currently under test | (ok) | |
|sys-devel/amd-rocm-meta| 2.9 | | (ok) | |

<br>
ROCm Libraries:

|Ebuild|Current Version|State|FHS|in Gentoo portage|
|---|---|---|---|---|
|sci-libs/rocBLAS| 2.9 | Installs, not tested yet. | (ok) | |
|sci-libs/rocPRIM| 2.9 | Installs, not tested yet. | (ok) | |
|sci-libs/rocSPARSE| 2.9 | Installs, not tested yet.  | (ok) | |
|sci-libs/rocALUTION| 2.9 | Installs, not tested yet. | (ok) | |
|sci-libs/rocThrust| 2.9 | Installs, not tested yet. | (ok) | |
|sci-libs/rocFFT| 2.9 | Installs, not tested yet | (ok) | |
|sci-libs/rocRAND| 2.9 | Installs, not tested yet | (ok) |  |
|sci-libs/rocSOLVER| 9999 | Installs, not tested yet | (ok) | |
|sci-libs/hipCub | 2.9 | Installs, not tested yet. | (ok)| |
|sci-libs/hipBLAS | 2.9 | Installs, not tested yet. | (ok) | |
|sci-libs/hipSPARSE | 2.9 | Installs, not tested yet. | (ok) | |
|sci-libs/MIOpenGEMM | 1.1.6 | Installs, not tested yet. | (ok) | |
|sci-libs/MIOpen | 2.9 | Installs, not tested yet. | (ok) | |
|sci-libs/MIVisionX | | No ebuild exist, any contribution is appreciated. | | |
|sci-libs/MIGraphX | | No ebuild exist, any contribution is appreciated. | | | 

<br>
Systems known to work:

| No | CPU | PCIe |  GPU | additional information |
|---|---|---|---|---|
| 1 | Intel Core i5 8400 | PCIe 3.0 | Radeon RX 560 (POLARIS11) | |
| 2 | Intel Core i7 6700k | PCIe 3.0 over Thunderbolt 3 | Radeon VII | |
| 3 | AMD Ryzen 1700 | PCIe 3.0 | Radeon RX 580 | |
