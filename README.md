Ebuilds to install ROCm on Gentoo Linux

-> https://github.com/RadeonOpenCompute/ROCm

**Attention: With version 2.x of ROCm the ebuilds will be renamed to comply with the Gentoo naming rules. All ebuilds which are not in the official Gentoo tree are highly experimental, but please report all problems here if you tried it.**

Now in official Gentoo portage:
 - dev-libs/roct-thunk-interface
 - dev-libs/rocr-runtime

Work in progress:
 - dev-libs/rocm-opencl-runtime

Tested in this repository (2019-04-15):

|Ebuild|Version|State|in Gentoo portage|
|---|---|---|---|
|sys-kernel/rocm-sources| 2.3 | based on linux kernel 5.0.0-rc1 | 
|dev-libs/roct-thunk-interface| 2.3 |  | :heavy_check_mark: V2.0.0 |
|dev-libs/rocr-runtime| 2.3 | | :heavy_check_mark: V2.0.0 |
|media-libs/ROCm-OpenCL-Runtime| 2.3 | | WIP |
|media-libs/hsa-amd-aqlprofile| 1.0.0 | | |
|media-libs/hsa-ext-rocr| 1.1.9 | ||
|dev-util/rocminfo| 9999 | | |
|dev-util/rocm-smi| 2.3.9999 | | |
|sys-devel/hcc| 2.3 | fails when debug use flag is set | |
|sys-devel/hip| 2.3 | failes to build, Currently depends on HCC | |

All other ebuilds can be out of date!
