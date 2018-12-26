local lang = require 'language'

local function searchUnusedLocals(results, callback)
    for _, var in ipairs(results.locals) do
        if var.key == 'self'
        or var.key == '_'
        or var.key == '_ENV'
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
        local lIndex = index:lower()
        if lIndex == 'log' or lIndex == 'arg' then
            goto NEXT_VAR
        end
        if not index:find '%l' then
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
    searchUnusedLocals(results, function (start, finish, key)
        datas[#datas+1] = {
            start   = start,
            finish  = finish,
            level   = 'Information',
            message = lang.script('DIAG_UNUSED_LOCAL', key),
        }
    end)
    -- 读取未定义全局变量
    searchUndefinedGlobal(results, function (start, finish, key)
        datas[#datas+1] = {
            start   = start,
            finish  = finish,
            level   = 'Warning',
            message = lang.script('DIAG_UNDEFINED_GLOBAL', key),
        }
    end)
    -- 未使用的Label
    searchUnusedLabel(results, function (start, finish, key)
        datas[#datas+1] = {
            start   = start,
            finish  = finish,
            level   = 'Information',
            message = lang.script('DIAG_UNUSED_LABEL', key)
        }
    end)
    -- 只有空格与制表符的行，以及后置空格
    searchSpaces(vm, lines, function (start, finish, message)
        datas[#datas+1] = {
            start   = start,
            finish  = finish,
            level   = 'Information',
            message = message,
        }
    end)
    -- 重定义局部变量
    searchRedefinition(results, uri, function (start, finish, key, related)
        datas[#datas+1] = {
            start   = start,
            finish  = finish,
            level   = 'Information',
            message = lang.script('DIAG_REDEFINED_LOCAL', key),
            related = related,
        }
    end)
    -- 以括号开始的一行（可能被误解析为了上一行的call）
    searchNewLineCall(results, lines, function (start, finish)
        datas[#datas+1] = {
            start   = start,
            finish  = finish,
            level   = 'Warning',
            message = lang.script.DIAG_PREVIOUS_CALL,
        }
    end)
    -- 调用函数时的参数数量是否超过函数的接收数量
    searchRedundantParameters(results, function (start, finish, max, passed)
        datas[#datas+1] = {
            start   = start,
            finish  = finish,
            level   = 'Warning',
            message = lang.script('DIAG_OVER_MAX_ARGS', max, passed),
        }
    end)
    return datas
end
