# ~/nixos-config/home.nix
{ config, pkgs, lib, ... }:

{
  home = {
    username = "cloak";
    homeDirectory = "/home/cloak";
    stateVersion = "24.11";
    packages = with pkgs; [
      htop # Example package
      fastfetch
      cowsay
      # Add command-line tools or GUI apps you want managed for this user here
      # Example: libreoffice-fresh
    ];
  };
  programs.git = {
    enable = true;
    userName = "stepharmony";
    userEmail = "stepharmony@proton.me"; # <-- Set your email!
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      alias ls='ls --color=auto'
      alias ll='ls -alF'
      alias grep='grep --color=auto'
    '';
    shellAliases =
    let
      flakePath = "~/nixos-config";
    in {
      rebuild = "sudo nixos-rebuild switch --flake ${flakePath}";
      hms = "home-manager switch --flake ${flakePath}";
    };
  };

  # Example: Manage a config file using home.file
  # home.file.".config/someapp/config.txt" = {
  #   text = ''
  #     some_setting = value
  #     another_setting = other_value
  #   '';
  # };

  # === Services ===
  # Home Manager can manage user systemd services too
  # systemd.user.services.my-user-service = {
  #   Unit = { Description = "My cool user service"; };
  #   Service = { ExecStart = "${pkgs.coreutils}/bin/echo 'Hello from user service'"; };
  #   Install = { WantedBy = [ "default.target" ]; };
  # };
}
