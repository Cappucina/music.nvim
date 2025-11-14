local objects = require("framework.init").objects

-- UI components created and handled with nui.nvim
local function create_object(class, position, width, height)
    local popup = require("nui.popup")
    local layout = require("nui.layout")

    if not width or width <= 0 then
        width = 150
    end
    if not height or height <= 0 then
        height = 150
    end

    local main_popup = popup({
        enter = true,
        border = "single" -- "double" works too
    })

    local main_layout = layout(
        {
            position = position,
            size = {
                width = width,
                height = height
            }
        }
    )

    main_layout:mount()
    table.insert(objects, {
        class = class,
        position = position,
        width = width,
        height = height
    })
end

local function remove_object()

end

local function clone_object(object)

end

return {
    create_object = create_object,
    remove_object = remove_object,
    clone_object = clone_object
}