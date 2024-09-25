local files    = require 'files'
local lang     = require 'language'
local guide    = require 'parser.guide'
local vm       = require 'vm'
local await    = require 'await'

local sourceTypes = {
    'setfield',
    'setmethod',
    'setindex',
}

---@param source parser.object
---@return parser.object?
local function getTopFunctionOfIf(source)
    while true do
        if source.type == 'ifblock'
        or source.type == 'elseifblock'
        or source.type == 'elseblock'
        or source.type == 'function'
        or source.type == 'main' then
            return source
        end
        source = source.parent
    end
end

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    if vm.isMetaFile(uri) then
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
        local myTopBlock = getTopFunctionOfIf(src)
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
            local defTopBlock = getTopFunctionOfIf(def)
            if uri == guide.getUri(def) and myTopBlock ~= defTopBlock then
                goto CONTINUE
            end
            local defValue = vm.getObjectValue(def)
            if not defValue or defValue.type ~= 'function' then
                goto CONTINUE
            end
            if vm.getDefinedClass(guide.getUri(def), def.node)
            and not vm.getDefinedClass(guide.getUri(src), src.node)
            then
                -- allow type variable to override function defined in class variable
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
