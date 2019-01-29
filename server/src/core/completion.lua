local findResult = require 'core.find_result'
local hover = require 'core.hover'

local CompletionItemKind = {
    Text = 1,
    Method = 2,
    Function = 3,
    Constructor = 4,
    Field = 5,
    Variable = 6,
    Class = 7,
    Interface = 8,
    Module = 9,
    Property = 10,
    Unit = 11,
    Value = 12,
    Enum = 13,
    Keyword = 14,
    Snippet = 15,
    Color = 16,
    File = 17,
    Reference = 18,
    Folder = 19,
    EnumMember = 20,
    Constant = 21,
    Struct = 22,
    Event = 23,
    Operator = 24,
    TypeParameter = 25,
}

local function matchKey(me, other)
    if me == other then
        return true
    end
    if me == '' then
        return true
    end
    if #me > #other then
        return false
    end
    local lMe = me:lower()
    local lOther = other:lower()
    if lMe:sub(1, 1) ~= lOther:sub(1, 1) then
        return false
    end
    if lMe == lOther:sub(1, #lMe) then
        return true
    end
    local used = {}
    local cur = 1
    local lookup
    local researched
    for i = 1, #lMe do
        local c = lMe:sub(i, i)
        -- 1. 看当前字符是否匹配
        if c == lOther:sub(cur, cur) then
            used[cur] = true
            goto NEXT
        end
        -- 2. 看前一个字符是否匹配
        if not used[cur-1] then
            if c == lOther:sub(cur-1, cur-1) then
                used[cur-1] = true
                goto NEXT
            end
        end
        -- 3. 向后找这个字
        lookup = lOther:find(c, cur+1, true)
        if lookup then
            cur = lookup
            used[cur] = true
            goto NEXT
        end

        -- 4. 重新搜索整个字符串，但是只允许1次，否则失败.如果找不到也失败
        if researched then
            return false
        else
            researched = true
            for j = 1, cur - 2 do
                if c == lOther:sub(j, j) then
                    used[j] = true
                    goto NEXT
                end
            end
            return false
        end
        -- 5. 找到下一个可用的字，如果超出长度且把自己所有字都用尽就算成功
        ::NEXT::
        repeat
            cur = cur + 1
        until not used[cur]
        if cur > #lOther then
            return i == #lMe
        end
    end
    return true
end

local function searchLocals(vm, pos, name, callback)
    for _, loc in ipairs(vm.results.locals) do
        if loc.source.start == 0 then
            goto CONTINUE
        end
        if loc.source.start <= pos and loc.close >= pos then
            if matchKey(name, loc.key) then
                callback(loc)
            end
        end
        ::CONTINUE::
    end
end

local function sortPairs(t)
    local keys = {}
    for k in pairs(t) do
        keys[#keys+1] = k
    end
    table.sort(keys)
    local i = 0
    return function ()
        i = i + 1
        local k = keys[i]
        return k, t[k]
    end
end

local function searchFields(name, source, parent, object, callback)
    if not parent or not parent.value then
        return
    end
    if type(name) ~= 'string' then
        return
    end
    local map = {}
    parent.value:eachField(function (key, field)
        if type(key) ~= 'string' then
            goto CONTINUE
        end
        if object then
            if not field.value or field.value:getType() ~= 'function' then
                goto CONTINUE
            end
        end
        if field.source == source then
            goto CONTINUE
        end
        if matchKey(name, key) then
            map[key] = field
        end
        ::CONTINUE::
    end)
    for _, field in sortPairs(map) do
        callback(field)
    end
end

local KEYS = {'and', 'break', 'do', 'else', 'elseif', 'end', 'false', 'for', 'function', 'goto', 'if', 'in', 'local', 'nil', 'not', 'or', 'repeat', 'return', 'then', 'true', 'until', 'while', 'toclose'}
local function searchKeyWords(name, callback)
    for _, key in ipairs(KEYS) do
        if matchKey(name, key) then
            callback(key)
        end
    end
end

local function getKind(var, default)
    local value = var.value
    if default == CompletionItemKind.Variable then
        if value:getType() == 'function' then
            return CompletionItemKind.Function
        end
    end
    if default == CompletionItemKind.Field then
        local tp = type(value:getValue())
        if tp == 'number' or tp == 'integer' or tp == 'string' then
            return CompletionItemKind.Enum
        end
        if value:getType() == 'function' then
            if var.parent and var.parent.value and var.parent.value.GLOBAL ~= true then
                return CompletionItemKind.Method
            else
                return CompletionItemKind.Function
            end
        end
    end
    return default
end

local function getDetail(var)
    local tp = type(var.value:getValue())
    if tp == 'boolean' then
        return ('= %q'):format(var.value:getValue())
    elseif tp == 'number' then
        if math.type(var.value:getValue()) == 'integer' then
            return ('= %q'):format(var.value:getValue())
        else
            local str = ('= %.10f'):format(var.value:getValue())
            local dot = str:find('.', 1, true)
            local suffix = str:find('[0]+$', dot+2)
            if suffix then
                return str:sub(1, suffix-1)
            else
                return str
            end
        end
    elseif tp == 'string' then
        return ('= %q'):format(var.value:getValue())
    end
    return nil
end

local function getDocument(var, source)
    if not source then
        return nil
    end
    if var.value:getType() == 'function' then
        local hvr = hover(var, source)
        if not hvr then
            return nil
        end
        local text = ([[
```lua
%s
```
%s
```lua
%s
```
]]):format(hvr.label or '', hvr.description or '', hvr.enum or '')
        return {
            kind = 'markdown',
            value = text,
        }
    end
    return nil
end

local function searchAsLocal(vm, word, pos, result, callback)
    searchFields(word, result.source, vm.results.locals[1], nil, function (var)
        callback(var, CompletionItemKind.Variable)
    end)

    -- 支持 local function
    if matchKey(word, 'function') then
        callback('function', CompletionItemKind.Keyword)
    end
end

local function searchAsArg(vm, word, pos, result, callback)
    searchFields(word, result.source, vm.results.locals[1], nil, function (var)
        if var.value.lib then
            return
        end
        callback(var, CompletionItemKind.Variable)
    end)
end

local function searchAsGlobal(vm, word, pos, result, callback)
    if word == '' or word == nil then
        return
    end
    searchLocals(vm, pos, word, function (var)
        callback(var, CompletionItemKind.Variable)
    end)
    searchFields(word, result.source, vm.results.locals[1], nil, function (var)
        callback(var, CompletionItemKind.Field)
    end)
    searchKeyWords(word, function (name)
        callback(name, CompletionItemKind.Keyword)
    end)
end

local function searchAsSuffix(result, word, callback)
    searchFields(word, result.source, result.parent, result.source.object, function (var)
        callback(var, CompletionItemKind.Field)
    end)
end

local function searchInArg(vm, inCall, inString, callback)
    local lib = inCall.func.lib
    if not lib then
        return
    end

    -- require列举出可以引用到的文件
    if lib.special == 'require' then
        if not vm.lsp or not vm.lsp.workspace or not inString then
            return
        end
        local results = vm.lsp.workspace:matchPath(vm.uri, inString[1])
        if not results then
            return
        end
        for _, v in ipairs(results) do
            if v ~= inString[1] then
                callback(v, CompletionItemKind.File, {
                    textEdit = {
                        start = inString.start+1,
                        finish = inString.finish-1,
                        newText = ('%q'):format(v):sub(2, -2),
                    }
                })
            end
        end
    end

    -- 其他库函数，根据参数位置找枚举值
    if lib.args and lib.enums then
        local arg = lib.args[inCall.select]
        local name = arg and arg.name
        for _, enum in ipairs(lib.enums) do
            if enum.name == name and enum.enum then
                if inString then
                    callback(enum.enum, CompletionItemKind.EnumMember, {
                        documentation = enum.description
                    })
                else
                    callback(('%q'):format(enum.enum), CompletionItemKind.EnumMember, {
                        documentation = enum.description
                    })
                end
            end
        end
    end
end

local function searchAsIndex(vm, word, pos, result, callback)
    searchLocals(vm, pos, word, function (var)
        callback(var, CompletionItemKind.Variable)
    end)
    for _, index in ipairs(vm.results.indexs) do
        if matchKey(word, index.key) then
            callback(index.key, CompletionItemKind.Property)
        end
    end
    searchFields(word, result.source, vm.results.locals[1], nil, function (var)
        callback(var, CompletionItemKind.Field)
    end)
end

local function findClosePos(vm, pos)
    local curDis = math.maxinteger
    local parent = nil
    local inputSource = nil
    local function found(object, source)
        local dis = pos - source.finish
        if dis > 1 and dis < curDis then
            curDis = dis
            parent = object
            inputSource = source
        end
    end
    for _, source in ipairs(vm.results.sources) do
        found(source.bind, source)
    end
    if not parent then
        return nil
    end
    if parent.type ~= 'local' and parent.type ~= 'field' then
        return nil
    end
    local sep = inputSource.dot or inputSource.colon
    if not sep then
        return nil
    end
    if sep.finish > pos then
        return nil
    end
    -- 造个假的 DirtyName
    local source = {
        type = 'name',
        start = pos,
        finish = pos,
        object = sep.type == ':' and parent,
        [1]    = '',
    }
    local result = {
        type = 'field',
        parent = parent,
        key = '',
        source = source,
    }
    return result, source
end

local function isContainPos(obj, pos)
    if obj.start <= pos and obj.finish + 1 >= pos then
        return true
    end
    return false
end

local function findString(vm, word, pos)
    local finishPos = pos + #word - 1
    for _, source in ipairs(vm.results.strings) do
        if isContainPos(source, finishPos) then
            return source
        end
    end
    return nil
end

local function findArgCount(args, pos)
    for i, arg in ipairs(args) do
        if isContainPos(arg, pos) then
            return i
        end
    end
    return #args + 1
end

-- 找出范围包含pos的call
local function findCall(vm, word, pos)
    local finishPos = pos + #word - 1
    local results = {}
    for _, call in ipairs(vm.results.calls) do
        if isContainPos(call.args, finishPos) then
            local n = findArgCount(call.args, finishPos)
            local var = call.lastObj.bind
            if var then
                results[#results+1] = {
                    func = call.func,
                    var = var,
                    source = call.lastObj,
                    select = n,
                    args = call.args,
                }
            end
        end
    end
    if #results == 0 then
        return nil
    end
    -- 可能处于 'func1(func2(' 的嵌套中，因此距离越远的函数层级越低
    table.sort(results, function (a, b)
        return a.args.start < b.args.start
    end)
    return results[#results]
end

local function makeList(list, source)
    local mark = {}
    local function callback(var, defualt, data)
        local key
        if type(var) == 'string' then
            key = var
        else
            key = var.key
        end
        if mark[key] then
            return
        end
        mark[key] = true
        data = data or {}
        if var == key then
            data.label = var
            data.kind = defualt
        elseif var.source ~= source then
            data.label = var.key
            data.kind = getKind(var, defualt)
            data.detail = data.detail or getDetail(var)
            data.documentation = data.documentation or getDocument(var, source)
        else
            return
        end
        list[#list+1] = data
    end
    return callback
end

local function searchInResult(result, word, source, vm, pos, callback)
    if result.type == 'local' then
        if result.link then
            result = result.link
        end
        if source.isArg then
            searchAsArg(vm, word, pos, result, callback)
        elseif source.isLocal then
            searchAsLocal(vm, word, pos, result, callback)
        else
            searchAsGlobal(vm, word, pos, result, callback)
        end
    elseif result.type == 'field' then
        if source.isIndex then
            searchAsIndex(vm, word, pos, result, callback)
        elseif result.parent and result.parent.value and result.parent.value.GLOBAL == true then
            searchAsGlobal(vm, word, pos, result, callback)
        else
            searchAsSuffix(result, word, callback)
        end
    end
end

local function searchAllWords(text, vm, callback)
    if text == '' then
        return
    end
    if type(text) ~= 'string' then
        return
    end
    for _, source in ipairs(vm.results.sources) do
        if source.type == 'name' then
            if text ~= source[1] and matchKey(text, source[1]) then
                callback(source[1], CompletionItemKind.Text)
            end
        end
    end
end

local function searchSpecial(vm, pos, callback)
    -- 尝试 #
    local result, source = findResult(vm, pos, 2)
    if source and source.indexSource and result.source.op == '#'
    then
        local label = source.indexSource.indexName .. '+1'
        callback(label, CompletionItemKind.Snippet, {
            textEdit = {
                start = source.start + 1,
                finish = source.indexSource.finish,
                newText = ('%s] = '):format(label),
            }
        })
    end
end

local function clearList(list, source)
    local key = source[1]
    -- 如果只有一个结果且是自己，则不显示
    if #list == 1 then
        if list[1].label == key then
            list[1] = nil
        end
        return
    end
    -- 如果有多个结果，则将完全符合的放到最前面
    if #list > 1 then
        for i, v in ipairs(list) do
            if v.label == key then
                table.remove(list, i)
                table.insert(list, 1, v)
                return
            end
        end
    end
end

local function isValidResult(result)
    if not result then
        return false
    end
    if result.type == 'local' or result.type == 'field' then
        return true
    end
    return false
end

return function (vm, pos, word)
    local list = {}
    local callback = makeList(list)
    local inCall = findCall(vm, word, pos)
    local inString = findString(vm, word, pos)
    if inCall then
        searchInArg(vm, inCall, inString, callback)
    end
    searchSpecial(vm, pos, callback)
    if not inString then
        local result, source = findResult(vm, pos)
        if not isValidResult(result) then
            result, source = findClosePos(vm, pos)
        end
        if isValidResult(result) then
            callback = makeList(list, source)
            searchInResult(result, word, source, vm, pos, callback)
            searchAllWords(result.key, vm, callback)
            clearList(list, source)
        else
            searchAllWords(word, vm, callback)
        end
    end
    if #list == 0 then
        return nil
    end
    return list
end
