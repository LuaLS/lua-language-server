local json = require 'json'

local TIMEOUT = 1.0

local ID = 0
local BUF = {}

local function notify(self, data)
    data.jsonrpc = '2.0'
    local content = json.encode(data)
    local buf = ('Content-Length: %d\r\n\r\n%s'):format(#content, content)
    io.write(buf)
end

local function request(self, data, callback)
    ID = ID + 1
    data.jsonrpc = '2.0'
    data.id = ID
    local content = json.encode(data)
    local buf = ('Content-Length: %d\r\n\r\n%s'):format(#content, content)
    BUF[ID] = {
        callback = callback,
        timeout = os.clock() + TIMEOUT,
    }
    io.write(buf)
end

local function response(self, id, data)
    data.jsonrpc = '2.0'
    data.id = id
    local content = json.encode(data)
    local buf = ('Content-Length: %d\r\n\r\n%s'):format(#content, content)
    io.write(buf)
end

local function recieve(self, proto)
    local id = proto.id
    local data = BUF[id]
    log.warn('Recieve id not found: ', table.dump(proto))
    if not data then
        return
    end
    BUF[id] = nil
    if os.clock() > data.timeout then
        log.warn('Recieve timeout: ', table.dump(proto.error))
        return
    end
    if proto.result then
        data.callback(proto.result)
    else
        log.warn('Recieve: ', table.dump(proto.error))
    end
end

return {
    notify   = notify,
    request  = request,
    response = response,
    recieve  = recieve,
}
