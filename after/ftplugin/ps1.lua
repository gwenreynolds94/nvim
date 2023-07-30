---- ps1.lua
local P = {}
------------------------------------------------------------------

local cocfg = vfn['coc#config']

cocfg( 'semanticTokens.enable', false )

--[======[
vim.opt.shell = [[pwsh]]
vim.opt.shellcmdflag = [[-NoLogo -ExecutionPolicy RemoteSigned -Command ]]
                .. [[[Console]::InputEncoding=]]
                ..     [[[Console]::OutputEncoding=]]
                ..         [[[System.Text.UTF8Encoding]::new();]]
                .. [[$PSDefaultParameterValues['Out-File:Encoding']='utf8';]]
                .. [[Remove-Alias -Force -ErrorAction SilentlyContinue tee;]]
vim.opt.shellredir = [[2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode]]
vim.opt.shellpipe  = [[2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode]]
vim.opt.shellquote  = [[]]
vim.opt.shellxquote = [[]]
--]======]


------------------------------------------------------------------
_G.jk.ftplugin = {}
_G.jk.ftplugin.ps1 = P
------------------------------------------------------------------
