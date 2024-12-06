return {
  'okuuva/auto-save.nvim',

  config = function()
    require('auto-save').setup {
      noautocmd = true,
    }
  end,
}
