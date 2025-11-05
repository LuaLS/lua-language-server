---@class VM.Coder
local M = Class 'VM.Coder'

M.code = '-- Not made yet --'
---@type function?
M.func = nil

---@alias VM.CoderProvider fun(coder: VM.Coder, source: LuaParser.Node.Base)

---@type table<string, VM.CoderProvider?>
M.providers = {}

function M:__init()
    self.env   = _G
    self.indentation = 0

    self.blockStack = {}
end

---@param ast LuaParser.Ast
function M:makeFromAst(ast)
    self.buf = {}
    self.disposers = {}
    self.compiled = {}

    self:addLine('-- Middle Code: ' .. ast.source)
    self:addLine 'local coder, vfile = ...'
    self:addLine 'local rt  = vfile.scope.rt'
    self:addLine 'local uri = vfile.uri'
    self:addLine 'local r   = coder.map'
    self:addLine 'local v   = coder.var'
    self:addLine ''

    self:compile(ast.main)

    self:addLine ''
    self:addLine 'return function ()'
    self:addIndentation(1)
    for i = #self.disposers, 1, -1 do
        self:addLine(self.disposers[i])
    end
    self:addIndentation(-1)
    self:addLine 'end'

    self.code = table.concat(self.buf)
    self.compiled = nil

    self.func = load(self.code, self.code, 't', self.env)
end

---@param code string
function M:addLine(code)
    local buf = self.buf
    if code == '' then
        buf[#buf+1] = '\n'
        return
    end
    if self.indentation > 0 then
        local indentation = string.rep('    ', self.indentation)
        buf[#buf+1] = indentation
        buf[#buf+1] = code:gsub('\n', '\n' .. indentation):gsub('%s+$', '')
    else
        buf[#buf+1] = code
    end
    buf[#buf+1] = '\n'
end

---@param code string
function M:addCode(code)
    local buf = self.buf
    buf[#buf+1] = code
end

---@param source LuaParser.Node.Base
function M:addUnknown(source)
    self:addLine('{key} = rt.UNKNOWN' % {
        key = self:getKey(source),
    })
end

---@param code string
function M:addDisposer(code)
    local disposers = self.disposers
    disposers[#disposers+1] = code
end

---@private
---@type function?
M.disposer = nil

---@param vfile VM.Vfile
function M:dispose(vfile)
    if self.disposer then
        vfile.scope.rt:lockCache()
        xpcall(function ()
            self.disposer()
        end, log.error)
        vfile.scope.rt:unlockCache()
        self.disposer = nil
    end
end

local function makeRegistry(t)
    return setmetatable({}, {
        __index = function (_, k)
            local v = t[k]
            if v == nil then
                error('No such key: ' .. tostring(k))
            end
            return v
        end,
        __newindex = function (_, k, v)
            local ov = t[k]
            if ov ~= nil then
                error('Key already exists: ' .. tostring(k))
            end
            t[k] = v
        end,
    })
end

---@param vfile VM.Vfile
function M:run(vfile)
    self:dispose(vfile)
    local map = {}
    local var = {}
    self.map = makeRegistry(map)
    self.var = makeRegistry(var)
    vfile.scope.rt:lockCache()
    local suc = xpcall(function (...)
        self.disposer = self.func(self, vfile)
    end, log.error)
    vfile.scope.rt:unlockCache()
    self.map = map
    self.var = var
    if not suc then
        log.debug(self.code)
    end

    LAST_CODE = self.code
end

---@param delta integer
function M:addIndentation(delta)
    self.indentation = self.indentation + delta
end

---@param source? LuaParser.Node.Base
---@param canBeNil? boolean
---@return boolean
function M:compile(source, canBeNil)
    if not source then
        assert(canBeNil, 'Source is nil')
        return false
    end
    if self.compiled[source] then
        error('Source already compiled: ' .. source.kind)
    end
    self.compiled[source] = true
    local provider = M.providers[source.kind]
    if not provider then
        self:addLine('--[[!!! ' .. source.kind .. ' !!!]]')
        return false
    end
    provider(self, source)
    return true
end

function M:pushBlock()
    self.blockStack[#self.blockStack+1] = {}
end

function M:popBlock()
    self.blockStack[#self.blockStack] = nil
end

function M:currentBlock()
    return self.blockStack[#self.blockStack]
end

---@param callback function
---@param comment? string
function M:withIndentation(callback, comment)
    if comment then
        self:addLine('do -- ' .. comment:match('[^\r\n]*'))
    else
        self:addLine 'do'
    end
    self:addIndentation(1)
    callback()
    self:addIndentation(-1)
    self:addLine 'end'
end

function M:setBlockKV(k, v)
    local block = self:currentBlock()
    if block then
        block[k] = v
    end
end

function M:getBlockKV(k)
    local block = self:currentBlock()
    if block then
        return block[k]
    end
end

function M:clearCatGroup()
    self:setBlockKV('catGroup', nil)
end

---@param group LuaParser.Node.Cat[]
---@param cat LuaParser.Node.Cat
---@return boolean
local function isNearby(group, cat)
    local last = group[#group]
    if not last then
        return true
    end
    return (last.finishRow + 1) == cat.startRow
end

---@param cat LuaParser.Node.Cat
---@param nearby? boolean
function M:addToCatGroup(cat, nearby)
    local group = self:getBlockKV('catGroup')

    if not group
    or (nearby and not isNearby(group, cat)) then
        group = {}
        self:setBlockKV('catGroup', group)
    end
    group[#group+1] = cat

    local map = self:getBlockKV('catGroupMap')
    if not map then
        map = {}
        self:setBlockKV('catGroupMap', map)
    end
    map[cat] = group
end

---@param nearbySource? LuaParser.Node.Base
---@return LuaParser.Node.Cat[]?
function M:getCatGroup(nearbySource)
    local group = self:getBlockKV('catGroup')
    if not group then
        return nil
    end
    local first = group[1]
    if not first then
        return nil
    end
    if nearbySource then
        local sourceLine = nearbySource.startRow
        local catLine = group[#group].finishRow
        if (sourceLine - 1) ~= catLine then
            return nil
        end
    end
    return group
end

---@param source { start: integer, finish: integer, key?: { start: integer, finish: integer } }
---@return string
function M:makeLocationCode(source)
    source = source.key or source
    return string.format('{ uri = uri, offset = %d, length = %d }'
        , source.start
        , source.finish - source.start
    )
end

---@param source LuaParser.Node.FieldID | LuaParser.Node.Exp | LuaParser.Node.TableFieldID
---@return string?
function M:makeFieldCode(source)
    if source.kind == 'fieldid' then
        ---@cast source LuaParser.Node.FieldID
        return string.format('rt.value(%q)', source.id)
    end
    if source.kind == 'tablefieldid' then
        ---@cast source LuaParser.Node.TableFieldID
        return string.format('rt.value(%q)', source.id)
    end
    if source.isLiteral then
        ---@cast source LuaParser.Node.Literal
        return string.format('rt.value(%q)', source.value)
    end
    return nil
end

---@param source LuaParser.Node.Base
---@return string
function M:getKey(source)
    return string.format('r[%q]', source.uniqueKey)
end

---@param source LuaParser.Node.Base
---@return string
function M:getVariableKey(source)
    return string.format('v[%q]', source.uniqueKey)
end

---@param key string
---@return string
function M:getCustomKey(key)
    return string.format('r[%q]', key)
end

---@return VM.Coder
function ls.vm.createCoder()
    return New 'VM.Coder' ()
end

---@param kind string
---@param callback VM.CoderProvider
function ls.vm.registerCoderProvider(kind, callback)
    M.providers[kind] = callback
end
