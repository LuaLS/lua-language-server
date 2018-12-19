local findResult = require 'matcher.find_result'

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
        return false
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
    local used = {
        [1] = true,
    }
    local cur = 2
    local lookup
    local researched
    for i = 2, #lMe do
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
            for j = 2, cur - 2 do
                if c == lOther:sub(j, j) then
                    used[j] = true
                    goto NEXT
                end
            end
            return false
        end
        -- 5. 找到下一个可用的字，如果超出长度则失败
        ::NEXT::
        repeat
            cur = cur + 1
        until not used[cur]
        if cur > #lOther then
            return false
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
                callback(loc.key)
            end
        end
        ::CONTINUE::
    end
end

return function (vm, pos)
    local result = findResult(vm, pos)
    if not result then
        return nil
    end
    local list = {}
    local source = result.source
    if source.type == 'name' then
        searchLocals(vm, pos, result.key, function (label)
            list[#list+1] = {
                label = label,
                kind = CompletionItemKind.Variable,
            }
        end)
    end
    return list
end
