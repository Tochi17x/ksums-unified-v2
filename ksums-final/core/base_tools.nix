{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    python3
    neovim
    git
    btop
    neofetch
    lazygit
    curl
    wget
    htop
    tmux
  ];

  services.openssh.enable = true;
  services.tailscale.enable = true;
}
