local keymap = vim.keymap

test = {
  strategy = "neovim",
  java = {
    runner = "gradletest"
  }
}

if vim.fn.has("nvim") == 1 then
  keymap.set('t', '<C-o>', '<C-\\><C-n>', { noremap = true })
end

