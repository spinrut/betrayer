{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
          libPath = with pkgs; lib.makeLibraryPath [
            libGL
            libxkbcommon
            wayland
          ];
        in
        with pkgs;
        {
          devShells.default = mkShell {
              nativeBuildInputs = [
                rustc
                cargo
                clippy
                cargo-edit
                # https://github.com/Riey/cargo-feature/issues/35
                #cargo-feature
                rust-analyzer
                rustfmt
              ];

              RUST_SRC_PATH = "${rust.packages.stable.rustPlatform.rustLibSrc}";
              LD_LIBRARY_PATH = libPath;

              shellHook = ''
                exec fish
              '';
          };
        }
      );
}
