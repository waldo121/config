{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "ahci" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "aesni_intel" "i2c_dev" ];
  boot.extraModulePackages = [ ];

  # Velocloud Edge 510: 8GB eMMC (/dev/mmcblk0) on the mainboard.
  # If booting from USB or SATA, adjust accordingly.
  fileSystems."/" = {
    device = "/dev/mmcblk0p1";
    fsType = "ext4";
  };

  # No swap — 4GB RAM is enough for a router, and eMMC is slow.

  # Intel I210 NICs (4 ports) — in-tree igb driver.
  # Port mapping: igb0=GE1, igb1=GE2, igb2=GE3, igb3=GE4.
  networking.useDHCP = false;
  networking.interfaces.igb1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
