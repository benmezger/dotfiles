{
  pkgs ? import <nixpkgs> { },
  python ? "python311",
}:

let
  inherit (pkgs) lib stdenv;
  pythonPackage = builtins.getAttr (python) pkgs;
  poetry = pkgs.poetry.override { python3 = pythonPackage; };
in
pkgs.mkShell {
  NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
    stdenv.cc.cc
    pkgs.zlib # numpy
  ];
  NIX_LD = lib.fileContents "${stdenv.cc}/nix-support/dynamic-linker";
  buildInputs = [
    pythonPackage
    poetry
    pkgs.zsh
  ];
  shellHook = ''
    export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH
    export POETRY_HOME=${poetry}
    export POETRY_VIRTUALENVS_IN_PROJECT=true
  '';
}
