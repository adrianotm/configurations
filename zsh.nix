{ config, pkgs, ... }: {
  config = {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "thefuck" "git" "ssh-agent" ];
        theme = "af-magic";

        extraConfig = ''
          eval "$(direnv hook zsh)"
        '';
      };
      shellAliases = {
        rmh = "cd ~/channable/requestmachine";
        shm = "cd ~/channable/sharkmachine";
        shmi = "cd ~/channable/sharkmachine-interface";
        jm = "cd ~/channable/jobmachine";
        img = "cd ~/channable/imaginator";
        fs = "cd ~/channable/feedscrubber";
      };
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
      };

    };
  };
}
