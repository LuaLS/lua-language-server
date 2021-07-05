-- list of matched words
words   = {'thisIsAnExampleWord.ifItExistsInFile.thenTryLoadThisLibrary'}
-- list or matched file names
files   = {'thisIsAnExampleFile.ifItExistsInWorkSpace.thenTryLoadThisLibrary'}
-- lsit of settings to be changed
configs = {
    {
        name  = 'Lua.runtime.version',
        type  = 'set',
        value = 'LuaJIT',
    },
    {
        name  = 'Lua.diagnostics.globals',
        type  = 'add',
        value = 'global1',
    }
}
for _, name in ipairs {'global2', 'global3', 'global4'} do
    config[#config+1] = {
        name  = 'Lua.diagnostics.globals',
        type  = 'add',
        value = name,
    }
end
