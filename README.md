Ebuilds to install ROCm on Gentoo Linux

-> https://github.com/RadeonOpenCompute/ROCm

**Please report all problems here first, if you tried ebuilds of this repository.**<br>
All ebuilds which are already exist in Gentoo portage will be removed from this repository.<br>
If you have a problem with an ebuild from Gentoo portage then submit a bugreport at https://bugs.gentoo.org/.

**The ebuilds for ROCm 4.0.0 are in a good state.**<br>
All ebuilds which depend on HIP are updated to depend on "dev-util/hip" in Gentoo portage.<br>
Their are some more ebuilds which are in portage now and will be removed soon.

**Ebuilds for ROCm 4.3.0 are work in progress... <br>Feel free to open an issue to report problems, bugs or simply your experience.**<br>

**Thanks to all contributors.**

The following tables show all ebuilds tested (2021-09-05) in this repository. <br>
All other ebuilds can be out of date!

Kernel, driver, libraries, compiler and tools:

|Ebuild|Current Version|State| FHS | in Gentoo portage| other overlay | 
|---|---|---|---|---|---|
|sys-kernel/rocm-sources| 4.3.0 | based on linux kernel 5.11.0 | (ok) |  |   |
|dev-util/rocm-cmake| 4.3.0 | | Yes | :heavy_check_mark:<br> 3.8.0, 3.9.0, 3.10.0, 4.0.0, 4.1.0, 4.2.0, 4.3.0 |  |
|dev-libs/roct-thunk-interface| 4.3.0 |  | Yes | :heavy_check_mark:<br> 4.0.0, 4.1.0, 4.2.0, 4.3.0  |  |
|sys-devel/llvm-roc | 4.3.0 | | Yes |:heavy_check_mark:<br> 3.7.0, 3.8.0, 3.9.0, 3.10.0, 4.0.0, 4.1.0, 4.2.0, 4.3.0 |  |
|dev-libs/rocm-device-libs | 4.3.0 | | Yes | :heavy_check_mark:<br> 3.7.0, 3.8.0, 3.9.0, 3.10.0, 4.0.0, 4.1.0, 4.2.0, 4.3.0 |  |
|media-libs/hsa-amd-aqlprofile| 4.3.0 | | (ok) | |  |
|dev-libs/rocr-runtime| 4.3.0 | | Yes | :heavy_check_mark:<br> 3.8.0, 3.9.0, 3.10.0, 4.0.0, 4.1.0, 4.2.0, 4.3.0 |  |
|dev-util/rocminfo | 4.3.0 |  | Yes | :heavy_check_mark:<br> 3.7.0, 3.8.0, 3.9.0, 3.10.0, 4.0.0, 4.1.0, 4.2.0, 4.3.0 |  |
|dev-util/rocm-bandwidth-test| 4.3.0 |  | (ok) |  |  |
|dev-libs/rocm-smi-lib| 4.3.0 |  | (ok) | |  |
|dev-util/rocm-smi| 4.0.0 | deprecated | Yes | :heavy_check_mark:<br> 4.0.0 |  |
|dev-libs/rocm-comgr | 4.3.0 | | Yes | :heavy_check_mark:<br> 3.9.0, 3.10.0, 4.0.0, 4.1.0, 4.2.0, 4.3.0 |  |
|dev-libs/amd-dbgapi | 4.3.0 |  | (ok) | |  |
|dev-libs/rocclr | 4.3.0 | | Yes | :heavy_check_mark:<br> 3.8.0, 3.9.0, 3.10.0, 4.0.0, 4.1.0, 4.2.0, 4.3.0 |  |
|dev-libs/rocm-opencl-runtime| 4.3.0 |  | Yes | :heavy_check_mark:<br> 3.8.0, 3.9.0, 3.10.0, 4.0.0, 4.1.0, 4.2.0, 4.3.0 |  |
|dev-util/rocm-clang-ocl| 4.3.0 | | Yes | :heavy_check_mark:<br> 4.3.0 |  |
|dev-util/hip| 4.3.0 |  | Yes | :heavy_check_mark:<br> 4.0.0, 4.1.0, 4.2.0, 4.3.0  |  |
|dev-libs/rocm-debug-agent | 4.3.0 |  | (ok) | |  |
|dev-util/roctracer| 4.3.0 |  | Yes | :heavy_check_mark:<br> 4.0.0, 4.2.0, 4.3.0  |  |
|dev-util/rocprofiler| 4.3.0 |  | (ok) | |  |
|dev-util/rcp| 5.6 |   | (ok) | |  |
|dev-libs/rccl | 4.3.0 |  | Yes | :heavy_check_mark:<br> 4.0.0, 4.3.0  |  |
|dev-util/Tensile | 4.0.0 | | Yes | | science<br> :heavy_check_mark:<br> 4.0.0 |

<br>
ROCm Libraries:

|Ebuild|Current Version|State|FHS|in Gentoo portage| other overlay |
|---|---|---|---|---|---|
|sci-libs/rocPRIM| 4.3.0 |  | Yes | :heavy_check_mark:<br> 4.0.0, 4.3.0 |  |
|sci-libs/rocRAND| 4.3.0 |  | Yes | :heavy_check_mark:<br> 4.0.0, 4.3.0 |  |
|sci-libs/rocFFT| 4.0.0 |  | Yes | :heavy_check_mark:<br> 4.0.0 |  |
|sci-libs/rocSPARSE| 4.3.0 |  | Yes | :heavy_check_mark:<br> 4.0.0, 4.3.0 |  |
|sci-libs/rocBLAS| 4.3.0 |  | Yes | :heavy_check_mark:<br> 4.3.0 | |
|sci-libs/rocSOLVER| 4.0.0 |  | (ok) |  |  |
|sci-libs/rocALUTION| 4.0.0 | | (ok) |  |  |
|sci-libs/rocThrust| 4.0.0, 4.3.0 |  | Yes | :heavy_check_mark:<br> 4.0.0, 4.3.0 |  |
|sci-libs/hipCUB | 4.0.0 |  | Yes | :heavy_check_mark:<br> 4.0.0  |  |
|sci-libs/hipBLAS | 4.0.0 |  | (ok) |  |  |
|sci-libs/hipFFT |  |  |  |  |  |
|sci-libs/hipSPARSE | 4.3.0 |  | Yes | :heavy_check_mark:<br> 4.0.0, 4.3.0 |  |
|sci-libs/MIOpenGEMM | 4.0.0 |  | (ok) | |  |
|sci-libs/MIOpen | 4.3.0 |  | Yes | :heavy_check_mark:<br> 4.3.0 |  |

<br>
Meta ebuilds:

|Ebuild|Current Version|State| FHS | in Gentoo portage| 
|---|---|---|---|---|
|dev-util/amd-rocm-meta| 4.0.0 |  | (ok) | |

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
