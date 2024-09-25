local files  = require 'files'
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
return function (uri, callback)
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

    local delayer = await.newThrottledDelayer(1000)
    ---@async
    guide.eachSourceTypes(ast.ast, types, function (source)
        delayer:delay()
        checkSet(source)
    end)
end
