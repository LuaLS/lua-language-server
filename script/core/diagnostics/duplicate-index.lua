local files    = require 'files'
local guide    = require 'parser.guide'
local lang     = require 'language'
local define   = require 'proto.define'
local await    = require 'await'

---@async
return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end
    ---@async
    guide.eachSourceType(ast.ast, 'table', function (source)
        await.delay()
        local mark = {}
        for _, obj in ipairs(source) do
            if obj.type == 'tablefield'
            or obj.type == 'tableindex'
            or obj.type == 'tableexp' then
                local name = guide.getKeyName(obj)
                if name  then
                    if not mark[name] then
                        mark[name] = {}
                    end
                    mark[name][#mark[name]+1] = obj.field or obj.index or obj.value
                end
            end
        end

        for name, defs in pairs(mark) do
            if #defs > 1 and name then
                local related = {}
                for i = 1, #defs do
                    local def = defs[i]
                    related[i] = {
                        start  = def.start,
                        finish = def.finish,
                        uri    = uri,
                    }
                end
                for i = 1, #defs - 1 do
                    local def = defs[i]
                    callback {
                        start   = def.start,
                        finish  = def.finish,
                        related = related,
                        message = lang.script('DIAG_DUPLICATE_INDEX', name),
                        level   = define.DiagnosticSeverity.Hint,
                        tags    = { define.DiagnosticTag.Unnecessary },
                    }
                end
                for i = #defs, #defs do
                    local def = defs[i]
                    callback {
                        start   = def.start,
                        finish  = def.finish,
                        related = related,
                        message = lang.script('DIAG_DUPLICATE_INDEX', name),
                    }
                end
            end
        end
    end)
end
