return {
    "saghen/blink.cmp",
    opts = {
        keymap = {
            preset = "default",
        },
        signature = {
            enabled = true,
            window = {
                show_documentation = false,
            },
        },
        completion = {
            documentation = {
                auto_show = false,
            },
        },
        cmdline = {
            enabled = true,
            keymap = {
                ["<Tab>"] = { "show", "accept" },
            },
            completion = {
                menu = {
                    ---@diagnostic disable-next-line: unused-local
                    auto_show = function(ctx)
                        return vim.fn.getcmdtype() == ":"
                    end,
                },
            },
        },
    },
}
