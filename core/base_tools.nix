{ config, lib, pkgs, ... }: {
  # Shared packages for all systems
  environment.systemPackages = with pkgs; [
    mcap-cli
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

  # Enable OpenSSH and Tailscale
  services.openssh.enable = true;
  services.tailscale.enable = true;
}
