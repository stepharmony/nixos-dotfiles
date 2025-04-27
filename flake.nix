{
  inputs = {
    # Use nixos-unstable channel for Nixpkgs
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Disko for partitioning
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs"; # Ensure Disko uses the same nixpkgs

    # Home Manager from master branch
    home-manager = {
      url = "github:nix-community/home-manager"; # Defaults to master branch
      # Make Home Manager use the same nixpkgs as the system
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, disko, home-manager, ...}@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations.wirtual = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/vm-tester/configuration.nix
          disko.nixosModules.disko
          ./hosts/vm-tester/disko-config.nix
          {
            _module.args.disks = [ "/dev/vda" ];
          }
        ];
      };
      diskoConfigurations.wirtual = import ./hosts/vm-tester/disko-config.nix;

      nixosConfigurations.zephyrus = inputs.nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/zephyrus/configuration.nix
          disko.nixosModules.disko
          ./hosts/zephyrus/disko-config.nix
          {
            _module.args.disks = [ "/dev/nvme0n1" ];
          }
        ];
      };
      diskoConfigurations.zephyrus = import ./hosts/zephyrus/disko-config.nix;


      homeConfigurations.cloak = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/cloak/home.nix ];
      };
    };
}
