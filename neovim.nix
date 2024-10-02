{ pkgs, ...}:
{
  programs.neovim =
  let
    toLua = str: "lua << EOF\n${str}\nEOF\n";
    # toLuaFile = file: "lua << EOF\n${builtins.readFile file}}\nEOF\n";
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
      texpresso-vim
      coc-pyright
      vim-airline
      vim-airline-themes
      vim-devicons
			{
				plugin = (nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-fish
          p.tree-sitter-lua
          p.tree-sitter-scheme
          p.tree-sitter-python
          p.tree-sitter-json
          p.tree-sitter-c
          p.tree-sitter-cpp
          p.tree-sitter-latex
          p.tree-sitter-html
          p.tree-sitter-markdown
        ]));
        config = toLua ''
				require('nvim-treesitter.configs').setup {
					ensure_installed = {},
					auto_install = false,
					highlight = { enable = true },
					indent = { enable = true },
				}'';
			}
      telescope-fzf-native-nvim
      {
        plugin = telescope-nvim;
        config = toLua ''
				local builtin = require('telescope.builtin')
				vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
				vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
				vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
				vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

				require('telescope').setup({
					extensions = {
						fzf = {
							fuzzy = true,                    -- false will only do exact matching
							override_generic_sorter = true,  -- override the generic sorter
							override_file_sorter = true,     -- override the file sorter
							case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
						                                 -- the default case_mode is "smart_case"

    				}
  				}
				})

				require('telescope').load_extension('fzf')'';
      }
      {
        plugin = telescope-file-browser-nvim;
        config = toLua "require(\"telescope\").load_extension(\"file_browser\")";
      }
      {
        plugin = telescope-project-nvim;
        config = toLua "require(\"telescope\").load_extension(\"project\")";
      }
      {
        plugin = telescope-github-nvim;
        config = toLua "require(\"telescope\").load_extension(\"gh\")";
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
