local lang = require 'language'
local config = require 'config'

local DiagnosticSeverity = {
    Error       = 1,
    Warning     = 2,
    Information = 3,
    Hint        = 4,
}

local mt = {}
mt.__index = mt

function mt:searchUnusedLocals(callback)
    self.vm:eachSource(function (source)
        local loc = source:bindLocal()
        if not loc then
            return
        end
        local name = loc:getName()
        if name == '_' or name == '_ENV' or name == '' then
            return
        end
        if source:action() ~= 'local' then
            return
        end
        if loc:get 'hide' then
            return
        end
        local used = loc:eachInfo(function (info)
            if info.type == 'get' then
                return true
            end
        end)
        if not used then
            callback(source.start, source.finish, name)
        end
    end)
end

function mt:searchUndefinedGlobal(callback)
    self.vm:eachSource(function (source)
        if not source:get 'global' then
            return
        end
        local value = source:bindValue()
        if not value then
            return
        end
        if source:action() ~= 'get' then
            return
        end
        if value:getLib() then
            return
        end
        local name = source:getName()
        if name == '' then
            return
        end
        if type(name) ~= 'string' then
            return
        end
        if config.config.diagnostics.globals[name] then
            return
        end
        local defined = value:eachInfo(function (info)
            if info.type == 'set' then
                return true
            end
        end)
        if not defined then
            callback(source.start, source.finish, name)
        end
    end)
end

function mt:searchUnusedLabel(callback)
    self.vm:eachSource(function (source)
        local label = source:bindLabel()
        if not label then
            return
        end
        if source:action() ~= 'set' then
            return
        end
        local used = label:eachInfo(function (info)
            if info.type == 'get' then
                return true
            end
        end)
        if not used then
            callback(source.start, source.finish, label:getName())
        end
    end)
end

local function isContainPos(obj, start, finish)
    if obj.start <= start and obj.finish + 1 >= finish then
        return true
    end
    return false
end

local function isInString(vm, start, finish)
    for _, source in ipairs(vm.sources) do
        if source.type == 'string' and isContainPos(source, start, finish) then
            return true
        end
    end
    return false
end

function mt:searchSpaces(callback)
    local vm = self.vm
    local lines = self.lines
    for i = 1, #lines do
        local line = lines:line(i)

        if line:find '^[ \t]+$' then
            local start, finish = lines:range(i)
            if isInString(vm, start, finish) then
                goto NEXT_LINE
            end
            callback(start, finish, lang.script.DIAG_LINE_ONLY_SPACE)
            goto NEXT_LINE
        end

        local pos = line:find '[ \t]+$'
        if pos then
            local start, finish = lines:range(i)
            start = start + pos - 1
            if isInString(vm, start, finish) then
                goto NEXT_LINE
            end
            callback(start, finish, lang.script.DIAG_LINE_POST_SPACE)
            goto NEXT_LINE
        end

        ::NEXT_LINE::
    end
end

function mt:searchRedefinition(callback)
    local used = {}
    local uri = self.uri
    self.vm:eachSource(function (source)
        local loc = source:bindLocal()
        if not loc then
            return
        end
        local shadow = loc:shadow()
        if not shadow then
            return
        end
        if used[shadow] then
            return
        end
        used[shadow] = true
        if loc:get 'hide' then
            return
        end
        local name = loc:getName()
        if name == '_' or name == '_ENV' or name == '' then
            return
        end
        local related = {}
        for i = 1, #shadow do
            related[i] = {
                start  = shadow[i].source.start,
                finish = shadow[i].source.finish,
                uri    = uri,
            }
        end
        for i = 2, #shadow do
            callback(shadow[i].source.start, shadow[i].source.finish, name, related)
        end
    end)
end

function mt:searchNewLineCall(callback)
    local lines = self.lines
    self.vm:eachSource(function (source)
        if source.type ~= 'simple' then
            return
        end
        for i = 1, #source - 1 do
            local callSource = source[i]
            local funcSource = source[i-1]
            if callSource.type ~= 'call' then
                goto CONTINUE
            end
            local callLine = lines:rowcol(callSource.start)
            local funcLine = lines:rowcol(funcSource.finish)
            if callLine > funcLine then
                callback(callSource.start, callSource.finish)
            end
            :: CONTINUE ::
        end
    end)
end

function mt:searchRedundantParameters(callback)
    self.vm:eachSource(function (source)
        local call, args = source:bindCall()
        if not call then
            return
        end
        local func = call:getFunction()
        if not func then
            return
        end
        -- 参数中有 ... ，不用再检查了
        if func:hasDots() then
            return
        end
        local max = #func.args
        if func:getObject() then
            max = max + 1
        end
        local passed = #args
        for i = max + 1, passed do
            local extra = args[i]
            callback(extra.start, extra.finish, max, passed)
        end
    end)
end

function mt:doDiagnostics(func, code, callback)
    if config.config.diagnostics.disable[code] then
        return
    end
    func(self, function (start, finish, ...)
        local data = callback(...)
        data.code   = code
        data.start  = start
        data.finish = finish
        self.datas[#self.datas+1] = data
    end)
    if coroutine.isyieldable() then
        coroutine.yield()
    end
end

return function (vm, lines, uri)
    local session = setmetatable({
        vm = vm,
        lines = lines,
        uri = uri,
        datas = {},
    }, mt)

    -- 未使用的局部变量
    session:doDiagnostics(session.searchUnusedLocals, 'unused-local', function (key)
        return {
            level   = DiagnosticSeverity.Information,
            message = lang.script('DIAG_UNUSED_LOCAL', key),
        }
    end)
    -- 读取未定义全局变量
    session:doDiagnostics(session.searchUndefinedGlobal, 'undefined-global', function (key)
        return {
            level   = DiagnosticSeverity.Warning,
            message = lang.script('DIAG_UNDEFINED_GLOBAL', key),
        }
    end)
    -- 未使用的Label
    session:doDiagnostics(session.searchUnusedLabel, 'unused-label', function (key)
        return {
            level   =DiagnosticSeverity.Hint,
            message = lang.script('DIAG_UNUSED_LABEL', key)
        }
    end)
    -- 只有空格与制表符的行，以及后置空格
    session:doDiagnostics(session.searchSpaces, 'trailing-space', function (message)
        return {
            level   = DiagnosticSeverity.Hint,
            message = message,
        }
    end)
    -- 重定义局部变量
    session:doDiagnostics(session.searchRedefinition, 'redefined-local', function (key, related)
        return {
            level   = DiagnosticSeverity.Hint,
            message = lang.script('DIAG_REDEFINED_LOCAL', key),
            related = related,
        }
    end)
    -- 以括号开始的一行（可能被误解析为了上一行的call）
    session:doDiagnostics(session.searchNewLineCall, 'newline-call', function ()
        return {
            level   = DiagnosticSeverity.Information,
            message = lang.script.DIAG_PREVIOUS_CALL,
        }
    end)
    -- 调用函数时的参数数量是否超过函数的接收数量
    session:doDiagnostics(session.searchRedundantParameters, 'remainder-parameters', function (max, passed)
        return {
            level   = DiagnosticSeverity.Information,
            message = lang.script('DIAG_OVER_MAX_ARGS', max, passed),
        }
    end)
    return session.datas
end
