local is_valid_mode = require("utility").is_valid_mode

-- Make managing keybinds in Neovim so much easier.
--[[

    <KeybindManager>.bind  (<Mode>, <Keybind>, <Callback>): <"Success": bool>
                    .rem   (<Keybind>): <"Success": bool>
                    .change(<Old_Keybind>, <New_Keybind>, <Callback>?): <"Success": bool>
                    .load  (): <void>

]]

local KeybindManager = {}
local binds = {}
local keys = {
    a="a", b="b", c="c", d="d", e="e", f="f", g="g", h="h", i="i", j="j",
    k="k", l="l", m="m", n="n", o="o", p="p", q="q", r="r", s="s", t="t",
    u="u", v="v", w="w", x="x", y="y", z="z",

    ["0"]="0", ["1"]="1", ["2"]="2", ["3"]="3", ["4"]="4", ["5"]="5",
    ["6"]="6", ["7"]="7", ["8"]="8", ["9"]="9",

    f1="F1", f2="F2", f3="F3", f4="F4", f5="F5", f6="F6", f7="F7", f8="F8",
    f9="F9", f10="F10", f11="F11", f12="F12",

    up="Up", down="Down", left="Left", right="Right",

    num0="Num0", num1="Num1", num2="Num2", num3="Num3", num4="Num4", num5="Num5",
    num6="Num6", num7="Num7", num8="Num8", num9="Num9", numenter="Enter",
    ["num+"]="+", ["num-"]="-", ["num*"]="*", ["num/"]="/",

    ctrl="C", control="C", lctrl="C", rctrl="C",
    alt="A", option="A", lalt="A", ralt="A",
    shift="S", lshift="S", rshift="S",
    cmd="D", super="D", meta="D",

    enter="CR", return_key="CR", space="Space", tab="Tab",
    esc="Esc", escape="Esc", backspace="BS", delete="Del", del="Del",
    home="Home", ["end"]="End", pageup="PageUp", pagedown="PageDown",

    ["-"]="-", ["="]="=", ["["]="[", ["]"]="]", ["\\"]="\\", [";"]=";", ["'"]="'",
    [","]=",", ["."]=".", ["/"]="/", ["`"]="`", ["~"]="~",
    ["!"]="!", ["@"]="@", ["#"]="#", ["$"]="$", ["%"]="%", ["^"]="^",
    ["&"]="&", ["*"]="*", ["("]="(", [")"]=")", ["_"]="_", ["+"]="+",
    ["|"]="|", [":"]=":", ['"']='"', ["<"]="<", [">"]=">"
}

KeybindManager.bind = function(mode, keybind, callback)
    local success, err = pcall(function()
        if not is_valid_mode(mode) then
            mode = "n"
        end

        table.insert(binds, {
            mode = mode,
            keybind = keybind,
            callback = callback,
        })
    end)

    if not success then
        vim.notify("KeybindManager.bind error: " .. tostring(err), vim.log.levels.ERROR)
        return false
    end

    return true
end

KeybindManager.rem = function(keybind)
    local success, err = pcall(function()
        for index, bind_table in ipairs(binds) do
            if bind_table.keybind == keybind then
                table.remove(binds, index)
                return true
            end
        end
        return false
    end)

    if not success then
        vim.notify("KeybindManager.rem error: " .. tostring(err), vim.log.levels.ERROR)
        return false
    end

    return success
end

KeybindManager.change = function(old_keybind, new_keybind, callback)
    local ok, result = pcall(function()
        for _, bind_table in ipairs(binds) do
            if bind_table.keybind == old_keybind then
                bind_table.keybind = new_keybind
                
                if callback then
                    bind_table.callback = callback
                end
                return true
            end
        end
        return false
    end)

    if not ok then
        vim.notify("KeybindManager.change error: " .. tostring(result), vim.log.levels.ERROR)
        return false
    end

    return result
end

KeybindManager.load = function()
    local function parse(keybind)
        if not keybind or keybind == "" then
            return ""
        end

        keybind = keybind:lower():gsub("%s*%+%s*", "+"):gsub("%s+", " ")

        local parts = {}
        for part in keybind:gmatch("[^%+]+") do
            table.insert(parts, part)
        end

        local mapped = {}
        local main_key = parts[#parts]

        for index = 1, #parts - 1 do
            local mod = keys[parts[index]]
            
            if mod and not vim.tbl_contains(mapped, mod) then
                table.insert(mapped, mod)
            end
        end

        table.insert(mapped, keys[main_key] or main_key:upper())

        return "<" .. table.concat(mapped, "-") .. ">" -- Acceptable Vim keybind
    end

    for _, bind_table in ipairs(binds) do
        opts = vim.tbl_extend("force", {
            noremap = true,
            silent = true,
        }, {})

        local parsed = parse(bind_table.keybind)
        if parsed == "" then
            vim.notify("KeybindManager: '" .. tostring(bind_table.keybind) .. "' is not an acceptable keybind!", vim.log.levels.WARN)
            return
        end

        vim.keymap.set(bind_table.mode, parsed, bind_table.callback, opts)
    end
end

return KeybindManager