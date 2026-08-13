---@meta package

--[[@@@
-- Module：modname -> 该模块文件根 return 的第一个值
-- （合并 RequireUri 的 modname->uri 解析与 RequireValue 的 uri->main return）
alias 'Module'
    : param('T')
    : onValue(function (c)
        local modname = c.args[1]
        local literal = modname.value.literal
        if type(literal) ~= 'string' then
            return c.type 'never'
        end
        local suri = c.location and c.location.uri
        local uris = c.scope:searchFiles(literal, suri)
        if #uris == 0 then
            return c.type 'never'
        end
        -- 解析结果依赖 Scope 的文件集合：注册 alias 节点，Scope 增删文件时刷新
        c.scope:addRef(c.node)
        -- 只复用已加载的文件；未加载返回 never，避免加载链递归
        local vfile = c.scope.vm:getFile(uris[1])
        if not vfile then
            return c.type 'never'
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
---@return Module<T>
---@return unknown loaderdata
function require(modname) end
---#else
---#DES 'require<5.3'
---@generic T: string
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
