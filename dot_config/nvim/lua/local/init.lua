local modules = {}

local function scan_dir_recursive(dir, prefix)
  local fs = vim.uv.fs_scandir(dir)
  if not fs then
    return
  end

  while true do
    local name, type = vim.uv.fs_scandir_next(fs)
    if not name then
      break
    end

    local full_path = dir .. "/" .. name
    if type == "directory" then
      scan_dir_recursive(full_path, prefix .. name .. ".")
    elseif type == "file" and name:sub(-4) == ".lua" then
      -- skip init.lua in root module to avoid circular require
      if not (prefix == "local." and name == "init.lua") then
        local mod_name = prefix .. name:sub(1, -5)
        local ok, mod = pcall(require, mod_name)
        if ok then
          modules[mod_name] = mod
        else
          vim.notify("Failed to load " .. mod_name .. ": " .. mod, vim.log.levels.ERROR)
        end
      end
    end
  end
end

-- Get the path of this file
local current_file = debug.getinfo(1, "S").source:sub(2)
local local_dir = vim.fn.fnamemodify(current_file, ":h")

-- Start scanning
scan_dir_recursive(local_dir, "local.")

return modules
