local exclude = { "node_modules", ".git" }

return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = { hidden = true, ignored = true, exclude = exclude },
        grep = { hidden = true, ignored = true, exclude = exclude },
        explorer = { hidden = true, ignored = true, exclude = exclude },
      },
    },
  },
}
