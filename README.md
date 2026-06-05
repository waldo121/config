# nixos & home-manager configs

```
# build nixos (laptop)
sudo nixos-rebuild switch -I nixos-config=hosts/laptop/configuration.nix   # laptop
home-manager switch -f hosts/laptop/home.nix                               # home-manager
```
