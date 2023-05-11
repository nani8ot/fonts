{
  description =
    "A flake giving access to fonts that I use, outside of nixpkgs.";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        defaultPackage = pkgs.symlinkJoin {
          name = "myfonts-0.1.4";
          paths = builtins.attrValues
            self.packages.${system}; # Add font derivation names here
        };

        packages.gillsans = pkgs.stdenvNoCC.mkDerivation {
          name = "nerdfont-symbols-only-font";
          dontConfigue = true;
          src = pkgs.fetchzip {
            url =
              "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/NerdFontsSymbolsOnly.zip";
            sha256 = "sha256-YcZUKzRskiqmEqVcbK/XL6ypsNMbY49qJYFG3yZVF78=";
            stripRoot = false;
          };
          installPhase = ''
            mkdir -p $out/share/fonts
            cp -R $src $out/share/fonts/truetype/
          '';
          meta = { description = "A NerdFonts Symbols Only Font Family derivation."; };
        };

        packages.palatino = pkgs.stdenvNoCC.mkDerivation {
          name = "palatino-font";
          dontConfigue = true;
          src = pkgs.fetchzip {
            url =
              "https://www.dfonts.org/wp-content/uploads/fonts/Palatino.zip";
            sha256 = "sha256-FBA8Lj2yJzrBQnazylwUwsFGbCBp1MJ1mdgifaYches=";
            stripRoot = false;
          };
          installPhase = ''
            mkdir -p $out/share/fonts
            cp -R $src/Palatino $out/share/fonts/truetype/
          '';
          meta = { description = "The Palatino Font Family derivation."; };
        };
      });
}
