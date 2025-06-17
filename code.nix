 { pkgs, ... }:
{
    programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        profiles.default = {
            extensions = with pkgs.vscode-extensions; [
                bbenoist.nix 
                visualstudioexptteam.vscodeintellicode
                vscodevim.vim
            ];
        };
        
        
    };
    home.packages = with pkgs; [
        android-tools
        android-studio-tools
        android-studio
        code-cursor
    ];
}
