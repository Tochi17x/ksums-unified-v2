{
  description = "KSUMS NixOS - Laptop + Server";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    copyparty.url = "github:9001/copyparty";
    copyparty.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, copyparty, ... }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {

      ##################
      ### LAPTOP #######
      ##################
      laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # ALLOW UNFREE - MUST BE FIRST
          { nixpkgs.config.allowUnfree = true; }

          ./hosts/laptop/hardware-configuration.nix
          ./hosts/laptop/configuration.nix
        ];
      };

      ##################
      ### SERVER #######
      ##################
      lib-o-yap = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./core/base_tools.nix
          ./hosts/lib-o-yap/hardware-configuration.nix
          ./hosts/lib-o-yap/configuration.nix
          
          copyparty.nixosModules.default
          ({ pkgs, ... }: {
            nixpkgs.overlays = [ copyparty.overlays.default ];
            services.copyparty = {
              enable = true;
              user = "shop";
              group = "users";
              settings = { i = "0.0.0.0"; p = [ 3923 ]; };
              volumes = {
                "/data" = {
                  path = "/tank/data";
                  access = { r = "*"; rw = [ "*" ]; };
                  flags = { e2d = true; nodupe = true; };
                };
              };
            };
            networking.firewall.allowedTCPPorts = [ 3923 22 ];
          })
        ];
      };

    };
  };
}
