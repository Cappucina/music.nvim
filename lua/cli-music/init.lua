local cli_music = {}

cli_music.setup() = function()
    local KeybindManager = require("core.KeybindManager")

    require("dependencies")
    require("commands.OpenMusicPlayer").assign_command()

    KeybindManager.load()
end