local findSource = require 'core.find_source'
local getFunctionHover = require 'core.hover.function'
local getFunctionHoverAsLib = require 'core.hover.lib_function'

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

local function getDucumentation(name, value)
    if value:getType() == 'function' then
        local lib = value:getLib()
        local hover
        if lib then
            hover = getFunctionHoverAsLib(name, lib)
        else
            hover = getFunctionHover(name, value:getFunction())
        end
        if not hover then
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
]]):format(hover.label or '', hover.description or '', hover.enum or '')
        return {
            kind = 'markdown',
            value = text,
        }
    end
    return nil
end

local function getDetail(value)
    local literal = value:getLiteral()
    local tp = type(literal)
    if tp == 'boolean' then
        return ('= %q'):format(literal)
    elseif tp == 'string' then
        return ('= %q'):format(literal)
    elseif tp == 'number' then
        if math.type(literal) == 'integer' then
            return ('= %q'):format(literal)
        else
            local str = ('= %.16f'):format(literal)
            local dot = str:find('.', 1, true)
            local suffix = str:find('[0]+$', dot + 2)
            if suffix then
                return str:sub(1, suffix - 1)
            else
                return str
            end
        end
    end
    return nil
end

local function getKind(cata, value)
    if value:getType() == 'function' then
        local func = value:getFunction()
        if func and func:getObject() then
            return CompletionItemKind.Method
        else
            return CompletionItemKind.Function
        end
    end
    if cata == 'field' then
        local literal = value:getLiteral()
        local tp = type(literal)
        if tp == 'number' or tp == 'integer' or tp == 'string' then
            return CompletionItemKind.Enum
        end
    end
    return nil
end

local function getValueData(cata, name, value)
    return {
        documentation = getDucumentation(name, value),
        detail = getDetail(value),
        kind = getKind(cata, value),
    }
end

local function searchLocals(vm, source, word, callback)
    for _, src in ipairs(vm.sources) do
        local loc = src:bindLocal()
        if not loc then
            goto CONTINUE
        end

        if      src.start <= source.start
            and loc:close() >= source.finish
            and matchKey(word, loc:getName())
        then
            callback(loc:getName(), src, CompletionItemKind.Variable, getValueData('local', loc:getName(), loc:getValue()))
        end
        :: CONTINUE ::
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

local function searchFields(vm, source, word, callback)
    local parent = source:get 'parent'
    if not parent then
        return
    end
    local map = {}
    parent:eachChild(function (k, v)
        if type(k) ~= 'string' then
            goto CONTINUE
        end
        if source:get 'object' and v:getType() ~= 'function' then
            goto CONTINUE
        end
        if matchKey(word, k) then
            map[k] = v
        end
        :: CONTINUE ::
    end)
    for k, v in sortPairs(map) do
        callback(k, nil, CompletionItemKind.Field, getValueData('field', k, v))
    end
end

local function searchIndex(vm, source, word, callback)
    for _, src in ipairs(vm.sources) do
        if src:get 'table index' then
            if matchKey(word, src[1]) then
                callback(src[1], src, CompletionItemKind.Property)
            end
        end
    end
end

local function searchCloseGlobal(vm, source, word, callback)
    local loc = source:bindLocal()
    local close = loc:close()
    -- 因为闭包的关系落在局部变量finish到close范围内的全局变量一定能访问到该局部变量
    for _, src in ipairs(vm.sources) do
        if      src:get 'global'
            and src.start >= source.finish
            and src.finish <= close
        then
            if matchKey(word, src[1]) then
                callback(src[1], src, CompletionItemKind.Variable)
            end
        end
    end
end

local KEYS = {'and', 'break', 'do', 'else', 'elseif', 'end', 'false', 'for', 'function', 'goto', 'if', 'in', 'local', 'nil', 'not', 'or', 'repeat', 'return', 'then', 'true', 'until', 'while', 'toclose'}
local function searchKeyWords(vm, source, word, callback)
    for _, key in ipairs(KEYS) do
        if matchKey(word, key) then
            callback(key, nil, CompletionItemKind.Keyword)
        end
    end
end

local function searchAsGlobal(vm, source, word, callback)
    if word == '' then
        return
    end
    searchLocals(vm, source, word, callback)
    searchFields(vm, source, word, callback)
    searchKeyWords(vm, source, word, callback)
end

local function searchAsSuffix(vm, source, word, callback)
    searchFields(vm, source, word, callback)
end

local function searchAsIndex(vm, source, word, callback)
    searchLocals(vm, source, word, callback)
    searchIndex(vm, source, word, callback)
    searchFields(vm, source, word, callback)
end

local function searchAsLocal(vm, source, word, callback)
    searchCloseGlobal(vm, source, word, callback)

    -- 特殊支持 local function
    if matchKey(word, 'function') then
        callback('function', nil, CompletionItemKind.Keyword)
    end
end

local function searchAsArg(vm, source, word, callback)
    searchCloseGlobal(vm, source, word, callback)
end

local function searchSource(vm, source, word, callback)
    if source:get 'table index' then
        searchAsIndex(vm, source, word, callback)
        return
    end
    if source:get 'arg' then
        searchAsArg(vm, source, word, callback)
        return
    end
    if source:get 'global' then
        searchAsGlobal(vm, source, word, callback)
        return
    end
    if source:action() == 'local' then
        searchAsLocal(vm, source, word, callback)
        return
    end
    if source:bindLocal() then
        searchAsGlobal(vm, source, word, callback)
        return
    end
    if source:get 'simple' then
        searchAsSuffix(vm, source, word, callback)
        return
    end
end

local function searchCallArg(vm, source, word, callback, pos)
    local results = {}
    for _, src in ipairs(vm.sources) do
        if      src.type == 'call' 
            and src.start <= pos
            and src.finish >= pos
        then
            results[#results+1] = src
        end
    end
    if #results == 0 then
        return nil
    end
    -- 可能处于 'func1(func2(' 的嵌套中，将最近的call放到最前面
    table.sort(results, function (a, b)
        return a.start > b.start
    end)
    local call = results[1]
    local func, args = call:bindCall()

    local lib = func:getLib()
    if not lib then
        return
    end

    local select = 1
    for i, arg in ipairs(args) do
        if arg.start <= pos and arg.finish >= pos then
            select = i
            break
        end
    end

    -- 根据参数位置找枚举值
    if lib.args and lib.enums then
        local arg = lib.args[select]
        local name = arg and arg.name
        for _, enum in ipairs(lib.enums) do
            if enum.name == name and enum.enum then
                if matchKey(word, enum.enum) then
                    local label, textEdit
                    if source.type ~= arg.type then
                        label = ('%q'):format(enum.enum)
                    end
                    if source.type ~= 'call' then
                        textEdit = {
                            start = source.start,
                            finish = source.finish,
                            newText = ('%q'):format(enum.enum),
                        }
                    end
                    callback(enum.enum, nil, CompletionItemKind.EnumMember, {
                        label = label,
                        documentation = enum.description,
                        textEdit = textEdit,
                    })
                end
            end
        end
    end
end

local function searchAllWords(vm, source, word, callback)
    if word == '' then
        return
    end
    for _, src in ipairs(vm.sources) do
        if      src.type == 'name'
            and matchKey(word, src[1])
        then
            callback(src[1], src, CompletionItemKind.Text)
        end
    end
end

local function makeList(source, word)
    local list = {}
    local mark = {}
    return function (name, src, kind, data)
        if src == source then
            return
        end
        if word == name then
            return
        end
        if mark[name] then
            return
        end
        mark[name] = true
        if not data then
            data = {}
        end
        if not data.label then
            data.label = name
        end
        if not data.kind then
            data.kind = kind
        end
        list[#list+1] = data
    end, list
end

return function (vm, pos, word)
    local source = findSource(vm, pos)
    if not source then
        return nil
    end
    local callback, list = makeList(source, word)
    searchCallArg(vm, source, word, callback, pos)
    searchSource(vm, source, word, callback)
    searchAllWords(vm, source, word, callback)

    if #list == 0 then
        return nil
    end

    return list
end
