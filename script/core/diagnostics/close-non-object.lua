local files    = require 'files'
local guide    = require 'parser.guide'
local lang     = require 'language'
local vm       = require 'vm'

return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    guide.eachSourceType(state.ast, 'local', function (source)
        if not source.attrs then
            return
        end
        if source.attrs[1][1] ~= 'close' then
            return
        end
        if not source.value then
            callback {
                start   = source.start,
                finish  = source.finish,
                message = lang.script.DIAG_COSE_NON_OBJECT,
            }
            return
        end
        local infer = vm.getInfer(source.value)
        if  not infer:hasClass(uri)
        and not infer:hasType(uri, 'nil')
        and not infer:hasType(uri, 'table')
        and not infer:hasUnknown(uri)
        and not infer:hasAny(uri) then
            callback {
                start   = source.value.start,
                finish  = source.value.finish,
                message = lang.script.DIAG_COSE_NON_OBJECT,
            }
        end
    end)
end
