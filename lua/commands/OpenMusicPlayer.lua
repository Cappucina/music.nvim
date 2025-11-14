local function assign_command()
    
    
    vim.api.nvim_create_user_command("OpenMusicPlayer", function(opts)
        
    end, {
        nargs = 0
    })
end

return {
    assign_command = assign_command
}