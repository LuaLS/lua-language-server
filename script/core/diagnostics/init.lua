local files  = require 'files'
local define = require 'proto.define'
local config = require 'config'
local await  = require 'await'

-- 把耗时最长的诊断放到最后面
local diagSort = {
    ['undefined-field'] = 99,
    ['redundant-parameter'] = 100,
}

local diagList = {}
for k in pairs(define.DiagnosticDefaultSeverity) do
    diagList[#diagList+1] = k
end
table.sort(diagList, function (a, b)
    return (diagSort[a] or 0) < (diagSort[b] or 0)
end)

local function check(uri, name, results)
    if config.config.diagnostics.disable[name] then
        return
    end
    local level =  config.config.diagnostics.severity[name]
                or define.DiagnosticDefaultSeverity[name]

    local neededFileStatus =  config.config.diagnostics.neededFileStatus[name]
        or define.DiagnosticDefaultNeededFileStatus[name]
    if neededFileStatus == 'Opened' and not files.isOpen(uri) then
        return
    end
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

    local isOpen = files.isOpen(uri)

    for _, name in ipairs(diagList) do
        await.delay()
        local results = {}
        check(uri, name, results)
        response(results)
    end
end
