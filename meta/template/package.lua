---@meta package

--[[@@@
-- Module：modname -> 该模块文件根 return 的第一个值
-- （合并 RequireUri 的 modname->uri 解析与 RequireValue 的 uri->main return）
alias 'Module'
    : define(function (c)
        c.param('T')
        c.resetCacheOnScopeChanged()
    end)
    : onValue(function (c)
        local modname = c.args[1]
        local literal = modname?.value?.literal
        if type(literal) ~= 'string' then
            return c.type 'any'
        end
        local suri = c.location?.uri
        local uris = c.scope:searchFiles(literal, suri)
        if #uris == 0 then
            return c.type 'any'
        end
        local ret = c.scope:getMainReturn(uris[1])
        if not ret then
            return c.type 'never'
        end
        return ret
    end)

-- ModName：require 模块名（继承 string，hover 显示命中的文件路径）
alias 'ModName'
    : define(function (c)
        c.setValue(c.type 'string')
    end)
    : onHover(function (c)
        local src = c.source
        if not src or src.kind ~= 'string' then
            return
        end
        ---@cast src LuaParser.Node.String
        local uris, searchers = c.scope:searchFiles(src.value, c.location?.uri)
        if #uris == 0 then
            return
        end
        local lines = {}
        for i, uri in ipairs(uris) do
            local path = c.scope:getRelativePath(uri) or uri
            local searcher = (searchers[i] or ''):gsub('^[/\\]+', '')
            lines[#lines+1] = '* [{}]({}) （搜索路径：`{}`）' % { path, uri, searcher }
        end
        return {
            description = table.concat(lines, '\n'),
        }
    end)
    : onDefinition(function (c)
        local src = c.source
        if not src or src.kind ~= 'string' then
            return
        end
        ---@cast src LuaParser.Node.String
        local uris = c.scope:searchFiles(src.value, c.location?.uri)
        if #uris == 0 then
            return
        end
        return {
            uri = uris[1],
            originUri = c.location?.uri,
            range = { 0, 0 },
            originRange = { src.start, src.finish },
        }
    end)
    : onCompletion(function (c)
        local src = c.source
        if not src or src.kind ~= 'string' then
            return
        end
        ---@cast src LuaParser.Node.String
        local items = c.scope:searchFilesByPartial(src.value, c.location?.uri)
        local results = {}
        for _, item in ipairs(items) do
            local path = c.scope:getRelativePath(item.uri) or item.uri
            local searcher = (item.searcher or ''):gsub('^[/\\]+', '')
            results[#results+1] = {
                label       = item.name,
                detail      = path,
                description = '* [{}]({}) （搜索路径：`{}`）' % { path, item.uri, searcher },
                kind        = c.kind.Module,
            }
        end
        return results
    end)
]]

---#if VERSION >=5.4 then
---#DES 'require>5.4'
---@generic T: ModName
---@param modname T
---@return Module<T>
---@return unknown loaderdata
function require(modname) end
---#else
---#DES 'require<5.3'
---@generic T: ModName
---@param modname T
---@return Module<T>
function require(modname) end
---#end

---#DES 'package'
---@class packagelib
---#DES 'package.cpath'
---@field cpath     string
---#DES 'package.loaded'
---@field loaded    table
---#DES 'package.path'
---@field path      string
---#DES 'package.preload'
---@field preload   table
package = {}

---#DES 'package.config'
package.config = [[
/
;
?
!
-]]

---@version <5.1
---#DES 'package.loaders'
package.loaders = {}

---#DES 'package.loadlib'
---@param libname string
---@param funcname string
---@return any
function package.loadlib(libname, funcname) end

---#DES 'package.searchers'
---@version >5.2
package.searchers = {}

---#DES 'package.searchpath'
---@version >5.2,JIT
---@param name string
---@param path string
---@param sep? string
---@param rep? string
---@return string? filename
---@return string? errmsg
---@nodiscard
function package.searchpath(name, path, sep, rep) end

---#DES 'package.seeall'
---@version <5.1
---@param module table
function package.seeall(module) end

return package
