{
  description = "seccomp-tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
      perSystem = {system, ...}:
        let
          pkgs = import nixpkgs { inherit system; };

          gems = pkgs.bundlerEnv {
            name = "seccom-tools-gems";
            gemdir = ./.;
          };

          app = pkgs.bundlerApp {
            pname = "seccomp-tools";
            gemdir = ./.;
            exes = ["seccomp-tools"];
          };
        in
          {
            packages.default = app;
            devShells.default = pkgs.mkShell {
              buildInputs = [ gems gems.wrappedRuby ];
            };
          };
    };
}
