local gc   = require 'gc'
local util = require 'utility'

---@class languageClient
---@field _inFile  file*
---@field _outFile file*
---@field _gc      gc
local mt = {}
mt.__index = mt

function mt:__close()
    self:remove()
end

function mt:_openIO()
    local r = math.random(1, 10000)
    self._inPath  = ('%s/%s.in'):format(LOGPATH, r)
    self._outPath = ('%s/%s.out'):format(LOGPATH, r)
    local stdin   = io.open(self._inPath, 'rb')
    local stdout  = io.open(self._outPath, 'wb')
    self._inFile  = io.open(self._inPath, 'wb')
    self._outFile = io.open(self._outPath, 'rb')
    io.stdin      = stdin
    io.stdout     = stdout
    self:gc(function ()
        stdin:close()
        stdout:close()
        self._inFile:close()
        self._outFile:close()
    end)
end

function mt:_flushServer()
    -- reset scopes
    local ws    = require 'workspace'
    local scope = require 'workspace.scope'
    local files = require 'files'
    ws.reset()
    scope.reset()
    files.reset()
end

function mt:start()
    self:_openIO()
    self:_flushServer()
end

function mt:gc(obj)
    return self._gc:add(obj)
end

function mt:remove()
    self._gc:remove()
end

return function ()
    local self = setmetatable({
        _gc = gc(),
    }, mt)
    return self
end
