---@meta

---
---`lovr` is the single global table that is exposed to every LÖVR app. It contains a set of **modules** and a set of **callbacks**.
---
---@class lovr.lovr
lovr.lovr = {}

---
---Get the current major, minor, and patch version of LÖVR.
---
---@return number major # The major version.
---@return number minor # The minor version.
---@return number patch # The patch number.
function lovr.lovr.getVersion() end
