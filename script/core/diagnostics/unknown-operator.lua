local files   = require 'files'
local guide   = require 'parser.guide'
local lang    = require 'language'
local vm      = require 'vm'
local await   = require 'await'
local util    = require 'utility'

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    if not state.ast.docs then
        return
    end

    for _, doc in ipairs(state.ast.docs) do
        if doc.type == 'doc.operator' then
            local op = doc.op
            if op then
                if  not util.arrayHas(vm.UNARY_OP, op[1])
                and not util.arrayHas(vm.BINARY_OP, op[1]) then
                    callback {
                        start   = doc.op.start,
                        finish  = doc.op.finish,
                        message = lang.script('DIAG_UNKNOWN_OPERATOR', op[1])
                    }
                end
            end
        end
    end
end
