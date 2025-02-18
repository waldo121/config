 { pkgs, ... }:
{
    programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        extensions = with pkgs.vscode-extensions; [
            bbenoist.nix 
            ms-dotnettools.csharp
            ms-dotnettools.csdevkit
            ms-azuretools.vscode-docker
            ms-dotnettools.vscode-dotnet-runtime
            github.copilot
            github.copilot-chat
            visualstudioexptteam.vscodeintellicode
            golang.go
        ];
    };
}
