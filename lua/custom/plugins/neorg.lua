return {
  'nvim-neorg/neorg',
  lazy = false,
  version = '*',
  dependencies = { { 'nvim-lua/plenary.nvim' }, { 'nvim-neorg/neorg-telescope' } },
  config = function()
    require('neorg').setup {
      load = {
        ['core.defaults'] = {},
        ['core.concealer'] = {},
        ['core.summary'] = {
          config = {
            strategy = 'default', -- or "by_path"
          },
        },
        ['core.keybinds'] = {
          config = {
            default_keybinds = true,
            neorg_leader = ',',
          },
        },
        ['core.dirman'] = {
          config = {
            workspaces = {
              notes = '~/notes',
            },
            default_workspace = 'notes',
          },
        },
        ['core.integrations.telescope'] = {}, -- Keep this
      },
    }

    -- Custom keybindings for telescope + neorg
    local function map(mode, lhs, rhs, opts)
      opts = opts or {}
      vim.keymap.set(mode, lhs, rhs, opts)
    end
    local neorgroup = vim.api.nvim_create_augroup('neorg', { clear = true })

    vim.api.nvim_create_autocmd({ 'FileType' }, {
      pattern = { 'norg' },
      group = neorgroup,
      callback = function()
        vim.g.maplocalleader = ','
        vim.o.conceallevel = 2
        vim.o.foldlevelstart = 99
        vim.keymap.set('n', '<LocalLeader>nr', ':Neorg return<CR>', { noremap = true, silent = true, desc = '[N]eorg [R]eturn' })

        -- Telescope Neorg commands
        map('n', '<leader>nf', '<cmd>Telescope neorg find_norg_files<cr>', { desc = 'Find Neorg files' })
        map('n', '<leader>nh', '<cmd>Telescope neorg search_headings<cr>', { desc = 'Search headings' })
        map('n', '<leader>nl', '<cmd>Telescope neorg find_linkable<cr>', { desc = 'Find linkable items' })
        map('n', '<leader>nw', '<cmd>Telescope neorg switch_workspace<cr>', { desc = 'Switch workspace' })
        vim.keymap.set('n', '<LocalLeader>nm', ':Neorg inject-metadata<CR>', { noremap = true, silent = true, desc = '[N]eorg insert [M]etadata' })
        vim.keymap.set('n', '<LocalLeader>nj', ':Neorg journal toc open<CR>', { noremap = true, silent = true, desc = '[N]eorg [J]ournal' })
        vim.keymap.set('n', '<LocalLeader>nt', ':Neorg journal today<CR>', { noremap = true, silent = true, desc = '[N]eorg [T]oday' })
        vim.keymap.set('n', '<LocalLeader>ns', ':Neorg journal tomorrow<CR>', { noremap = true, silent = true, desc = 'Neorg  tomorrow' })
        vim.keymap.set('n', '<LocalLeader>ny', ':Neorg journal yesterday<CR>', { noremap = true, silent = true, desc = '[N]eorg [Y]esterday' })
        vim.keymap.set('n', '<LocalLeader>neo', ':e /tmp/neorg-export.md<CR>', { noremap = true, silent = true, desc = '[N]eorg [E]xport [O]pen' })
        vim.keymap.set(
          'n',
          '<LocalLeader>nee',
          ':Neorg export to-file /tmp/neorg-export.md<CR>',
          { noremap = true, silent = true, desc = '[N]eorg [E]xport Predefined' }
        )
        vim.keymap.set('n', '<LocalLeader>nef', ':Neorg export to-file ', { noremap = true, silent = true, desc = '[N]eorg [E]xport [F]ile' })
      end,
    })

    vim.keymap.set('n', '<Leader>ni', ':Neorg index<CR>', { noremap = true, silent = true, desc = '[N]eorg [I]ndex' })
  end,
}
