local files    = require 'files'
local lang     = require 'language'
local define   = require 'proto.define'
local guide    = require 'parser.guide'
local vm       = require 'vm'
local await    = require 'await'

local sourceTypes = {
    'setfield',
    'setmethod',
    'setindex',
}

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    ---@async
    guide.eachSourceTypes(state.ast, sourceTypes, function (src)
        await.delay()
        local name = guide.getKeyName(src)
        if not name then
            return
        end
        local value = vm.getObjectValue(src)
        if not value or value.type ~= 'function' then
            return
        end
        local defs = vm.getDefs(src)
        for _, def in ipairs(defs) do
            if def == src then
                goto CONTINUE
            end
            if  def.type ~= 'setfield'
            and def.type ~= 'setmethod'
            and def.type ~= 'setindex' then
                goto CONTINUE
            end
            local defValue = vm.getObjectValue(def)
            if not defValue or defValue.type ~= 'function' then
                goto CONTINUE
            end
            callback {
                start   = src.start,
                finish  = src.finish,
                related = {{
                    start  = def.start,
                    finish = def.finish,
                    uri    = guide.getUri(def),
                }},
                message = lang.script('DIAG_DUPLICATE_SET_FIELD', name),
            }
            ::CONTINUE::
        end
    end)
end
