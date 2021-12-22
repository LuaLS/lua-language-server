---@meta

--- OpenResty string functions.
--- https://github.com/openresty/lua-resty-string
local str = {
  _VERSION = "0.14",
}


--- Encode byte string in hexidecimal.
---
--- This is most useful for retrieving a printable string from a checksum
--- result.
---
--- Usage:
---
---```lua
---  local str = require "resty.string"
---  local md5 = require "resty.md5"
---
---  local sum = md5:new()
---  sum:update("hello")
---  sum:update("goodbye")
---  local digest = sum:final()
---  print(str.to_hex(digest)) --> 441add4718519b71e42d329a834d6d5e
---```
---@param s string
---@return string hex
function str.to_hex(s) end

--- Convert an ASCII string to an integer.
---
--- If the string is not numeric, `-1` is returned.
---
--- Usage:
---
---```lua
---  local str = require "resty.string"
---  print(str.atoi("250")) --> 250
---  print(str.atoi("abc")) --> -1
---```
---
---@param s string
---@return number
function str.atoi(s) end


--- A lua-resty-string checksum object.
---@class resty.string.checksum : table
local checksum = {
  _VERSION = str._VERSION,
}

--- Create a new checksum object.
---@return resty.string.checksum?
function checksum:new() end

--- Add a string to the checksum data.
---
--- This can be called multiple times.
---
---@param s string
---@return boolean ok
function checksum:update(s) end

--- Calculate the final checksum.
---@return string? digest
function checksum:final() end

--- Reset the checksum object.
---@return boolean ok
function checksum:reset() end


return str