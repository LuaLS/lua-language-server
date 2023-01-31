local json = require "json"
local type = type
local next = next
local error = error
local table_concat = table.concat
local table_sort = table.sort
local string_rep = string.rep
local setmetatable = setmetatable

local math_type

if _VERSION == "Lua 5.1" or _VERSION == "Lua 5.2" then
    local math_floor = math.floor
    function math_type(v)
        if v >= -2147483648 and v <= 2147483647 and math_floor(v) == v then
            return "integer"
        end
        return "float"
    end
else
    math_type = math.type
end

local statusVisited
local statusBuilder
local statusDep
local statusOpt

local defaultOpt = {
    newline = "\n",
    indent = "    ",
    depth = 0,
}
defaultOpt.__index = defaultOpt

local function encode_newline()
    statusBuilder[#statusBuilder+1] = statusOpt.newline..string_rep(statusOpt.indent, statusDep)
end

local encode_map = {}
local encode_string = json._encode_string
for k ,v in next, json._encode_map do
    encode_map[k] = v
end

local function encode(v)
    local res = encode_map[type(v)](v)
    statusBuilder[#statusBuilder+1] = res
end

function encode_map.string(v)
    statusBuilder[#statusBuilder+1] = '"'
    statusBuilder[#statusBuilder+1] = encode_string(v)
    return '"'
end

function encode_map.table(t)
    local first_val = next(t)
    if first_val == nil then
        if json.isObject(t) then
            return "{}"
        else
            return "[]"
        end
    end
    if statusVisited[t] then
        error("circular reference")
    end
    statusVisited[t] = true
    if type(first_val) == 'string' then
        local key = {}
        for k in next, t do
            if type(k) ~= "string" then
                error("invalid table: mixed or invalid key types: "..k)
            end
            key[#key+1] = k
        end
        table_sort(key)
        statusBuilder[#statusBuilder+1] = "{"
        statusDep = statusDep + 1
        encode_newline()
        do
            local k = key[1]
            statusBuilder[#statusBuilder+1] = '"'
            statusBuilder[#statusBuilder+1] = encode_string(k)
            statusBuilder[#statusBuilder+1] = '": '
            encode(t[k])
        end
        for i = 2, #key do
            local k = key[i]
            statusBuilder[#statusBuilder+1] = ","
            encode_newline()
            statusBuilder[#statusBuilder+1] = '"'
            statusBuilder[#statusBuilder+1] = encode_string(k)
            statusBuilder[#statusBuilder+1] = '": '
            encode(t[k])
        end
        statusDep = statusDep - 1
        encode_newline()
        statusVisited[t] = nil
        return "}"
    elseif json.supportSparseArray then
        local max = 0
        for k in next, t do
            if math_type(k) ~= "integer" or k <= 0 then
                error("invalid table: mixed or invalid key types: "..k)
            end
            if max < k then
                max = k
            end
        end
        statusBuilder[#statusBuilder+1] = "["
        statusDep = statusDep + 1
        encode_newline()
        encode(t[1])
        for i = 2, max do
            statusBuilder[#statusBuilder+1] = ","
            encode_newline()
            encode(t[i])
        end
        statusDep = statusDep - 1
        encode_newline()
        statusVisited[t] = nil
        return "]"
    else
        if t[1] == nil then
            error("invalid table: sparse array is not supported")
        end
        statusBuilder[#statusBuilder+1] = "["
        statusDep = statusDep + 1
        encode_newline()
        encode(t[1])
        local count = 2
        while t[count] ~= nil do
            statusBuilder[#statusBuilder+1] = ","
            encode_newline()
            encode(t[count])
            count = count + 1
        end
        if next(t, count-1) ~= nil then
            local k = next(t, count-1)
            if type(k) == "number" then
                error("invalid table: sparse array is not supported")
            else
                error("invalid table: mixed or invalid key types: "..k)
            end
        end
        statusDep = statusDep - 1
        encode_newline()
        statusVisited[t] = nil
        return "]"
    end
end

local function beautify_option(option)
    return setmetatable(option or {}, defaultOpt)
end

local function beautify_builder(builder, v, option)
    statusVisited = {}
    statusBuilder = builder
    statusOpt = beautify_option(option)
    statusDep = statusOpt.depth
    encode(v)
end

local function beautify(v, option)
    beautify_builder({}, v, option)
    return table_concat(statusBuilder)
end

json.beautify = beautify
json._beautify_builder = beautify_builder
json._beautify_option = beautify_option

return json
