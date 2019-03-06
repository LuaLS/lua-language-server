local findSource = require 'core.find_source'
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
            callback(loc:getName(), src, CompletionItemKind.Variable)
        end
        :: CONTINUE ::
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
            map[#map+1] = k
        end
        :: CONTINUE ::
    end)
    table.sort(map)
    for _, k in ipairs(map) do
        callback(k, nil, CompletionItemKind.Field)
    end
end

local function searchAsGlobal(vm, source, word, callback)
    if word == '' then
        return
    end
    searchLocals(vm, source, word, callback)
    searchFields(vm, source, word, callback)
end

local function searchSource(vm, source, word, callback)
    if source:get 'global' then
        searchAsGlobal(vm, source, word, callback)
        return
    end
    if source:bindLocal() then
        searchAsGlobal(vm, source, word, callback)
        return
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
        data.label = name
        data.kind = kind
        list[#list+1] = data
    end, list
end

return function (vm, pos, word)
    local source = findSource(vm, pos)
    if not source then
        return nil
    end
    local callback, list = makeList(source, word)
    searchSource(vm, source, word, callback)
    searchAllWords(vm, source, word, callback)

    if #list == 0 then
        return nil
    end

    return list
end
