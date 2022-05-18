name    = 'World of Warcraft'
words   = {'wow.api'}
files   = {
    '.*%.toc',
    '.*%.lua',
}
configs = {
    {
        key    = 'Lua.runtime.version',
        action = 'set',
        value  = 'Lua 5.1',
    },
    {
        key    = 'Lua.runtime.builtin',
        action = 'prop',
        prop   = 'debug',
        value  = 'disable',
    },
    {
        key    = 'Lua.runtime.builtin',
        action = 'prop',
        prop   = 'io',
        value  = 'disable',
    },
    {
        key    = 'Lua.runtime.builtin',
        action = 'prop',
        prop   = 'os',
        value  = 'disable',
    },
    {
        key    = 'Lua.runtime.builtin',
        action = 'prop',
        prop   = 'package',
        value  = 'disable',
    },
}
