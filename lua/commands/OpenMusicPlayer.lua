local function assign_command()
    local object = require("framework.components.object")
    
    vim.api.nvim_create_user_command("OpenMusicPlayer", function(opts)
        object.create_object("frame", "50%", 50, 50)
    end, {
        nargs = 0
    })
end

return {
    assign_command = assign_command
}