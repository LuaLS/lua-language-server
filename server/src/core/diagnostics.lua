local lang = require 'language'
local config = require 'config'

local DiagnosticSeverity = {
    Error       = 1,
    Warning     = 2,
    Information = 3,
    Hint        = 4,
}

local function searchUnusedLocals(results, callback)
    for _, var in ipairs(results.locals) do
        if var.key == 'self'
        or var.key == '_'
        or var.key == '_ENV'
        or var.key == ''
        then
            goto NEXT_VAR
        end
        for _, info in ipairs(var) do
            if info.type == 'get' then
                goto NEXT_VAR
            end
            if info.type == 'local' then
                if info.source.start == 0 then
                    goto NEXT_VAR
                end
            end
        end
        callback(var.source.start, var.source.finish, var.key)
        ::NEXT_VAR::
    end
end

local function searchUndefinedGlobal(results, callback)
    local env = results.locals[1]
    for index, field in pairs(env.value.child) do
        if field.value.lib then
            goto NEXT_VAR
        end
        if type(index) ~= 'string' then
            goto NEXT_VAR
        end
        if config.config.diagnostics.globals[index] then
            goto NEXT_VAR
        end
        local lIndex = index:lower()
        if lIndex == 'log' or lIndex == '' then
            goto NEXT_VAR
        end
        if index:find '^_*%u' then
            goto NEXT_VAR
        end
        for _, info in ipairs(field) do
            if info.type == 'set' then
                goto NEXT_VAR
            end
        end
        for _, info in ipairs(field) do
            if info.type == 'get' then
                callback(info.source.start, info.source.finish, tostring(index))
            end
        end
        ::NEXT_VAR::
    end
end

local function searchUnusedLabel(results, callback)
    for _, label in ipairs(results.labels) do
        for _, info in ipairs(label) do
            if info.type == 'goto' then
                goto NEXT_LABEL
            end
        end
        for _, info in ipairs(label) do
            if info.type == 'set' then
                callback(info.source.start, info.source.finish, label.key)
            end
        end
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

local function searchSpaces(vm, lines, callback)
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

local function searchRedefinition(results, uri, callback)
    local used = {}
    for _, var in ipairs(results.locals) do
        if var.key == '_'
        or var.key == '_ENV'
        or var.key == ''
        then
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

local function searchNewLineCall(results, lines, callback)
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

local function searchRedundantParameters(results, callback)
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

return function (vm, lines, uri)
    local datas = {}
    local results = vm.results
    -- 未使用的局部变量
    if not config.config.diagnostics.disable['unused-local'] then
        searchUnusedLocals(results, function (start, finish, key)
            datas[#datas+1] = {
                code    = 'unused-local',
                start   = start,
                finish  = finish,
                level   = DiagnosticSeverity.Information,
                message = lang.script('DIAG_UNUSED_LOCAL', key),
            }
        end)
    end
    -- 读取未定义全局变量
    if not config.config.diagnostics.disable['undefined-global'] then
        searchUndefinedGlobal(results, function (start, finish, key)
            datas[#datas+1] = {
                code    = 'undefined-global',
                start   = start,
                finish  = finish,
                level   = DiagnosticSeverity.Warning,
                message = lang.script('DIAG_UNDEFINED_GLOBAL', key),
            }
        end)
    end
    -- 未使用的Label
    if not config.config.diagnostics.disable['unused-label'] then
        searchUnusedLabel(results, function (start, finish, key)
            datas[#datas+1] = {
                code    = 'unused-label',
                start   = start,
                finish  = finish,
                level   =DiagnosticSeverity.Information,
                message = lang.script('DIAG_UNUSED_LABEL', key)
            }
        end)
    end
    -- 只有空格与制表符的行，以及后置空格
    if not config.config.diagnostics.disable['trailing-space'] then
        searchSpaces(vm, lines, function (start, finish, message)
            datas[#datas+1] = {
                code    = 'trailing-space',
                start   = start,
                finish  = finish,
                level   = DiagnosticSeverity.Information,
                message = message,
            }
        end)
    end
    -- 重定义局部变量
    if not config.config.diagnostics.disable['redefined-local'] then
        searchRedefinition(results, uri, function (start, finish, key, related)
            datas[#datas+1] = {
                code    = 'redefined-local',
                start   = start,
                finish  = finish,
                level   = DiagnosticSeverity.Information,
                message = lang.script('DIAG_REDEFINED_LOCAL', key),
                related = related,
            }
        end)
    end
    -- 以括号开始的一行（可能被误解析为了上一行的call）
    if not config.config.diagnostics.disable['newline-call'] then
        searchNewLineCall(results, lines, function (start, finish)
            datas[#datas+1] = {
                code    = 'newline-call',
                start   = start,
                finish  = finish,
                level   = DiagnosticSeverity.Information,
                message = lang.script.DIAG_PREVIOUS_CALL,
            }
        end)
    end
    -- 调用函数时的参数数量是否超过函数的接收数量
    if not config.config.diagnostics.disable['remainder-parameters'] then
        searchRedundantParameters(results, function (start, finish, max, passed)
            datas[#datas+1] = {
                code    = 'remainder-parameters',
                start   = start,
                finish  = finish,
                level   = DiagnosticSeverity.Warning,
                message = lang.script('DIAG_OVER_MAX_ARGS', max, passed),
            }
        end)
    end
    return datas
end
