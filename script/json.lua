local pairs = pairs
local type = type
local next = next
local error = error
local tonumber = tonumber
local tostring = tostring
local utf8_char = utf8.char
local table_concat = table.concat
local table_sort = table.sort
local string_char = string.char
local string_byte = string.byte
local string_find = string.find
local string_match = string.match
local string_gsub = string.gsub
local string_sub = string.sub
local string_format = string.format
local math_type = math.type
local setmetatable = setmetatable
local Inf = math.huge

local json = {}
json.null = function() end
json.object = {}

-- json.encode --

local encode

local encode_escape_map = {
    [ "\"" ] = "\\\"",
    [ "\\" ] = "\\\\",
    [ "/" ]  = "\\/",
    [ "\b" ] = "\\b",
    [ "\f" ] = "\\f",
    [ "\n" ] = "\\n",
    [ "\r" ] = "\\r",
    [ "\t" ] = "\\t",
}

local decode_escape_set = {}
local decode_escape_map = {}
for k, v in pairs(encode_escape_map) do
    decode_escape_map[v] = k
    decode_escape_set[string_byte(v, 2)] = true
end

for i = 0, 31 do
    local c = string_char(i)
    if not decode_escape_map[c] then
        encode_escape_map[c] = string_format("\\u%04x", i)
    end
end

local function encode_nil()
    return "null"
end

local function encode_null(val)
    if val == json.null then
        return "null"
    end
    error "cannot serialise function: type not supported"
end

local function encode_string(val)
    return '"' .. string_gsub(val, '[\0-\31\\"/]', encode_escape_map) .. '"'
end

local function convertreal(v)
    local g = string_format('%.16g', v)
    if tonumber(g) == v then
        return g
    end
    return string_format('%.17g', v)
end

local function encode_number(val)
    if val ~= val or val <= -Inf or val >= Inf then
        error("unexpected number value '" .. tostring(val) .. "'")
    end
    return string_gsub(convertreal(val), ',', '.')
end

local function encode_table(val, mark)
    local first_val = next(val)
    if first_val == nil then
        if getmetatable(val) == json.object then
            return "{}"
        else
            return "[]"
        end
    end
    mark = mark or {}
    if mark[val] then
        error("circular reference")
    end
    mark[val] = true
    local res = {}
    if type(first_val) == 'string' then
        local key = {}
        for k in pairs(val) do
            if type(k) ~= "string" then
                error("invalid table: mixed or invalid key types")
            end
            key[#key+1] = k
        end
        table_sort(key)
        for i = 1, #key do
            local k = key[i]
            res[i] = encode_string(k) .. ":" .. encode(val[k], mark)
        end
        mark[val] = nil
        return "{" .. table_concat(res, ",") .. "}"
    else
        local max = 0
        for k in pairs(val) do
            if math_type(k) ~= "integer" then
                error("invalid table: mixed or invalid key types")
            end
            max = max > k and max or k
        end
        for i = 1, max do
            res[i] = encode(val[i], mark)
        end
        mark[val] = nil
        return "[" .. table_concat(res, ",") .. "]"
    end
end

local encode_map = {
    [ "nil"      ] = encode_nil,
    [ "table"    ] = encode_table,
    [ "string"   ] = encode_string,
    [ "number"   ] = encode_number,
    [ "boolean"  ] = tostring,
    [ "function" ] = encode_null,
    [ "userdata" ] = function () error("unexpected type 'userdata'") end,
    [ "thread"   ] = function () error("unexpected type 'thread'") end,
}

encode = function(val, mark)
    return encode_map[type(val)](val, mark)
end

json.encode = encode

-- json.decode --

local statusBuf
local statusPos
local statusTop
local statusAry = {}
local statusRef = {}

local function find_line()
    local line = 1
    local pos = 1
    while true do
        local f, _, nl1, nl2 = string_find(statusBuf, '([\n\r])([\n\r]?)', pos)
        if not f then
            return line, statusPos - pos + 1
        end
        local newpos = f + ((nl1 == nl2 or nl2 == '') and 1 or 2)
        if newpos > statusPos then
            return line, statusPos - pos + 1
        end
        pos = newpos
        line = line + 1
    end
end

local function decode_error(msg)
    error(string_format("ERROR: %s at line %d col %d", msg, find_line()))
end

local function get_word()
    return string_match(statusBuf, "^[^ \t\r\n%]},]*", statusPos)
end

local function next_byte()
    statusPos = string_find(statusBuf, "[^ \t\r\n]", statusPos)
    if statusPos then
        return string_byte(statusBuf, statusPos)
    end
    statusPos = #statusBuf + 1
    decode_error("unexpected character '<eol>'")
end

local function decode_unicode_surrogate(s1, s2)
    return utf8_char(0x10000 + (tonumber(s1, 16) - 0xd800) * 0x400 + (tonumber(s2, 16) - 0xdc00))
end

local function decode_unicode_escape(s)
    return utf8_char(tonumber(s, 16))
end

local function decode_string()
    local has_unicode_escape = false
    local has_escape = false
    local i = statusPos + 1
    while true do
        i = string_find(statusBuf, '["\\\0-\31]', i)
        if not i then
            decode_error "expected closing quote for string"
        end
        local x = string_byte(statusBuf, i)
        if x < 32 then
            statusPos = i
            decode_error "control character in string"
        end
        if x == 34 --[[ '"' ]] then
            local s = string_sub(statusBuf, statusPos + 1, i - 1)
            if has_unicode_escape then
                s = string_gsub(string_gsub(s
                    , "\\u([dD][89aAbB]%x%x)\\u([dD][c-fC-F]%x%x)", decode_unicode_surrogate)
                    , "\\u(%x%x%x%x)", decode_unicode_escape)
            end
            if has_escape then
                s = string_gsub(s, "\\.", decode_escape_map)
            end
            statusPos = i + 1
            return s
        end
        --assert(x == 92 --[[ "\\" ]])
        local nx = string_byte(statusBuf, i+1)
        if nx == 117 --[[ "u" ]] then
            if not string_match(statusBuf, "^%x%x%x%x", i+2) then
                statusPos = i
                decode_error "invalid unicode escape in string"
            end
            has_unicode_escape = true
            i = i + 6
        else
            if not decode_escape_set[nx] then
                statusPos = i
                decode_error("invalid escape char '" .. (nx and string_char(nx) or "<eol>") .. "' in string")
            end
            has_escape = true
            i = i + 2
        end
    end
end

local function decode_number()
    local word = get_word()
    if not (
        string_match(word, '^.[0-9]*$')
     or string_match(word, '^.[0-9]*%.[0-9]+$')
     or string_match(word, '^.[0-9]*[Ee][+-]?[0-9]+$')
     or string_match(word, '^.[0-9]*%.[0-9]+[Ee][+-]?[0-9]+$')
    ) then
        decode_error("invalid number '" .. word .. "'")
    end
    statusPos = statusPos + #word
    return tonumber(word)
end

local function decode_number_negative()
    local word = get_word()
    if not (
        string_match(word, '^.[1-9][0-9]*$')
     or string_match(word, '^.[1-9][0-9]*%.[0-9]+$')
     or string_match(word, '^.[1-9][0-9]*[Ee][+-]?[0-9]+$')
     or string_match(word, '^.[1-9][0-9]*%.[0-9]+[Ee][+-]?[0-9]+$')
     or word == "-0"
     or string_match(word, '^.0%.[0-9]+$')
     or string_match(word, '^.0[Ee][+-]?[0-9]+$')
     or string_match(word, '^.0%.[0-9]+[Ee][+-]?[0-9]+$')
    ) then
        decode_error("invalid number '" .. word .. "'")
    end
    statusPos = statusPos + #word
    return tonumber(word)
end

local function decode_number_zero()
    local word = get_word()
    if not (
        #word == 1
     or string_match(word, '^.%.[0-9]+$')
     or string_match(word, '^.[Ee][+-]?[0-9]+$')
     or string_match(word, '^.%.[0-9]+[Ee][+-]?[0-9]+$')
    ) then
        decode_error("invalid number '" .. word .. "'")
    end
    statusPos = statusPos + #word
    return tonumber(word)
end

local function decode_true()
    if string_sub(statusBuf, statusPos, statusPos+3) ~= "true" then
        decode_error("invalid literal '" .. get_word() .. "'")
    end
    statusPos = statusPos + 4
    return true
end

local function decode_false()
    if string_sub(statusBuf, statusPos, statusPos+4) ~= "false" then
        decode_error("invalid literal '" .. get_word() .. "'")
    end
    statusPos = statusPos + 5
    return false
end

local function decode_null()
    if string_sub(statusBuf, statusPos, statusPos+3) ~= "null" then
        decode_error("invalid literal '" .. get_word() .. "'")
    end
    statusPos = statusPos + 4
    return json.null
end

local function decode_array()
    statusPos = statusPos + 1
    local res = {}
    if next_byte() == 93 --[[ "]" ]] then
        statusPos = statusPos + 1
        return res
    end
    statusTop = statusTop + 1
    statusAry[statusTop] = true
    statusRef[statusTop] = res
    return res
end

local function decode_object()
    statusPos = statusPos + 1
    local res = {}
    if next_byte() == 125 --[[ "}" ]] then
        statusPos = statusPos + 1
        return setmetatable(res, json.object)
    end
    statusTop = statusTop + 1
    statusAry[statusTop] = false
    statusRef[statusTop] = res
    return res
end

local decode_uncompleted_map = {
    [ string_byte '"' ] = decode_string,
    [ string_byte "0" ] = decode_number_zero,
    [ string_byte "1" ] = decode_number,
    [ string_byte "2" ] = decode_number,
    [ string_byte "3" ] = decode_number,
    [ string_byte "4" ] = decode_number,
    [ string_byte "5" ] = decode_number,
    [ string_byte "6" ] = decode_number,
    [ string_byte "7" ] = decode_number,
    [ string_byte "8" ] = decode_number,
    [ string_byte "9" ] = decode_number,
    [ string_byte "-" ] = decode_number_negative,
    [ string_byte "t" ] = decode_true,
    [ string_byte "f" ] = decode_false,
    [ string_byte "n" ] = decode_null,
    [ string_byte "[" ] = decode_array,
    [ string_byte "{" ] = decode_object,
}
local function unexpected_character()
    decode_error("unexpected character '" .. string_sub(statusBuf, statusPos, statusPos) .. "'")
end

local decode_map = {}
for i = 0, 255 do
    decode_map[i] = decode_uncompleted_map[i] or unexpected_character
end

local function decode()
    return decode_map[next_byte()]()
end

local function decode_item()
    local top = statusTop
    local ref = statusRef[top]
    if statusAry[top] then
        ref[#ref+1] = decode()
    else
        if next_byte() ~= 34 --[[ '"' ]] then
            decode_error "expected string for key"
        end
        local key = decode_string()
        if next_byte() ~= 58 --[[ ":" ]] then
            decode_error "expected ':' after key"
        end
        statusPos = statusPos + 1
        ref[key] = decode()
    end
    if top == statusTop then
        repeat
            local chr = next_byte(); statusPos = statusPos + 1
            if chr == 44 --[[ "," ]] then
                return
            end
            if statusAry[statusTop] then
                if chr ~= 93 --[[ "]" ]] then decode_error "expected ']' or ','" end
            else
                if chr ~= 125 --[[ "}" ]] then decode_error "expected '}' or ','" end
            end
            statusTop = statusTop - 1
        until statusTop == 0
    end
end

function json.decode(str)
    if type(str) ~= "string" then
        error("expected argument of type string, got " .. type(str))
    end
    statusBuf = str
    statusPos = 1
    statusTop = 0
    local res = decode()
    while statusTop > 0 do
        decode_item()
    end
    if string_find(statusBuf, "[^ \t\r\n]", statusPos) then
        decode_error "trailing garbage"
    end
    return res
end

return json
