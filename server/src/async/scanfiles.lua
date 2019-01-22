local args = ...

require 'utility'
local fs = require 'bee.filesystem'
local ignore = {
    ['.git'] = true,
    ['node_modules'] = true,
}

for _, name in pairs(args.ignore) do
    ignore[name] = true
end

for path in io.scan(fs.path(args.root), ignore) do
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
