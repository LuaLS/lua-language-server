local json = require "json"
local type = type
local next = next
local error = error
local table_concat = table.concat
local table_sort = table.sort
local string_rep = string.rep
local math_type = math.type
local setmetatable = setmetatable
local getmetatable = getmetatable

local statusMark
local statusQue
local statusDep
local statusOpt

local defaultOpt = {
    newline = "\n",
    indent = "  ",
}
defaultOpt.__index = defaultOpt

local function encode_newline()
    statusQue[#statusQue+1] = statusOpt.newline..string_rep(statusOpt.indent, statusDep)
end

local encode_map = {}
local encode_string = json._encode_string
for k ,v in next, json._encode_map do
    encode_map[k] = v
end

local function encode(v)
    local res = encode_map[type(v)](v)
    statusQue[#statusQue+1] = res
end

function encode_map.string(v)
    statusQue[#statusQue+1] = '"'
    statusQue[#statusQue+1] = encode_string(v)
    return '"'
end

function encode_map.table(t)
    local first_val = next(t)
    if first_val == nil then
        if getmetatable(t) == json.object then
            return "{}"
        else
            return "[]"
        end
    end
    if statusMark[t] then
        error("circular reference")
    end
    statusMark[t] = true
    if type(first_val) == 'string' then
        local key = {}
        for k in next, t do
            if type(k) ~= "string" then
                error("invalid table: mixed or invalid key types")
            end
            key[#key+1] = k
        end
        table_sort(key)
        statusQue[#statusQue+1] = "{"
        statusDep = statusDep + 1
        encode_newline()
        local k = key[1]
        statusQue[#statusQue+1] = '"'
        statusQue[#statusQue+1] = encode_string(k)
        statusQue[#statusQue+1] = '": '
        encode(t[k])
        for i = 2, #key do
            local k = key[i]
            statusQue[#statusQue+1] = ","
            encode_newline()
            statusQue[#statusQue+1] = '"'
            statusQue[#statusQue+1] = encode_string(k)
            statusQue[#statusQue+1] = '": '
            encode(t[k])
        end
        statusDep = statusDep - 1
        encode_newline()
        statusMark[t] = nil
        return "}"
    else
        local max = 0
        for k in next, t do
            if math_type(k) ~= "integer" or k <= 0 then
                error("invalid table: mixed or invalid key types")
            end
            if max < k then
                max = k
            end
        end
        statusQue[#statusQue+1] = "["
        statusDep = statusDep + 1
        encode_newline()
        encode(t[1])
        for i = 2, max do
            statusQue[#statusQue+1] = ","
            encode_newline()
            encode(t[i])
        end
        statusDep = statusDep - 1
        encode_newline()
        statusMark[t] = nil
        return "]"
    end
end

local function beautify(v, option)
    if type(v) == "string" then
        v = json.decode(v)
    end
    statusMark = {}
    statusQue = {}
    statusDep = 0
    statusOpt = option and setmetatable(option, defaultOpt) or defaultOpt
    encode(v)
    return table_concat(statusQue)
end

json.beautify = beautify

return json
