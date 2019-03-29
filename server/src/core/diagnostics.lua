local lang = require 'language'
local config = require 'config'
local library = require 'core.library'
local buildGlobal = require 'vm.global'

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
    local definedGlobal = {}
    for name in pairs(config.config.diagnostics.globals) do
        definedGlobal[name] = true
    end
    local envValue = buildGlobal(self.vm.lsp)
    envValue:eachInfo(function (info)
        if info.type == 'set child' then
            local name = info[1]
            definedGlobal[name] = true
        end
    end)
    self.vm:eachSource(function (source)
        if not source:get 'global' then
            return
        end
        local name = source:getName()
        if name == '' then
            return
        end
        local parent = source:get 'parent'
        if not parent then
            return
        end
        if not parent:get 'ENV' then
            return
        end
        if definedGlobal[name] then
            return
        end
        if type(name) ~= 'string' then
            return
        end
        callback(source.start, source.finish, name)
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
    if obj.start <= start and obj.finish >= finish then
        return true
    end
    return false
end

local function isInString(vm, start, finish)
    return vm:eachSource(function (source)
        if source.type == 'string' and isContainPos(source, start, finish) then
            return true
        end
    end)
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
                start  = shadow[i]:getSource().start,
                finish = shadow[i]:getSource().finish,
                uri    = uri,
            }
        end
        for i = 2, #shadow do
            callback(shadow[i]:getSource().start, shadow[i]:getSource().finish, name, related)
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
        local passed = #args
        for i = max + 1, passed do
            local extra = args[i]
            callback(extra.start, extra.finish, max, passed)
        end
    end)
end

function mt:searchAmbiguity1(callback)
    self.vm:eachSource(function (source)
        if source.op ~= 'or' then
            return
        end
        local exp = source[2]
        if exp.op ~= '+' and exp.op ~= '-' then
            return
        end
        if exp[1][1] == 0 and exp[2].type == 'number' then
            callback(source.start, source.finish, exp.op, exp[2][1])
        end
    end)
end

function mt:searchLowercaseGlobal(callback)
    local definedGlobal = {}
    for name in pairs(config.config.diagnostics.globals) do
        definedGlobal[name] = true
    end
    for name in pairs(library.global) do
        definedGlobal[name] = true
    end
    local uri = self.vm.uri
    local envValue = self.vm.env:getValue()
    envValue:eachInfo(function (info, src)
        if info.type == 'set child' and src.uri == uri then
            local name = info[1]
            if definedGlobal[name] then
                return
            end
            local first = name:match '%w'
            if not first then
                return
            end
            if first:match '%l' then
                callback(src.start, src.finish)
            end
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
        if self.vm:isRemoved() then
            coroutine.yield('stop')
        else
            coroutine.yield()
        end
    end
end

function mt:searchUndefinedEnvChild(callback)
    self.vm:eachSource(function (source)
        if not source:get 'global' then
            return
        end
        local name = source:getName()
        if name == '' then
            return
        end
        local parent = source:get 'parent'
        if parent:get 'ENV' then
            return
        end
        local ok = parent:eachInfo(function (info)
            if info.type == 'set child' and info[1] == name then
                return true
            end
        end)
        if ok then
            return
        end
        callback(source.start, source.finish, name)
        return
    end)
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
            level   = DiagnosticSeverity.Hint,
            message = lang.script('DIAG_UNUSED_LOCAL', key),
        }
    end)
    -- 读取未定义全局变量
    session:doDiagnostics(session.searchUndefinedGlobal, 'undefined-global', function (key)
        return {
            level   = DiagnosticSeverity.Warning,
            message = lang.script('DIAG_UNDEF_GLOBAL', key),
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
    -- x or 0 + 1
    session:doDiagnostics(session.searchAmbiguity1, 'ambiguity-1', function (op, num)
        return {
            level   = DiagnosticSeverity.Warning,
            message = lang.script('DIAG_AMBIGUITY_1', op, num),
        }
    end)
    -- 不允许定义首字母小写的全局变量（很可能是拼错或者漏删）
    session:doDiagnostics(session.searchLowercaseGlobal, 'lowercase-global', function ()
        return {
            level   = DiagnosticSeverity.Information,
            message = lang.script.DIAG_LOWERCASE_GLOBAL,
        }
    end)
    -- 未定义的变量（重载了 `_ENV`）
    session:doDiagnostics(session.searchUndefinedEnvChild, 'undefined-env-child', function (key)
        return {
            level   = DiagnosticSeverity.Information,
            message = lang.script('DIAG_UNDEF_ENV_CHILD', key),
        }
    end)
    return session.datas
end
