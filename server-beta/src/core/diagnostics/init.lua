local files  = require 'files'
local define = require 'proto.define'
local config = require 'config'

local function check(uri, name, level, results)
    if config.config.diagnostics.disable[name] then
        return
    end
    level = config.config.diagnostics.severity[name] or level
    require('core.diagnostics.' .. name)(uri, function (result)
        result.level = level or result.level
        result.code  = name
        results[#results+1] = result
    end)
end

return function (uri)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end
    local results = {}

    for name, level in pairs(define.DiagnosticDefaultSeverity) do
        check(uri, name, level, results)
    end

    return results
end
