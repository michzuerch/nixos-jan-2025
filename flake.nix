{
  description = "nixos-config michzuerch@gmail.com Januar 2025";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";

    # COMING SOON...
    #nixvim = {
    #  url = "github:nix-community/nixvim";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    systems = ["x86_64-linux"];
    homeStateVersion = "24.11";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    lib = nixpkgs.lib;
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});

    pkgsFor = lib.genAttrs systems (system: import nixpkgs {inherit system;});

    user = "michzuerch";
    hosts = [
      {
        hostname = "thinkpadnomad";
        stateVersion = "24.11";
      }
      {
        hostname = "slim3";
        stateVersion = "24.05";
      }
      {
        hostname = "330-15ARR";
        stateVersion = "24.11";
      }
    ];

    makeSystem = {
      hostname,
      stateVersion,
    }:
      nixpkgs.lib.nixosSystem {
        system = system;
        specialArgs = {
          inherit inputs stateVersion hostname user;
        };

        modules = [
          ./hosts/${hostname}/configuration.nix
        ];
      };
  in {
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    nixosConfigurations = nixpkgs.lib.foldl' (configs: host:
      configs
      // {
        "${host.hostname}" = makeSystem {
          inherit (host) hostname stateVersion;
        };
      }) {}
    hosts;

    homeConfigurations.${user} = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        inherit inputs homeStateVersion user;
      };

      modules = [
        ./home-manager/home.nix
      ];
    };
  };
}
