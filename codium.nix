 { pkgs, ... }:
{
    programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        extensions = with pkgs.vscode-extensions; [
            bbenoist.nix 
            ms-azuretools.vscode-docker
            github.copilot
            github.copilot-chat
            visualstudioexptteam.vscodeintellicode
            golang.go
            vscodevim.vim
        ];
    };
}
