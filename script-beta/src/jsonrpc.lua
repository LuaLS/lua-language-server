local json  = require 'json'
local pcall = pcall

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

function m.decode(reader, errHandle)
    -- 读取协议头
    local line = reader 'l'
    -- 不支持修改文本编码
    if line:find('Content-Type', 1, true) then
        return nil
    end
    local len = line:match('Content%-Length%: (%d+)')
    if not len then
        errHandle('Error header: ' .. line)
        return nil
    end
    local content = reader(len + 2)
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
