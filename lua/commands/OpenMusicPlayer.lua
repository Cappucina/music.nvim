vim.api.nvim_create_user_command("test123", function(opts)
    print("works")
end, {
    nargs = 0
})

vim.api.nvim_create_user_command("OpenMusicPlayer", function(opts)
    local Input = require("nui.input")
    local event = require("nui.utils.autocmd").event

    local input = Input({
        position = "50%",
        size = {
            width = 20,
        },
        border = {
            style = "single",
            text = {
                top = "[Howdy?]",
                top_align = "center",
            },
        },
        win_options = {
            winhighlight = "Normal:Normal,FloatBorder:Normal",
        },
        }, {
            prompt = "> ",
            default_value = "Hello",
            on_close = function()
                print("Input Closed!")
            end,
            on_submit = function(value)
                print("Input Submitted: " .. value)
            end,
        })

        input:mount()

        input:on(event.BufLeave, function()
        input:unmount()
    end)
end, {
    nargs = 0
})