name = 'luafilesystem'
words = { 'require[%s%(\"\']+lfs[%)\"\']' }
configs = {
    {
        key    = 'Lua.diagnostics.globals',
        action = 'add',
        value  = 'lfs',
    },
}
