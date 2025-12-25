local ansi    = require 'tools.encoder.ansi'
local utf16   = require 'tools.encoder.utf16'
local utf16le = utf16('le', utf8.codepoint '�')
local utf16be = utf16('be', utf8.codepoint '�')

---@alias Encoder.Encoding 'ansi'|'utf-8'|'utf-16'|'utf-16-le'|'utf-16-be'

---@alias Encoder.Bom 'no'|'yes'|'auto'

---@class Encoder
local M = {}

---@param encoding Encoder.Encoding
---@param s        string
---@param i?       integer
---@param j?       integer
---@return integer
function M.len(encoding, s, i, j)
    i = i or 1
    j = j or #s
    if encoding == 'utf-16'
    or encoding == 'utf-16-le' then
        local us = utf16le.fromutf8(s:sub(i, j))
        return #us // 2
    end
    if encoding == 'utf-16-be' then
        local us = utf16be.fromutf8(s:sub(i, j))
        return #us // 2
    end
    if encoding == 'utf-8' then
        return utf8.len(s, i, j, true) or 0
    end
    log.error('Unsupport len encoding:', encoding)
    return j - i + 1
end

---@param encoding Encoder.Encoding
---@param s        string
---@param n        integer
---@param i?       integer
---@return integer
function M.offset(encoding, s, n, i)
    i = i or 1
    if encoding == 'utf-16'
    or encoding == 'utf-16-le' then
        local line = s:match('[^\r\n]*', i)
        if not line:find '[\x80-\xff]' then
            return n + i - 1
        end
        local us = utf16le.fromutf8(line)
        local os = utf16le.toutf8(us:sub(1, n * 2 - 2))
        return #os + i
    end
    if encoding == 'utf-16-be' then
        local line = s:match('[^\r\n]*', i)
        if not line:find '[\x80-\xff]' then
            return n + i - 1
        end
        local us = utf16be.fromutf8(line)
        local os = utf16be.toutf8(us:sub(1, n * 2 - 2))
        return #os + i
    end
    if encoding == 'utf-8' then
        return (utf8.offset(s, n, i))
    end
    log.error('Unsupport offset encoding:', encoding)
    return n + i - 1
end

---@param encoding Encoder.Encoding
---@param text string
---@param bom Encoder.Bom
---@return string
function M.encode(encoding, text, bom)
    if encoding == 'utf-8' then
        if bom == 'yes' then
            text = '\xEF\xBB\xBF' .. text
        end
        return text
    end
    if encoding == 'ansi' then
        return ansi.fromutf8(text)
    end
    if encoding == 'utf-16'
    or encoding == 'utf-16-le' then
        text = utf16le.fromutf8(text)
        if bom == 'yes'
        or bom == 'auto' then
            text = '\xFF\xFE' .. text
        end
        return text
    end
    if encoding == 'utf-16-be' then
        text = utf16be.fromutf8(text)
        if bom == 'yes'
        or bom == 'auto' then
            text = '\xFE\xFF' .. text
        end
        return text
    end
    log.error('Unsupport encode encoding:', encoding)
    return text
end

---@param encoding Encoder.Encoding
---@param text string
---@return string
function M.decode(encoding, text)
    if encoding == 'utf-8' then
        return text
    end
    if encoding == 'ansi' then
        return ansi.toutf8(text)
    end
    if encoding == 'utf-16'
    or encoding == 'utf-16-le' then
        return utf16le.toutf8(text)
    end
    if encoding == 'utf-16-be' then
        return utf16be.toutf8(text)
    end
    log.error('Unsupport encode encoding:', encoding)
    return text
end

return M
