{ config, pkgs, lib, ... }:

{
  system.stateVersion = "24.05";

  #################
  ### NIX #########
  #################
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  #################
  ### BOOT ########
  #################
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #################
  ### NETWORK #####
  #################
  networking.hostName = "ksums-laptop";
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

  #################
  ### SSH #########
  #################
  services.openssh.enable = true;
  services.openssh.settings = {
    PasswordAuthentication = true;
    PermitRootLogin = "no";
  };

  #################
  ### USER ########
  #################
  users.users.potato = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" ];
  };
  security.sudo.wheelNeedsPassword = false;

  #################
  ### AUDIO #######
  #################
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #################
  ### HYPRLAND ####
  #################
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
      user = "greeter";
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  #################
  ### FONTS #######
  #################
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    font-awesome
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];

  #################
  ### ENV #########
  #################
  environment.sessionVariables = {
    MUMBLE_HOST = "192.168.1.50";
    MUMBLE_PORT = "64738";
    MUMBLE_USER = "Crew";
    NIXOS_OZONE_WL = "1";
  };

  #################
  ### PACKAGES ####
  #################
  environment.systemPackages = with pkgs; [
    # System
    openssh git neovim btop lazygit curl wget unzip ripgrep fd python3 neofetch htop

    # Browser
    firefox

    # Terminal & Files
    kitty nautilus

    # Hyprland
    waybar wofi mako swww
    grim slurp wl-clipboard cliphist
    brightnessctl pamixer pavucontrol
    networkmanagerapplet
    hyprlock hypridle hyprpicker grimblast

    # Theming
    gtk3 gtk4 adwaita-icon-theme

    # Utils
    playerctl libnotify xdg-utils

    # KSUMS Apps
    mumble
    foxglove-studio
  ];

  programs.firefox.enable = true;
}
