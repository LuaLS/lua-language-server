local sleep      = require 'ffi.sleep'
local subprocess = require 'bee.subprocess'
local lsp        = require 'lsp'
local Method     = require 'method'
local fs         = require 'bee.filesystem'

local function listen(self, input, output)
    if input then
        log.info('指定输入文件，路径为：', input)
        fs.create_directories(input:parent_path())
        io.input(io.open(input:string(), 'rb'))
    else
        subprocess.filemode(io.stdin, 'b')
    end
    if output then
        log.info('指定输出文件，路径为：', output)
        fs.create_directories(output:parent_path())
        io.output(io.open(output:string(), 'wb'))
    else
        subprocess.filemode(io.stdout, 'b')
    end
    io.input():setvbuf 'no'
    io.output():setvbuf 'no'

    local session = lsp()
    local cache = ''
    session:setInput(function (mode)
        local num = subprocess.peek(io.input())
        if num > 0 then
            cache = cache .. io.read(num)
        end
        if type(mode) == 'number' then
            if #cache < mode then
                return nil
            end
            local res = cache:sub(1, mode)
            cache = cache:sub(mode + 1)
            return res
        elseif mode == 'l' then
            local pos = cache:find '[\r\n]'
            if not pos then
                return nil
            end
            local res = cache:sub(1, pos - 1)
            if cache:sub(pos, pos + 1) == '\r\n' then
                cache = cache:sub(pos + 2)
            else
                cache = cache:sub(pos + 1)
            end
            return res
        end
        return nil
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
        session:runStep()
        sleep(1)
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
