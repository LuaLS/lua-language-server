local ast     = require 'parser.ast'
local grammar = require 'parser.grammar'

local function buildState(lua, version, options)
    local errs  = {}
    local diags = {}
    local comms = {}
    local state = {
        version = version,
        lua = lua,
        root = {},
        errs = errs,
        diags = diags,
        comms = comms,
        options = options or {},
        pushError = function (err)
            if err.finish < err.start then
                err.finish = err.start
            end
            local last = errs[#errs]
            if last then
                if last.start <= err.start and last.finish >= err.finish then
                    return
                end
            end
            err.level = err.level or 'error'
            errs[#errs+1] = err
            return err
        end,
        pushDiag = function (code, info)
            if not diags[code] then
                diags[code] = {}
            end
            diags[code][#diags[code]+1] = info
        end,
        pushComment = function (comment)
            comms[#comms+1] = comment
        end
    }
    if version == 'Lua 5.1' or version == 'LuaJIT' then
        state.ENVMode = '@fenv'
    else
        state.ENVMode = '_ENV'
    end
    return state
end

return function (lua, mode, version, options)
    local state = buildState(lua, version, options)
    local clock = os.clock()
    ast.init(state)
    local suc, res, err = xpcall(grammar, debug.traceback, lua, mode)
    ast.close()
    if not suc then
        return nil, res
    end
    if not res and err then
        state.pushError(err)
    end
    state.ast = res
    state.parseClock = os.clock() - clock
    return state
end
