local files    = require 'files'
local searcher = require 'core.searcher'
local lang     = require 'language'
local define   = require 'proto.define'
local guide    = require "parser.guide"

return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    guide.eachSourceType(ast.ast, 'local', function (source)
        if not source.ref then
            return
        end
        local sets = {}
        for _, ref in ipairs(source.ref) do
            if ref.type ~= 'getlocal' then
                goto CONTINUE
            end
            local nxt = ref.next
            if not nxt then
                goto CONTINUE
            end
            if nxt.type == 'setfield'
            or nxt.type == 'setmethod'
            or nxt.type == 'setindex' then
                local name = guide.getKeyName(nxt)
                if not name then
                    goto CONTINUE
                end
                local value = searcher.getObjectValue(nxt)
                if not value or value.type ~= 'function' then
                    goto CONTINUE
                end
                if not sets[name] then
                    sets[name] = {}
                end
                sets[name][#sets[name]+1] = nxt
            end
            ::CONTINUE::
        end
        for name, values in pairs(sets) do
            if #values <= 1 then
                goto CONTINUE_SETS
            end
            local blocks = {}
            for _, value in ipairs(values) do
                local block = guide.getBlock(value)
                if not blocks[block] then
                    blocks[block] = {}
                end
                blocks[block][#blocks[block]+1] = value
            end
            for _, defs in pairs(blocks) do
                if #defs <= 1 then
                    goto CONTINUE_BLOCKS
                end
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
                        message = lang.script('DIAG_DUPLICATE_SET_FIELD', name),
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
                        message = lang.script('DIAG_DUPLICATE_SET_FIELD', name),
                    }
                end
                ::CONTINUE_BLOCKS::
            end
            ::CONTINUE_SETS::
        end
    end)
end
