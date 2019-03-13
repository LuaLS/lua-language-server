local createValue = require 'vm.value'
local library = require 'core.library'
local libraryBuilder = require 'vm.library'
local sourceMgr = require 'vm.source'

return function (lsp)
    local global = lsp and lsp.globalValue
    if not global then
        global = createValue('table', sourceMgr.dummy())
        for name, lib in pairs(library.global) do
            if not global:rawGet(name) then
                local value = libraryBuilder.value(lib)
                global:rawSet(name, value)
            end
        end
    end
    if lsp then
        lsp.globalValue = global
    end
    return global
end
