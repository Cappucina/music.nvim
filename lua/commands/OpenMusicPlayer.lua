local Popup, Layout = require("nui.popup"), require("nui.layout")

local function assign_command()
    vim.api.nvim_create_user_command("OpenMusicPlayer", function(opts)
        local background = Popup({
            enter = true,
            border = "single", -- "double" is applicable
            win_options = {
                winhighlight = "NormalFloat:BlackFloat,FloatBorder:BlackFloatBorder"
            }
        })

        vim.api.nvim_set_hl(0, "BlackFloat", { bg = "#000000", fg = "#ffffff" })
        vim.api.nvim_set_hl(0, "BlackFloatBorder", { bg = "#000000", fg = "#ffffff" })

        local layout = Layout(
            {
                position = "50%",
                size = {
                    width = "75%",
                    height = "80%"
                },
            },
            Layout.Box({})
        )

        layout:mount()
    end, {
        nargs = 0
    })
end

return {
    assign_command = assign_command
}