local guide = require 'parser.guide'

return function (state)
    return function (pos1, pos2)
        return state.lua:sub(
            guide.positionToOffset(state, pos1),
            guide.positionToOffset(state, pos2)
        )
    end
end
