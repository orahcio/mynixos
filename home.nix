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
  home.stateVersion = "24.05";
  
  # Para permitir pacotes unfree pra serem instalados
  nixpkgs.config.allowUnfree = true;

  # Since we do not install home-manager, you need to let home-manager
  # manage your shell, otherwise it will not be able to add its hooks
  # to your profile.
  programs.home-manager.enable = true;
  
  # Direnv (ref. SergeK https://discourse.nixos.org/t/reproducible-direnv-setup-on-nixos/20006/2)
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      complete -F _command doas
    '';
  };
  
programs.eza = {
  enable = true;
  enableFishIntegration = true;
  extraOptions = [
    "--group-directories-first"
    "--header"
  ];
  icons = true;
};

  programs.bat.enable = true;

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
      fastfetch
    '';
    functions = {
      llama_run = {
        body = ''
        set -l __args $argv
        ollama run llama3 $__args'';
      };
    };
  };
  
  programs.starship = import ./starship.nix;
  
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
    extraPython3Packages = pyPkgs: with pyPkgs; [
      python-lsp-server
      pynvim
      ];
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter
      vim-devicons
      coc-pyright
      vim-airline
      vim-airline-themes
      {
        plugin = telescope-nvim;
        config = toLua ''
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})'';
      }
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

  # programs.firefox.enable = true;

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

  
  home.packages = with pkgs; [
    xournalpp
    texpresso
    inkscape
    #gimp
    jabref
    poppler_utils
    libreoffice-qt
    hunspell
    hunspellDicts.pt_BR
    hunspellDicts.en_US
    # labplot
    hexchat
    maelstrom
    twtxt
    #tor-browser
    # Coisas de email
    thunderbird
    neomutt
  ];

}

