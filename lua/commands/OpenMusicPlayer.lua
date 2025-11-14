local Popup, Layout = require("nui.popup"), require("nui.layout")

local function assign_command()
    vim.api.nvim_create_user_command("OpenMusicPlayer", function(opts)
        local background = Popup({
            enter = true,
            border = "shadow",
            position = "50%",
            size = {
                width = "80%",
                height = "65%"
            }
        })

        background:mount()
    end, {
        nargs = 0
    })
end

return {
    assign_command = assign_command
}