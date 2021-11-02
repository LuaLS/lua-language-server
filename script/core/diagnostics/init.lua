local files  = require 'files'
local define = require 'proto.define'
local config = require 'config'
local await  = require 'await'
local vm     = require "vm.vm"

-- 把耗时最长的诊断放到最后面
local diagSort = {
    ['deprecated'] = 98,
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
    if config.get 'Lua.diagnostics.disable'[name] then
        return
    end
    local level =  config.get 'Lua.diagnostics.severity'[name]
                or define.DiagnosticDefaultSeverity[name]

    local neededFileStatus =   config.get 'Lua.diagnostics.neededFileStatus'[name]
                            or define.DiagnosticDefaultNeededFileStatus[name]

    if neededFileStatus == 'None' then
        return
    end

    if neededFileStatus == 'Opened' and not files.isOpen(uri) then
        return
    end

    local severity = define.DiagnosticSeverity[level]
    local clock = os.clock()
    local mark = {}
    require('core.diagnostics.' .. name)(uri, function (result)
        if vm.isDiagDisabledAt(uri, result.start, name) then
            return
        end
        if result.start < 0 then
            return
        end
        if mark[result.start] then
            return
        end
        mark[result.start] = true
        result.level = severity or result.level
        result.code  = name
        results[#results+1] = result
    end, name)
    local passed = os.clock() - clock
    if passed >= 0.5 then
        log.warn(('Diagnostics [%s] @ [%s] takes [%.3f] sec!'):format(name, uri, passed))
    end
    if DIAGTIMES then
        DIAGTIMES[name] = (DIAGTIMES[name] or 0) + passed
    end
end

---@async
return function (uri, response)
    local ast = files.getState(uri)
    if not ast then
        return nil
    end

    if TEST then
        log.debug('do diagnostic @', uri)
    end

    for _, name in ipairs(diagList) do
        await.delay()
        local results = {}
        check(uri, name, results)
        response(results)
    end
end
