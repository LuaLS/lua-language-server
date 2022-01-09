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

local sleepRest = 0.0

---@async
local function checkSleep(uri, passed)
    local speedRate = config.get(uri, 'Lua.diagnostics.workspaceRate')
    if speedRate <= 0 or speedRate >= 100 then
        return
    end
    local sleepTime = passed * (100 - speedRate) / speedRate
    if sleepTime + sleepRest < 0.001 then
        sleepRest = sleepRest + sleepTime
        return
    end
    sleepRest = sleepTime + sleepRest
    sleepTime = sleepRest
    if sleepTime > 0.1 then
        sleepTime = 0.1
    end
    local clock = os.clock()
    await.sleep(sleepTime)
    local sleeped = os.clock() - clock

    sleepRest = sleepRest - sleeped
end

---@async
---@param uri uri
---@param name string
---@param isScopeDiag boolean
---@param response async fun(result: any)
local function check(uri, name, isScopeDiag, response)
    if config.get(uri, 'Lua.diagnostics.disable')[name] then
        return
    end
    local level =  config.get(uri, 'Lua.diagnostics.severity')[name]
                or define.DiagnosticDefaultSeverity[name]

    local neededFileStatus =   config.get(uri, 'Lua.diagnostics.neededFileStatus')[name]
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
    ---@async
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
        response(result)
    end, name)
    local passed = os.clock() - clock
    if passed >= 0.5 then
        log.warn(('Diagnostics [%s] @ [%s] takes [%.3f] sec!'):format(name, uri, passed))
    end
    if isScopeDiag then
        checkSleep(uri, passed)
    end
    if DIAGTIMES then
        DIAGTIMES[name] = (DIAGTIMES[name] or 0) + passed
    end
end

---@async
---@param uri uri
---@param isScopeDiag boolean
---@param response async fun(result: any)
---@param checked  async fun(name: string)
return function (uri, isScopeDiag, response, checked)
    local ast = files.getState(uri)
    if not ast then
        return nil
    end

    if TEST then
        log.debug('do diagnostic @', uri)
    end

    for _, name in ipairs(diagList) do
        await.delay()
        check(uri, name, isScopeDiag, response)
        if checked then
            checked(name)
        end
    end
end
