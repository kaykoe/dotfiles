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
        },
    },
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "neopywal",
        },
    },
}
