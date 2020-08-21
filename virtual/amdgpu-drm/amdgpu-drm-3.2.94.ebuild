EAPI=7
DESCRIPTION="Virtual for the amdgpu DRM (Direct Rendering Manager) kernel module"
KEYWORDS="amd64"
IUSE="amdgpu-dkms dkms +firmware kernel rock-dkms"
AMDGPU_DKMS_PV="20.30.1109583"
ROCK_DKMS_PV="3.7.0"
VANILLA_KERNEL_PV="9999" #  DC_VER >="3.2.87" was not released yet in any official point release.  It appears on master on May 28, 2020.
LINUX_FIRMWARE_PV="20200807" # matches last commit/tag AMDGPU_DKMS_PV in linux-firmware git
RDEPEND="amdgpu-dkms? ( >=sys-kernel/amdgpu-dkms-${AMDGPU_DKMS_PV} )
	 rock-dkms? ( >=sys-kernel/rock-dkms-${ROCK_DKMS_PV} )
	 firmware? (
		|| (
			amdgpu-dkms? ( >=sys-firmware/amdgpu-firmware-${AMDGPU_DKMS_PV} )
			rock-dkms? ( >=sys-firmware/rock-firmware-${ROCK_DKMS_PV} )
			!amdgpu-dkms? (
				!rock-dkms? (
					>=sys-kernel/linux-firmware-${LINUX_FIRMWARE_PV}
				)
			)
		)
	 )"
REQUIRED_USE="^^ ( amdgpu-dkms kernel rock-dkms )
	amdgpu-dkms? ( dkms )
	dkms? ( ^^ ( amdgpu-dkms rock-dkms ) )
	rock-dkms? ( dkms )"
SLOT="0/${PV}" # based on DC_VER, rock-dkms will not be an exact fit

pkg_setup() {
	ewarn "The linux-firmware git logs currently doesn't indicate 20.20 firmware yet as of 20200614"
	if use amdgpu-dkms || use rock-dkms ; then
		:;
	else
		if [[ ! -f "${EROOT}/usr/src/linux/drivers/gpu/drm/amd/display/dc/dc.h" ]] ; then
			die "Cannot find /usr/src/linux/drivers/gpu/drm/amd/display/dc/dc.h"
		fi
		DC_VER=$(grep "DC_VER" "${EROOT}/usr/src/linux/drivers/gpu/drm/amd/display/dc/dc.h" | cut -f 3 -d " " | sed -e "s|\"||g")
		if ver_test ${DC_VER} -lt ${PV} ; then
			die "Your DC_VER is old.  Your kernel needs to be at least ${VANILLA_KERNEL_PV} or DC_VER needs to be ${PV}."
		fi
	fi
}
