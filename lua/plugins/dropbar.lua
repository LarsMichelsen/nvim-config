local append_space = function(icons)
    local result = {}
    for k, v in pairs(icons) do
        result[k] = v .. " "
    end
    return result
end

local kind_icons = {
    Array = "",
    Boolean = "",
    Class = "",
    Color = "",
    Constant = "",
    Constructor = "",
    Enum = "",
    EnumMember = "",
    Event = "",
    Field = "",
    File = "",
    Folder = "",
    Function = "",
    Interface = "",
    Key = "",
    Keyword = "",
    Method = "",
    Module = "",
    Namespace = "",
    Null = "",
    Number = "",
    Object = "",
    Operator = "",
    Package = "",
    Property = "",
    Reference = "",
    Snippet = "",
    String = "",
    Struct = "",
    Text = "",
    TypeParameter = "",
    Unit = "",
    Value = "",
    Variable = "",
}

icons = {
    -- LSP diagnostic
    diagnostic = {
        error = "󰅚 ",
        warn = "󰀪 ",
        hint = "󰌶 ",
        info = "󰋽 ",
    },
    -- LSP kinds
    kind = kind_icons,
    kind_with_space = append_space(kind_icons),
}

---@type LazyPluginSpec
return {
    "Bekaboo/dropbar.nvim",
    event = {
        "BufRead",
        "BufNewFile",
    },
    opts = {
        icons = {
            kinds = {
                symbols = vim.tbl_extend("keep", { Folder = " " }, icons.kind_with_space),
            },
        },
        sources = {
            path = {
                modified = function(sym)
                    return sym:merge({
                        name = sym.name .. " [+]",
                        name_hl = "DiffAdded",
                    })
                end,
            },
        },
    },
}
