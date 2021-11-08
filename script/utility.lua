local tableSort    = table.sort
local stringRep    = string.rep
local tableConcat  = table.concat
local tostring     = tostring
local type         = type
local pairs        = pairs
local ipairs       = ipairs
local next         = next
local rawset       = rawset
local move         = table.move
local setmetatable = debug.setmetatable
local mathType     = math.type
local mathCeil     = math.ceil
local getmetatable = getmetatable
local mathAbs      = math.abs
local mathRandom   = math.random
local ioOpen       = io.open
local utf8Len      = utf8.len
local getenv       = os.getenv
local getupvalue   = debug.getupvalue
local mathHuge     = math.huge
local inf          = 1 / 0
local nan          = 0 / 0
local utf8         = utf8
local error        = error

_ENV = nil

local function isInteger(n)
    if mathType then
        return mathType(n) == 'integer'
    else
        return type(n) == 'number' and n % 1 == 0
    end
end

local function formatNumber(n)
    if n == inf
    or n == -inf
    or n == nan
    or n ~= n then -- IEEE 标准中，NAN 不等于自己。但是某些实现中没有遵守这个规则
        return ('%q'):format(n)
    end
    if isInteger(n) then
        return tostring(n)
    end
    local str = ('%.10f'):format(n)
    str = str:gsub('%.?0*$', '')
    return str
end

local TAB = setmetatable({}, { __index = function (self, n)
    self[n] = stringRep('    ', n)
    return self[n]
end})

local RESERVED = {
    ['and']      = true,
    ['break']    = true,
    ['do']       = true,
    ['else']     = true,
    ['elseif']   = true,
    ['end']      = true,
    ['false']    = true,
    ['for']      = true,
    ['function'] = true,
    ['goto']     = true,
    ['if']       = true,
    ['in']       = true,
    ['local']    = true,
    ['nil']      = true,
    ['not']      = true,
    ['or']       = true,
    ['repeat']   = true,
    ['return']   = true,
    ['then']     = true,
    ['true']     = true,
    ['until']    = true,
    ['while']    = true,
}

local m = {}

--- 打印表的结构
---@param tbl table
---@param option table {optional = 'self'}
---@return string
function m.dump(tbl, option)
    if not option then
        option = {}
    end
    if type(tbl) ~= 'table' then
        return ('%s'):format(tbl)
    end
    local lines = {}
    local mark = {}
    lines[#lines+1] = '{'
    local function unpack(tbl, deep)
        mark[tbl] = (mark[tbl] or 0) + 1
        local keys = {}
        local keymap = {}
        local integerFormat = '[%d]'
        local alignment = 0
        if #tbl >= 10 then
            local width = #tostring(#tbl)
            integerFormat = ('[%%0%dd]'):format(mathCeil(width))
        end
        for key in pairs(tbl) do
            if type(key) == 'string' then
                if not key:match('^[%a_][%w_]*$')
                or RESERVED[key]
                or option['longStringKey']
                then
                    keymap[key] = ('[%q]'):format(key)
                else
                    keymap[key] = ('%s'):format(key)
                end
            elseif isInteger(key) then
                keymap[key] = integerFormat:format(key)
            else
                keymap[key] = ('["<%s>"]'):format(tostring(key))
            end
            keys[#keys+1] = key
            if option['alignment'] then
                if #keymap[key] > alignment then
                    alignment = #keymap[key]
                end
            end
        end
        local mt = getmetatable(tbl)
        if not mt or not mt.__pairs then
            if option['sorter'] then
                option['sorter'](keys, keymap)
            else
                tableSort(keys, function (a, b)
                    return keymap[a] < keymap[b]
                end)
            end
        end
        for _, key in ipairs(keys) do
            local keyWord = keymap[key]
            if option['noArrayKey']
                and isInteger(key)
                and key <= #tbl
            then
                keyWord = ''
            else
                if #keyWord < alignment then
                    keyWord = keyWord .. (' '):rep(alignment - #keyWord) .. ' = '
                else
                    keyWord = keyWord .. ' = '
                end
            end
            local value = tbl[key]
            local tp = type(value)
            if option['format'] and option['format'][key] then
                lines[#lines+1] = ('%s%s%s,'):format(TAB[deep+1], keyWord, option['format'][key](value, unpack, deep+1))
            elseif tp == 'table' then
                if mark[value] and mark[value] > 0 then
                    lines[#lines+1] = ('%s%s%s,'):format(TAB[deep+1], keyWord, option['loop'] or '"<Loop>"')
                elseif deep >= (option['deep'] or mathHuge) then
                    lines[#lines+1] = ('%s%s%s,'):format(TAB[deep+1], keyWord, '"<Deep>"')
                else
                    lines[#lines+1] = ('%s%s{'):format(TAB[deep+1], keyWord)
                    unpack(value, deep+1)
                    lines[#lines+1] = ('%s},'):format(TAB[deep+1])
                end
            elseif tp == 'string' then
                lines[#lines+1] = ('%s%s%q,'):format(TAB[deep+1], keyWord, value)
            elseif tp == 'number' then
                lines[#lines+1] = ('%s%s%s,'):format(TAB[deep+1], keyWord, (option['number'] or formatNumber)(value))
            elseif tp == 'nil' then
            else
                lines[#lines+1] = ('%s%s%s,'):format(TAB[deep+1], keyWord, tostring(value))
            end
        end
        mark[tbl] = mark[tbl] - 1
    end
    unpack(tbl, 0)
    lines[#lines+1] = '}'
    return tableConcat(lines, '\r\n')
end

--- 递归判断A与B是否相等
---@param a any
---@param b any
---@return boolean
function m.equal(a, b)
    local tp1 = type(a)
    local tp2 = type(b)
    if tp1 ~= tp2 then
        return false
    end
    if tp1 == 'table' then
        local mark = {}
        for k, v in pairs(a) do
            mark[k] = true
            local res = m.equal(v, b[k])
            if not res then
                return false
            end
        end
        for k in pairs(b) do
            if not mark[k] then
                return false
            end
        end
        return true
    elseif tp1 == 'number' then
        if mathAbs(a - b) <= 1e-10 then
            return true
        end
        return tostring(a) == tostring(b)
    else
        return a == b
    end
end

local function sortTable(tbl)
    if not tbl then
        tbl = {}
    end
    local mt = {}
    local keys = {}
    local mark = {}
    local n = 0
    for key in next, tbl do
        n=n+1;keys[n] = key
        mark[key] = true
    end
    tableSort(keys)
    function mt:__newindex(key, value)
        rawset(self, key, value)
        n=n+1;keys[n] = key
        mark[key] = true
        if type(value) == 'table' then
            sortTable(value)
        end
    end
    function mt:__pairs()
        local list = {}
        local m = 0
        for key in next, self do
            if not mark[key] then
                m=m+1;list[m] = key
            end
        end
        if m > 0 then
            move(keys, 1, n, m+1)
            tableSort(list)
            for i = 1, m do
                local key = list[i]
                keys[i] = key
                mark[key] = true
            end
            n = n + m
        end
        local i = 0
        return function ()
            i = i + 1
            local key = keys[i]
            return key, self[key]
        end
    end

    return setmetatable(tbl, mt)
end

--- 创建一个有序表
---@param tbl table {optional = 'self'}
---@return table
function m.container(tbl)
    return sortTable(tbl)
end

--- 读取文件
---@param path string
function m.loadFile(path, keepBom)
    local f, e = ioOpen(path, 'rb')
    if not f then
        return nil, e
    end
    local text = f:read 'a'
    f:close()
    if not keepBom then
        if text:sub(1, 3) == '\xEF\xBB\xBF' then
            return text:sub(4)
        end
        if text:sub(1, 2) == '\xFF\xFE'
        or text:sub(1, 2) == '\xFE\xFF' then
            return text:sub(3)
        end
    end
    return text
end

--- 写入文件
---@param path string
---@param content string
function m.saveFile(path, content)
    local f, e = ioOpen(path, "wb")

    if f then
        f:write(content)
        f:close()
        return true
    else
        return false, e
    end
end

--- 计数器
---@param init integer {optional = 'after'}
---@param step integer {optional = 'after'}
---@return fun():integer
function m.counter(init, step)
    if not step then
        step = 1
    end
    local current = init and (init - 1) or 0
    return function ()
        current = current + step
        return current
    end
end

--- 排序后遍历
---@param t table
function m.sortPairs(t, sorter)
    local keys = {}
    for k in pairs(t) do
        keys[#keys+1] = k
    end
    tableSort(keys, sorter)
    local i = 0
    return function ()
        i = i + 1
        local k = keys[i]
        return k, t[k]
    end
end

--- 深拷贝（不处理元表）
---@param source table
---@param target table {optional = 'self'}
function m.deepCopy(source, target)
    local mark = {}
    local function copy(a, b)
        if type(a) ~= 'table' then
            return a
        end
        if mark[a] then
            return mark[a]
        end
        if not b then
            b = {}
        end
        mark[a] = b
        for k, v in pairs(a) do
            b[copy(k)] = copy(v)
        end
        return b
    end
    return copy(source, target)
end

--- 序列化
function m.unpack(t)
    local result = {}
    local tid = 0
    local cache = {}
    local function unpack(o)
        local id = cache[o]
        if not id then
            tid = tid + 1
            id = tid
            cache[o] = tid
            if type(o) == 'table' then
                local new = {}
                result[tid] = new
                for k, v in next, o do
                    new[unpack(k)] = unpack(v)
                end
            else
                result[id] = o
            end
        end
        return id
    end
    unpack(t)
    return result
end

--- 反序列化
function m.pack(t)
    local cache = {}
    local function pack(id)
        local o = cache[id]
        if o then
            return o
        end
        o = t[id]
        if type(o) == 'table' then
            local new = {}
            cache[id] = new
            for k, v in next, o do
                new[pack(k)] = pack(v)
            end
            return new
        else
            cache[id] = o
            return o
        end
    end
    return pack(1)
end

--- defer
local deferMT = { __close = function (self) self[1]() end }
function m.defer(callback)
    return setmetatable({ callback }, deferMT)
end

function m.enableCloseFunction()
    setmetatable(function () end, { __close = function (f) f() end })
end

local esc = {
    ["'"]  = [[\']],
    ['"']  = [[\"]],
    ['\r'] = [[\r]],
    ['\n'] = '\\\n',
}

function m.viewString(str, quo)
    if not quo then
        if str:find('[\r\n]') then
            quo = '[['
        elseif not str:find("'", 1, true) and str:find('"', 1, true) then
            quo = "'"
        else
            quo = '"'
        end
    end
    if quo == "'" then
        str = str:gsub('[\000-\008\011-\012\014-\031\127]', function (char)
            return ('\\%03d'):format(char:byte())
        end)
        return quo .. str:gsub([=[['\r\n]]=], esc) .. quo
    elseif quo == '"' then
        str = str:gsub('[\000-\008\011-\012\014-\031\127]', function (char)
            return ('\\%03d'):format(char:byte())
        end)
        return quo .. str:gsub([=[["\r\n]]=], esc) .. quo
    else
        local eqnum = #quo - 2
        local fsymb = ']' .. ('='):rep(eqnum) .. ']'
        if not str:find(fsymb, 1, true) then
            str = str:gsub('[\000-\008\011-\012\014-\031\127]', '')
            return quo .. str .. fsymb
        end
        for i = 0, 10 do
            local fsymb = ']' .. ('='):rep(i) .. ']'
            if not str:find(fsymb, 1, true) then
                local ssymb = '[' .. ('='):rep(i) .. '['
                str = str:gsub('[\000-\008\011-\012\014-\031\127]', '')
                return ssymb .. str .. fsymb
            end
        end
        return m.viewString(str, '"')
    end
end

function m.viewLiteral(v)
    local tp = type(v)
    if tp == 'nil' then
        return 'nil'
    elseif tp == 'string' then
        return m.viewString(v)
    elseif tp == 'boolean' then
        return tostring(v)
    elseif tp == 'number' then
        if isInteger(v) then
            return tostring(v)
        else
            return formatNumber(v)
        end
    end
    return nil
end

function m.utf8Len(str, start, finish)
    local len = 0
    for _ = 1, 10000 do
        local clen, pos = utf8Len(str, start, finish, true)
        if clen then
            len = len + clen
            break
        else
            len = len + 1 + utf8Len(str, start, pos - 1, true)
            start = pos + 1
        end
    end
    return len
end

function m.revertTable(t)
    local len = #t
    if len <= 1 then
        return t
    end
    for x = 1, len // 2 do
        local y = len - x + 1
        t[x], t[y] = t[y], t[x]
    end
    return t
end

function m.randomSortTable(t, max)
    local len = #t
    if len <= 1 then
        return t
    end
    if not max or max > len then
        max = len
    end
    for x = 1, max do
        local y = mathRandom(len)
        t[x], t[y] = t[y], t[x]
    end
    return t
end

function m.tableMultiRemove(t, index)
    local mark = {}
    for i = 1, #index do
        local v = index[i]
        mark[v] = true
    end
    local offset = 0
    local me = 1
    local len = #t
    while true do
        local it = me + offset
        if it > len then
            for i = me, len do
                t[i] = nil
            end
            break
        end
        if mark[it] then
            offset = offset + 1
        else
            if me ~= it then
                t[me] = t[it]
            end
            me = me + 1
        end
    end
end

---遍历文本的每一行
---@param text string
---@param keepNL boolean # 保留换行符
---@return fun(text:string):string
function m.eachLine(text, keepNL)
    local offset = 1
    local lineCount = 0
    local lastLine
    return function ()
        if offset > #text then
            if not lastLine then
                lastLine = ''
                return ''
            end
            return nil
        end
        lineCount = lineCount + 1
        local nl = text:find('[\r\n]', offset)
        if not nl then
            lastLine = text:sub(offset)
            offset = #text + 1
            return lastLine
        end
        local line
        if text:sub(nl, nl + 1) == '\r\n' then
            if keepNL then
                line = text:sub(offset, nl + 1)
            else
                line = text:sub(offset, nl - 1)
            end
            offset = nl + 2
        else
            if keepNL then
                line = text:sub(offset, nl)
            else
                line = text:sub(offset, nl - 1)
            end
            offset = nl + 1
        end
        return line
    end
end

function m.sortByScore(tbl, callbacks)
    if type(callbacks) ~= 'table' then
        callbacks = { callbacks }
    end
    local size = #callbacks
    local scoreCache = {}
    for i = 1, size do
        scoreCache[i] = {}
    end
    tableSort(tbl, function (a, b)
        for i = 1, size do
            local callback = callbacks[i]
            local cache    = scoreCache[i]
            local sa       = cache[a] or callback(a)
            local sb       = cache[b] or callback(b)
            cache[a] = sa
            cache[b] = sb
            if sa > sb then
                return true
            elseif sa < sb then
                return false
            end
        end
        return false
    end)
end

---裁剪字符串
---@param str string
---@param mode? '"left"'|'"right"'
---@return string
function m.trim(str, mode)
    if mode == "left" then
        return str:gsub('^%s+', '')
    end
    if mode == "right" then
        return str:gsub('%s+$', '')
    end
    return str:match '^%s*(%S+)%s*$'
end

function m.expandPath(path)
    if path:sub(1, 1) == '~' then
        local home = getenv('HOME')
        if not home then -- has to be Windows
            home = getenv 'USERPROFILE' or (getenv 'HOMEDRIVE' .. getenv 'HOMEPATH')
        end
        return home .. path:sub(2)
    elseif path:sub(1, 1) == '$' then
        path = path:gsub('%$([%w_]+)', getenv)
        return path
    end
    return path
end

function m.arrayToHash(l)
    local t = {}
    for i = 1, #l do
        t[l[i]] = true
    end
    return t
end

function m.switch()
    local map = {}
    local cachedCases = {}
    local obj = {
        case = function (self, name)
            cachedCases[#cachedCases+1] = name
            return self
        end,
        call = function (self, callback)
            for i = 1, #cachedCases do
                local name = cachedCases[i]
                cachedCases[i] = nil
                if map[name] then
                    error('Repeated fields:' .. tostring(name))
                end
                map[name] = callback
            end
            return self
        end,
        getMap = function (self)
            return map
        end
    }
    return obj
end

---@param f async fun()
function m.getUpvalue(f, name)
    for i = 1, 999 do
        local uname, value = getupvalue(f, i)
        if not uname then
            break
        end
        if name == uname then
            return value, true
        end
    end
    return nil, false
end

return m
