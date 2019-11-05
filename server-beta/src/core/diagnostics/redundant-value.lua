local files = require 'files'
local guide = require 'parser.guide'

local function check(source)
    
end

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end

end
