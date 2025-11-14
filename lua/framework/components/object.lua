-- ui_objects.lua
local popup = require("nui.popup")
local layout = require("nui.layout")

local objects = {}

-- helpers
local function find_index_by_ref(obj)
  for i, v in ipairs(objects) do
    if v == obj then
      return i
    end
  end
  return nil
end

local function is_table(t)
  return type(t) == "table"
end

-- Normalize position so we can safely offset clones.
-- Accepts several common forms:
-- 1) { row = N, col = M }
-- 2) { N, M } (array-style)
-- 3) any other table — returned as-is
local function normalize_position(pos)
  if not is_table(pos) then
    return pos
  end
  if pos.row ~= nil or pos.col ~= nil then
    return { row = pos.row or 0, col = pos.col or 0 }
  end
  if pos[1] ~= nil or pos[2] ~= nil then
    return { row = pos[1] or 0, col = pos[2] or 0 }
  end
  return pos
end

-- Safely attempt to unmount a component; ignore errors.
local function try_unmount(component)
  if component == nil then
    return
  end
  local ok, err = pcall(function()
    -- layout and popup in nui expose :unmount()
    if component.unmount and type(component.unmount) == "function" then
      component:unmount()
    end
  end)
  if not ok then
    -- swallow errors but print to vim's message area so devs can debug
    vim.notify("ui_objects: unmount error: " .. tostring(err), vim.log.levels.WARN)
  end
end

-- create_object: builds popup & layout, mounts, stores handles, returns the object
local function create_object(class, position, width, height)
  -- Basic validation and defaults
  if not class then
    error("create_object: class is required")
  end
  if not width or width <= 0 then
    width = 50
  end
  if not height or height <= 0 then
    height = 20
  end
  if not position then
    -- default to centered relative to editor if nui supports it in your config
    position = { row = "50%", col = "50%" }
  end

  -- instantiate popup
  local ok, main_popup = pcall(function()
    return popup({
      enter = true,
      border = "single",
      -- put minimal size on popup itself; layout will manage children
      size = {
        width = width,
        height = height
      }
    })
  end)
  if not ok then
    error("create_object: failed to create popup: " .. tostring(main_popup))
  end

  -- construct layout containing the popup
  local ok2, main_layout = pcall(function()
    -- layout expects (opts, child)
    -- we pass the position and size here
    return layout(
      {
        position = position,
        size = {
          width = width,
          height = height
        }
      },
      layout.Box({
        layout.Box(main_popup, {
          size = "100%"
        })
      }, {
        dir = "row"
      })
    )
  end)
  if not ok2 then
    -- clean up popup if layout fails
    try_unmount(main_popup)
    error("create_object: failed to create layout: " .. tostring(main_layout))
  end

  -- mount layout (which mounts its child popup)
  local ok3, err = pcall(function() main_layout:mount() end)
  if not ok3 then
    try_unmount(main_layout)
    try_unmount(main_popup)
    error("create_object: failed to mount layout: " .. tostring(err))
  end

  -- build object descriptor and store handles so we can unmount/clone later
  local obj = {
    class = class,
    position = position,
    width = width,
    height = height,
    popup = main_popup,
    layout = main_layout,
    mounted = true
  }

  table.insert(objects, obj)
  return obj
end

-- remove_object: accepts an object reference OR an index; unmounts & removes entry
local function remove_object(obj_or_index)
  local idx
  local obj

  if type(obj_or_index) == "number" then
    idx = obj_or_index
    obj = objects[idx]
    if not obj then
      return nil, "remove_object: no object at index " .. tostring(idx)
    end
  else
    obj = obj_or_index
    idx = find_index_by_ref(obj)
    if not idx then
      return nil, "remove_object: object not found"
    end
  end

  -- unmount layout first (which typically unmounts popup children)
  try_unmount(obj.layout)
  -- also try to explicitly unmount popup if it still exists
  try_unmount(obj.popup)

  -- mark not mounted and remove from list
  obj.mounted = false
  table.remove(objects, idx)

  return true
end

-- clone_object: duplicate an existing object (by reference or index)
-- returns the newly created object or nil+err
local function clone_object(obj_or_index)
  local obj
  if type(obj_or_index) == "number" then
    obj = objects[obj_or_index]
    if not obj then
      return nil, "clone_object: index not found"
    end
  else
    obj = obj_or_index
  end
  if not obj then
    return nil, "clone_object: source object required"
  end

  -- compute an offset position so the clone is visible and not stacked exactly on top
  local base_pos = normalize_position(obj.position)
  local new_pos = base_pos
  if type(base_pos) == "table" and (base_pos.row ~= nil or base_pos.col ~= nil) then
    -- If rows/cols are numeric, offset them. If they are strings like "50%", try to avoid arithmetic.
    local function safe_add(v, delta)
      if type(v) == "number" then
        return v + delta
      end
      -- cannot numeric-add (e.g. "50%") -> keep as-is to avoid breaking nui
      return v
    end
    new_pos = {
      row = safe_add(base_pos.row, 2),
      col = safe_add(base_pos.col, 4)
    }
  else
    -- fallback: if position is arbitrary table, attempt to shallow-copy and hope nui accepts it
    local copy = {}
    for k, v in pairs(base_pos) do copy[k] = v end
    new_pos = copy
  end

  -- call create_object to ensure consistent creation pipeline
  local new_obj = create_object(obj.class, new_pos, obj.width, obj.height)
  return new_obj
end

-- expose public API and current list (read-only recommended)
return {
  create_object = create_object,
  remove_object = remove_object,
  clone_object = clone_object,
  _objects = objects, -- exposed for debugging; treat as read-only in normal usage
}