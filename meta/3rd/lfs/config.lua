name = 'luafilesystem'
words = { 'lfs%.%w+' }
configs = {
    {
        key    = 'Lua.diagnostics.globals',
        action = 'add',
        value  = 'lfs',
    },
}
