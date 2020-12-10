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

    local function is_G(src)
        if not src then
            return false
        end
        while src.node ~= nil and src.type == 'getfield' and src.field[1] == '_G' do
            src = src.node
        end
        return src.type == 'getglobal' and src.special == '_G'
    end

    local function canInfer2Class(src)
        local className = vm.getClass(src, 0)
        if not className then
            local inferType = vm.getInferType(src, 0)
            if inferType ~= 'any' and inferType ~= 'table' then
                className = inferType
            end
        end

        return className and className ~= 'table'
    end

    local function checkUndefinedField(src)
        local fieldName = guide.getKeyName(src)
        if is_G(src)then
            return
        end

        if not canInfer2Class(src.node) then
            return
        end
    
        local refs = vm.getFields(src.node, 0)

        local fields = {}
        local empty = true
        for _, ref in ipairs(refs) do
            if ref.type == 'getfield' or ref.type == 'getmethod' then
                goto CONTINUE
            end
            local name = vm.getKeyName(ref)
            if not name or vm.getKeyType(ref) ~= 'string' then
                goto CONTINUE
            end
            fields[name] = true
            empty = false
            ::CONTINUE::
        end

        -- 没找到任何 field，跳过检查
        if empty then
            return
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
