local Popup, Layout = require("nui.popup"), require("nui.layout")

local function assign_command()
    -- highlight groups
    vim.api.nvim_set_hl(0, "MatteBlackPopup", { bg = "#000000", fg = "#ffffff" })
    vim.api.nvim_set_hl(0, "MatteBlackBorder", { bg = "#000000", fg = "#ffffff" })
    
    vim.api.nvim_create_user_command("OpenMusicPlayer", function(opts)
        local background = Popup({
            enter = true,
            border = "double",
            position = "50%",
            size = {
                width = "80%",
                height = "65%"
            },
            win_options = {
                winhighlight = "Normal:MatteBlackPopup,FloatBorder:MatteBlackBorder"
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