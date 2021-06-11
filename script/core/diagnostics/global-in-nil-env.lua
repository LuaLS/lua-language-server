local files    = require 'files'
local guide    = require 'parser.guide'
local lang     = require 'language'

-- TODO: 检查路径是否可达
local function mayRun(path)
    return true
end

return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end
    local root = guide.getRoot(ast.ast)
    local env  = guide.getENV(root)

    local nilDefs = {}
    if not env.ref then
        return
    end
    for _, ref in ipairs(env.ref) do
        if ref.type == 'setlocal' then
            if ref.value and ref.value.type == 'nil' then
                nilDefs[#nilDefs+1] = ref
            end
        end
    end

    if #nilDefs == 0 then
        return
    end

    local function check(source)
        local node = source.node
        if node.tag == '_ENV' then
            local ok
            for _, nilDef in ipairs(nilDefs) do
                local mode, pathA = guide.getPath(nilDef, source)
                if  mode == 'before'
                and mayRun(pathA) then
                    ok = nilDef
                    break
                end
            end
            if ok then
                callback {
                    start   = source.start,
                    finish  = source.finish,
                    uri     = uri,
                    message = lang.script.DIAG_GLOBAL_IN_NIL_ENV,
                    related = {
                        {
                            start  = ok.start,
                            finish = ok.finish,
                            uri    = uri,
                        }
                    }
                }
            end
        end
    end

    guide.eachSourceType(ast.ast, 'getglobal', check)
    guide.eachSourceType(ast.ast, 'setglobal', check)
end
