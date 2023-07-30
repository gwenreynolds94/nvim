local A = {}


A.git_url = 'https://github.com/wbthomason/packer.nvim'
A.plugin_dir_start = vim.fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
A.plugin_dir_opt = vim.fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
A.alreadybootstrapped = false
A.bootstrapped = false
A.gitresult = nil

A.pkgs = {
    { [[wbthomason/packer.nvim]], opt = true },
    insert = tb.insert,
}

function A.pkgs:addpkglist(_pkg_list)
    for _, _pkg in ipairs(_pkg_list or {}) do
        A.pkgs:insert(_pkg)
    end
end

function A:has_opt_dir()
    return (vim.fn.empty(vim.fn.glob(A.plugin_dir_opt)) < 1)
end

function A:has_start_dir()
    return (vim.fn.empty(vim.fn.glob(A.plugin_dir_start)) < 1)
end

function A:startup(_gitres)
    if not _gitres then
        A.bootstrapped = false
    else
        A:packadd()
        require'packer'.startup(function(use)
            for _, _pkg in ipairs(A.pkgs)
                do use(_pkg) end
            if not A.alreadybootstrapped then
                require'packer'.sync()
                require'packer'.update() end
        end)
        A.bootstrapped = true
    end
end
function A:clonerepo()
    local hndl
    hndl = vim.loop.spawn('git', {
        args = {
                'clone',
                A.git_url,
                A.plugin_dir_opt,
            },
        },
        vim.schedule_wrap(function(code, _)
            if hndl ~= nil then hndl:close() end
            A.gitresult = (code == 0)
            A:startup(A.gitresult)
        end)
    )
end
function A:packadd() vcmd[[packadd packer.nvim]] end

function A:sync()
    if A.bootstrapped
        then require'packer'.sync() end end


function A:init(_pkg_list)
    A.pkgs:addpkglist(_pkg_list)
    A.alreadybootstrapped = A:has_start_dir() or A:has_opt_dir()
    if not A.alreadybootstrapped
    then A:clonerepo()
    else A:startup(true) end
    return A.bootstrapped
end

return A
