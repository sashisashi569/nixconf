{ pkgs, ... }: {
  i18n.inputMethod = {
    enable = true;
    type   = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;   # native Wayland input-method protocol
      addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
        fcitx5-qt
        fcitx5-configtool
      ];
    };
  };
}
