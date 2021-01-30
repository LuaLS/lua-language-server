local files  = require 'files'
local guide  = require 'parser.guide'
local vm     = require 'vm'
local config = require 'config'

local function typeHint(uri, start, finish)
    local ast = files.getAst(uri)
    if not ast then
        return nil
    end
    local edits = {}
    guide.eachSourceBetween(ast.ast, start, finish, function (source)
        if  source.type ~= 'local'
        and source.type ~= 'setglobal'
        and source.type ~= 'tablefield'
        and source.type ~= 'tableindex'
        and source.type ~= 'setfield'
        and source.type ~= 'setindex' then
            return
        end
        if source[1] == '_' then
            return
        end
        -- 排除掉 xx = function 与 xx = {}
        if source.value and (source.value.type == 'function' or source.value.type == 'table') then
            return
        end
        if source.parent.type == 'funcargs' then
            if not config.config.hint.paramType then
                return
            end
        else
            if not config.config.hint.setType then
                return
            end
        end
        local infer = vm.getInferType(source, 0)
        local src = source
        if source.type == 'tablefield' then
            src = source.field
        elseif source.type == 'tableindex' then
            src = source.index
        end
        edits[#edits+1] = {
            newText = (':%s'):format(infer),
            start   = src.finish,
            finish  = src.finish,
        }
    end)
    return edits
end

return {
    typeHint = typeHint,
}
