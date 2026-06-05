return {
  'olrtg/nvim-emmet',
  config = function() vim.keymap.set({ 'n', 'v' }, '<leader>xw', require('nvim-emmet').wrap_with_abbreviation, { desc = 'emmet: wrap with abbreviation' }) end,
}
