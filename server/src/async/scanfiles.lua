local args = ...

require 'utility'
local fs = require 'bee.filesystem'
local path_filter = require 'path_filter'

local function scan(root, filter)
    local result = {}
    local len = #root:string()
    local name = root:string():sub(len+2):gsub('/', '\\')
    if filter(name) then
        OUT:push('log', '过滤文件：', root:string())
    else
        result[#result+1] = root
    end
    local i = 0
    return function ()
        i = i + 1
        local current = result[i]
        if not current then
            return nil
        end
        if fs.is_directory(current) then
            for path in current:list_directory() do
                local name = path:string():sub(len+2):gsub('/', '\\')
                if filter(name) then
                    OUT:push('log', '过滤文件：', path:string())
                else
                    result[#result+1] = path
                end
            end
        end
        return current
    end
end

local ignore = {}
for _, name in ipairs(args.ignored) do
    if name:sub(1, 1) ~= '!' then
        ignore[#ignore+1] = name
    end
end
local filter = path_filter(ignore)
for path in scan(fs.path(args.root), filter) do
    local ok, msg = IN:pop()
    if ok and msg == 'stop' then
        OUT:push 'stop'
        return
    end
    if path:extension():string() == '.lua' then
        local buf = io.load(path)
        if buf then
            OUT:push('file', {
                path = fs.absolute(path):string(),
                buf = buf,
            })
        end
    end
end

OUT:push 'ok'
