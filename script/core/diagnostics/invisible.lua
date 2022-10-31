local files    = require 'files'
local guide    = require 'parser.guide'
local lang     = require 'language'
local vm       = require 'vm.vm'
local await    = require 'await'

local checkTypes = {'getfield', 'setfield', 'getmethod', 'setmethod', 'getindex', 'setindex'}

---@async
return function (uri, callback)
    local state = files.getState(uri)
    if not state then
        return
    end

    ---@async
    guide.eachSourceTypes(state.ast, checkTypes, function (src)
        local child = src.field or src.method or src.index
        if not child then
            return
        end
        local key = guide.getKeyName(src)
        if not key then
            return
        end
        await.delay()
        local defs = vm.getDefs(src)
        for _, def in ipairs(defs) do
            if not vm.isVisible(src.node, def) then
                if vm.getVisibleType(def) == 'private' then
                    callback {
                        start   = child.start,
                        finish  = child.finish,
                        uri     = uri,
                        message = lang.script('DIAG_INVISIBLE_PRIVATE', {
                            field = key,
                            class = vm.getParentClass(def):getName(),
                        }),
                    }
                elseif vm.getVisibleType(def) == 'protected' then
                    callback {
                        start   = child.start,
                        finish  = child.finish,
                        uri     = uri,
                        message = lang.script('DIAG_INVISIBLE_PROTECTED', {
                            field = key,
                            class = vm.getParentClass(def):getName(),
                        }),
                    }
                elseif vm.getVisibleType(def) == 'package' then
                    callback {
                        start   = child.start,
                        finish  = child.finish,
                        uri     = uri,
                        message = lang.script('DIAG_INVISIBLE_PACKAGE', {
                            field = key,
                            uri   = guide.getUri(def),
                        }),
                    }
                else
                    error('Unknown visible type: ' .. vm.getVisibleType(def))
                end
                break
            end
        end
    end)
end
