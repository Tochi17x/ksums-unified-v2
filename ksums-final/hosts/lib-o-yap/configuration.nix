{ config, lib, pkgs, ... }:

{
  system.stateVersion = "24.05";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ZFS
  boot.supportedFilesystems = [ "zfs" ];
  boot.kernelModules = [ "zfs" ];
  boot.zfs.extraPools = [ "tank" ];

  # Btrfs
  fileSystems."/".options = [ "compress=zstd" ];
  fileSystems."/home".options = [ "compress=zstd" ];
  fileSystems."/nix".options = [ "compress=zstd" "noatime" ];
  services.btrfs.autoScrub.enable = true;

  networking.hostName = "lib-o-yap";
  networking.hostId = "bcc4454e";
  networking.networkmanager.enable = true;

  users.users.shop = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };
  security.sudo.wheelNeedsPassword = false;
}
