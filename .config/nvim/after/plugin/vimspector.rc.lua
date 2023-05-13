local keymap = vim.keymap

vim.g.vimspector_enable_mappings = 'HUMAN'
vim.g.vimspector_sidebar_width = 80
vim.g.vimspector_bottombar_height = 20
keymap.set('n', '<F1>', ':CocCommand java.debug.vimspector.start<CR>', { noremap = true })
