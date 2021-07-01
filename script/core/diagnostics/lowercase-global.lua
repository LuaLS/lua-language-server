local files   = require 'files'
local guide   = require 'parser.guide'
local lang    = require 'language'
local config  = require 'config'
local vm      = require 'vm'

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

-- 不允许定义首字母小写的全局变量（很可能是拼错或者漏删）
return function (uri, callback)
    local ast = files.getState(uri)
    if not ast then
        return
    end

    local definedGlobal = {}
    for name in pairs(config.get 'Lua.diagnostics.globals') do
        definedGlobal[name] = true
    end

    guide.eachSourceType(ast.ast, 'setglobal', function (source)
        local name = guide.getKeyName(source)
        if definedGlobal[name] then
            return
        end
        local first = name:match '%w'
        if not first then
            return
        end
        if not first:match '%l' then
            return
        end
        -- 如果赋值被标记为 doc.class ,则认为是允许的
        if isDocClass(source) then
            return
        end
        if vm.isGlobalLibraryName(name) then
            return
        end
        callback {
            start   = source.start,
            finish  = source.finish,
            message = lang.script.DIAG_LOWERCASE_GLOBAL,
        }
    end)
end
