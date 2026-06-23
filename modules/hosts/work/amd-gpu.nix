{
  den.aspects.work.nixos = {pkgs, ...}: {
    boot.kernelParams = [
      # "amdgpu.dc=0"
      # https://wiki.archlinux.org/title/AMDGPU#Issues_with_power_management_/_dynamic_re-activation_of_a_discrete_amdgpu_graphics_card
      "amdgpu.runpm=0"
      # https://community.frame.work/t/fedora-kde-becomes-suddenly-slow/58459
      # https://gitlab.freedesktop.org/drm/amd/-/issues/3647
      # https://wiki.archlinux.org/title/AMDGPU#Frozen_or_unresponsive_display_(flip_done_timed_out)
      "amdgpu.dcdebugmask=0x10"
      # "amdgpu.dcdebugmask=0x12"
    ];

    environment.systemPackages = [
      (pkgs.writeShellScriptBin
        "amd-gpu-recover"
        "sudo cat /sys/kernel/debug/dri/1/amdgpu_gpu_recover")
    ];
  };
}
