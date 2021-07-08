-- list or matched file names
files   = {'resty/redis%.lua'}
-- lsit of settings to be changed
configs = {
    {
        key    = 'Lua.runtime.version',
        action = 'set',
        value  = 'LuaJIT',
    },
}
