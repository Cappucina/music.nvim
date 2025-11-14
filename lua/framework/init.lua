local object = require("framework.components.object")
local clone_methods = require("utility").clone_methods

local objects = {}
local framework = {
    objects = objects
}

local function clone_and_merge(target, ...)
    local sources = {...}
    for _, source in ipairs(sources) do
        local cloned = clone_methods(source)
        for key, value in pairs(cloned) do
            target[key] = value
        end
    end
    return target
end

clone_and_merge(framework, object)