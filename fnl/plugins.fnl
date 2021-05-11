(module plugins
  {require-macros [macros]})
  
(packer-use
  :wbthomason/packer.nvim {}
  :Olical/aniseed {:branch "develop"}

  :gruvbox-community/gruvbox {}
  :noahfrederick/vim-noctu {}

  ; :romgrk/barbar.nvim {:mod "plugins.barbar"}

  :neovim/nvim-lspconfig {}

  :nvim-telescope/telescope.nvim {:cmd ["Telescope"]
                                  :requires [:nvim-lua/popup.nvim
                                             :nvim-lua/plenary.nvim]}

  :nvim-treesitter/nvim-treesitter {; :mod "plugins.treesitter"
                                    :run ":TSUpdate"}

  :bhurlow/vim-parinfer {}
  :Olical/conjure {})
