{
  userConf,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.latex;
  tex = (
    pkgs.texlive.combine {
      inherit (pkgs.texlive)
        scheme-medium # Provides the core texmf structure
        dvisvgm # for preview and export as html
        dvipng # for preview and export as html
        wrapfig
        preprint
        titlesec
        marvosym
        enumitem
        tcolorbox
        tikzfill
        pdfcol
        listingsutf8
        changepage
        capt-of
        listings
        ulem
        biblatex
        ;
    }
  );
in
{
  options.my = {
    latex.enable = lib.mkEnableOption "install latex packages";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      tex
    ];
  };
}
