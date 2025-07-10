local M = {}

local function load_pairs_from_json(path)
  local lines = vim.fn.readfile(path)
  if vim.tbl_isempty(lines) then
    vim.notify("JSON file is empty or missing: " .. path, vim.log.levels.ERROR)
    return {}
  end

  local ok, parsed = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not ok then
    vim.notify("Failed to parse JSON: " .. parsed, vim.log.levels.ERROR)
    return {}
  end

  local result = {}
  for _, v in ipairs(parsed) do
    result[v.task_id] = v
  end

  return result
end

M.pairs =
  load_pairs_from_json("/home/ubuntu/projects/agent-core-pbt/experiment/v2.1-20250122-sonnet3.5/patch_pairs.json")

M.task_ids = vim.tbl_keys(M.pairs)
table.sort(M.task_ids)

M.index = 1

function M.view_pair(pair)
  if not pair then
    print("Invalid index: " .. M.index)
    return
  end

  -- Close all existing windows
  vim.cmd("only!")

  -- Open patch on the left
  vim.cmd("edit " .. pair.patch)

  -- Open gold_patch on the right
  vim.cmd("vsplit " .. pair.gold_patch)
end

function M.next()
  if M.index >= #M.task_ids then
    M.index = #M.task_ids
    vim.notify("Already at last pair", vim.log.levels.WARN)
  else
    M.index = M.index + 1
    M.view_pair(M.pairs[M.task_ids[M.index]])
  end
end

function M.prev()
  if M.index <= 1 then
    M.index = 1
    vim.notify("Already at first pair", vim.log.levels.WARN)
  else
    M.index = M.index - 1
    M.view_pair(M.pairs[M.task_ids[M.index]])
  end
end

vim.keymap.set("n", "<c-i>", function()
  local task_ids = {} -- list of (idx, task_id)
  for i = M.index, #M.task_ids do
    table.insert(task_ids, { i, M.task_ids[i] })
  end
  for i = 1, M.index - 1 do
    table.insert(task_ids, { i, M.task_ids[i] })
  end

  local snacks = require("snacks")
  snacks.picker.select(task_ids, {
    prompt = "select a task",
    format_item = function(item)
      local idx, task_id = unpack(item)
      local suffix = ""
      local value = M.pairs[task_id]
      if value.plausible then
        suffix = "plausible"
      else
        suffix = "implausible"
      end
      return idx .. " " .. task_id .. " " .. suffix
    end,
  }, function(item)
    if not item then
      return
    end
    local idx, task_id = unpack(item)
    M.view_pair(M.pairs[task_id])
    M.index = idx
    vim.notify("set index to " .. M.index)
  end)
end)

vim.keymap.set("n", "<C-j>", M.next)
vim.keymap.set("n", "<C-k>", M.prev)

return M
