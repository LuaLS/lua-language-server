local files  = require 'files'
local define = require 'proto.define'
local config = require 'config'
local await  = require 'await'

-- 把耗时最长的诊断放到最后面
local diagLevel = {
    ['redundant-parameter'] = 100,
}

local diagList = {}
for k in pairs(define.DiagnosticDefaultSeverity) do
    diagList[#diagList+1] = k
end
table.sort(diagList, function (a, b)
    return (diagLevel[a] or 0) < (diagLevel[b] or 0)
end)

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

return function (uri, response)
    local vm  = require 'vm'
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end

    for _, name in ipairs(diagList) do
        local level = define.DiagnosticDefaultSeverity[name]
        await.delay()
        local results = {}
        check(uri, name, level, results)
        response(results)
    end
end
