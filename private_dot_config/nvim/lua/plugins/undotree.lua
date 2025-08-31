vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_DiffAutoOpen = 0

return {
  {
    "mbbill/undotree",
    keys = {
      {
        "<leader>U",
        "<cmd> UndotreeToggle<cr>",
        desc = "Undotree",
      },
    },
  },
}
