return {
    {
        "saghen/blink.cmp",
        opts = {
            completion = {
                ghost_text = {
                    enabled = false,
                },
            },
            keymap = {
                preset = "enter",
                ["<CR>"] = { "fallback" },
                ["<C-CR>"] = { "select_and_accept", "fallback" },
                ["<C-j>"] = { "select_and_accept", "fallback" },
            },
        },
    },
}
