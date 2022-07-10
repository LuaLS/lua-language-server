name    = 'Factorio'
files   = {'control%.lua', '%a[%w%-_]*/control%.lua'}
configs = {
    {
        key    = 'Lua.runtime.version',
        action = 'set',
        value  = 'Lua 5.2',
    },
    {
        key    = 'Lua.diagnostics.globals',
        action = 'add',
        value  = 'global',
    }
}