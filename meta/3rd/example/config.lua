-- if not set, the folder name will be used
name    = 'Example'
-- list of matched words
words   = {'thisIsAnExampleWord%.ifItExistsInFile%.thenTryLoadThisLibrary'}
-- list or matched file names. `.lua`, `.dll` and `.so` only
files   = {'thisIsAnExampleFile%.ifItExistsInWorkSpace%.thenTryLoadThisLibrary%.lua'}
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
    },
    {
        key    = 'Lua.runtime.special',
        action = 'prop',
        prop   = 'include',
        value  = 'require',
    },
    {
        key    = 'Lua.runtime.builtin',
        action = 'prop',
        prop   = 'io',
        value  = 'disable',
    },
}
for _, name in ipairs {'global2', 'global3', 'global4'} do
    configs[#configs+1] = {
        key    = 'Lua.diagnostics.globals',
        action = 'add',
        value  = name,
    }
end
