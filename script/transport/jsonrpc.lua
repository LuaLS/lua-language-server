---@class JSONRPC
local M = {}

---@param luaTable table
---@return string
function M.encode(luaTable)
    luaTable['jsonrpc'] = '2.0'
    local json = ls.json.encode(luaTable)
    local buf = {}
    buf[#buf+1] = "Content-Length: "
    buf[#buf+1] = #json
    buf[#buf+1] = "\r\n\r\n"
    buf[#buf+1] = json
    return table.concat(buf)
end

---@alias JSONRPC.Reader fun(len: number): string?

---@param reader JSONRPC.Reader
---@return table<string, string>
local function decodeHead(reader)
    local head = {}
    local buf = ''
    while true do
        local char = reader(1)
        if char == nil then
            error('RPC Disconnected!')
        end
        buf = buf .. char
        if buf == '\r\n' then
            break
        end
        if buf:sub(-2) ~= '\r\n' then
            goto continue
        end
        local k, v = buf:match '^([^:]+)%s*%:%s*(.+)\r\n$'
        if not k then
            error('RPC header error: ' .. buf)
        end
        head[k] = v
        buf = ''
        ::continue::
    end
    return head
end

---@param reader JSONRPC.Reader
---@return table
function M.decode(reader)
    local head = decodeHead(reader)
    local len = tonumber(head['Content-Length'])
    if type(len) ~= 'number' then
        error('RPC `Content-Length` type error: ' .. tostring(head['Content-Length']))
    end
    local content = reader(len)
    if content == nil then
        error('RPC Disconnected!')
    end
    ---@type any
    local null = ls.json.null
    ls.json.null = nil
    local _ <close> = ls.util.defer(function ()
        ls.json.null = null
    end)
    local res = ls.json.decode(content)
    return res --[[@as table]]
end

return M
