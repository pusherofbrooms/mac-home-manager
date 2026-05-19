{
  description = "Home Manager configuration of Jorgensen";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, emacs-overlay, ... }:
    let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          emacs-overlay.overlay
          (final: prev: {
            emacs-git = prev.emacs-git.overrideAttrs (_old: {
              src = final.fetchgit {
                url = "https://git.savannah.gnu.org/git/emacs.git";
                rev = "98c28606d2a67ceab4c6cb03a17eb756e809b31b";
                sha256 = "18ah19lcnvbmjyaj4r56l1wy9sqklwj60djwkyam0bhlky23bkvj";
              };
            });
          })
        ];
      };
    in {
      homeConfigurations.Jorgensen = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
