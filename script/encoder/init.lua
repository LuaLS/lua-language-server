local ansi    = require 'encoder.ansi'
local utf16le = require 'encoder.utf16le'
local utf16be = require 'encoder.utf16be'

---@alias encoder.encoding '"utf8"'|'"utf16"'|'"utf16le"'|'"utf16be"'

---@alias encoder.bom '"no"'|'"yes"'|'"auto"'

local m = {}

---@param encoding encoder.encoding
---@param s string
---@param i integer
---@param j integer
function m.len(encoding, s, i, j)
    i = i or 1
    j = j or #s
    if encoding == 'utf16'
    or encoding == 'utf16' then
        local us = utf16le.encode(s:sub(i, j))
        return #us // 2
    end
    if encoding == 'utf16be' then
        local us = utf16be.encode(s:sub(i, j))
        return #us // 2
    end
    if encoding == 'utf8' then
        return utf8.len(s, i, j, true)
    end
    log.error('Unsupport len encoding:', encoding)
    return j - i + 1
end

---@param encoding encoder.encoding
---@param s string
---@param n integer
---@param i integer
function m.offset(encoding, s, n, i)
    i = i or 1
    if encoding == 'utf16'
    or encoding == 'utf16le' then
        local line = s:match('[^\r\n]*', i)
        if not line:find '[\x80-\xff]' then
            return n + i - 1
        end
        local us = utf16le.encode(line)
        local os = utf16le.decode(us:sub(1, n * 2 - 2))
        return #os + i
    end
    if encoding == 'utf16be' then
        local line = s:match('[^\r\n]*', i)
        if not line:find '[\x80-\xff]' then
            return n + i - 1
        end
        local us = utf16be.encode(line)
        local os = utf16be.decode(us:sub(1, n * 2 - 2))
        return #os + i
    end
    if encoding == 'utf8' then
        return utf8.offset(s, n, i)
    end
    log.error('Unsupport offset encoding:', encoding)
    return n + i - 1
end

---@param encoding encoder.encoding
---@param text string
---@param bom encoder.bom
---@return string
function m.encode(encoding, text, bom)
    if encoding == 'utf8' then
        if bom == 'yes' then
            text = '\xEF\xBB\xBF' .. text
        end
        return text
    end
    if encoding == 'ansi' then
        return ansi.encode(text)
    end
    if encoding == 'utf16'
    or encoding == 'utf16le' then
        text = utf16le.encode(text)
        if bom == 'yes'
        or bom == 'auto' then
            text = '\xFF\xFE' .. text
        end
        return text
    end
    if encoding == 'utf16be' then
        text = utf16be.encode(text)
        if bom == 'yes'
        or bom == 'auto' then
            text = '\xFE\xFF' .. text
        end
        return text
    end
    log.error('Unsupport encode encoding:', encoding)
    return text
end

---@param encoding encoder.encoding
---@param text string
---@return string
function m.decode(encoding, text)
    if encoding == 'utf8' then
        return text
    end
    if encoding == 'ansi' then
        return ansi.decode(text)
    end
    if encoding == 'utf16'
    or encoding == 'utf16le' then
        return utf16le.decode(text)
    end
    if encoding == 'utf16be' then
        return utf16be.decode(text)
    end
    log.error('Unsupport encode encoding:', encoding)
    return text
end

return m
