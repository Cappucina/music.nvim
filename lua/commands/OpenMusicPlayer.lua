local Popup, Layout = require("nui.popup"), require("nui.Layout")

local function assign_command()
    vim.api.nvim_create_user_command("OpenMusicPlayer", function(opts)
        local background = Popup({
            enter = true,
            border = "single" -- "double" is applicable
        })

        local layout = Layout(
            {
                position = "50%",
                size = {
                    width = 80,
                    height = "60%"
                },
            },
            Layout.Box({
                Layout.Box(background, {
                    size = "40%"
                }),
            }, {
                size = "40%"
            }),
        )
    end, {
        nargs = 0
    })
end

return {
    assign_command = assign_command
}