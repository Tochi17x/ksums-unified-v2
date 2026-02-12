# KSUMS NixOS Config

## Setup

```bash
# 1. Clone or copy this folder
cd ~
git clone <repo> ksums-final
# OR
unzip ksums-final.zip

# 2. Copy YOUR hardware config
sudo cp /etc/nixos/hardware-configuration.nix ~/ksums-final/hosts/laptop/hardware-configuration.nix

# 3. Git track it
cd ~/ksums-final
git init
git add .
git commit -m "Initial"

# 4. Rebuild with unfree flag
sudo NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --flake .#laptop --impure

# 5. Reboot
sudo reboot

# 6. Copy Hyprland config
mkdir -p ~/.config/hypr
cp ~/ksums-final/dotfiles/hyprland.conf ~/.config/hypr/
hyprctl reload
```

## Keybinds

| Key | Action |
|-----|--------|
| Super + Return | Terminal |
| Super + D | App launcher |
| Super + Q | Close |
| Super + F | Fullscreen |
| Super + F1 | Mumble |
| Super + F2 | Foxglove |
| Super + 1-9 | Workspace |

## Hosts

- `laptop` - Hyprland desktop with Foxglove + Mumble
- `lib-o-yap` - Server with CopyParty
