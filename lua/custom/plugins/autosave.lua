return {
  'brianhuster/autosave.nvim',
  event = 'InsertEnter',
  opts = {
    disable_inside_paths = {
      vim.fn.stdpath 'config',
    },
  },
}
