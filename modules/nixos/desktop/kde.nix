{
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

}
