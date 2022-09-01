--[[

 ____  ____  ____  _  _  __  ____  _  _ 
(_  _)(  __)(  _ \( \/ )(  )(  __)( \/ )
  )(   ) _)  )   // \/ \ )(  ) _)  )  / 
 (__) (____)(__\_)\_)(_/(__)(__)  (__/  

 Termify is a simple Neovim plugin that enables you to run and read the output of a script in a disposable popup window.

--]]

local termify = {}
local api = vim.api
local headerBuf, headerWin
local bodyBuf, bodyWin

termify.config = {
  supportedFiletypes = {
    ['swift'] = "swift",
    ['dart'] = "dart",
    ['python'] = "python",
    ['lua'] = "lua",
    ['md'] = "glow",
  },
  closeMappings = { '<esc>', 'q' },
  borderStyle = 'rounded'
}

-- Utility functions
local function ternary(cond, T, F)
  if cond then return T else return F end
end

local function center(str)
  local width = api.nvim_win_get_width(0)
  local shift = math.floor(width / 2) - math.floor(string.len(str) / 2)
  return string.rep(' ', shift) .. str
end

local function getFileExtension(path)
  local filetype = path:match("^.+(%..+)$")
  return filetype:sub(2)
end

-- Window actions
local function open_window(args)
  local isHeader = args.isHeader
  local buffer = api.nvim_create_buf(false, true)
  local width = api.nvim_get_option("columns")
  local height = api.nvim_get_option("lines")
  local win_height = math.ceil(height * 0.8 - 5)
  local win_width = math.ceil(width * 0.8)
  local row = math.ceil((height - win_height) / 2 - 1)
  local col = math.ceil((width - win_width) / 2)

  local opts = {
    style = "minimal",
    relative = "editor",
    width = win_width,
    focusable = ternary(isHeader, false, true),
    height = ternary(isHeader, 1, win_height),
    row = ternary(isHeader, row - 2, row),
    col = col,
    border = termify.config.borderStyle,
    zindex = ternary(isHeader, 1, 2)
  }

  api.nvim_buf_set_option(buffer, 'bufhidden', 'wipe')
  return api.nvim_open_win(buffer, true, opts), buffer
end

local function close_windows()
  if api.nvim_win_is_valid(headerWin) then
    api.nvim_win_close(headerWin, true)
  end

  if api.nvim_win_is_valid(bodyWin) then
    api.nvim_win_close(bodyWin, true)
  end
end

-- Setup mappings
local function set_mappings(buffer)
  local opts = { nowait = true, noremap = true, silent = true }
  local map = api.nvim_buf_set_keymap

  for _, mapping in pairs(termify.config.closeMappings) do
    map(buffer, 'n', mapping, ':lua require"termify".close()<cr>', opts)
  end
end

-- Rendering content
local function renderHeader(buffer, text)
  vim.cmd [[hi def link TermifyHeading Function]]
  api.nvim_buf_set_lines(buffer, 0, -1, false, {
    center(text),
  })
  api.nvim_buf_add_highlight(buffer, -1, 'TermifyHeading', 0, 0, -1)
end

local function renderBody(filetype, path, callback)
  vim.fn.termopen(termify.config.supportedFiletypes[filetype] .. " \"" .. path .. "\"", { on_stdout = callback })
end

-- Public functions
termify.setup = function(params)
  termify.config = vim.tbl_extend("force", {}, termify.config, params or {})
end

termify.run = function()
  local path = api.nvim_buf_get_name(0)
  local filetype = getFileExtension(path)

  if termify.config.supportedFiletypes[filetype] == nil then
    vim.notify_once("  Unsuported filetype: " .. filetype, vim.log.levels.ERROR)
    return
  end

  -- Setup header window
  headerWin, headerBuf = open_window { isHeader = true }
  renderHeader(headerBuf, " ﰌ Running ")
  set_mappings(headerBuf)

  -- Setup body window
  bodyWin, bodyBuf = open_window { isHeader = false }
  renderBody(filetype, path, function()
    renderHeader(headerBuf, "  Output ")
  end)
  set_mappings(bodyBuf)
end

termify.close = function()
  close_windows()
end

return termify
