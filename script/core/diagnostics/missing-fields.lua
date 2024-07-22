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
        local sortedDefs = {}
        for _, def in ipairs(defs) do
            if def.type == 'doc.class' then
                if def.bindSource and guide.isInRange(def.bindSource, src.start) then
                    return
                end
                if not sortedDefs[def.class[1]] then
                    sortedDefs[def.class[1]] = {}
                end
                local samedefs = sortedDefs[def.class[1]]
                samedefs[#samedefs+1] = def
            end
            if def.type == 'doc.type.array'
            or def.type == 'doc.type.table' then
                return
            end
        end
        
        local Allwarnings = {}
        for _, samedefs in pairs(sortedDefs) do
            local warnings = {}
            for _, def in ipairs(samedefs) do
                if def.type == 'doc.class' then
                    if not def.fields then
                        goto continue
                    end

                    local requiresKeys = {}
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

                    if #requiresKeys == 0 then
                        goto continue
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
                        goto continue
                    end

                    warnings[#warnings+1] = lang.script('DIAG_MISSING_FIELDS', def.class[1], table.concat(missedKeys, ', '))
                end  
                ::continue::
            end
            if #warnings == 0 then
                return
            else
                for i = 1, #warnings do
                    Allwarnings[#Allwarnings+1] = warnings[i]
                end
            end
        end
        if #Allwarnings == 0 then
            return
        end
        callback {
            start   = src.start,
            finish  = src.finish,
            message = table.concat(Allwarnings, '\n')
        }
    end)
end
