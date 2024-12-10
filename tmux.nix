{ pkgs, config, ... }: {
  programs.tmux = {
    enable = true;
    shortcut = "a";
    aggressiveResize = true;
    baseIndex = 1;
    newSession = true;
    # Stop tmux+escape craziness.
    escapeTime = 0;
    shell = "${pkgs.zsh}/bin/zsh";
    # Force tmux to use /tmp for sockets (WSL2 compat)
    secureSocket = false;
    keyMode = "vi";
    terminal = "screen-256color";

    extraConfig = ''
      set -g renumber-windows on

      bind-key -n c-g send-prefix
      bind-key -n c-t send-keys c-g    

      # pane navigation
      bind -r h select-pane -L  # move left
      bind -r j select-pane -D  # move down
      bind -r k select-pane -U  # move up
      bind -r l select-pane -R  # move right
      bind > swap-pane -D       # swap current pane with the next one
      bind < swap-pane -U       # swap current pane with the previous one

      # pane resizing
      bind -r H resize-pane -L 2
      bind -r J resize-pane -D 2
      bind -r K resize-pane -U 2
      bind -r L resize-pane -R 2

      # window navigation
      unbind n
      unbind p
      bind -r C-h previous-window # select previous window
      bind -r C-l next-window     # select next window
      bind Tab last-window        # move to last active window
      bind + run 'cut -c3- ~/.tmux.conf | sh -s _maximize_pane "#{session_name}" #D'
    '';
  };
}
