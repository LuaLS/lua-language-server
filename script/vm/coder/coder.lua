---@class Coder: GCHost
local M = Class 'Coder'

Extends(M, 'GCHost')

if ls.threadName == 'master' then
    M.coderMaster = ls.async.create('coder', 8, 'vm.coder.coder-worker', true)
end

M.code = '-- Not made yet --'
---@type function?
M.func = nil

---@alias VM.CoderProvider fun(coder: Coder, source: LuaParser.Node.Base)

---@type table<string, VM.CoderProvider?>
M.providers = {}

function M:__init()
    self.env = _G
    ---@type table<string, { key: string, offset: integer }[]>
    self.variableMap = {}
end

function M:__del()
end

---@param ast LuaParser.Ast
function M:makeFromAst(ast)
    self.buf = {}
    self.indentation = 0
    self.disposers = {}
    self.compiled = {}
    self.blockStack = {}
    self.flow = New 'Coder.Flow' (self)

    self:addLine('-- Middle Code: ' .. ast.source)
    self:addLine 'global <const> *'
    self:addLine 'local coder, vfile = ...'
    self:addLine 'local rt  = vfile.scope.rt'
    self:addLine 'local uri = vfile.uri'
    self:addLine 'local r   = coder.map'
    self:addLine ''

    self:compile(ast.main)

    self:addLine ''
    self:addLine 'coder:bindGC(function ()'
    self:addIndentation(1)
    for i = #self.disposers, 1, -1 do
        self:addLine(self.disposers[i])
    end
    self:addIndentation(-1)
    self:addLine 'end)'

    -- self:simplifyCode()

    self.code = table.concat(self.buf):gsub('[ ]+([\r\n])', '%1')
    self.compiled = nil
    self.blockStack = nil
    self.flow = nil

    self.func = assert(load(self.code, self.code, 't', self.env))
end

---@async
---@param file File
function M:makeFromFile(file)
    local code = self.coderMaster:awaitRequest('makeCode', {
        text = file:getText(),
        source = file.uri,
    })
    if not code then
        log.error('Failed to make coder from file: ' .. file.uri)

        return
    end
    local func = load(code, code, 't', self.env)
    if not func then
        log.error('Failed to load coder function from file: ' .. file.uri)
        return
    end
    self.code = code
    self.func = func
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
        buf[#buf+1] = code:gsub('\n', '\n' .. indentation)
    else
        buf[#buf+1] = code
    end
    buf[#buf+1] = '\n'
end

function M:simplifyCode()
    local main = {}
    local refs = {}

    ---@param code string
    local function collectUsedKeys(code)
        local key, value = code:match('^%s*r%[(%b""%)]%s*=%s*(.+)')
        local map = main
        if key then
            if not refs[key] then
                refs[key] = {}
            end
            map = refs[key]
        else
            value = code
        end

        for k in value:gmatch('r%[(%b"")%]') do
            map[k] = true
        end
    end

    for _, line in ipairs(self.buf) do
        collectUsedKeys(line)
    end

    local usedKeys = {}
    local function markUsed(key)
        if usedKeys[key] then
            return
        end
        usedKeys[key] = true
        local map = refs[key]
        if map then
            for k in pairs(map) do
                markUsed(k)
            end
        end
    end

    for k in pairs(main) do
        markUsed(k)
    end

    ---@param code string
    ---@return boolean
    local function isNoUsed(code)
        local key = code:match('^%s*r%[(%b"")%]%s*=')
        if not key then
            return false
        end
        return not usedKeys[key]
    end

    for i, line in ipairs(self.buf) do
        if isNoUsed(line) then
            self.buf[i] = '-- No used key: ' .. self.buf[i]
        end
    end
end

function M:simplifyMap()
    local map = self.map
    for k in pairs(map) do
        local dummyType = k:match('(.-)|')
        if dummyType and dummyType ~= 'field' then
            map[k] = nil
        end
    end
end

---@param source LuaParser.Node.Base
function M:addUnknown(source)
    self:addLine('{key} = rt.UNKNOWN' % {
        key = self:getKey(source),
    })
end

---@param source LuaParser.Node.Base
function M:addUnneeded(source)
    self:addLine('-- Unneeded: {}' % {
        source.code,
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

function M:dispose()
    Delete(self)
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

function M:saveVariable(name, key, offset)
    local infos = self.variableMap[name]
    if not infos then
        infos = {}
        self.variableMap[name] = infos
    end
    infos[#infos+1] = { key = key, offset = offset }
end

---@param vfile VM.Vfile
function M:run(vfile)
    if not self.func then
        return
    end
    self.rt = vfile.scope.rt
    self.vfile = vfile
    local map = {}
    self.map = makeRegistry(map)
    vfile.scope.rt:lockCache()
    local suc = xpcall(function (...)
        self.disposer = self.func(self, vfile)
    end, log.error)
    vfile.scope.rt:unlockCache()
    self.map = map
    -- self:simplifyMap()
    if not suc then
        ls.util.saveFile(ls.env.LOG_PATH / 'last_failed_coder.log', self.code)
    end

    LAST_CODE = self.code
    if ls.args.SAVE_CODER then
        local path = vfile.scope:getRelativePath(vfile.uri)
        if path then
            local uri = ls.uri.encode(ls.env.LOG_PATH / 'coder' / vfile.scope.name / path)
            ---@async
            ls.await.call(function ()
                ls.afs.write(uri, self.code)
            end)
        end
    end
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
        error('No provider for kind: ' .. source.kind)
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
---@param comment? string | LuaParser.Node.Base
function M:withIndentation(callback, comment)
    if type(comment) == 'string' then
        self:addLine('do -- ' .. comment:match('[^\r\n]*'))
    elseif type(comment) == 'table' then
        ---@cast comment LuaParser.Node.Base
        self:addLine('do -- :{}: {}' % {
            comment.startRow + 1,
            comment.code:match('[^\r\n]*'),
        })
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

---@param source? LuaParser.Node.FieldID | LuaParser.Node.Exp | LuaParser.Node.TableFieldID
---@return string?
function M:makeFieldCode(source)
    if not source then
        return nil
    end
    if source.kind == 'fieldid' then
        ---@cast source LuaParser.Node.FieldID
        return string.format('%q', source.id)
    end
    if source.kind == 'tablefieldid' then
        ---@cast source LuaParser.Node.TableFieldID
        return string.format('%q', source.id)
    end
    if source.isLiteral then
        ---@cast source LuaParser.Node.Literal
        if source.value ~= nil then
            return string.format('%q', source.value)
        end
    end
    return nil
end

--- 形如 `r["uniqueKey"]`，表示某个节点的值
---@param source LuaParser.Node.Base
---@return string
function M:getKey(source)
    return string.format('r[%q]', source.uniqueKey)
end

---@param key string
---@return string
function M:getCustomKey(key)
    return string.format('r[%q]', key)
end

---@param source LuaParser.Node.Param
---@return boolean
---@return LuaParser.Node.Term?
function M:looksLikeSelf(source)
    if source.isSelf then
        return true, source.parent.name and source.parent.name.last
    end
    if source.id ~= 'self' or source.index ~= 1 then
        return false, nil
    end
    local cat = self:findMatchedCatParam(source)
    if cat then
        return false, nil
    end
    local func = source.parent
    if not func or func.kind ~= 'function' then
        return false, nil
    end
    local assign = func.parent
    if not assign or assign.kind ~= 'assign' then
        return false, nil
    end
    ---@cast assign LuaParser.Node.Assign
    if assign.values[func.index] ~= func then
        return false, nil
    end
    local exp = assign.exps and assign.exps[func.index]
    if not exp or exp.kind ~= 'field' then
        return false, nil
    end
    return true, exp.last
end

---@param source LuaParser.Node.Base
---@return string
function M:makeVarKey(source)
    if source.kind == 'var' then
        ---@cast source LuaParser.Node.Var
        if source.loc then
            return self:getKey(source.loc) or error('Cannot make var key')
        elseif source.env then
            return '{env}:getChild({field%q})' % {
                env  = self:getKey(source.env),
                field = source.id,
            }
        else
            return 'rt:globalGet({%q})' % { source.id }
        end
    end
    if source.kind == 'field' then
        ---@cast source LuaParser.Node.Field
        local fieldCode =  self:makeFieldCode(source.key)
                        or 'rt.UNKNOWN'
        return '{last}:getChild({field})' % {
            last  = self:getKey(source.last),
            field = fieldCode,
        }
    end
    error('Cannot make var key for kind ' .. tostring(source.kind))
end

---@return Coder
function ls.vm.createCoder()
    return New 'Coder' ()
end

---@param kind string
---@param callback VM.CoderProvider
function ls.vm.registerCoderProvider(kind, callback)
    M.providers[kind] = callback
end
