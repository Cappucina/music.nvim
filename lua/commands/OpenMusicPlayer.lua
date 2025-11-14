local Popup = require("nui.popup")
local Layout = require("nui.layout")
local Input = require("nui.input")

local event = require("nui.utils.autocmd").event

local function assign_command()
    vim.api.nvim_set_hl(0, "MatteBlackPopup", { bg = "#000000", fg = "#ffffff" })
    vim.api.nvim_set_hl(0, "MatteBlackBorder", { bg = "#000000", fg = "#ffffff" })
    vim.api.nvim_set_hl(0, "PopupTitle", { bg = "#000000", fg = "#ffffff", bold = true })
    vim.api.nvim_set_hl(0, "PopupDesc", { bg = "#000000", fg = "#cccccc" })
    
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

        -- TITLE --
        vim.api.nvim_buf_set_lines(background.bufnr, 0, 1, false, { " Neovim Music Player" })
    
        -- SEARCH BAR --
        local search_bar = Input({
            position = "50%",
            size = {
                width = 20
            },
            relative = "editor",
            border = {
                style = "single"
            },
            win_options = {
                winhighlight = "Normal:Normal,FloatBorder:Normal"
            },
        }, {
            prompt = "> ",
            default_value = "",
            on_submit = function(value)
                print("submitted: " .. value)
                -- background:unmount()
            end,
        })

        search_bar:mount()
    end, {
        nargs = 0
    })
end

return {
    assign_command = assign_command
}