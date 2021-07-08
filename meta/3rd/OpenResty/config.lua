-- list of matched words
words   = {}
-- list or matched file names
files   = {}
-- lsit of settings to be changed
configs = {
    {
        key    = 'Lua.runtime.version',
        action = 'set',
        value  = 'LuaJIT',
    },
    {
        key    = 'Lua.diagnostics.globals',
        action = 'add',
        value  = 'global1',
    }
}
for _, name in ipairs {'global2', 'global3', 'global4'} do
    configs[#configs+1] = {
        key    = 'Lua.diagnostics.globals',
        action = 'add',
        value  = name,
    }
end
