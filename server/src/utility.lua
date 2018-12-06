local fs = require 'bee.filesystem'

local table_sort = table.sort
local string_rep = string.rep
local type = type
local pairs = pairs
local ipairs = ipairs
local math_type = math.type

local TAB = setmetatable({}, { __index = function (self, n)
    self[n] = string_rep('\t', n)
    return self[n]
end})

local KEY = {}

function table.dump(tbl)
    if type(tbl) ~= 'table' then
        error('Must be a table')
    end
    local table_mark = {}
    local lines = {}
    lines[#lines+1] = '{'
    local function unpack(tbl, tab)
        if table_mark[tbl] then
            error('Cyclic references are not allowed.')
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
                error('Key must be `string` or `integer`')
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
                error(('Unsupport value type: [%s]'):format(tp))
            end
        end
    end
    unpack(tbl, 0)
    lines[#lines+1] = '}'
    return table.concat(lines, '\n')
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

function io.scan(path)
    local result = {path}
    local i = 0
    return function ()
        i = i + 1
        local current = result[i]
        if not current then
            return nil
        end
        if fs.is_directory(current) then
            for path in current:list_directory() do
                result[#result+1] = path
            end
        end
        return current
    end
end
