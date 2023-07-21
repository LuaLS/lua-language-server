local vm    = require 'vm'
local files = require 'files'
local guide = require 'parser.guide'
local await = require 'await'
local lang  = require 'language'

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    ---@async
    guide.eachSourceType(state.ast, 'table', function (src)
        await.delay()

        local defs = vm.getDefs(src)
        local requiresKeys = {}
        local isClass = false
        for _, def in ipairs(defs) do
            if def.type == 'doc.class' then
                if not def.fields then
                    goto continue
                end
                if def.bindSource then
                    if guide.isInRange(def.bindSource, src.start) then
                        isClass = true
                        break
                    end
                end
                for _, field in ipairs(def.fields) do
                    if  not field.optional
                    and not vm.compileNode(field):isNullable() then
                        local key = vm.getKeyName(field)
                        if key and not requiresKeys[key] then
                            requiresKeys[key] = true
                            requiresKeys[#requiresKeys+1] = key
                        end
                    end
                end
            end
            ::continue::
        end

        if #requiresKeys == 0 or isClass then
            return
        end

        local myKeys = {}
        for _, field in ipairs(src) do
            local key = vm.getKeyName(field)
            if key then
                myKeys[key] = true
            end
        end

        local missedKeys = {}
        for _, key in ipairs(requiresKeys) do
            if not myKeys[key] then
                missedKeys[#missedKeys+1] = ('`%s`'):format(key)
            end
        end

        if #missedKeys == 0 then
            return
        end

        callback {
            start   = src.start,
            finish  = src.finish,
            message = lang.script('DIAG_MISSING_FIELDS', table.concat(missedKeys, ', ')),
        }
    end)
end
