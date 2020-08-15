local files  = require 'files'
local define = require 'proto.define'
local config = require 'config'
local await  = require 'await'

local function check(uri, name, level, results)
    if config.config.diagnostics.disable[name] then
        return
    end
    level = config.config.diagnostics.severity[name] or level
    local severity = define.DiagnosticSeverity[level]
    local clock = os.clock()
    require('core.diagnostics.' .. name)(uri, function (result)
        result.level = severity or result.level
        result.code  = name
        results[#results+1] = result
    end, name)
    local passed = os.clock() - clock
    if passed >= 0.5 then
        log.warn(('Diagnostics [%s] @ [%s] takes [%.3f] sec!'):format(name, uri, passed))
    end
end

return function (uri)
    local vm  = require 'vm'
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end
    local results = {}

    for name, level in pairs(define.DiagnosticDefaultSeverity) do
        await.delay()
        vm.setSearchLevel(0)
        check(uri, name, level, results)
    end

    if #results == 0 then
        return nil
    end

    return results
end
