local files = require("files")
local guide = require("parser.guide")
local converter = require("proto.converter")

return function(uri, position)
    local state = files.getState(uri)
    if not state then
        return
    end

    local pos = converter.unpackPosition(state, position)
    return { data = guide.positionToOffset(state, pos) }
end
