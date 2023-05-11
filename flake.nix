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
          name = "myfonts-0.2.0";
          paths = builtins.attrValues
            self.packages.${system}; # Add font derivation names here
        };

        packages.nerdfont-symbols = pkgs.stdenvNoCC.mkDerivation {
          name = "nerdfont-symbols-only-font";
          dontConfigue = true;
          src = pkgs.fetchzip {
            url =
              "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/NerdFontsSymbolsOnly.zip";
            sha256 = "sha256-ntLbwY0ttGd8sMaa4ztkynxW1P0EtjIoYkqJaN7TJVw=";
            stripRoot = false;
          };
          installPhase = ''
            mkdir -p $out/share/fonts
            rm LICENSE readme.md
            cp -R $src $out/share/fonts/truetype/
          '';
          meta = { description = "A NerdFonts Symbols Only Font Family derivation."; };
        };
      });
}
