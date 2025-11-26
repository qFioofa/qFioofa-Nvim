local PACKAGE_NAME = "oil"

local Options = {
    default_file_explorer = false,
    view_options = {
        show_hidden = false,
    },
    win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
    },
    float = {
        padding = 2,
        max_width = 80,
        max_height = 20,
        border = "rounded",
        win_options = {
            winblend = 0,
        },
    },
    keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = "actions.tcd",
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
    },
}

function setBinds()
	vim.keymap.set("n", "<leader>e", function()
        oil.open_float()
    end)
end
return function()
    require(PACKAGE_NAME).setup(Options)
end
