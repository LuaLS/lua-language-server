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
                local className = def.class[1]
                if not sortedDefs[className] then
                    sortedDefs[className] = {}
                end
                local samedefs = sortedDefs[className]
                samedefs[#samedefs+1] = def
            end
            if def.type == 'doc.type.array'
            or def.type == 'doc.type.table' then
                return
            end
        end

        local warnings = {}
        for _, samedefs in pairs(sortedDefs) do
            local missedKeys = {}
            local className
            for _, def in ipairs(samedefs) do
                className = def.class[1]
                if not def.fields or #def.fields == 0 then
                    goto continue
                end

                local myKeys = {}
                for _, field in ipairs(src) do
                    local key = vm.getKeyName(field)
                    if key then
                        myKeys[key] = true
                    end
                end

                for _, field in ipairs(def.fields) do
                    if  not field.optional
                    and not vm.compileNode(field):isNullable() then
                        local key = vm.getKeyName(field)
                        if key and not myKeys[key] then
                            missedKeys[#missedKeys+1] = ('`%s`'):format(key)
                        end
                    end
                end
                ::continue::
            end

            if #missedKeys == 0 then
                return
            end
            
            warnings[#warnings+1] = lang.script('DIAG_MISSING_FIELDS', className, table.concat(missedKeys, ', '))
        end

        if #warnings == 0 then
            return
        end
        callback {
            start   = src.start,
            finish  = src.finish,
            message = table.concat(warnings, '\n')
        }
    end)
end
