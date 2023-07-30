---- nvim-dap.init.lua
local D = {}
------------------------------------------------------------------


D.dap = require'dap'

---@diagnostic disable-next-line
D.dap.adapters.godot = {
    type = [[server]],
    host = [[127.0.0.1]],
    port = 6006,
}

D.dap.configurations.gdscript = {
    {
        type = "godot",
        request = "launch",
        name = "Launch scene",
        project = "${workspaceFolder}",
        launch_scene = true,
    }
}


------------------------------------------------------------------
return D
------------------------------------------------------------------
