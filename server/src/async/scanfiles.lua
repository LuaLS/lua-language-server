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
        list[#list+1] = path:string()
    end
end

OUT:push(list)
