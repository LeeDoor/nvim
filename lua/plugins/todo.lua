return {
    {
        "folke/todo-comments.nvim",
        opts = {
            highlight = {
                pattern = [[<(KEYWORDS)>]],
                comments_only = false,
            },
            search = {
                pattern = [[\b(KEYWORDS)\b]],
            },
        },
    },
}
