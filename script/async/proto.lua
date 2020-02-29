local json   = require 'json'

local function pushError(...)
    local t = table.pack(...)
    for i = 1, t.n do
        t[i] = tostring(t[i])
    end
    local buf = table.concat(t, '\t')
    ERR:push(buf)
end

local function readProtoHeader()
    local header = io.read 'l'
    if header:sub(1, #'Content-Length') == 'Content-Length' then
        return header
    elseif header:sub(1, #'Content-Type') == 'Content-Type' then
        return nil
    else
        pushError('Proto header error:', header)
        return nil
    end
end

local function readProtoContent(header)
    local len = tonumber(header:match('%d+'))
    if not len then
        pushError('Proto header error:', header)
        return nil
    end
    local buf = io.read(len+2)
    if not buf then
        return nil
    end
    local suc, res = pcall(json.decode, buf)
    if not suc then
        pushError('Proto error:', buf)
        return nil
    end
    return res
end

local function readProto()
    local header = readProtoHeader()
    if not header then
        return
    end
    local data = readProtoContent(header)
    if not data then
        return
    end
    OUT:push(data)
end

while true do
    readProto()
    GC:push(ID, collectgarbage 'count')
end
