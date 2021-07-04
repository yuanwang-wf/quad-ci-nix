{
  description = "Walkthrough of The Simple Haskell Handbook";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils/master";
    devshell.url = "github:numtide/devshell/master";
  };

  outputs = { self, nixpkgs, flake-utils, devshell }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        overlay = final: prev: {
          haskellPackages = prev.haskellPackages.override {
            overrides = hself: hsuper: {

              quad = hself.callCabal2nix "quad"
                (final.nix-gitignore.gitignoreSourcePure [ ./.gitignore ] ./.)
                { };
            };
          };
          quad =
            final.haskell.lib.justStaticExecutables final.haskellPackages.quad;

        };
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ devshell.overlay overlay ];
        };

        myHaskellEnv = (pkgs.haskellPackages.ghcWithHoogle (p:
          with p;
          [ cabal-install ormolu hlint brittany record-dot-preprocessor ]
          ++ pkgs.quad.buildInputs));

      in rec {

        defaultPackage = pkgs.quad;
        devShell = pkgs.devshell.mkShell {
          name = "quad-dev-shell";
          env = [
            {
              name = "HIE_HOOGLE_DATABASE";
              value = "${myHaskellEnv}/share/doc/hoogle/default.hoo";
            }
            {
              name = "NIX_GHC";
              value = "${myHaskellEnv}/bin/ghc";
            }
            {
              name = "NIX_GHCPKG";
              value = "${myHaskellEnv}/bin/ghc-pkg";
            }
          ];
          packages = [ myHaskellEnv pkgs.nixpkgs-fmt pkgs.hpack ];
        };
      });
}
