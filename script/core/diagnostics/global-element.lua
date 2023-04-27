local files     = require 'files'
local guide     = require 'parser.guide'
local lang      = require 'language'
local config    = require 'config'
local vm        = require 'vm'
local util      = require 'utility'

local function isDocClass(source)
    if not source.bindDocs then
        return false
    end
    for _, doc in ipairs(source.bindDocs) do
        if doc.type == 'doc.class' then
            return true
        end
    end
    return false
end

-- If global elements are discouraged by coding convention, this diagnostic helps with reminding about that
-- Exceptions may be added to Lua.diagnostics.globals
return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    local definedGlobal = util.arrayToHash(config.get(uri, 'Lua.diagnostics.globals'))

    guide.eachSourceType(ast.ast, 'setglobal', function (source)
        local name = guide.getKeyName(source)
        if not name or definedGlobal[name] then
            return
        end
        -- If the assignment is marked as doc.class, then it is considered allowed 
        if isDocClass(source) then
            return
        end
        if definedGlobal[name] == nil then
            definedGlobal[name] = false
            local global = vm.getGlobal('variable', name)
            if global then
                for _, set in ipairs(global:getSets(uri)) do
                    if vm.isMetaFile(guide.getUri(set)) then
                        definedGlobal[name] = true
                        return
                    end
                end
            end
        end
        callback {
            start   = source.start,
            finish  = source.finish,
            message = lang.script.DIAG_GLOBAL_ELEMENT,
        }
    end)
end
