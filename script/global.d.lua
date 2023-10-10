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

---display the internal semantic of the hovring token, use command line: --shownode=true
---@type boolean
SHOWNODE = false

---trace every searching into log, use command line: --trace=true
---@type boolean
TRACE = false

---trace searching with `too deep!` into log, use command line: --footprint=true
---@type boolean
FOOTPRINT = false

---trace rpc, use command line: --rpclog=true
---@type boolean
RPCLOG = false

--enable preview features.
--
--the current version is `formatting`
---@type boolean
PREVIEW = false

--check path
---@type string
CHECK = ''

--make docs path
---@type string
DOC = ''

---@type string | '"Error"' | '"Warning"' | '"Information"' | '"Hint"'
CHECKLEVEL = 'Warning'

--Where to write the check results (JSON).
--
--If nil, use `LOGPATH/check.json`.
---@type string|nil
CHECK_OUT_PATH = ''

---@type 'trace' | 'debug' | 'info' | 'warn' | 'error'
LOGLEVEL = 'warn'

-- (experiment) Cache data into disk, may reduce memory usage, but increase CPU usage.
---@type boolean
LAZY = false

-- (experiment) Improve performance, but reduce accuracy
---@type boolean
CACHEALIVE = false

-- (experiment) Compile files in multi cpu cores
---@type integer
COMPILECORES = 0

-- TODO: delete this after new config
---@diagnostic disable-next-line: lowercase-global
jit = false

-- connect to client by socket
---@type integer
SOCKET = 0

-- Allowing the use of the root directory or home directory as the workspace
FORCE_ACCEPT_WORKSPACE = false
