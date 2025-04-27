# ~/nixos-config/configuration.nix
{ config, pkgs, lib, inputs, ... }:

# in order to install, run these commands
# nix-shell -p disko
# sudo disko --mode disko --flake .#zephyrus
# sudo nixos-install --no-channel-copy --no-root-password --flake .#zephyrus --arg disks '[ "/dev/vda" ]'

{
  imports =
 [ # Include the results of the hardware scan.
   ./hardware-configuration.nix
   ./disko-config.nix
 ];
  # === State Version ===
  # Keep this consistent with home.nix, usually the release you installed with.
  system.stateVersion = "24.11"; # Or the appropriate version if using unstable

  # --- Hostname (Must match flake) ---
  networking.hostName = "zephyrus";

  # --- Bootloader (Limine) ---
  boot.loader.limine = {
    enable = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # --- Kernel & Performance for Low Latency Audio ---
  boot.kernelPackages = pkgs.linuxPackages_latest;
  powerManagement.cpuFreqGovernor = "powersave";
  boot.kernel.sysctl."vm.swappiness" = 10;

  # --- Networking ---
  networking.networkmanager.enable = true;
  # networking.firewall.enable = true; # Recommended

  # --- Time & Locale ---
  time.timeZone = "Europe/Bucharest"; # Set your timezone
  i18n.defaultLocale = "en_US.UTF-8"; # Set your locale

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };

  # --- Audio Setup (Low-Latency PipeWire) ---
  services.pulseaudio.enable = false; # Ensure disabled
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };
  security.rtkit.enable = true;

  # --- ZRAM Swap ---
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 75;
  };

  # --- User Account (Must match home.nix) ---
  users.users.cloak = {
    isNormalUser = true;
    description = "Cloak";
    extraGroups = [ "wheel" "networkmanager" "audio" ];
    initialHashedPassword = "$6$49dJ6Vv3Bq/wFS2F$QDiMkSy4FUbVbK.7fchs.3ComTuWKI9S1NCbuZHFtLJ1kZ8hn2N0hbT1fT3G7b2bSnpVfnBFIzR3DqSmQh1Y61"; # <-- REPLACE THIS
  };
  security.sudo.wheelNeedsPassword = true;

  # --- Desktop Environment (Plasma 6 with Wayland Default) ---
  services = {
    # Enable the X server - needed for XWayland compatibility
    xserver.enable = true;

    # Enable the SDDM Display Manager
    displayManager.sddm = {
      enable = true;
      # --- Enable Wayland session support in SDDM ---
      # This makes the Plasma (Wayland) session available and typically default
      wayland.enable = true;
    };

    # Enable the Plasma 6 Desktop Environment
    desktopManager.plasma6.enable = true;
  };

  # --- Environment Variables for Wayland (Optional but often helpful) ---
  # These can sometimes help certain apps behave better under Wayland.
  # Add more as needed based on specific app requirements.
  environment.sessionVariables = {
    # Hint apps using Qt/KDE frameworks to use Wayland
    QT_QPA_PLATFORM = "wayland";
    # Hint SDL apps to use Wayland
    SDL_VIDEODRIVER = "wayland";
    # Hint Clutter apps to use Wayland
    # CLUTTER_BACKEND = "wayland";
    # For some Java apps (might need experimentation)
    # _JAVA_AWT_WM_NONREPARENTING = "1";
    # Fix issues with older Electron apps under Wayland (might vary)
    # NIXOS_OZONE_WL = "1";
  };

  # --- Packages ---
  environment.systemPackages = (with pkgs; [
    vim wget curl git firefox
    qpwgraph helvum qjackctl
    home-manager
    # Wayland specific tools (optional)
    # wl-clipboard # Wayland clipboard utilities
    # wdisplays    # GUI for managing Wayland outputs
  ])
  ++
  (with pkgs.kdePackages; [
    kate ark gwenview spectacle kcalc
    plasma-browser-integration
  ])
  ;

  # --- Nix Settings ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;

  # ... rest of your configuration ...
}
