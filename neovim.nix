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
      texpresso-vim
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
      xclip
      gh
      ripgrep
      fd
      texpresso
    ];
  };
}