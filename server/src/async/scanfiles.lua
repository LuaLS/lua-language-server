local root = ...

require 'utility'
local fs = require 'bee.filesystem'
local list = {}
local ignore = {
    ['.git'] = true,
    ['node_modules'] = true,
}

for path in io.scan(fs.path(root), ignore) do
    if path:extension():string() == '.lua' then
        local buf = io.load(path)
        if buf then
            OUT:push {
                path = fs.absolute(path):string(),
                buf = buf,
            }
        end
    end
end

OUT:push 'ok'
