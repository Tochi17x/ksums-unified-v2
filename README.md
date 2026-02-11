# KSUMS Unified NixOS Flake

One flake for both your laptop (Hyprland + Foxglove + Mumble) and server (lib-o-yap + CopyParty).

## Hosts

| Host | Description | Services |
|------|-------------|----------|
| `laptop` | Hyprland desktop | Foxglove, Mumble, PipeWire |
| `lib-o-yap` | ZFS server | CopyParty, Tailscale, SSH |

## Quick Setup

### For Laptop
```bash
# 1. Copy YOUR hardware config
cp /etc/nixos/hardware-configuration.nix hosts/laptop/hardware-configuration.nix

# 2. Rebuild
cd ~/ksums-unified-v2
nix flake update
sudo nixos-rebuild switch --flake .#laptop

# 3. Copy dotfiles
mkdir -p ~/.config/hypr ~/.config/waybar ~/Pictures/Screenshots
cp dotfiles/hyprland.conf ~/.config/hypr/
cp dotfiles/waybar/* ~/.config/waybar/
```

### For lib-o-yap Server
```bash
# Hardware config is already included
cd ~/ksums-unified-v2
nix flake update
sudo nixos-rebuild switch --flake .#lib-o-yap
```

## Services

### lib-o-yap Server
- **CopyParty**: http://lib-o-yap:3923
  - `/data` → `/tank/data` (ZFS pool)
- **SSH**: Port 22
- **Tailscale**: Enabled

### Laptop
- **Mumble**: Auto-connect with Super + F1
- **Foxglove**: Super + F2
- **SSH**: Port 22

## Keybinds (Laptop)

| Key | Action |
|-----|--------|
| Super + 1-9 | Switch workspace |
| Super + Shift + 1-9 | Move window |
| Super + F1 | Mumble |
| Super + F2 | Foxglove |
| Super + Return | Terminal |
| Super + D | App launcher |
| Super + Q | Close window |

## File Structure

```
ksums-unified-v2/
├── flake.nix              # Main flake (both hosts)
├── core/
│   └── base_tools.nix     # Shared packages
├── hosts/
│   ├── laptop/
│   │   └── hardware-configuration.nix
│   └── lib-o-yap/
│       ├── configuration.nix
│       └── hardware-configuration.nix
└── dotfiles/
    ├── hyprland.conf
    └── waybar/
        ├── config
        └── style.css
```
# ksums-unified-v2
