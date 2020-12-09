local files   = require 'files'
local vm      = require 'vm'
local lang    = require 'language'
local config  = require 'config'
local guide   = require 'parser.guide'
local define  = require 'proto.define'

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end

    local function checkUndefinedField(src)
        local fieldName = guide.getKeyName(src)
        local refs = vm.getFields(src.node, 0)

        local fields = {}
        for _, ref in ipairs(refs) do
            if ref.type == 'getfield' or ref.type == 'getmethod' then
                goto CONTINUE
            end
            local name = vm.getKeyName(ref)
            if not name or vm.getKeyType(ref) ~= 'string' then
                goto CONTINUE
            end
            fields[name] = true
            ::CONTINUE::
        end

        if not fields[fieldName] then
            local message = lang.script('DIAG_UNDEF_FIELD', fieldName)
            callback {
                start   = src.start,
                finish  = src.finish,
                message = message,
            }
        end
    end
    guide.eachSourceType(ast.ast, 'getfield', checkUndefinedField);
    guide.eachSourceType(ast.ast, 'getmethod', checkUndefinedField);
end
