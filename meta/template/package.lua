---@meta

---#if VERSION >=5.4 then
---#DES 'require>5.4'
---@param modname string
---@return unknown
---@return unknown loaderdata
function require(modname) end
---#else
---#DES 'require<5.3'
---@param modname string
---@return unknown
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
