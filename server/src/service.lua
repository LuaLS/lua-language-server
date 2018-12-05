local subprocess = require 'bee.subprocess'
local lsp        = require 'lsp'
local Method     = require 'method'
local fs         = require 'bee.filesystem'
local thread     = require 'thread'

local function listen(self)
    subprocess.filemode(io.stdin, 'b')
    subprocess.filemode(io.stdout, 'b')
    io.stdin:setvbuf 'no'
    io.stdout:setvbuf 'no'

    thread.require 'proto'

    local session = lsp()
    session:setInput(function ()
        return thread.proto()
    end)
    session:setOutput(function (buf)
        io.write(buf)
    end)
    session:setMethod(function (method, params)
        local optional
        if method:sub(1, 2) == '$/' then
            method = method:sub(3)
            optional = true
        end
        local f = Method[method]
        if f then
            local suc, res, res2 = pcall(f, session, params)
            if suc then
                return res, res2
            else
                return nil, '发生运行时错误：' .. res
            end
        end
        if optional then
            return false
        else
            return nil, '没有注册方法：' .. method
        end
    end)

    while true do
        thread.on_tick()
        session:runStep()
        thread.sleep(0.001)
    end
end

local mt = {
    listen     = listen,
}
mt.__index = mt

return function ()
    local session = setmetatable({}, mt)
    return session
end
