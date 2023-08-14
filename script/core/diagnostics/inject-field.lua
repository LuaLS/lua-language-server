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

        local class = vm.getDefinedClass(uri, node)
        if class then
            return
        end

        for _, def in ipairs(vm.getDefs(src)) do
            local dnode = def.node
            if dnode and vm.getDefinedClass(uri, dnode) then
                return
            end
            if def.type == 'doc.type.field' then
                return
            end
            if def.type == 'doc.field' then
                return
            end
        end

        local howToFix = lang.script('DIAG_INJECT_FIELD_FIX_CLASS', {
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
        elseif src.type == 'setfield' and src.method then
            callback {
                start   = src.method.start,
                finish  = src.method.finish,
                message = message,
            }
        end
    end
    guide.eachSourceType(ast.ast, 'setfield',  checkInjectField)
    guide.eachSourceType(ast.ast, 'setmethod', checkInjectField)
end
