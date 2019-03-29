local library = require 'core.library'
local libraryBuilder = require 'vm.library'
local sourceMgr = require 'vm.source'

return function (lsp)
    local global = lsp and lsp.globalValue
    if not global then
        libraryBuilder.clear()
        local t = {}
        for name, lib in pairs(library.global) do
            t[name] = libraryBuilder.value(lib)
        end

        global = t._G
        global:markGlobal()
        global:set('ENV', true)
        for k, v in pairs(t) do
            global:setChild(k, v, sourceMgr.dummy())
        end
    end
    if lsp then
        lsp.globalValue = global
    end
    return global
end
