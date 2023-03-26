{ pkgs, config, modulesPath, ... }:

let
  #nixvim = import (builtins.fetchGit {
  #  url = "https://github.com/pta2002/nixvim";
  #});
  nixos-wsl = import ./nixos-wsl;
in
{
  imports = [
    #nixvim.nixosModules.nixvim
    nixos-wsl.nixosModules.wsl
    <home-manager/nixos>
  ];

  wsl = {
    enable = true;
    nativeSystemd = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "i97henka";
    startMenuLaunchers = true;

    # Enable native Docker support
    # docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  users.users.i97henka = {
    isNormalUser = true;
    extraGroups = [ "wheel"];
  };


  home-manager.users.i97henka = { pkgs, ... }: {
    home.stateVersion = "22.11";
    home.packages = [ pkgs.jq pkgs.ripgrep pkgs.gh ];
    home.sessionVariables =  {
      DONT_PROMPT_WSL_INSTALL = "YES";
    };
    nixpkgs.config.allowUnfree = true;
    programs.bash = {
      enable = true;
      shellAliases = {
        ll = "ls -l";
        ".." = "cd ..";
        gst = "git status";
        glo = "git log --oneline";
        gfa = "git fetch --all";
        ggfl = "git push --force-with-lease";
      };
    };

    programs.git.enable = true;
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    programs.fzf.enable = true;
    programs.bat.enable = true;

    programs.vscode  = {
      enable = true;
      package = pkgs.vscode;
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
	      mechatroner.rainbow-csv
        github.copilot
      ];
    };

    programs.firefox.enable = true;

    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      extraConfig = ''
        set number
      '';
    };
  };

  services.gnome.gnome-keyring.enable = true;

  environment.systemPackages = with pkgs; [
    bat
    git
    vim
    gnome.seahorse
    wget
  ];

  programs.nix-ld.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "curses";
  };

  system.stateVersion = "22.11";
}
