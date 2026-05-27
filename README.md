# nixos & home-manager configs

```
# build nixos (laptop)
sudo nixos-rebuild switch -I nixos-config=hosts/laptop/configuration.nix

# build nixos (router) — build locally, deploy remotely
nixos-rebuild switch --target-host root@router.local -I nixos-config=hosts/router/configuration.nix

# build home-manager
home-manager switch -f hosts/laptop/home.nix
```
