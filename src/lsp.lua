local json   = require 'json'
local parser = require 'parser'

local ErrorCodes = {
	-- Defined by JSON RPC
	ParseError           = -32700,
	InvalidRequest       = -32600,
	MethodNotFound       = -32601,
	InvalidParams        = -32602,
	InternalError        = -32603,
	serverErrorStart     = -32099,
	serverErrorEnd       = -32000,
	ServerNotInitialized = -32002,
	UnknownErrorCode     = -32001,

	-- Defined by the protocol.
	RequestCancelled     = -32800,
}

local mt = {}
mt.__index = mt

mt._input = nil
mt._output = nil
mt._method = nil
mt._file = nil

function mt:_callback(method, params)
    local f = self._method
    if f then
        return f(method, params)
    end
    return nil, '没有注册method'
end

function mt:_send(data)
    local f = self._output
    if not f then
        return
    end
    data.jsonrpc = '2.0'
    local content = json.encode(data)
    local buf = ('Content-Length: %d\r\n\r\n%s'):format(#content, content)
    f(buf)
end

function mt:_readAsContent(header)
    local len = tonumber(header:match('%d+'))
    if not len then
        log.error('错误的协议头：', header)
        return
    end
    local buf = self:read(len+2)
    local suc, res = pcall(json.decode, buf)
    if not suc then
        log.error('错误的协议：', buf)
        return
    end
    local id     = res.id
    local method = res.method
    local params = res.params
    local response, err = self:_callback(method, params)
    if response then
        self:_send {
            id = id,
            result = response,
        }
    elseif id then
        self:_send {
            id = id,
            error = {
                code = ErrorCodes.UnknownErrorCode,
                message = err or ('没有回应：' .. method),
            },
        }
    end
end

function mt:setInput(input)
    self._input = input
end

function mt:setOutput(output)
    self._output = output
end

function mt:read(mode)
    if not self._input then
        return nil
    end
    return self._input(mode)
end

function mt:saveText(uri, version, text)
    local obj = self._file[uri]
    if obj then
        if obj.version >= version then
            return
        end
        obj.version = version
        obj.text = text
    else
        self._file[uri] = {
            version = version,
            text = text,
        }
    end
end

function mt:loadText(uri)
    local obj = self._file[uri]
    if not obj then
        return nil
    end
    return obj.text
end

function mt:removeText(uri, version)
    local obj = self._file[uri]
    if not obj then
        return
    end
    if obj.version >= version then
        return
    end
    self._file[uri] = nil
end

function mt:start(method)
    self._method = method
    while true do
        local header = self:read 'l'
        if not header then
            return
        end
        if header:sub(1, #'Content-Length') == 'Content-Length' then
            self:_readAsContent(header)
        elseif header:sub(1, #'Content-Type') == 'Content-Type' then
        else
            log.error('错误的协议头：', header)
        end
    end
    return true
end

function mt:stop()
    self._input = nil
    self._output = nil
end

return function ()
    return setmetatable({
        _file = {},
    }, mt)
end
