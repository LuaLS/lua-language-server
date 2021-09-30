local json     = require 'json'
local pcall    = pcall
local tonumber = tonumber
local util     = require 'utility'

---@class jsonrpc
local m = {}
m.type = 'jsonrpc'

function m.encode(pack)
    pack.jsonrpc = '2.0'
    local content = json.encode(pack)
    local buf = ('Content-Length: %d\r\n\r\n%s'):format(#content, content)
    return buf
end

local function readProtoHead(reader)
    local head = {}
    while true do
        local line = reader 'L'
        if line == nil then
            -- 说明管道已经关闭了
            return nil, 'Disconnected!'
        end
        if line == '\r\n' then
            break
        end
        local k, v = line:match '^([^:]+)%s*%:%s*(.+)\r\n$'
        if not k then
            return nil, 'Proto header error: ' .. line
        end
        if k == 'Content-Length' then
            v = tonumber(v)
        end
        head[k] = v
    end
    return head
end

function m.decode(reader)
    local head, err = readProtoHead(reader)
    if not head then
        return nil, err
    end
    local len = head['Content-Length']
    if not len then
        return nil, 'Proto header error: ' .. util.dump(head)
    end
    local content = reader(len)
    if not content then
        return nil, 'Proto read error'
    end
    local null = json.null
    json.null = nil
    local suc, res = pcall(json.decode, content)
    json.null = null
    if not suc then
        return nil, 'Proto parse error: ' .. res
    end
    return res
end

return m
