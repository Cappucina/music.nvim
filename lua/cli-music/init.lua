local KeybindManager = require("core.KeybindManager")

require("dependencies")

local uv = vim.loop
local cwd = uv.cwd()

local function require_dir(dir, module_prefix, skip_files)
    module_prefix = module_prefix or ""
    skip_files = skip_files or {}

    for _, file in ipairs(vim.fn.readdir(dir)) do
        local full_path = dir .. "/" .. file
        local stat = uv.fs_stat(full_path)
        if not stat then goto continue end

        if stat.type == "file" and file:match("%.lua$") then
            if not vim.tbl_contains(skip_files, file) then
                local mod_name = module_prefix .. file:gsub("%.lua$", "")
                require(mod_name)
                print("loaded: " .. mod_name)
            end
        elseif stat.type == "directory" then
            require_dir(full_path, module_prefix .. file .. ".", skip_files)
        end

        ::continue::
    end
end

require_dir(cwd .. "/lua/core", "core.", { "KeybindManager.lua" })
require_dir(cwd .. "/lua/cli-music", "cli-music.", { "init.lua" })
require_dir(cwd .. "/lua", "", { "dependencies.lua" })

KeybindManager.load()