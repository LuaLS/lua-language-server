local fs = require 'bee.filesystem'

local table_sort = table.sort
local string_rep = string.rep
local type = type
local pairs = pairs
local ipairs = ipairs
local math_type = math.type
local next = next
local rawset = rawset
local move = table.move
local setmetatable = setmetatable

local TAB = setmetatable({}, { __index = function (self, n)
    self[n] = string_rep('\t', n)
    return self[n]
end})

local KEY = {}

function table.dump(tbl)
    if type(tbl) ~= 'table' then
        return ('%q'):format(tbl)
    end
    local table_mark = {}
    local lines = {}
    lines[#lines+1] = '{'
    local function unpack(tbl, tab)
        if table_mark[tbl] then
            return '<Circle Table>'
        end
        table_mark[tbl] = true
        local keys = {}
        for key in pairs(tbl) do
            if type(key) == 'string' then
                if key:find('[^%w_]') then
                    KEY[key] = ('[%q]'):format(key)
                else
                    KEY[key] = key
                end
            elseif math_type(key) == 'integer' then
                KEY[key] = ('[%d]'):format(key)
            else
                KEY[key] = ('<%s>'):format(key)
            end
            keys[#keys+1] = key
        end
        table_sort(keys, function (a, b)
            return KEY[a] < KEY[b]
        end)
        for _, key in ipairs(keys) do
            local value = tbl[key]
            local tp = type(value)
            if tp == 'table' then
                lines[#lines+1] = ('%s%s = {'):format(TAB[tab+1], KEY[key])
                unpack(value, tab+1)
                lines[#lines+1] = ('%s},'):format(TAB[tab+1])
            elseif tp == 'string' or tp == 'number' or tp == 'boolean' then
                lines[#lines+1] = ('%s%s = %q,'):format(TAB[tab+1], KEY[key], value)
            else
                lines[#lines+1] = ('%s%s = <%s>,'):format(TAB[tab+1], KEY[key], value)
            end
        end
    end
    unpack(tbl, 0)
    lines[#lines+1] = '}'
    return table.concat(lines, '\n')
end

local function sort_table(tbl)
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
    table_sort(keys)
    function mt:__newindex(key, value)
        rawset(self, key, value)
        n=n+1;keys[n] = key
        mark[key] = true
        if type(value) == 'table' then
            sort_table(value)
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
            table_sort(list)
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

function table.container(tbl)
    return sort_table(tbl)
end

function io.load(file_path)
    local f, e = io.open(file_path:string(), 'rb')
    if not f then
        return nil, e
    end
    local buf = f:read 'a'
    f:close()
    return buf
end

function io.save(file_path, content)
    local f, e = io.open(file_path:string(), "wb")

    if f then
        f:write(content)
        f:close()
        return true
    else
        return false, e
    end
end

function io.scan(path, ignore)
    local result = {path}
    local i = 0
    local absolute
    if ignore then
        absolute = {}
        for _, name in ipairs(ignore) do
            local absoluteName = fs.path(name):string():lower()
            absolute[#absolute+1] = absoluteName
        end
    end

    local function isIgnored(path)
        if not absolute then
            return false
        end
        local target = path:string():lower()
        for _, name in ipairs(absolute) do
            if target == name then
                return true
            end
        end
        return false
    end

    return function ()
        i = i + 1
        local current = result[i]
        if not current then
            return nil
        end
        if fs.is_directory(current) then
            if not isIgnored(current) then
                for path in current:list_directory() do
                    result[#result+1] = path
                end
            end
        end
        return current
    end
end
