{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    git
    vim
    pavucontrol
    home-manager   # standalone: run `home-manager switch --flake <path>#<name>`
  ];
}
