# systemd-homed — portable, encrypted home directories
# Create users with: homectl create <user> --storage=luks --fs-type=ext4
{ ... }: {
  services.homed.enable = true;
}
