local sleep = require 'ffi.sleep'
local ext   = require 'process.ext'
local lsp   = require 'lsp'
local Method= require 'method'

local function listen(self, input, output)
    if input then
        log.info('指定输入文件，路径为：', input)
        fs.create_directories(input:parent_path())
        io.input(io.open(input:string(), 'rb'))
    else
        ext.set_filemode(io.stdin, 'b')
    end
    if output then
        log.info('指定输出文件，路径为：', output)
        fs.create_directories(output:parent_path())
        io.output(io.open(output:string(), 'wb'))
    else
        ext.set_filemode(io.stdout, 'b')
    end
    io.output():setvbuf 'no'

    local session = lsp()
    session:setInput(function (mode)
        return io.read(mode)
    end)
    session:setOutput(function (buf)
        io.write(buf)
        log.debug(buf)
    end)
    session:start(function (method, params)
        local f = Method[method]
        if f then
            local suc, res = pcall(f, session, params)
            if suc then
                return res
            else
                return nil, '发生运行时错误：' .. res
            end
        end
        return nil, '没有注册方法：' .. method
    end)
end

local mt = {
    definition = require 'service.definition',
    listen     = listen,
}
mt.__index = mt

return function ()
    local session = setmetatable({}, mt)
    return session
end
