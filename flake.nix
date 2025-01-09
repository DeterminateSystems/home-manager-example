{
  description = "Example Home Manager Configuration for NixOS Minimal";
  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";
    fh.url = "https://flakehub.com/f/DeterminateSystems/fh/*";
    home-manager.url = "https://flakehub.com/f/nix-community/home-manager/0.2411.*";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.url = "https://flakehub.com/f/nixos/nixpkgs/0.2411.*";
  };
  outputs =
    { self, ... }@inputs:
    let
      inherit (self) outputs;
      stateVersion = "24.11";
      helper = import ./lib { inherit inputs outputs stateVersion; };
    in
    {
      # To adapt this example to your needs, you need to change the following:
      # - macUsername -> your username on macOS (e.g. `whoami` in the terminal)
      # - macHostname -> the hostname of your Mac (e.g. `hostname` in the terminal)
      # - linuxUsername -> your username on the Ubuntu machine (e.g. `whoami` in the terminal)
      # - linuxHostname -> the hostname of your Ubuntu machine (e.g. `hostname` in the terminal)
      homeConfigurations = {
        "macUsername@macHostname" = helper.mkHome {
          username = "macUsername";
          hostname = "macHostname";
        };
        "linuxUsername@linuxHostname" = helper.mkHome {
          username = "linuxUsername";
          hostname = "linuxHostname";
        };
      };
    };
}
