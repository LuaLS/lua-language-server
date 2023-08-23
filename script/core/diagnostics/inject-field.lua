local files   = require 'files'
local vm      = require 'vm'
local lang    = require 'language'
local guide   = require 'parser.guide'
local await   = require 'await'
local hname   = require 'core.hover.name'

local skipCheckClass = {
    ['unknown']       = true,
    ['any']           = true,
    ['table']         = true,
}

---@async
return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    ---@async
    local function checkInjectField(src)
        await.delay()

        local node = src.node
        if not node then
            return
        end
        local ok
        for view in vm.getInfer(node):eachView(uri) do
            if skipCheckClass[view] then
                return
            end
            ok = true
        end
        if not ok then
            return
        end

        local isExact
        local class = vm.getDefinedClass(uri, node)
        if class then
            for _, doc in ipairs(class:getSets(uri)) do
                if vm.docHasAttr(doc, 'exact') then
                    isExact = true
                    break
                end
            end
            if not isExact then
                return
            end
            if  src.type == 'setmethod'
            and not guide.getSelfNode(node) then
                return
            end
        end

        for _, def in ipairs(vm.getDefs(src)) do
            local dnode = def.node
            if dnode
            and not isExact
            and vm.getDefinedClass(uri, dnode) then
                return
            end
            if def.type == 'doc.type.field' then
                return
            end
            if def.type == 'doc.field' then
                return
            end
        end

        local howToFix = ''
        if not isExact then
            howToFix = lang.script('DIAG_INJECT_FIELD_FIX_CLASS', {
                node = hname(node),
                fix  = '---@class',
            })
            for _, ndef in ipairs(vm.getDefs(node)) do
                if ndef.type == 'doc.type.table' then
                    howToFix = lang.script('DIAG_INJECT_FIELD_FIX_TABLE', {
                        fix   = '[any]: any',
                    })
                    break
                end
            end
        end

        local message = lang.script('DIAG_INJECT_FIELD', {
            class = vm.getInfer(node):view(uri),
            field = guide.getKeyName(src),
            fix   = howToFix,
        })
        if     src.type == 'setfield' and src.field then
            callback {
                start   = src.field.start,
                finish  = src.field.finish,
                message = message,
            }
        elseif src.type == 'setmethod' and src.method then
            callback {
                start   = src.method.start,
                finish  = src.method.finish,
                message = message,
            }
        end
    end
    guide.eachSourceType(ast.ast, 'setfield',  checkInjectField)
    guide.eachSourceType(ast.ast, 'setmethod', checkInjectField)

    ---@async
    local function checkExtraTableField(src)
        await.delay()

        if not src.bindSource then
            return
        end
        if not vm.docHasAttr(src, 'exact') then
            return
        end
        local value = src.bindSource.value
        if not value or value.type ~= 'table' then
            return
        end
        for _, field in ipairs(value) do
            local defs = vm.getDefs(field)
            for _, def in ipairs(defs) do
                if def.type == 'doc.field' then
                    goto nextField
                end
            end
            local message = lang.script('DIAG_INJECT_FIELD', {
                class = vm.getInfer(src):view(uri),
                field = guide.getKeyName(src),
                fix   = '',
            })
            callback {
                start   = field.start,
                finish  = field.finish,
                message = message,
            }
            ::nextField::
        end
    end

    guide.eachSourceType(ast.ast, 'doc.class', checkExtraTableField)
end
