 { pkgs, ... }:
{
    programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        profiles.default = {
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
        
        
    };
    home.packages = with pkgs; [
        go
        gopls
        gcc
        podman-compose
        podman-tui
        dbeaver-bin
        podman
        android-tools
        android-studio-tools
        android-studio
        code-cursor
        python314
        ansible
        gh
    ];
}
