local files   = require 'files'
local vm      = require 'vm'
local lang    = require 'language'
local guide   = require 'parser.guide'
local noder   = require 'core.noder'
local await   = require 'await'

local SkipCheckClass = {
    ['unknown']       = true,
    ['any']           = true,
    ['table']         = true,
    ['nil']           = true,
    ['number']        = true,
    ['integer']       = true,
    ['boolean']       = true,
    ['function']      = true,
    ['userdata']      = true,
    ['lightuserdata'] = true,
}

---@async
return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    local cache = {}

    ---@async
    local function checkUndefinedField(src)
        local id = noder.getID(src)
        if not id then
            return
        end
        if cache[id] then
            return
        end

        await.delay()

        if #vm.getDefs(src) > 0 then
            cache[id] = true
            return
        end
        local node = src.node
        if node then
            local defs = vm.getDefs(node)
            local ok
            for _, def in ipairs(defs) do
                if  def.type == 'doc.class.name'
                and not SkipCheckClass[def[1]] then
                    ok = true
                    break
                end
            end
            if not ok then
                cache[id] = true
                return
            end
        end
        local message = lang.script('DIAG_UNDEF_FIELD', guide.getKeyName(src))
        if src.type == 'getfield' and src.field then
            callback {
                start   = src.field.start,
                finish  = src.field.finish,
                message = message,
            }
        elseif src.type == 'getmethod' and src.method then
            callback {
                start   = src.method.start,
                finish  = src.method.finish,
                message = message,
            }
        end
    end
    guide.eachSourceType(ast.ast, 'getfield',  checkUndefinedField)
    guide.eachSourceType(ast.ast, 'getmethod', checkUndefinedField)
    guide.eachSourceType(ast.ast, 'getindex',  checkUndefinedField)
end
