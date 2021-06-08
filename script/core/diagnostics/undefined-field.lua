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
    local ast = files.getAst(uri)
    if not ast then
        return
    end

    local cache = vm.getCache 'undefined-field'

    local function getAllDocClassFromInfer(src)
        local infers = cache[src]
        if cache[src] == nil then
            tracy.ZoneBeginN('undefined-field getInfers')
            infers = vm.getInfers(src, 0) or false
            local refs = vm.getRefs(src)
            for _, ref in ipairs(refs) do
                cache[ref] = infers
            end
            tracy.ZoneEnd()
        end

        if not infers then
            return nil
        end

        local mark = {}
        local function addTo(allDocClass, src)
            if not mark[src] then
                allDocClass[#allDocClass+1] = src
                mark[src] = true
            end
        end

        local allDocClass = {}
        for i = 1, #infers do
            local infer = infers[i]
            if infer.type ~= '_G' and infer.type ~= 'any' and infer.type ~= 'table' then
                local inferSource = infer.source
                if inferSource.type == 'doc.class' then
                    addTo(allDocClass, inferSource)
                elseif inferSource.type == 'doc.class.name' then
                    addTo(allDocClass, inferSource.parent)
                elseif inferSource.type == 'doc.type.name' then
                    local docTypes = vm.getDocDefines(inferSource[1])
                    for _, docType in ipairs(docTypes) do
                        if docType.type == 'doc.class.name' then
                            addTo(allDocClass, docType.parent)
                        end
                    end
                end
            end
        end

        return allDocClass
    end

    local function getAllFieldsFromAllDocClass(allDocClass)
        local fields = {}
        local empty = true
        for _, docClass in ipairs(allDocClass) do
            tracy.ZoneBeginN('undefined-field getDefFields')
            local refs = vm.getDefs(docClass, '*')
            tracy.ZoneEnd()

            for _, ref in ipairs(refs) do
                local name = vm.getKeyName(ref)
                if not name or vm.getKeyType(ref) ~= 'string' then
                    goto CONTINUE
                end
                fields[name] = true
                empty = false
                ::CONTINUE::
            end
        end

        if empty then
            return nil
        else
            return fields
        end
    end

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
