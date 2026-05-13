{
  description = "NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      systems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      overlay-unstable = final: prev: {
        unstable = import nixpkgs-unstable {
          inherit (prev.stdenv.hostPlatform) system;
          config.allowUnfree = true;
        };
      };
    in
    {
      formatter = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        pkgs.writeShellApplication {
          name = "format-nixos-config";
          runtimeInputs = [
            pkgs.findutils
            pkgs.nixfmt-rfc-style
          ];
          text = ''
            find "$PWD" -path "$PWD/.git" -prune -o -name '*.nix' -print0 | xargs -0 nixfmt
          '';
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              age
              deadnix
              git
              gitleaks
              nil
              nix-output-monitor
              nixfmt-rfc-style
              nh
              ripgrep
              sops
              statix
            ];

            shellHook = ''
              echo "NixOS config shell: nix fmt, nix flake check, gitleaks detect --redact --source ."
            '';
          };
        }
      );

      checks = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          nixfmt =
            pkgs.runCommand "nixfmt-check"
              {
                nativeBuildInputs = [ pkgs.nixfmt-rfc-style ];
                src = self;
              }
              ''
                cp -r "$src" source
                chmod -R u+w source
                find source -name '*.nix' -print0 | xargs -0 nixfmt --check
                touch "$out"
              '';

          statix =
            pkgs.runCommand "statix-check"
              {
                nativeBuildInputs = [ pkgs.statix ];
                src = self;
              }
              ''
                statix check --ignore 'hosts/*/hardware-configuration.nix' "$src"
                touch "$out"
              '';

          secrets =
            pkgs.runCommand "gitleaks-check"
              {
                nativeBuildInputs = [ pkgs.gitleaks ];
                src = self;
              }
              ''
                gitleaks detect --no-git --redact --source "$src"
                touch "$out"
              '';
        }
      );

      # NixOS Configs
      nixosConfigurations = {
        # Laptop Configuration
        "nixos-laptop" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/nixos-laptop/configuration.nix
            ./modules/core/home-manager.nix
            (_: {
              nixpkgs.overlays = [ overlay-unstable ];
            })
          ];
        };

        # Desktop Configuration
        "nixos-desktop" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./hosts/nixos-desktop/default.nix
            ./modules/core/home-manager.nix
            (_: {
              nixpkgs.overlays = [ overlay-unstable ];
            })
          ];
        };
      };
    };
}
