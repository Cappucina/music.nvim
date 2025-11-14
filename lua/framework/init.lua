local object = require("framework.components.object")

local framework = {}

for key, value in pairs(object) do
    framework[key] = value
end

return framework