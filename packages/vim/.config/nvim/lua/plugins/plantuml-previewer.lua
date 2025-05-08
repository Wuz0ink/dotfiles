return {
    {
        "weirongxu/plantuml-previewer.vim",
        ft = { "plantuml", "puml", "uml" },
        dependencies = {
            "tyru/open-browser.vim",
        },
        config = function()
            vim.g["plantuml_previewer#plantuml_jar_path"] = vim.fn.expand("~/.local/bin/plantuml.jar")
        end
    }
}
