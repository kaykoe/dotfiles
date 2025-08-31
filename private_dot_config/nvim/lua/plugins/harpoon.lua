return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  keys = function()
    local keys = {
      {
        "<leader>h",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon File",
      },
      {
        "<leader>H",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },

      {
        "<C-n>",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "Harpoon to File " .. 1,
      },
      {
        "<C-e>",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "Harpoon to File " .. 2,
      },
      {
        "<C-i>",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "Harpoon to File " .. 3,
      },
      {
        "<C-o>",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "Harpoon to File " .. 4,
      },
      {
        "<C-7>",
        function()
          require("harpoon"):list():select(5)
        end,
        desc = "Harpoon to File " .. 5,
      },
      {
        "<C-8>",
        function()
          require("harpoon"):list():select(6)
        end,
        desc = "Harpoon to File " .. 6,
      },
      {
        "<C-9>",
        function()
          require("harpoon"):list():select(7)
        end,
        desc = "Harpoon to File " .. 7,
      },
      {
        "<C-0>",
        function()
          require("harpoon"):list():select(8)
        end,
        desc = "Harpoon to File " .. 8,
      },
    }
    return keys
  end,
}
