local createValue = require 'vm.value'
local library = require 'core.library'
local libraryBuilder = require 'vm.library'
local sourceMgr = require 'vm.source'

return function (lsp)
    local global = lsp and lsp.globalValue
    if not global then
        local t = {}
        for name, lib in pairs(library.global) do
            t[name] = libraryBuilder.value(lib)
        end

        global = t._G
        global:markGlobal()
        for k, v in pairs(t) do
            global:setChild(k, v, sourceMgr.dummy())
        end
    end
    if lsp then
        lsp.globalValue = global
    end
    return global
end
