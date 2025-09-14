return {
  'akinsho/bufferline.nvim',
  opts = {},
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    vim.opt.termguicolors = true
    require('bufferline').setup {}
  end,
}
