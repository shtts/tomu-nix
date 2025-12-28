# Tomu 
A Nix flake for **Tomu**, a simple music player.
Original upstream source: [6z7y/tomu](https://github.com/6z7y/tomu)

> [!IMPORTANT]
> You must have Nix Experimental Features (`flakes` and `nix-command`) enabled.
> See the [NixOS Wiki](https://nixos.wiki/wiki/flakes) for instructions on how to enable them.

## Quick Start

Run it instantly without installing:

```bash
nix run github:shtts/tomu-nix 'musicfile.mp3'
```

Or enter a shell with `tomu` available:

```bash
nix shell github:shtts/tomu-nix
```

---

## Installation

### Step 1: Add to `flake.nix`

1. Add the repository to your `inputs`.
2. Pass `inputs` to your configuration using `specialArgs` (for NixOS) or `extraSpecialArgs` (for Home Manager).

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # 1. Add tomu-nix to inputs
    tomu-nix.url = "github:shtts/tomu-nix";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.my-machine = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      # 2. Pass inputs to configuration.nix
      specialArgs = { inherit inputs; };
      
      modules = [
        ./configuration.nix
        
        # If using Home Manager as a module:
        home-manager.nixosModules.home-manager
        {
          # 3. Pass inputs to home.nix
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.yourname = ./home.nix;
        }
      ];
    };
  };
}
```

### Step 2: Add to Package List

#### NixOS (`configuration.nix`)

```nix
{ pkgs, inputs, ... }: # <-- Ensure 'inputs' is included here

{
  environment.systemPackages = [
    pkgs.git
    pkgs.vim
    
    # Install Tomu
    inputs.tomu-nix.packages.${pkgs.system}.default
  ];
}
```

#### Home Manager (`home.nix`)

```nix
{ pkgs, inputs, ... }: # <-- Ensure 'inputs' is included here

{
  home.packages = [
    # Install Tomu
    inputs.tomu-nix.packages.${pkgs.system}.default
  ];
}
```
