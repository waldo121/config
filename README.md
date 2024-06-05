# My nixos & home-manager configs

```
# add nixos Hardware channel
sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
sudo nix-channel --update
# building nixos
sudo nixos-rebuild switch -I nixos-config=configuration.nix
# building home 
home-manager switch -f home.nix 
```