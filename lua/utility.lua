local vim_keybind_modes = {
    "n",  -- Normal
    "i",  -- Insert
    "v",  -- Visual
    "x",  -- Visual Block
    "t",  -- Terminal
    "c",  -- Command-line
}

local function is_valid_mode(mode)
    for _, value in ipairs(vim_keybind_modes) do
        if value == mode then
            return true
        end
    end
    return false
end

return {
    is_valid_mode = is_valid_mode
}