local P = { }

P.autopacker = require'pkgs.auto-packer'

P.isbootstrapped = P.autopacker:init{
    {
        [[nvim-lualine/lualine.nvim]],
        requires = { [[nvim-tree/nvim-web-devicons]], opt = true },
    },
    {
        [[nvim-tree/nvim-tree.lua]],
        requires = { [[nvim-tree/nvim-web-devicons]] },
    },
    {
        [[nvim-telescope/telescope.nvim]],
        tag = '0.1.2',
        requires = { { [[nvim-lua/plenary.nvim]] } },
    },
    {
        [[Shatur/neovim-session-manager]],
        requires = { { [[nvim-lua/plenary.nvim]] } },
    },
    {
        [[nvim-telescope/telescope-fzf-native.nvim]],
        run = [[make]],
    },
    {
        [[neoclide/coc.nvim]], branch = [[release]],
    },
    --- { [[windwp/nvim-autopairs]] },
    { [[mfussenegger/nvim-dap]] },
    { [[lukas-reineke/indent-blankline.nvim]] },
    { [[nvim-treesitter/nvim-treesitter]] },
    --- { [[simrat39/symbols-outline.nvim]] },
    { [[norcalli/nvim-colorizer.lua]] },
    { [[EdenEast/nightfox.nvim]] },
    { [[rcarriga/nvim-notify]] },
    --- { [[liuchengxu/vista.vim]] },
    --- { [[Shougo/echodoc.vim]] },
    { [[RRethy/nvim-align]] },
    { [[fannheyward/telescope-coc.nvim]] },
    { [[folke/twilight.nvim]] },
    --- { [[neovim/nvim-lspconfig]] },
 }

return P
