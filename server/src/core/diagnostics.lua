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
    local results = self.results
    for _, var in ipairs(results.locals) do
        if var.key == '_'
        or var.key == '_ENV'
        or var.key == ''
        then
            goto NEXT_VAR
        end
        if var.hide then
            goto NEXT_VAR
        end
        local ok = self.vm:eachInfo(var, function (info)
            if info.type == 'get' then
                return true
            end
            if info.type == 'local' then
                if info.source.start == 0 then
                    return true
                end
            end
        end)
        if ok then
            goto NEXT_VAR
        end
        callback(var.source.start, var.source.finish, var.key)
        ::NEXT_VAR::
    end
end

function mt:searchUndefinedGlobal(callback)
    local globalValue = self.vm.lsp.globalValue
    globalValue:eachField(function (index, field)
        if field.value.lib then
            goto NEXT_VAR
        end
        if type(index) ~= 'string' then
            goto NEXT_VAR
        end
        if config.config.diagnostics.globals[index] then
            goto NEXT_VAR
        end
        if index == '' then
            goto NEXT_VAR
        end
        local ok = self.vm:eachInfo(field, function (info)
            if info.type == 'set' then
                return true
            end
        end)
        if ok then
            goto NEXT_VAR
        end
        self.vm:eachInfo(field, function (info)
            if info.type == 'get' then
                callback(info.source.start, info.source.finish, tostring(index))
            end
        end)
        ::NEXT_VAR::
    end)
end

function mt:searchUnusedLabel(callback)
    local results = self.results
    for _, label in ipairs(results.labels) do
        local ok = self.vm:eachInfo(label, function (info)
            if info.type == 'goto' then
                return true
            end
        end)
        if ok then
            goto NEXT_LABEL
        end
        self.vm:eachInfo(label, function (info)
            if info.type == 'set' then
                callback(info.source.start, info.source.finish, label.key)
            end
        end)
        ::NEXT_LABEL::
    end
end

local function isContainPos(obj, start, finish)
    if obj.start <= start and obj.finish + 1 >= finish then
        return true
    end
    return false
end

local function isInString(vm, start, finish)
    for _, source in ipairs(vm.results.strings) do
        if isContainPos(source, start, finish) then
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
    local results = self.results
    local uri = self.uri
    local used = {}
    for _, var in ipairs(results.locals) do
        if var.key == '_'
        or var.key == '_ENV'
        or var.key == ''
        then
            goto NEXT_VAR
        end
        if var.hide then
            goto NEXT_VAR
        end
        local shadow = var.shadow
        if not shadow then
            goto NEXT_VAR
        end
        if used[shadow] then
            goto NEXT_VAR
        end
        used[shadow] = true
        -- 如果多次重定义，则不再警告
        if #shadow >= 4 then
            goto NEXT_VAR
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
            callback(shadow[i].source.start, shadow[i].source.finish, shadow[i].key, related)
        end
        ::NEXT_VAR::
    end
end

function mt:searchNewLineCall(callback)
    local results = self.results
    local lines = self.lines
    for _, call in ipairs(results.calls) do
        if not call.nextObj then
            goto NEXT_CALL
        end
        if not call.lastObj.start then
            goto NEXT_CALL
        end
        local callline = lines:rowcol(call.args.start)
        local lastline = lines:rowcol(call.lastObj.finish)
        if callline > lastline then
            callback(call.args.start, call.args.finish)
        end
        ::NEXT_CALL::
    end
end

function mt:searchRedundantParameters(callback)
    local results = self.results
    for _, call in ipairs(results.calls) do
        if not call.func.built then
            goto NEXT_CALL
        end
        if call.func.hasDots then
            goto NEXT_CALL
        end
        if not call.func.args then
            return
        end
        local max = #call.func.args
        local passed = #call.args
        for i = max + 1, passed do
            local source = call.args[i]
            if source.start then
                callback(source.start, source.finish, max, passed)
            else
                log.error('No start: ', table.dump(source))
            end
        end
        ::NEXT_CALL::
    end
end

function mt:doDiagnostics(func, code, callback)
    if config.config.diagnostics.disable[code] then
        return
    end
    self[func](self, function (start, finish, ...)
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
        results = vm.results,
        lines = lines,
        uri = uri,
        datas = {},
    }, mt)

    -- 未使用的局部变量
    session:doDiagnostics('searchUnusedLocals', 'unused-local', function (key)
        return {
            level   = DiagnosticSeverity.Information,
            message = lang.script('DIAG_UNUSED_LOCAL', key),
        }
    end)
    -- 读取未定义全局变量
    session:doDiagnostics('searchUndefinedGlobal', 'undefined-global', function (key)
        return {
            level   = DiagnosticSeverity.Warning,
            message = lang.script('DIAG_UNDEFINED_GLOBAL', key),
        }
    end)
    -- 未使用的Label
    session:doDiagnostics('searchUnusedLabel', 'unused-label', function (key)
        return {
            level   =DiagnosticSeverity.Hint,
            message = lang.script('DIAG_UNUSED_LABEL', key)
        }
    end)
    -- 只有空格与制表符的行，以及后置空格
    session:doDiagnostics('searchSpaces', 'trailing-space', function (message)
        return {
            level   = DiagnosticSeverity.Hint,
            message = message,
        }
    end)
    -- 重定义局部变量
    session:doDiagnostics('searchRedefinition', 'redefined-local', function (key, related)
        return {
            level   = DiagnosticSeverity.Information,
            message = lang.script('DIAG_REDEFINED_LOCAL', key),
            related = related,
        }
    end)
    -- 以括号开始的一行（可能被误解析为了上一行的call）
    session:doDiagnostics('searchNewLineCall', 'newline-call', function ()
        return {
            level   = DiagnosticSeverity.Information,
            message = lang.script.DIAG_PREVIOUS_CALL,
        }
    end)
    -- 调用函数时的参数数量是否超过函数的接收数量
    session:doDiagnostics('searchRedundantParameters', 'remainder-parameters', function (max, passed)
        return {
            level   = DiagnosticSeverity.Information,
            message = lang.script('DIAG_OVER_MAX_ARGS', max, passed),
        }
    end)
    return session.datas
end
