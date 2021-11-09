---develop mode, use command line: --develop=true
---@type boolean
DEVELOP = false

---port for `Lua Debug` connecting, use command line: --dbgport=11411
---@type integer
DBGPORT = 0

---need holdon before `Lua Debug` connecting, use command line: --dbgwait=true
---@type boolean
DBGWAIT = false

---displayed language, use command line: --locale="en-us"
---@type '"en-us"'|'"zh-cn"'|'"pt-br"'
LOCALE = 'en-us'

---path of local config file, use command line: --configpath="config.lua"
---@type string
CONFIGPATH = ''

---display the internal data of the hovring token, use command line: --showsource=true
---@type boolean
SHOWSOURCE = false

---trace every searching into log, use command line: --trace=true
---@type boolean
TRACE = false

---trace searching with `too deep!` into log, use command line: --footprint=true
---@type boolean
FOOTPRINT = false

---trace rpc, use command line: --rpclog=true
---@type boolean
RPCLOG = false
