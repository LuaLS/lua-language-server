name = 'luafilesystem'
words = { 'require[%s%(\"\']+lfs[%)\"\']' }
config = {
    ["Lua.diagnostics.globals"] = {
        "lfs",
    },
}
