local api = vim.api
local M = {}

local namespace = api.nvim_create_namespace("vim-trainer")
local current_target = nil
local score = 0

local snippets = {
  [[
local function calculate_latency(req, res)
    local latency = res - req
    return math.max(0, latency)
end]],
  [[
const handleWebSocket = (msg) => {
    if (msg.type === 'AUTH') {
        processToken(msg.payload);
    }
};]]
}

-- Picks a random position and highlights it
local function set_new_target(bufnr, lines)
  -- Clear previous target highlight
  api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)

  local row = math.random(0, #lines - 1)
  local line_len = string.len(lines[row + 1])

  -- Retry if we hit an empty line
  if line_len == 0 then
    return set_new_target(bufnr, lines)
  end

  local col = math.random(0, line_len - 1)
  current_target = { row, col }

  -- Apply built-in ErrorMsg highlight (usually red) to the single character
  api.nvim_buf_set_extmark(bufnr, namespace, row, col, {
    end_col = col + 1,
    hl_group = "ErrorMsg",
  })
end

-- Hooked to CursorMoved: checks if we hit the target
local function check_win_condition(bufnr)
  if not current_target then return end

  local cursor = api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1   -- nvim_win_get_cursor is 1-indexed for rows
  local col = cursor[2]       -- and 0-indexed for columns

  if row == current_target[1] and col == current_target[2] then
    score = score + 1
    print("Score: " .. score)

    local lines = api.nvim_buf_get_lines(bufnr, 0, -1, false)
    set_new_target(bufnr, lines)
  end
end

function M.start()
  math.randomseed(os.time())
  score = 0

  -- Create a clean, unlisted scratch buffer
  local bufnr = api.nvim_create_buf(false, true)
  api.nvim_set_current_buf(bufnr)

  -- Load a random snippet
  local snippet_text = snippets[math.random(#snippets)]
  local lines = {}
  for s in snippet_text:gmatch("[^\r\n]+") do
    table.insert(lines, s)
  end
  api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)

  -- Create an autocmd group to manage the cursor tracking
  local group = api.nvim_create_augroup("VimTrainer", { clear = true })
  api.nvim_create_autocmd("CursorMoved", {
    group = group,
    buffer = bufnr,
    callback = function() check_win_condition(bufnr) end
  })

  -- Map 'q' to wipe the buffer and exit the trainer
  api.nvim_buf_set_keymap(bufnr, 'n', 'q', ':bwipeout!<CR>', { noremap = true, silent = true })

  set_new_target(bufnr, lines)
  print("Vim Trainer started! Use motions to reach the red character. Press 'q' to quit.")
end

return M
