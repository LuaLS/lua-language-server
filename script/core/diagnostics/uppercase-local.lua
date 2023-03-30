local files     = require 'files'
local guide     = require 'parser.guide'
local lang      = require 'language'

local function isDocClass(source)
    if not source.bindDocs then
        return false
    end
    for _, doc in ipairs(source.bindDocs) do
        if doc.type == 'doc.class' then
            return true
        end
    end
    return false
end

-- If local elements must be named lowercase by coding convention, this diagnostic helps with reminding about that
return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    guide.eachSourceType(ast.ast, 'local', function (source)
        local name = guide.getKeyName(source)
        if not name then
            return
        end
        local first = name:match '%w' -- alphanumeric character
        if not first then
            return
        end
        if not first:match '%u' then -- uppercase
            return
        end
        -- If the assignment is marked as doc.class, then it is considered allowed 
        if isDocClass(source) then
            return
        end
        
        callback {
            start   = source.start,
            finish  = source.finish,
            message = lang.script('DIAG_UPPERCASE_LOCAL', name),
        }
    end)
end
