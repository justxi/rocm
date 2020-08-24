Ebuilds to install ROCm on Gentoo Linux

-> https://github.com/RadeonOpenCompute/ROCm

**Please report all problems here first, if you tried ebuilds of this repository.**<br>
All ebuilds which are already exist in Gentoo portage will be removed from this repository.<br>
If you have a problem with an ebuild from Gentoo portage then submit a bugreport at https://bugs.gentoo.org/.

**The ebuilds for ROCm 3.3.0 are in a good state.**<br>

**Support for ROCm 3.7.0 is work in progress.**<br>

**Thanks to all contributors.**

The following tables show all ebuilds tested (2020-08-22) in this repository. <br>
All other ebuilds can be out of date!

Kernel, driver, libraries, compiler and tools:

|Ebuild|Current Version|State| FHS | in Gentoo portage| 
|---|---|---|---|---|
|sys-kernel/rocm-sources| 3.7.0 | based on linux kernel 5.6.0 | (ok) |  |
|dev-util/rocm-cmake| 3.7.0 | | Yes | :heavy_check_mark:<br> 0.2, 2.7.0, 2.8.0, 2.9.0, 2.10.0, 3.0.0, 3.3.0, 3.5.0, 3.7.0 |
|dev-libs/roct-thunk-interface| 3.7.0 |  | Yes | :heavy_check_mark:<br> 3.0.0, 3.1.0, 3.3.0, 3.5.0, 3.6.0, 3.7.0  |
|sys-devel/llvm-roc | 3.7.0 | | Yes |:heavy_check_mark:<br> 2.6.0, 2.7.0, 2.8.0, 2.9.0, 2.10.0, 3.0.0, 3.1.0, 3.3.0, 3.5.0, 3.5.1, 3.7.0 | |
|dev-libs/rocm-device-libs | 3.7.0 | | Yes | :heavy_check_mark:<br> 3.0.0, 3.1.0, 3.3.0, 3.5.0, 3.5.1, 3.7.0 |
|media-libs/hsa-ext-rocr| 1.1.30500.0 | | Yes | :heavy_check_mark:<br> 1.1.30500.0 |
|media-libs/hsa-amd-aqlprofile| 1.0.0 | | (ok) | |
|dev-libs/rocr-runtime| 3.7.0 | | Yes | :heavy_check_mark:<br> 3.0.0, 3.1.0, 3.3.0, 3.5.0, 3.7.0 |
|dev-util/rocminfo | 3.7.0 |  | Yes | :heavy_check_mark:<br> 2.6.0, 2.7.0, 2.8.0, 2.9.0, 2.10.0, 3.0.0, 3.1.0, 3.3.0, 3.5.0, 3.7.0 |
|dev-util/rocm-bandwidth-test| 3.7.0 | Reports suitable informations. | (ok) |  |
|dev-libs/rocm-smi-lib| 3.7.0 |  | (ok) | |
|dev-util/rocm-smi| 3.7.0 | Reports suitable informations. | (ok) | |
|dev-libs/rocm-comgr | 3.7.0 | | Yes | :heavy_check_mark:<br> 3.0.0, 3.1.0, 3.3.0, 3.5.0, 3.7.0 |
|dev-libs/amd-dbgapi | 3.7.0 |  | (ok) | |
|dev-libs/rocclr | 3.7.0 | | Yes | :heavy_check_mark:<br> 3.5.0, 3.7.0 |
|dev-libs/rocm-opencl-runtime| 3.7.0 |  | Yes | :heavy_check_mark:<br> 3.0.0, 3.1.0, 3.3.0, 3.5.0, 3.7.0 |
|dev-util/rocm-clang-ocl| 3.7.0 | | (ok) | |
|sys-devel/hip| 3.7.0 |  | (ok) | |
|dev-libs/rocm-debug-agent | 3.7.0 | formerly dev-libs/rocr-debug-agent  | (ok) | |
|dev-util/roctracer| 3.7.0 |  | (ok) | |
|dev-util/rocprofiler| 3.7.0 |  | (ok) | |
|dev-util/rcp| 5.6 |   | (ok) | |
|dev-libs/RCCL | 3.7.0 |  | (ok) | |
|dev-util/Tensile | 3.7.0 | | (ok) | |
|sys-devel/amd-rocm-meta| 3.7.0 | Currently only updated packages (3.7.0) could be installed. | (ok) | |

<br>
ROCm Libraries:

|Ebuild|Current Version|State|FHS|in Gentoo portage|
|---|---|---|---|---|
|sci-libs/rocPRIM| 3.7.0 |  | (ok) | |
|sci-libs/rocRAND| 3.5.0 |  | (ok) |  |
|sci-libs/rocFFT| 3.5.0 |  | (ok) | |
|sci-libs/rocSPARSE| 3.5.0 |  | (ok) | |
|sci-libs/rocBLAS| 3.5.0 | builds without tensile | (ok) | |
|sci-libs/rocSOLVER| 3.3.0 |  | (ok) | |
|sci-libs/rocALUTION| 3.3.0 | | (ok) | |
|sci-libs/rocThrust| 3.5.0 |  | (ok) | |
|sci-libs/hipCUB | 3.5.0 |  | (ok)| |
|sci-libs/hipBLAS | 3.3.0 |  | (ok) | |
|sci-libs/hipSPARSE | 3.5.0 |  | (ok) | |
|sci-libs/MIOpenGEMM | 1.1.6 |  | (ok) | |
|sci-libs/MIOpen | 3.3.0 |  | (ok) | |
|sci-libs/MIVisionX | | No ebuild exist, any contribution is appreciated. | | |
|sci-libs/AMDMIGraphX | | No ebuild exist, any contribution is appreciated. | | | 

<br>
Systems known to work:

| No | CPU | PCIe |  GPU | additional information |
|---|---|---|---|---|
| 1 | Intel Core i5 8400 | PCIe 3.0 | Radeon RX 560 (POLARIS11) | |
| 2 | Intel Core i7 6700k | PCIe 3.0 over Thunderbolt 3 | Radeon VII | |
| 3 | AMD Ryzen 1700 | PCIe 3.0 | Radeon RX 580 | |

<br>
=== For tensorflow-rocm ===

``` emerge miopen rocFFT rocRAND rocBLAS rccl rocm-smi rocminfo ```

=== AMDGPU wiki page ===

https://wiki.gentoo.org/wiki/AMDGPU#SME
https://wiki.gentoo.org/wiki/AMDGPU#Kernel

=== udev rule for ROCm ===

This is so ROCm utilities and libraries can function correctly.

``` echo 'SUBSYSTEM=="kfd", KERNEL=="kfd", TAG+="uaccess", GROUP="video"' | sudo tee /etc/udev/rules.d/70-kfd.rules ```

You probably also want to add a video group if you don't already have one and add yourself to it.

Add a video group:
``` emerge acct-group/video ```

Add your user account to the group:
``` sudo usermod -a -G video $LOGNAME ```

=== ROCm debugging tools ===

In no particular order some helpful utilities for testing ROCm are:

Note: clinfo might not work with a noexec /tmp

``` rocminfo && rocm-smi && hipconfig && clinfo && MIOpenDriver pool ```
