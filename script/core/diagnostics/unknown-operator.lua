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
                local opName = op[1]
                if  not vm.OP_BINARY_MAP[opName]
                and not vm.OP_UNARY_MAP[opName]
                and not vm.OP_OTHER_MAP[opName] then
                    callback {
                        start   = doc.op.start,
                        finish  = doc.op.finish,
                        message = lang.script('DIAG_UNKNOWN_OPERATOR', opName)
                    }
                end
            end
        end
    end
end
