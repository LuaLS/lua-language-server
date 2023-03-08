local files    = require 'files'
local guide    = require 'parser.guide'
local lang     = require 'language'

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    local function check(source)
        local node = source.node
        if node.tag == '_ENV' then
            return
        end
        if guide.isParam(node) then
            return
        end

        if not node.value or node.value.type == 'nil' then
            callback {
                start   = source.start,
                finish  = source.finish,
                uri     = uri,
                message = lang.script.DIAG_GLOBAL_IN_NIL_ENV,
                related = {
                    {
                        start  = node.start,
                        finish = node.finish,
                        uri    = uri,
                    }
                }
            }
        end
    end

    guide.eachSourceType(state.ast, 'getglobal', check)
    guide.eachSourceType(state.ast, 'setglobal', check)
end
