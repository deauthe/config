return {
  {
    "kawre/leetcode.nvim",
    url = "https://github.com/deauthe/leetcode.nvim",
    branch = "personal-setup",
    build = ":TSUpdate html",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      lang = "golang",
      picker = { provider = "snacks-picker" },
      injector = {
        golang = {
          imports = { "//go:build ignore", "", "package main" },
          after = {
            "type ListNode struct {",
            "\tVal  int",
            "\tNext *ListNode",
            "}",
            "",
            "type TreeNode struct {",
            "\tVal         int",
            "\tLeft, Right *TreeNode",
            "}",
          },
        },
      },
    },
  },
}
