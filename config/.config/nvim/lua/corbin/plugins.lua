-- Initialize lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- define plugins
require('lazy').setup({
    -- Colorscheme
    { "ellisonleao/gruvbox.nvim", priority = 1000 },
    -- LSP
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        dependencies = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' }, -- Required
            {
                                 -- Optional
                'williamboman/mason.nvim',
                build = function()
                    pcall(vim.cmd, 'MasonUpdate')
                end,
            },
            { 'williamboman/mason-lspconfig.nvim' }, -- Optional

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' }, -- Required
            { 'hrsh7th/cmp-nvim-lsp' }, -- Required
            { 'L3MON4D3/LuaSnip' }, -- Required
        }
    },

    -- Fuzzy Finder
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.1',
        dependencies = { 'nvim-lua/plenary.nvim' }
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate"
    },
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            init = function()
                -- PERF: no need to load the plugin, if we only need its queries for mini.ai
                local plugin = require("lazy.core.config").spec.plugins["nvim-treesitter"]
                local opts = require("lazy.core.plugin").values(plugin, "opts", false)
                local enabled = false
                if opts.textobjects then
                    for _, mod in ipairs({ "move", "select", "swap", "lsp_interop" }) do
                        if opts.textobjects[mod] and opts.textobjects[mod].enable then
                            enabled = true
                            break
                        end
                    end
                end
                if not enabled then
                    require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
                end
            end,
        },
    }
})
