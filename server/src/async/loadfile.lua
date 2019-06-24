require 'utility'
local fs = require 'bee.filesystem'

while true do
    local filename, mode = IN:bpop()
    local buf = io.load(fs.path(filename))
    if buf then
        OUT:push(filename, mode, buf)
    end
    GC:push(ID, collectgarbage 'count')
end
