{
  description = "My-Nix";
  inputs = {
	    nixpkgs.url = "nixpkgs/nixos-26.05";
	    home-manager = {
	      url = "github:nix-community/home-manager/release-26.05";
	      inputs.nixpkgs.follows = "nixpkgs";
	    };
      silentSDDM = {
        url = "github:uiriansan/SilentSDDM";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      qylock = {
          url = "github:Darkkal44/qylock";
      };
      catppuccin = {
        url = "github:catppuccin/nix";
        inputs.nixpkgs.follows = "nixpkgs";
      };
      sidra = {
        url = "github:wimpysworld/sidra";
      };
  };

  outputs = { self, nixpkgs, home-manager, qylock, catppuccin, ...} @ inputs: {
	    nixosConfigurations.caelums-nix = nixpkgs.lib.nixosSystem {
	        system = "x86_64-linux";
          # this passes the inputs to configuration.nix
          specialArgs = { inherit inputs; };
	        
          modules = [
		          ./configuration.nix 
              qylock.nixosModules.default
              catppuccin.nixosModules.catppuccin
		          home-manager.nixosModules.home-manager
		          {
		              home-manager = {
			                useGlobalPkgs = true;
			                useUserPackages = true;
                      extraSpecialArgs = { inherit inputs; };
			                users.caelum = {
                        imports = [
                          ./home.nix
                          catppuccin.homeModules.catppuccin
                        ];
                      };
			                backupFileExtension = "backup";
		              };
		          }
	        ];
	    };
  };
}


