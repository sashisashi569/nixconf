# Environment variables for applications that don't use the Wayland IM protocol
# GTK4 / Qt6 apps on Wayland use the native protocol via fcitx5.waylandFrontend.
# These vars cover older GTK3/Qt5 apps and X11-compatibility (XIM).
{ ... }: {
  home.sessionVariables = {
    XMODIFIERS    = "@im=fcitx";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE  = "fcitx";
    SDL_IM_MODULE = "fcitx";
    INPUT_METHOD  = "fcitx";
  };
}
