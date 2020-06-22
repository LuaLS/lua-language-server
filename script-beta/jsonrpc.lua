local json  = require 'json'
local pcall = pcall
local tonumber = tonumber

_ENV = nil

---@class jsonrpc
local m = {}
m.type = 'jsonrpc'

function m.encode(pack)
    pack.jsonrpc = '2.0'
    local content = json.encode(pack)
    local buf = ('Content-Length: %d\r\n\r\n%s'):format(#content, content)
    return buf
end

local function readProtoHead(reader, errHandle)
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
                errHandle('Proto header error:', head)
                break
            end
        end
    end
    return head
end

function m.decode(reader, errHandle)
    local head = readProtoHead(reader, errHandle)
    local len = head['Content-Length']
    if not len then
        errHandle('Proto header error:', head)
        return nil
    end
    local content = reader(len)
    if not content then
        return nil
    end
    local suc, res = pcall(json.decode, content)
    if not suc then
        errHandle('Proto parse error: ' .. res)
        return nil
    end
    return res
end

return m
