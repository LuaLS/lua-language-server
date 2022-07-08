local files  = require 'files'
local define = require 'proto.define'
local lang   = require 'language'
local guide  = require 'parser.guide'
local await  = require 'await'

local types = {
    'local',
    'setlocal',
    'setglobal',
    'setfield',
    'setindex' ,
}

---@async
return function (uri, callback, code)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    local last

    local function checkSet(source)
        if source.value then
            last = source
        else
            if not last then
                return
            end
            if  last.start       <= source.start
            and last.value.start >= source.finish then
                callback {
                    start   = source.start,
                    finish  = source.finish,
                    message = lang.script('DIAG_UNBALANCED_ASSIGNMENTS')
                }
            else
                last = nil
            end
        end
    end

    ---@async
    guide.eachSourceTypes(ast.ast, types, function (source)
        await.delay()
        checkSet(source)
    end)
end
