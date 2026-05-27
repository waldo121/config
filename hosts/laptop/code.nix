 { pkgs, ... }:
{
    programs.vscode = {
        enable = true;
        package = pkgs.vscodium;
        profiles.default = {
            extensions = with pkgs.vscode-extensions; [
                bbenoist.nix 
                vscodevim.vim
                ms-python.python
            ];
        };
        
        
    };
    programs.opencode = {
        enable = true;
        enableMcpIntegration = true;
    };
    programs.mcp = {
        enable = true;
        servers = {
            mcp-nixos = {
                command = "nix";
                args = [
                    "run"
                    "github:utensils/mcp-nixos"
                    "--"
                ];
            };
        };
    };
    home.packages = with pkgs; [
        python314FreeThreading
        podman
        podman-compose
    ];
}
