{
  description = "NixOS Configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
    codex-desktop-linux = {
      url = "github:ilysenko/codex-desktop-linux";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
          inherit (final.stdenv.hostPlatform) system;
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
            pkgs.nixfmt
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
              nixfmt
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
                nativeBuildInputs = [ pkgs.nixfmt ];
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
                cd "$src" && statix check --ignore '**/hardware-configuration.nix' .
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

          nixos-laptop = self.nixosConfigurations.nixos-laptop.config.system.build.toplevel;
          nixos-desktop = self.nixosConfigurations.nixos-desktop.config.system.build.toplevel;
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
