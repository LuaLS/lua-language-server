local M = { _NAME = "uri._util" }

-- Build a char->hex map
local escapes = {}
for i = 0, 255 do
    escapes[string.char(i)] = string.format("%%%02X", i)
end

function M.uri_encode (text, patn)
    if not text then return end
    if not patn then
        -- Default unsafe characters.  RFC 2732 ^(uric - reserved)
        -- TODO - this should be updated to the latest RFC.
        patn = "^A-Za-z0-9%-_.!~*'()"
    end
    return (text:gsub("([" .. patn .. "])",
                      function (chr) return escapes[chr] end))
end

function M.uri_decode (str, patn)
    -- Note from RFC1630:  "Sequences which start with a percent sign
    -- but are not followed by two hexadecimal characters are reserved
    -- for future extension"
    if not str then return end
    if patn then patn = "[" .. patn .. "]" end
    return (str:gsub("%%(%x%x)", function (hex)
        local char = string.char(tonumber(hex, 16))
        return (patn and not char:find(patn)) and "%" .. hex or char
    end))
end

-- This is the remove_dot_segments algorithm from RFC 3986 section 5.2.4.
-- The input buffer is 's', the output buffer 'path'.
function M.remove_dot_segments (s)
    local path = ""

    while s ~= "" do
        if s:find("^%.%.?/") then                       -- A
            s = s:gsub("^%.%.?/", "", 1)
        elseif s:find("^/%./") or s == "/." then        -- B
            s = s:gsub("^/%./?", "/", 1)
        elseif s:find("^/%.%./") or s == "/.." then     -- C
            s = s:gsub("^/%.%./?", "/", 1)
            if path:find("/") then
                path = path:gsub("/[^/]*$", "", 1)
            else
                path = ""
            end
        elseif s == "." or s == ".." then               -- D
            s = ""
        else                                            -- E
            local _, p, seg = s:find("^(/?[^/]*)")
            s = s:sub(p + 1)
            path = path .. seg
        end
    end

    return path
end

-- TODO - wouldn't this be better as a method on string?  s:split(patn)
function M.split (patn, s, max)
    if s == "" then return {} end

    local i, j = 1, string.find(s, patn)
    if not j then return { s } end

    local list = {}
    while true do
        if #list + 1 == max then list[max] = s:sub(i); return list end
        list[#list + 1] = s:sub(i, j - 1)
        i = j + 1
        j = string.find(s, patn, i)
        if not j then
            list[#list + 1] = s:sub(i)
            break
        end
    end
    return list
end

function M.attempt_require (modname)
    local ok, result = pcall(require, modname)
    if ok then
        return result
    elseif type(result) == "string" and
           result:find("module '.*' not found") then
        return nil
    else
        error(result)
    end
end

function M.subclass_of (class, baseclass)
    class.__index = class
    class.__tostring = baseclass.__tostring
    class._SUPER = baseclass
    setmetatable(class, baseclass)
end

function M.do_class_changing_change (uri, baseclass, changedesc, newvalue,
                                     changefunc)
    local tmpuri = {}
    setmetatable(tmpuri, baseclass)
    for k, v in pairs(uri) do tmpuri[k] = v end
    changefunc(tmpuri, newvalue)
    tmpuri._uri = nil

    local foo, err = tmpuri:init()
    if not foo then
        error("URI not valid after " .. changedesc .. " changed to '" ..
              newvalue .. "': " .. err)
    end

    setmetatable(uri, getmetatable(tmpuri))
    for k in pairs(uri) do uri[k] = nil end
    for k, v in pairs(tmpuri) do uri[k] = v end
end

function M.uri_part_not_allowed (class, method)
    class[method] = function (self, new)
        if new then error(method .. " not allowed on this kind of URI") end
        return self["_" .. method]
    end
end

return M
-- vi:ts=4 sw=4 expandtab
