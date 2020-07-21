local json   = require 'json'

local function pushError(...)
    local t = table.pack(...)
    for i = 1, t.n do
        t[i] = tostring(t[i])
    end
    local buf = table.concat(t, '\t')
    ERR:push(buf)
end

local function readProtoHead(reader)
    local head = {}
    while true do
        local line = reader 'L'
        if line == '\r\n' then
            break
        else
            local k, v = line:match '^([^:]+)%s*%:%s*(.+)\r\n$'
            if k then
                if k == 'Content-Length' then
                    v = tonumber(v)
                end
                head[k] = v
            else
                pushError('Proto header error:', head)
                break
            end
        end
    end
    return head
end

local function readProtoContent(head)
    local len = head['Content-Length']
    if not len then
        pushError('Proto header error:', head)
        return nil
    end
    local buf = io.read(len)
    if not buf then
        return nil
    end
    return buf
end

local function readProto()
    local head = readProtoHead(io.read)
    if not head then
        return
    end
    local data = readProtoContent(head)
    if not data then
        return
    end
    OUT:push(data)
end

while true do
    readProto()
    GC:push(ID, collectgarbage 'count')
end
