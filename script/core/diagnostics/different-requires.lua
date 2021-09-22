local files   = require 'files'
local guide   = require 'parser.guide'
local lang    = require 'language'
local config  = require 'config'
local vm      = require 'vm'
local ws      = require 'workspace'

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end
    local cache = vm.getCache 'different-requires'
    guide.eachSpecialOf(state.ast, 'require', function (source)
        local call = source.parent
        if not call or call.type ~= 'call' then
            return
        end
        local arg1 = call.args and call.args[1]
        if not arg1 or arg1.type ~= 'string' then
            return
        end
        local literal = arg1[1]
        local results = ws.findUrisByRequirePath(literal)
        if not results or #results ~= 1 then
            return
        end
        local result = results[1]
        if not files.isLua(result) then
            return
        end
        local other = cache[result]
        if not other then
            cache[result] = {
                source  = arg1,
                require = literal,
            }
            return
        end
        if other.require ~= literal then
            callback {
                start   = arg1.start,
                finish  = arg1.finish,
                related = {
                    {
                        start  = other.source.start,
                        finish = other.source.finish,
                        uri    = guide.getUri(other.source),
                    }
                },
                message = lang.script('DIAG_DIFFERENT_REQUIRES'),
            }
        end
    end)
end
