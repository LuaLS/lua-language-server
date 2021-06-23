local files   = require 'files'
local vm      = require 'vm'
local lang    = require 'language'
local config  = require 'config'
local guide   = require 'parser.guide'
local define  = require 'proto.define'

local SkipCheckClass = {
    ['unknown'] = true,
    ['any']     = true,
    ['table']   = true,
    ['nil']     = true,
}

return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    local cache = vm.getCache 'undefined-field'

    local function checkUndefinedField(src)
        if #vm.getDefs(src) > 0 then
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
    guide.eachSourceType(ast.ast, 'getfield', checkUndefinedField);
    guide.eachSourceType(ast.ast, 'getmethod', checkUndefinedField);
end
