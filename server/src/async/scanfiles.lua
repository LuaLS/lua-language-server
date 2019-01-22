local args = ...

require 'utility'
local fs = require 'bee.filesystem'
local ignore = { '.git', 'node_modules' }

local root = fs.absolute(fs.path(args.root))
for name in pairs(args.ignore) do
    ignore[#ignore+1] = name
end
for i, name in ipairs(ignore) do
    ignore[i] = root / name
end

for path in io.scan(root, ignore) do
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
