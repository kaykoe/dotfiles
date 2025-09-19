return {
    {
        "RedsXDD/neopywal.nvim",
        name = "neopywal",
        lazy = false,
        priority = 1000,
        opts = {
            use_palette = "wallust",
            transparent_background = true,
            no_italic = true,
            styles = {
                conditionals = { "bold" },
                keywords = { "bold" },
                loops = { "bold" },
                includes = { "bold" },
                types = { "bold" },
            },
            custom_highlights = function(C)
                local U = require("neopywal.utils.color")
                return {
                    all = {
                        ColorColumn = {
                            bg = U.blend(C.foreground, C.background, 0.5),
                        },
                    },
                }
            end,
        },
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "neopywal",
        },
    },
}
