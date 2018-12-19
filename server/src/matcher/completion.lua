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
        -- 5. 找到下一个可用的字，如果超出长度就算成功
        ::NEXT::
        repeat
            cur = cur + 1
        until not used[cur]
        if cur > #lOther then
            break
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

local function searchFields(name, parent, callback)
    for key, field in pairs(parent.value.child) do
        if type(key) ~= 'string' then
            goto CONTINUE
        end
        if matchKey(name, key ) then
            callback(field)
        end
        ::CONTINUE::
    end
end

local function getValueKind(value, default)
    if value.type == 'function' then
        return CompletionItemKind.Function
    end
    if default == CompletionItemKind.Field then
        local tp = type(value.value)
        if tp == 'number' or tp == 'integer' or tp == 'string' then
            return CompletionItemKind.Enum
        end
    end
    return default
end

local function getDetail(var)
    local tp = type(var.value.value)
    if tp == 'boolean' or tp == 'number' or tp == 'integer' or tp == 'string' then
        return ('%s = %q'):format(var.key, var.value.value)
    end
    return nil
end

return function (vm, pos)
    local result = findResult(vm, pos)
    if not result then
        return nil
    end
    local list = {}
    if result.type == 'local' then
        searchLocals(vm, pos, result.key, function (loc)
            list[#list+1] = {
                label = loc.key,
                kind = getValueKind(loc.value, CompletionItemKind.Variable),
                detail = getDetail(loc),
            }
        end)
        -- 也尝试搜索全局变量
        searchFields(result.key, vm.results.locals[1], function (field)
            list[#list+1] = {
                label = field.key,
                kind = getValueKind(field.value, CompletionItemKind.Field),
                detail = getDetail(field),
            }
        end)
    elseif result.type == 'field' then
        if result.parent.value and result.parent.value.ENV == true then
            -- 全局变量也搜索是不是local
            searchLocals(vm, pos, result.key, function (loc)
                list[#list+1] = {
                    label = loc.key,
                    kind = getValueKind(loc.value, CompletionItemKind.Variable),
                    detail = getDetail(loc),
                }
            end)
        end
        searchFields(result.key, result.parent, function (field)
            list[#list+1] = {
                label = field.key,
                kind = getValueKind(field.value, CompletionItemKind.Field),
                detail = getDetail(field),
            }
        end)
    end
    return list
end
