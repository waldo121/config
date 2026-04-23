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
                ms-python.python
            ];
        };
        
        
    };
    home.packages = with pkgs; [
        opencode
        python314FreeThreading
        mcp-nixos
    ];
}
