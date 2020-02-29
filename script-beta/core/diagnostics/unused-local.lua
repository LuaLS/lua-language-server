local files  = require 'files'
local guide  = require 'parser.guide'
local define = require 'proto.define'
local lang   = require 'language'

local function hasGet(loc)
    if not loc.ref then
        return false
    end
    local weak
    for _, ref in ipairs(loc.ref) do
        if ref.type == 'getlocal' then
            if not ref.next then
                return 'strong'
            end
            local nextType = ref.next.type
            if  nextType ~= 'setmethod'
            and nextType ~= 'setfield'
            and nextType ~= 'setindex' then
                return 'strong'
            else
                weak = true
            end
        end
    end
    if weak then
        return 'weak'
    else
        return nil
    end
end

local function isMyTable(loc)
    local value = loc.value
    if value and value.type == 'table' then
        return true
    end
    return false
end

local function isClose(source)
    if not source.attrs then
        return false
    end
    for _, attr in ipairs(source.attrs) do
        if attr[1] == 'close' then
            return true
        end
    end
    return false
end

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end
    guide.eachSourceType(ast.ast, 'local', function (source)
        local name = source[1]
        if name == '_'
        or name == '_ENV' then
            return
        end
        if isClose(source) then
            return
        end
        local data = hasGet(source)
        if data == 'strong' then
            return
        end
        if data == 'weak' then
            if not isMyTable(source) then
                return
            end
        end
        callback {
            start   = source.start,
            finish  = source.finish,
            tags    = { define.DiagnosticTag.Unnecessary },
            message = lang.script('DIAG_UNUSED_LOCAL', name),
        }
        if source.ref then
            for _, ref in ipairs(source.ref) do
                callback {
                    start   = ref.start,
                    finish  = ref.finish,
                    tags    = { define.DiagnosticTag.Unnecessary },
                    message = lang.script('DIAG_UNUSED_LOCAL', name),
                }
            end
        end
    end)
end
