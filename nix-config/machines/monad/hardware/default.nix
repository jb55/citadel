{ config, lib, pkgs, ... }:
{

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "sd_mod" "amdgpu" "vfio-pci" ];
  #boot.initrd.preDeviceCommands = ''
  #   DEVS="0000:27:00.0 0000:27:00.1"
  #   for DEV in $DEVS; do
  #     echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
  #   done
  #   modprobe -i vfio-pci
  #'';

  boot.kernelParams = [ "amdgpu.gpu_recovery=1" ];
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];
  boot.loader.grub.copyKernels = true;
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "znix/root/nixos";
      fsType = "zfs";
    };

  fileSystems."/home" =
    { device = "znix/home";
      fsType = "zfs";
    };

  fileSystems."/zbig" =
    { device = "zbig";
      fsType = "zfs";
    };

  #fileSystems."/chonk" =
  #  { device = "chonk";
  #    fsType = "zfs";
  #  };

  # swapDevices =
  #   [ { device = "/dev/disk/by-uuid/d4e4ae51-9179-439d-925b-8df42dd1bfc5"; }
  #   ];

  hardware.enableAllFirmware = true;

  boot.loader.grub.devices = [ "/dev/nvme0n1" ];
  boot.supportedFilesystems = ["zfs"];
}
