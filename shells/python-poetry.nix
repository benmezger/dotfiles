{
  pkgs ? import <nixpkgs> { },
  python ? "python311",
}:

let
  pythonPackage = builtins.getAttr (python) pkgs;
  poetry = pkgs.poetry.override { python3 = pythonPackage; };
in
pkgs.mkShell {
  buildInputs = [
    pythonPackage
    poetry
  ];
  shellHook = ''
    export POETRY_HOME=${poetry}
    export POETRY_VIRTUALENVS_IN_PROJECT=true
  '';
}
