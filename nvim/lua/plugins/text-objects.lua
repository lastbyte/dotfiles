return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  -- lazy = true,
  event = "VeryLazy",
  init =  function ()
    vim.g.no_plugin_maps = true
  end,
  config = function()
    -- Merged configuration for select and move
    require("nvim-treesitter-textobjects").setup({
      select = {
        enable = true,
        lookahead = true,
        selection_modes = {
          ['@parameter.outer'] = 'v', -- charwise
          ['@function.outer'] = 'V',  -- linewise
          -- ['@class.outer'] = '<c-v>', -- blockwise
        },
        include_surrounding_whitespace = false,
      },
      move = {
        set_jumps = true,
      },
    })

    -- Selection keymaps
    local select = require("nvim-treesitter-textobjects.select")
    vim.keymap.set({ "x", "o" }, "am", function() select.select_textobject("@function.outer", "textobjects") end)
    vim.keymap.set({ "x", "o" }, "im", function() select.select_textobject("@function.inner", "textobjects") end)
    vim.keymap.set({ "x", "o" }, "ac", function() select.select_textobject("@class.outer", "textobjects") end)
    vim.keymap.set({ "x", "o" }, "ic", function() select.select_textobject("@class.inner", "textobjects") end)
    vim.keymap.set({ "x", "o" }, "as", function() select.select_textobject("@local.scope", "locals") end)

    -- Swap keymaps
    local swap = require("nvim-treesitter-textobjects.swap")
    vim.keymap.set("n", "<leader>a", function() swap.swap_next("@parameter.inner") end)
    vim.keymap.set("n", "<leader>A", function() swap.swap_previous("@parameter.outer") end)

    -- Move keymaps
    local move = require("nvim-treesitter-textobjects.move")
    vim.keymap.set({ "n", "x", "o" }, "]m", function() move.goto_next_start("@function.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "]]", function() move.goto_next_start("@class.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "]o",
      function() move.goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "]s", function() move.goto_next_start("@local.scope", "locals") end)
    vim.keymap.set({ "n", "x", "o" }, "]z", function() move.goto_next_start("@fold", "folds") end)
    vim.keymap.set({ "n", "x", "o" }, "]M", function() move.goto_next_end("@function.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "][", function() move.goto_next_end("@class.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "[m", function() move.goto_previous_start("@function.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "[[", function() move.goto_previous_start("@class.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "[M", function() move.goto_previous_end("@function.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "[]", function() move.goto_previous_end("@class.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "]d", function() move.goto_next("@conditional.outer", "textobjects") end)
    vim.keymap.set({ "n", "x", "o" }, "[d", function() move.goto_previous("@conditional.outer", "textobjects") end)

    -- Repeatable move keymaps
    local ts_repeat_move = require("nvim-treesitter-textobjects.repeatable_move")
    vim.keymap.set({ "n", "x", "o" }, "<leader>;", ts_repeat_move.repeat_last_move_next)
    vim.keymap.set({ "n", "x", "o" }, "<leader>,", ts_repeat_move.repeat_last_move_previous)
    -- vim.keymap.set({ "n", "x", "o" }, "<leader>f", ts_repeat_move.builtin_f_expr, { expr = true })
    -- vim.keymap.set({ "n", "x", "o" }, "<leader>F", ts_repeat_move.builtin_F_expr, { expr = true })
    -- vim.keymap.set({ "n", "x", "o" }, "<leader>t", ts_repeat_move.builtin_t_expr, { expr = true })
    -- vim.keymap.set({ "n", "x", "o" }, "<leader>T", ts_repeat_move.builtin_T_expr, { expr = true })

    vim.keymap.set({ "n", "x", "o" }, "<home>", function()
      ts_repeat_move.repeat_last_move({ forward = false, start = true })
    end)
    vim.keymap.set({ "n", "x", "o" }, "<end>", function()
      ts_repeat_move.repeat_last_move({ forward = true, start = false })
    end)
  end,
}
