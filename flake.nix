{
  description = "KSUMS NixOS - Laptop (Hyprland) + Server (lib-o-yap)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";  # Unstable for foxglove-studio
    copyparty.url = "github:9001/copyparty";
    copyparty.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, copyparty, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      
      ###################
      ### LAPTOP ###
      ###################
      laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/laptop/hardware-configuration.nix
          ({ pkgs, lib, ... }: {
            system.stateVersion = "24.05";

            ### 🔧 NIX SETTINGS
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
            nixpkgs.config.allowUnfree = true;

            ### BOOT
            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;
            
            # Fix Fn lock - make function keys work as F1-F12 by default
            boot.kernelParams = [ "hid_apple.fnmode=2" ];

            ### NETWORK
            networking.hostName = "ksums-laptop";
            networking.networkmanager.enable = true;

            ### 🔒 SSH
            services.openssh.enable = true;
            services.openssh.settings = {
              PasswordAuthentication = true;
              PermitRootLogin = "no";
            };
            networking.firewall.enable = true;
            networking.firewall.allowedTCPPorts = [ 22 ];

            ### USER
            users.users.potato = {
              isNormalUser = true;
              extraGroups = [ "wheel" "networkmanager" "audio" "video" "input" ];
            };
            security.sudo.wheelNeedsPassword = false;

            ### AUDIO
            security.rtkit.enable = true;
            services.pipewire = {
              enable = true;
              alsa.enable = true;
              alsa.support32Bit = true;
              pulse.enable = true;
            };

            ### DESKTOP - HYPRLAND
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

            ### FONTS
            fonts.packages = with pkgs; [
              noto-fonts
              noto-fonts-cjk-sans
              noto-fonts-emoji
              font-awesome
              jetbrains-mono
              nerd-fonts.jetbrains-mono
            ];

            ### ENV (MUMBLE + FOXGLOVE)
            environment.sessionVariables = {
              MUMBLE_HOST = "192.168.1.50";
              MUMBLE_PORT = "64738";
              MUMBLE_USER = "Crew";
              NIXOS_OZONE_WL = "1";
            };

            ### PACKAGES
            environment.systemPackages = with pkgs; [
              # System tools
              openssh git neovim btop lazygit curl wget unzip ripgrep fd
              mcap-cli python3 neofetch
              
              # Browser - Firefox only
              firefox
              
              # Terminal & File manager
              kitty nautilus
              
              # Hyprland ecosystem
              waybar wofi mako swww
              grim slurp wl-clipboard cliphist brightnessctl pamixer
              pavucontrol networkmanagerapplet
              hyprlock hypridle hyprpicker grimblast
              
              # KSUMS - Voice & Telemetry
              mumble foxglove-studio
              
              # Theming
              gtk3 gtk4 adwaita-icon-theme
              
              # Misc
              playerctl libnotify xdg-utils
            ];

            # Set Firefox as default browser
            programs.firefox.enable = true;
            xdg.mime.defaultApplications = {
              "text/html" = "firefox.desktop";
              "x-scheme-handler/http" = "firefox.desktop";
              "x-scheme-handler/https" = "firefox.desktop";
            };
          })
        ];
      };

      ###################
      ### LIB-O-YAP SERVER ###
      ###################
      lib-o-yap = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./core/base_tools.nix
          ./hosts/lib-o-yap/configuration.nix
          ./hosts/lib-o-yap/hardware-configuration.nix

          copyparty.nixosModules.default
          ({ pkgs, ... }: {
            # Nix settings
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
            
            # CopyParty overlay and config
            nixpkgs.overlays = [ copyparty.overlays.default ];

            services.copyparty = {
              enable = true;
              user = "shop";
              group = "users";
              settings = {
                i = "0.0.0.0";
                p = [ 3923 ];
              };
              volumes = {
                "/data" = {
                  path = "/tank/data";
                  access = { r = "*"; rw = [ "*" ]; };
                  flags = { e2d = true; nodupe = true; };
                };
              };
            };

            # Firewall for CopyParty
            networking.firewall.allowedTCPPorts = [ 3923 22 ];
          })
        ];
      };

    };
  };
}
