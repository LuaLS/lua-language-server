require 'vm'
local parser = require 'parser'

local methods = {}

function methods.makeCode(params)
    local coder = ls.vm.createCoder()
    local ast = parser.compile(params.text, params.source, params.options)
    coder:makeFromAst(ast)
    return coder.code
end

return {
    resolve = function (method, params)
        return methods[method](params)
    end,
}
