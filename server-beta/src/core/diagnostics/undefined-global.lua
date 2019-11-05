local files    = require 'files'
local searcher = require 'searcher'
local lang     = require 'language'
local library  = require 'library'
local config   = require 'config'
local guide    = require 'parser.guide'

return function (uri, callback)
    local ast = files.getAst(uri)
    if not ast then
        return
    end

    -- 先遍历一次该文件中的全局变量
    -- 如果变量有 set 行为，则做标记
    -- 然后再遍历一次，对所有的行为打上相同标记
    local hasSet = {}
    searcher.eachGlobal(ast.ast, function (info)
        if hasSet[info.source] ~= nil then
            return
        end
        local mark = false
        searcher.eachRef(info.source, function (info)
            if info.mode == 'set' then
                mark = true
            end
        end)
        searcher.eachRef(info.source, function (info)
            hasSet[info.source] = mark
        end)
    end)
    -- 然后再遍历一次，检查所有标记为假的全局变量
    searcher.eachGlobal(ast.ast, function (info)
        local source = info.source
        local key = info.key
        local skey = key:match '^s|(.+)$'
        if not skey then
            return
        end
        if library.global[skey] then
            return
        end
        if config.config.diagnostics.globals[skey] then
            return
        end
        if info.mode == 'get' and not hasSet[source] then
            local message
            local otherVersion  = library.other[key]
            local customVersion = library.custom[key]
            if otherVersion then
                message = ('%s(%s)'):format(message, lang.script('DIAG_DEFINED_VERSION', table.concat(otherVersion, '/'), config.config.runtime.version))
            elseif customVersion then
                message = ('%s(%s)'):format(message, lang.script('DIAG_DEFINED_CUSTOM', table.concat(customVersion, '/')))
            else
                message = lang.script('DIAG_UNDEF_GLOBAL', info.key)
            end
            callback {
                start   = source.start,
                finish  = source.finish,
                message = message,
            }
        end
    end)
    -- 再遍历一次 getglobal ，找出 _ENV 被重载的情况
    guide.eachSourceType(ast.ast, 'getglobal', function (source)
        if hasSet[source] == nil then
            -- 单独验证自己是否在重载过的 _ENV 中有定义
            local setInENV
            searcher.eachRef(source, function (info)
                if info.mode == 'set' then
                    setInENV = true
                end
            end)
            if setInENV then
                return
            end
            local key = source[1]
            callback {
                start   = source.start,
                finish  = source.finish,
                message = lang.script('DIAG_UNDEF_ENV_CHILD', key),
            }
        end
    end)
end
