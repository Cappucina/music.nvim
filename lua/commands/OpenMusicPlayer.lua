local function assign_command()
    local framework = require("framework.init")
    
    vim.api.nvim_create_user_command("OpenMusicPlayer", function(opts)
        framework.create_object("frame", "50%", 150, 150)
    end, {
        nargs = 0
    })
end

return {
    assign_command = assign_command
}