{ config, pkgs, ... }:

let   hsp-bosh-cli = pkgs.bosh-cli.overrideAttrs (oldAttrs: rec {
        version = oldAttrs.version;
        postPatch = ''
            substituteInPlace cmd/version.go --replace '[DEV BUILD]' 'hsdp-${version}'
            substituteInPlace vendor/github.com/cloudfoundry/config-server/types/certificate_generator.go --replace '(365' '(1095'
          '';
      });

in {
  
  home.username = "Jorgensen";
  home.homeDirectory = "/Users/Jorgensen";

  home.stateVersion = "22.11";
  home.packages = with pkgs; [
    autoconf
    autogen
    automake
    awscli2
    bash-completion
    bashInteractive
    bats
    bottom
    hsp-bosh-cli
    cloudfoundry-cli
    credhub-cli
    direnv
    dos2unix
    fzf
    gawk
    getopt
    git
    git-lfs
    gnupg
    htop
    jq
    keepassxc
    kubectl
    nmap
    pwgen
    R
    ripgrep
    slack
    terraform
    tree
    wget
    yq

    ((emacsPackagesFor emacs-git).emacsWithPackages (epkgs: [
      epkgs.auto-complete
      epkgs.company
      epkgs.company-irony
      epkgs.company-quickhelp
      epkgs.counsel
      epkgs.csv-mode
      epkgs.direnv
      epkgs.exec-path-from-shell
      epkgs.flycheck
      epkgs.flycheck-irony
      epkgs.irony-eldoc
      epkgs.js2-mode
      epkgs.gptel
      epkgs.magit
      epkgs.markdown-mode
      epkgs.multi-vterm
      epkgs.nix-mode
      epkgs.org-tree-slide
      epkgs.platformio-mode
      epkgs.popup
      epkgs.projectile
      epkgs.rust-mode
      epkgs.toml-mode
      epkgs.vterm
      epkgs.yaml-mode
      epkgs.yasnippet
      epkgs.yasnippet-snippets
      epkgs.web-mode
      # The nixpkgs irony package seems to function ok.
      # emacsPackages.irony
      # emacsPackages.platformio-mode
      # emacsPackages.irony-eldoc
      # emacsPackages.flycheck-irony
      # emacsPackages.company-irony
    ]))
  ];

  home.file = {
  };

  home.sessionPath = [
    "$HOME/.rd/bin"
    "$HOME/.cargo/bin"
    "$HOME/bin"
  ];
  
  programs.bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [ "ignoredups" "ignorespace" ];
    shellAliases = {
      ls = "ls -G";
    };
    sessionVariables = {
      GIT_PS1_SHOWDIRTYSTATE = 1;
    };
    bashrcExtra = ''
# turn off terminal stop ctl-s
stty -ixon

# readline settings
bind 'set show-all-if-ambiguous on'
bind 'set menu-complete-display-prefix on'
bind 'set colored-completion-prefix on'
bind 'set colored-stats on'
bind 'TAB: menu-complete'
bind '"\e[Z": menu-complete-backward'

# aws completion
complete -C '$HOME/.nix-profile/bin/aws_completer' aws

# git completion
source $HOME/.nix-profile/share/git/contrib/completion/git-completion.bash

# There are many like it, but this one is mine.
# I can't seem to get this to work in the sessionVariables section
source $HOME/.nix-profile/share/git/contrib/completion/git-prompt.sh
PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]$(__git_ps1 " (%s)")\$\[\e[m\] \[\e[1;37m\]'
# PS1='\[\e[0;32m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] \[\e[1;37m\]'
# I prefer an empty PS2 for ease of copy paste
PS2=""
'';
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };
  
  programs.home-manager.enable = true;
}
