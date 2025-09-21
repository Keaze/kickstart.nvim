return {
  'akinsho/toggleterm.nvim',
  version = '*',
  config = function()
    require('toggleterm').setup {
      -- Basic settings
      size = 20,
      open_mapping = [[<F12>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = 'float',
      close_on_exit = true,
      shell = vim.o.shell,
      auto_scroll = true,
      -- Float terminal settings
      float_opts = {
        border = 'curved',
        width = 100,
        height = 30,
        winblend = 0,
        highlights = {
          border = 'Normal',
          background = 'Normal',
        },
      },
      -- Horizontal terminal settings
      horizontal_opts = {
        size = 15,
      },
      -- Vertical terminal settings
      vertical_opts = {
        size = 80,
      },
    }

    -- Terminal keybindings
    local Terminal = require('toggleterm.terminal').Terminal

    -- Function to set terminal keymaps
    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
      vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
    end

    -- Apply terminal keymaps when terminal opens
    vim.cmd 'autocmd! TermOpen term://* lua set_terminal_keymaps()'

    -- Specialized terminal instances
    local lazygit = Terminal:new {
      cmd = 'lazygit',
      dir = 'git_dir',
      direction = 'float',
      float_opts = {
        border = 'double',
        width = 120,
        height = 35,
      },
      on_open = function(term)
        vim.cmd 'startinsert!'
        vim.api.nvim_buf_set_keymap(term.bufnr, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
      end,
      on_close = function()
        vim.cmd 'startinsert!'
      end,
    }

    local htop = Terminal:new {
      cmd = 'btop4win',
      direction = 'float',
      float_opts = {
        border = 'double',
        width = 100,
        height = 30,
      },
    }

    local node = Terminal:new {
      cmd = 'node',
      direction = 'float',
      float_opts = {
        border = 'curved',
        width = 80,
        height = 25,
      },
    }

    local python = Terminal:new {
      cmd = 'python',
      direction = 'float',
      float_opts = {
        border = 'curved',
        width = 80,
        height = 25,
      },
    }

    -- Functions to toggle specialized terminals
    function _LAZYGIT_TOGGLE()
      lazygit:toggle()
    end

    function _HTOP_TOGGLE()
      htop:toggle()
    end

    function _NODE_TOGGLE()
      node:toggle()
    end

    function _PYTHON_TOGGLE()
      python:toggle()
    end

    -- General terminal functions
    function _HORIZONTAL_TOGGLE()
      vim.cmd 'ToggleTerm direction=horizontal'
    end

    function _VERTICAL_TOGGLE()
      vim.cmd 'ToggleTerm direction=vertical'
    end

    function _FLOAT_TOGGLE()
      vim.cmd 'ToggleTerm direction=float'
    end

    -- Key mappings
    local map = vim.keymap.set
    local opts = { noremap = true, silent = true }

    -- Basic terminal toggles
    map('n', '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', opts)
    map('n', '<leader>th', '<cmd>ToggleTerm direction=horizontal<cr>', opts)
    map('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical<cr>', opts)

    -- Terminal with specific ID (useful for multiple terminals)
    map('n', '<leader>t1', '<cmd>1ToggleTerm<cr>', opts)
    map('n', '<leader>t2', '<cmd>2ToggleTerm<cr>', opts)
    map('n', '<leader>t3', '<cmd>3ToggleTerm<cr>', opts)

    -- Specialized terminals
    map('n', '<leader>gg', '<cmd>lua _LAZYGIT_TOGGLE()<CR>', opts)
    map('n', '<leader>tt', '<cmd>lua _HTOP_TOGGLE()<CR>', opts)

    -- Send commands to terminal
    map('n', '<leader>tc', function()
      local cmd = vim.fn.input 'Command: '
      if cmd ~= '' then
        vim.cmd('ToggleTermSendCurrentLine ' .. cmd)
      end
    end, opts)

    -- Send visual selection to terminal
    map('v', '<leader>ts', '<cmd>ToggleTermSendVisualSelection<cr>', opts)

    -- Toggle all terminals
    map('n', '<leader>ta', '<cmd>ToggleTermToggleAll<cr>', opts)
  end,
  keys = {
    { '<leader>tf', desc = 'Toggle float terminal' },
    { '<leader>th', desc = 'Toggle horizontal terminal' },
    { '<leader>tv', desc = 'Toggle vertical terminal' },
    { '<leader>t1', desc = 'Toggle terminal 1' },
    { '<leader>t2', desc = 'Toggle terminal 2' },
    { '<leader>t3', desc = 'Toggle terminal 3' },
    { '<leader>gg', desc = 'Toggle LazyGit' },
    { '<leader>tt', desc = 'Toggle htop' },
    { '<leader>tn', desc = 'Toggle Node REPL' },
    { '<leader>tp', desc = 'Toggle Python REPL' },
    { '<leader>tc', desc = 'Send command to terminal' },
    { '<leader>ts', desc = 'Send selection to terminal', mode = 'v' },
    { '<leader>ta', desc = 'Toggle all terminals' },
  },
}
