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

    local function getDocClassFromInfer(src)
        local infers = vm.getInfers(src, 0)

        if not infers then
            return nil
        end

        for i = 1, #infers do
            local infer = infers[i]
            if infer.type ~= '_G' then
                local inferSource = infer.source
                if inferSource.type == 'doc.class' then
                    return inferSource
                elseif inferSource.type == 'doc.class.name' then
                    return inferSource.parent
                end
            end
        end

        return nil
    end

    local function checkUndefinedField(src)
        local fieldName = guide.getKeyName(src)

        local docClass = getDocClassFromInfer(src.node)
        if not docClass then
            return
        end

        local refs = vm.getFields(docClass)

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
