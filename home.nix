{ pkgs, lib, ... }:
{

  # The home-manager manual is at:
  #
  #   https://rycee.gitlab.io/home-manager/release-notes.html
  #
  # Configuration options are documented at:
  #
  #   https://rycee.gitlab.io/home-manager/options.html

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  #
  # You need to change these to match your username and home directory
  # path:
  home.username = "orahcio";
  home.homeDirectory = "/home/orahcio";

  # If you use non-standard XDG locations, set these options to the
  # appropriate paths:
  #
  # xdg.cacheHome
  # xdg.configHome
  # xdg.dataHome

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";

  # Since we do not install home-manager, you need to let home-manager
  # manage your shell, otherwise it will not be able to add its hooks
  # to your profile.
  programs.home-manager.enable = true;
  
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      complete -F _command doas
    '';
  };
  
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fastfetch
    '';
  };
  
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      "$schema" = "https://starship.rs/config-schema.json";

      format = lib.concatStrings [
        "[](color_orange)"
        "$os"
        "$username"
        "[](bg:color_yellow fg:color_orange)"
        "$directory"
        "[](fg:color_yellow bg:color_aqua)"
        "$git_branch"
        "$git_status"
        "[](fg:color_aqua bg:color_blue)"
        "$c"
        "$rust"
        "$golang"
        "$nodejs"
        "$php"
        "$java"
        "$kotlin"
        "$haskell"
        "$python"
        "[](fg:color_blue bg:color_bg3)"
        "$docker_context"
        "$conda"
        "[](fg:color_bg3 bg:color_bg1)"
        "$time"
        "[ ](fg:color_bg1)"
        "$line_break$character"
      ];
      right_format = "$cmd_duration";

      add_newline = true;

      palette = "gruvbox_dark";

      palettes.gruvbox_dark = {
        color_fg0 = "#fbf1c7";
        color_bg1 = "#3c3836";
        color_bg3 = "#665c54";
        color_blue = "#458588";
        color_aqua = "#689d6a";
        color_green = "#98971a";
        color_orange = "#d65d0e";
        color_purple = "#b16286";
        color_red = "#cc241d";
        color_yellow = "#d79921";
      };

      os = {
        disabled = false;
        style = "bg:color_orange fg:color_fg0";
      };

      os.symbols = {
        Windows = "󰍲";
        Ubuntu = "󰕈";
        SUSE = "";
        Raspbian = "󰐿";
        Mint = "󰣭";
        Macos = "󰀵";
        Manjaro = "";
        Linux = "󰌽";
        Gentoo = "󰣨";
        Fedora = "󰣛";
        Alpine = "";
        Amazon = "";
        Android = "";
        Arch = "󰣇";
        Artix = "󰣇";
        CentOS = "";
        Debian = "󰣚";
        Redhat = "󱄛";
        RedHatEnterprise = "󱄛";
      };

      username = {
        show_always = true;
        style_user = "bg:color_orange fg:color_fg0";
        style_root = "bg:color_orange fg:color_fg0";
        format = "[ $user ]($style)";
      };
      
      directory = {
        style = "fg:color_fg0 bg:color_yellow";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      directory.substitutions = {
        "Documentos" = "󰈙 ";
        "Downloads" = " ";
        "Music" = "󰝚 ";
        "Pictures" = " ";
        "Projetos" = "󰲋 ";
      };

      git_branch = {
        symbol = "";
        style = "bg:color_aqua";
        format = "[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)";
      };

      git_status = {
      style = "bg:color_aqua";
      format = "[[($all_status$ahead_behind )](fg:color_fg0 bg:color_aqua)]($style)";
      };

      nodejs = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      c = {
        symbol = " ";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      rust = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      golang = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      java = {
        symbol = " ";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      kotlin = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      haskell = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      python = {
        symbol = "";
        style = "bg:color_blue";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_blue)]($style)";
      };

      docker_context = {
        symbol = "";
        style = "bg:color_bg3";
        format = "[[ $symbol( $context) ](fg:#83a598 bg:color_bg3)]($style)";
      };

      conda = {
        style = "bg:color_bg3";
        format = "[[ $symbol( $environment) ](fg:#83a598 bg:color_bg3)]($style)";
      };
      
      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:color_bg1";
        format = "[[  $time ](fg:color_fg0 bg:color_bg1)]($style)";
      };
      
      cmd_duration = {
        min_time = 500;
        style = "bg:color_bg1";
        format = "[](fg:color_bg1)[[ ⧗ $duration ](fg:color_fg0 bg:color_bg1)]($style)";
      };
      
      line_break = {
        disabled = false;
      };

      character = {
        disabled = false;
        success_symbol = "[](bold fg:color_green)";
        error_symbol = "[](bold fg:color_red)";
        vimcmd_symbol = "[](bold fg:color_green)";
        vimcmd_replace_one_symbol = "[](bold fg:color_purple)";
        vimcmd_replace_symbol = "[](bold fg:color_purple)";
        vimcmd_visual_symbol = "[](bold fg:color_yellow)";
      };

    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };
  
  programs.git = {
    enable = true;
    userName = "orahcio";
    userEmail = "orahcio@gmail.com";
  };
  
  programs.neovim =
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    toLuaFile = file: "lua << EOF\n${builtins.readFile file}}\nEOF\n";
  in  
  {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    # extraConfig = ''
      # set number relativenumber
    # '';  
    # extraLuaConfig = ''
      # ${builtins.readFile ./lazy.lua}
    # '';
    plugins = with pkgs.vimPlugins; [
      {
        plugin = telescope-nvim;
        config = toLua ''
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})'';
      }
      nvim-treesitter
      vim-devicons
      coc-pyright
      {
        plugin = telescope-file-browser-nvim;
        config = toLua "require(\"telescope\").load_extension \"file_browser\"";
      }
      {
        plugin = telescope-project-nvim;
        config = toLua "require\'telescope\'.load_extension(\'project\')";
      }
      {
        plugin = telescope-github-nvim;
        config = toLua "require(\'telescope\').load_extension(\'gh\')";
      }
      {
        plugin = comment-nvim;
        config = toLua "require(\"Comment\").setup()";
      }
      {
        plugin = gruvbox-nvim;
        config = "colorscheme gruvbox";
      }
    ];
    extraPackages = with pkgs; [
      wl-clipboard
      gh
      ripgrep
      fd
    ];
  };

  # programs.nixvim = {
  #   enable = true;

  #   colorschemes.gruvbox.enable = true;
  #   plugins.lightline.enable = true;
  # };

  programs.firefox = {
    enable = true;
  };
  programs.qutebrowser = {
    enable = true;
    searchEngines = {
      DEFAULT = "https://duckduckgo.com/?t=h_&q={}&ia=web";
      nixpkgs = "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query={}";
      nw = "https://nixos.wiki/index.php?search={}&go=Go";
      mynix = "https://mynixos.com/search?q={}";
      pip = "https://pypi.org/search/?q={}";
      yt = "https://www.youtube.com/results?search_query={}";
      gg = "https://www.google.com/search?q={}";
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  # Montar Googledrive com ocamfuse depois de se conectar a internet
  # Lembrar que só faz sentido depois de configurar o google-drive-ocamfuse
  systemd.user.services.orahcioDrive = {
    # assim que tiver online o serviço excecuta
    Unit = {
      After = [ "network.target" ];
      Description = "Montar meu drive pessoal assim que logar na rede";
    };
    Service = {
      Type = "forking";
      User = "orahcio";
      ExecStart = ''${pkgs.google-drive-ocamlfuse}/bin/google-drive-ocamlfuse /home/orahcio/GoogleDrive'';
      ExecStop = ''fusermount -u /home/orahcio/GoogleDrive'';
      Restart = "always";
    };
    # só inicia o serviço depois que fazer o login
    Install.WantedBy = [ "default.target" ];
  };

  home.packages = with pkgs; [
    tectonic
    typst
    typst-live
    lyx
    tor-browser-bundle-bin
    google-chrome
    microsoft-edge
    xournalpp
    inkscape
    gimp
    krita
    gImageReader
    kitty
    jabref
    poppler_utils
    manim
    # labplot
    google-drive-ocamlfuse
    lynx
    ncgopher
    zapzap
    evolution
    hexchat
    maelstrom
    presenterm
    tmux
    (python3.withPackages(ps: with ps; [
      setuptools
      cython
      pyzmq
      ipykernel
      numpy
      matplotlib
      scipy
      ffmpeg-python
      sympy
      ipympl
      pandoc
      nbconvert
      pandas
      openpyxl
    ]))
  ];

}

