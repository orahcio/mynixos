{ pkgs, ...}:
{
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
    # Corretor ortográfico ref.: https://andreztz.github.io/neovim_spell_check/
    extraConfig = ''
      set number
      set tabstop=2
      set softtabstop=0 noexpandtab
      set shiftwidth=2
      set spell spelllang=pt_br,en " veja referência acima
      set linebreak " precisa ligar o linebreak para o comando abaixo funcionar
      set breakat=\ \ ;:,!? " caracteres os quais o texto pode quebrar
      set breakindent " para o texto quebrar e seguir a indentação
    '';  
    # extraLuaConfig = ''
      # ${builtins.readFile ./lazy.lua}
    # '';
    extraPython3Packages = pyPkgs: with pyPkgs; [
      python-lsp-server
      pynvim
      ];
    plugins = with pkgs.vimPlugins; [
      nvim-treesitter.withAllGrammars
      texpresso-vim
      coc-pyright
      vim-airline
      vim-airline-themes
      vim-devicons
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
        config = toLua "require(\"telescope\").load_extension(\"file_browser\")";
      }
      {
        plugin = telescope-project-nvim;
        config = toLua "require(\'telescope\').load_extension(\'project\')";
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
      texpresso
    ];
  };
}