 { pkgs, ... }:
let
  opencodeApiKey = "{file:~/.config/opencode/API_KEY}";
  agentModel = "opencode/nemotron-3-ultra-free";
  agents = {
    code-reviewer = ./resources/opencode/agents/code-reviewer.md;
    documentation = ./resources/opencode/agents/documentation.md;
  };
in
{
    programs.vscodium = {
        enable = true;
        profiles.default = {
            enableMcpIntegration = true;
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
        inherit agents;
        # Runtime file read, model centralized here — not in agent markdown frontmatter
        settings = {
            permission = "allow";
            agent = builtins.mapAttrs (_name: _path: {
                inherit opencodeApiKey agentModel;
            }) agents;
        };
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
    # Symlink so {file:~/.config/opencode/API_KEY} resolves at opencode runtime
    home.file.".config/opencode/API_KEY".source = ./resources/opencode/API_KEY;

    home.file.".config/opencode/skills/issue-workflow/SKILL.md".source = ./resources/opencode/skills/issue-workflow/SKILL.md;
    home.file.".config/opencode/skills/git-operations/SKILL.md".source = ./resources/opencode/skills/git-operations/SKILL.md;

    home.packages = with pkgs; [
        python314FreeThreading
        podman
        podman-compose
    ];
}
