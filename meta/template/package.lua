---@meta package

--[[@@@
-- RequireUri：modname -> uri（按 Lua require 规则解析，排除当前文件并按距离排序）
alias 'RequireUri'
    : param('T')
    : onValue(function (c)
        local modname = c.args[1]
        if modname.kind ~= 'value' then
            return c.type 'never'
        end
        local literal = modname.literal
        if type(literal) ~= 'string' then
            return c.type 'never'
        end
        local uris = c.scope:searchFiles(literal)
        if #uris == 0 then
            return c.type 'never'
        end
        return c.value(uris[1])
    end)
]]

--[[@@@
-- RequireValue：uri -> 该文件根 return 的第一个值
alias 'RequireValue'
    : param('T')
    : onValue(function (c)
        local uriNode = c.args[1]
        -- 兼容嵌套 alias：取解析后的值
        if uriNode.kind == 'call' then
            uriNode = uriNode.value
        end
        if uriNode.kind ~= 'value' then
            return c.type 'never'
        end
        local uri = uriNode.literal
        if type(uri) ~= 'string' then
            return c.type 'never'
        end
        -- 只复用已加载的文件；未加载返回 unknown，避免加载链递归
        local vfile = c.scope.vm:getFile(uri)
        if not vfile then
            return c.type 'unknown'
        end
        local ret = vfile:getMainReturn()
        if not ret then
            return c.type 'never'
        end
        return ret
    end)
]]

---#if VERSION >=5.4 then
---#DES 'require>5.4'
---@generic T: string
---@param modname T
---@return RequireValue<RequireUri<T>>
---@return unknown loaderdata
function require(modname) end
---#else
---#DES 'require<5.3'
---@generic T: string
---@param modname T
---@return RequireValue<RequireUri<T>>
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
