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
  home.packages = [
    pkgs.autoconf
    pkgs.autogen
    pkgs.automake
    pkgs.awscli2
    pkgs.bash-completion
    pkgs.bashInteractive
    pkgs.bats
    pkgs.bottom
    hsp-bosh-cli
    pkgs.cloudfoundry-cli
    pkgs.credhub-cli
    pkgs.direnv
    pkgs.dos2unix
    pkgs.fzf
    pkgs.gawk
    pkgs.getopt
    pkgs.git
    pkgs.git-lfs
    pkgs.gnupg
    pkgs.htop
    pkgs.jq
    pkgs.kubectl
    pkgs.nmap
    pkgs.pwgen
    pkgs.R
    pkgs.ripgrep
    pkgs.terraform
    pkgs.tree
    pkgs.wget
    pkgs.yq
  ];

  home.file = {
  };

  home.sessionPath = [
    "$HOME/.rd/bin"
    "$HOME/.cargo/bin"
    "$HOME/bin"
    "/opt/homebrew/bin"
  ];
  
  home.sessionVariables = {
    # EDITOR = "emacs";
    CPATH = "/opt/homebrew/include/";
    LIBRARY_PATH = "/opt/homebrew/lib";
  };

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
