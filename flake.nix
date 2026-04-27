{
  description = "My-Nix";
  inputs = {
	    nixpkgs.url = "nixpkgs/nixos-25.11";
	    home-manager = {
	      url = "github:nix-community/home-manager/release-25.11";
	      inputs.nixpkgs.follows = "nixpkgs";
	    };
      silentSDDM = {
        url = "github:uiriansan/SilentSDDM";
        inputs.nixpkgs.follows = "nixpkgs";
      };

  };

  outputs = { self, nixpkgs, home-manager, ...} @ inputs: {
	    nixosConfigurations.caelums-nix = nixpkgs.lib.nixosSystem {
	        system = "x86_64-linux";
          # this passes the silentSDDM input to configuration.nix
          specialArgs = { inherit inputs; };
	        
          modules = [
		          ./configuration.nix 
		          home-manager.nixosModules.home-manager
		          {
		              home-manager = {
			                useGlobalPkgs = true;
			                useUserPackages = true;
			                users.caelum = import ./home.nix;
			                backupFileExtension = "backup";
		              };
		          }
	        ];
	    };
  };
}


