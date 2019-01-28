local args = ...

require 'utility'
local fs = require 'bee.filesystem'
local path_filter = require 'path_filter'

local function scan(root, filter)
    local len = #root
    local result = {fs.path(root)}
    local i = 0
    return function ()
        i = i + 1
        local current = result[i]
        if not current then
            return nil
        end
        if fs.is_directory(current) then
            local name = current:string():sub(len+2):gsub('/', '\\')
            if filter(name) then
                OUT:push('log', '过滤目录：', current:string())
            else
                for path in current:list_directory() do
                    local name = path:string():sub(len+2):gsub('/', '\\')
                    if filter(name) then
                        OUT:push('log', '过滤文件：', path:string())
                    else
                        result[#result+1] = path
                    end
                end
            end
        end
        return current
    end
end

local filter = path_filter(args.ignored)
for path in scan(args.root, filter) do
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
