
local opt = vim.opt
local g = vim.g

---@diagnostic disable: unused-local
local jkglobal = require'jkglobal'

--- nvim-tree wants these disabled ---
g.loaded_netrw = 1                 ---
g.loaded_netrwPlugin = 1           ---
--- nvim-tree wants these disabled ---

opt.cmdheight = 1
--- vcmd.let[[g:echodoc#enable_at_startup = 1]]
--- vcmd.let[[g:echodoc#type = "echo"]]
--- vcmd.let[[g:echodoc#type = "floating"]]
--- vcmd.let[[g:echodoc#floating_config = {'border': 'single'}]]
--- vcmd.highlight[[link EchoDocFloat Pmenu]]


--- coc ---
opt.backup = false
opt.writebackup = false
opt.updatetime = 444
-----------
jk.conf.tsminimal = true
jk.pkgs = require'pkgs'
jk.isbs = jk.pkgs.isbootstrapped

g.mapleader = ' '

jk.keys = require'keys'
if jk.isbs
then jk.keys:bindall()
else jk.keys:bindnative() end

opt.clipboard:append[[unnamedplus]]
g.clipboard = {
    name = 'pwsh_cliboard',
    copy = {
        ['+'] = { 'win32yank.exe', '-i' },
        ['*'] = { 'win32yank.exe', '-i' },
    },
    paste = {
        ['+'] = 'win32yank.exe -o',
        ['*'] = 'win32yank.exe -o',
    }
}

opt.number = true
opt.relativenumber = true
-- opt.numberwidth = 3
opt.signcolumn = 'number'

opt.autoindent = true
opt.smarttab = true


opt.spelllang = 'en,cjk'
opt.spellsuggest = 'best,9'

opt.expandtab = true
opt.tabstop = 4
opt.cindent = true
opt.cinkeys = [[0{,0},0),0],0#,!^F,o,O,e]]
opt.cinoptions = [[s,e0,n0,f0.5s,{0,}0,^0,L0,:s,=s,]] .. --- L-1,=s,:s,f0
                 [[l1,i0,b0,gs,h0,N0,E0,ps,t0,+0]] .. --- l0,is,+s,ps,ts,hs
                 [[c1,C1,/0,(s,us,U1,w0,Ws,ks,]]   .. --- (2s,U0,k0,c3,C0,W0
                 [[m1,j1,J1,)20,*70,#0,P0]]           --- m0,j0,J0
opt.softtabstop = 4
opt.shiftwidth = 4
opt.shiftround = true

opt.termguicolors = true

opt.foldmethod = [[marker]]
opt.foldlevelstart = 1
opt.mouse:append[[c]] --- 'mouse' string (default "nvi")
opt.selectmode:append[[mouse]]
opt.colorcolumn = [[99]]
opt.splitright = true
opt.splitbelow = true
opt.completeopt = [[noinsert,menuone,noselect,preview]]
opt.ttimeoutlen = 0
opt.wildmenu = true
opt.sessionoptions = [[blank,buffers,curdir,folds,help,tabpages,winsize]]
if jk.isbs
    then opt.wildoptions:append[[fuzzy]] end

opt.grepprg = [[rg --vimgrep --no-heading --smart-case --pcre2 --context=1]]
opt.grepformat = [[%f:%l:%c:%m,%f:%l:%m]]

vcmd([===[
let &shell = 'pwsh'
let &shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command ]===]..
[===[[Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::]===]..
[===[new();$PSDefaultParameterValues[''Out-File:Encoding'']=''utf8'';]===]..
[===[Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
let &shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
let &shellpipe  = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
set shellquote= shellxquote=
]===])

--[======[
opt.shell = [[pwsh]]
opt.shellcmdflag = [[-NoLogo -ExecutionPolicy RemoteSigned -Command ]]
                .. [[[Console]::InputEncoding=]]
                ..     [[[Console]::OutputEncoding=]]
                ..         [[[System.Text.UTF8Encoding]::new();]]
                .. [[$PSDefaultParameterValues['Out-File:Encoding']='utf8';]]
                .. [[Remove-Alias -Force -ErrorAction SilentlyContinue tee;]]
opt.shellredir = [[2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode]]
opt.shellpipe  = [[2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode]]
opt.shellquote  = [[]]
opt.shellxquote = [[]]
--]======]



vim.cmd[[filetype plugin indent on]]

if jk.isbs then
    jk.conf.treesitter = require'pkgs.nvim-treesitter'
    jk.conf.nightfox = require'pkgs.nightfox'
    jk.conf.sessionmgr = require'pkgs.neovim-session-manager'
    jk.conf.dap = require'pkgs.nvim-dap'
    jk.conf.notify = require'pkgs.nvim-notify'
    jk.conf.nvimtree = require'pkgs.nvim-tree'
    jk.conf.lualine = require'pkgs.lualine'
    jk.conf.autopairs = require'pkgs.autopairs'
    jk.conf.indentblankline = require'pkgs.indent-blankline'
end

vim.cmd[[colorscheme duskfox]]

vim.fn.setreg('c', [[^i--- kd]])
vim.fn.setreg('u', [[^ikDkDkDkDkd]])
vim.fn.setreg('x', [[]])

vapi.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
    pattern = '*.start*layout',
    command = 'setlocal ft=xml',
})

