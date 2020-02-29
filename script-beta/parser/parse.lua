local ast = require 'parser.ast'

return function (self, lua, mode, version)
    local errs  = {}
    local diags = {}
    local state = {
        version = version,
        lua = lua,
        emmy = {},
        root = {},
        errs = errs,
        diags = diags,
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
        end
    }
    ast.init(state)
    local suc, res, err = xpcall(self.grammar, debug.traceback, self, lua, mode)
    ast.close()
    if not suc then
        return nil, res
    end
    if not res then
        state.pushError(err)
    end
    state.ast = res
    return state
end
