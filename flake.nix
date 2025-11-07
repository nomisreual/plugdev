{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages."${system}";
  in {
    devShells."${system}".default = pkgs.mkShell {
      packages = with pkgs; [
        neovim
      ];
      shellHook = ''
        # Set local config:
        unset XDG_CONFIG_HOME
        export XDG_CONFIG_HOME=./config

        # For local development:
        if [[ ! -d ./dev ]]; then
          mkdir ./dev
          unset XDG_CONFIG_DIRS
          export XDG_CONFIG_DIRS=./dev:$XDG_CONFIG_DIRS
        else
          unset XDG_CONFIG_DIRS
          export XDG_CONFIG_DIRS=./dev:$XDG_CONFIG_HOME

        fi

        if [[ -d "/tmp/nvim_share" ]]; then
          export XDG_DATA_HOME=/tmp/nvim_share
        else
          mkdir "/tmp/nvim_share"
          export XDG_DATA_HOME=/tmp/nvim_share
        fi
      '';
    };
  };
}
