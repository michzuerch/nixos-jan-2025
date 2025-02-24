{pkgs, ...}: {
  home.fonts = with pkgs; [
    dejavu_fonts
    jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    font-awesome
    powerline-fonts
    powerline-symbols
    nerdfonts.NerdFontsSymbolsOnly
  ];
}
