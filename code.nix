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
            dart-code.flutter
        ];
        
    };
    home.packages = with pkgs; [
        flutter327
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
    ];
}
