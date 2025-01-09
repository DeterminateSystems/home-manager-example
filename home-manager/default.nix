{
  lib,
  pkgs,
  stateVersion,
  username,
  ...
}:
let
  inherit (pkgs.stdenv) isDarwin isLinux;
in
{
  home = {
    inherit stateVersion;
    inherit username;
    homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";

    packages =
      with pkgs;
      [
        cpufetch
        fastfetch
        ipfetch
        onefetch
        micro
      ]
      ++ lib.optionals isLinux [
        ramfetch
      ]
      ++ lib.optionals isDarwin [
        m-cli
      ];
    sessionVariables = {
      EDITOR = "micro";
      SYSTEMD_EDITOR = "micro";
      VISUAL = "micro";
    };
  };

  # Workaround home-manager bug
  # - https://github.com/nix-community/home-manager/issues/2033
  news = {
    display = "silent";
    entries = lib.mkForce [ ];
  };

  nix = {
    package = pkgs.nixVersions.latest;
  };

  programs = {
    home-manager.enable = true;
    micro = {
      enable = true;
      settings = {
        autosu = true;
        diffgutter = true;
        paste = true;
        rmtrailingws = true;
        savecursor = true;
        saveundo = true;
        scrollbar = true;
        scrollbarchar = "░";
        scrollmargin = 4;
        scrollspeed = 1;
      };
    };
  };
}
