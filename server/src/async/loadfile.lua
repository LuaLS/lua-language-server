require 'utility'
local fs = require 'bee.filesystem'

while true do
    local filename = IN:bpop()
    local buf = io.load(fs.path(filename))
    if buf then
        OUT:push(filename, buf)
    end
    collectgarbage()
    GC:push(ID, collectgarbage 'count')
end
