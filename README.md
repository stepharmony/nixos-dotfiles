> [!NOTE]  
> There's nothing special in this configuration so far, other than a rushed VM configuration, but the structure is there. Progress with this repo will be very slow, because I'm focused on finishing the semester. Until then, I'll use Windows and change things up in this config in a VM whenever I have time.

# My cozy NixOS configuration
This repo hosts a NixOS configuration that's designed to fit my needs, from music production to studying. Some stuff present in this configuration is pretty niche, so feel free to take inspiration if you find something in here that helps.

## what this repo will contain
> [!NOTE]  
> This will be subject to change at any time, based on my priorities. This is just a list of general things that I plan to/have implemented in my config.
- nvidia configuration
  - [ ] patches such as `options nvidia NVreg_PreserveVideoMemoryAllocations=1` and modesetting for a somewhat proper wayland experience
- advanced gaming configuration
  - [ ] wine-discord-ipc-bridge integration (for seamless discord rich presence with windows games)
  - [ ] gaming apps (lutris, steam, latencyflex etc.)
- music prod essentials
  - [ ] yabridge and vst support
  - [ ] low-latency pipewire config (halfway achieved)
  - [x] realtime settings (somewhat done)
  - [ ] different DAWs (renoise, reaper) and plugins, as well as carla
- proper kanata configuration - the .kbd file should contain the following:
  - [ ] implement hardened kanata systemd service (note: the .kbd file has everything Gallium and QWERTY, as well as special characters for Romanian and German)
- virtualization
  - [ ] general stuff (qemu, libvirt, virt-manager)
  - [ ] single gpu passthrough (the hardest thing to implement)
- general programs
  - [ ] davinci resolve support
  - i don't know what else to implement yet
