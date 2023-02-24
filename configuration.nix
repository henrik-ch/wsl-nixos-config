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
    defaultUser = "nixos";
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


  #programs.nixvim.enable = true;

  users.users.i97henka.isNormalUser = true;
  home-manager.users.i97henka = { pkgs, ... }: {
    home.stateVersion = "22.11";
    home.packages = [ pkgs.jq pkgs.ripgrep pkgs.gh ];
    programs.bash.enable = true;
    programs.git.enable = true;
    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;
    programs.fzf.enable = true;
    programs.bat.enable = true;
    
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
    #  plugins = with pkgs.vimPlugins; [
	#nvim-lspconfig
	#nvim-treesitter.withAllGrammars
	#plenary-nvim
	#gruvbox-material
	#mini-nvim
    #  ];
    };
  };


  environment.systemPackages = with pkgs; [
    bat
    git
    vim
  ];

  system.stateVersion = "22.11";
}
