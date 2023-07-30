vim.notify = require'notify'

require[[notify]].setup{
    background_color = [[#000000]],
    minimum_width = 10,
    render = [[simple]],
    stages = [[slide]],
    top_down = false,
    timeout = 5000
}

