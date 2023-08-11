local files   = require 'files'
local vm      = require 'vm'
local lang    = require 'language'
local guide   = require 'parser.guide'
local await   = require 'await'

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
        if node then
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
        end
        local message = lang.script('DIAG_INJECT_FIELD', guide.getKeyName(src))
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
