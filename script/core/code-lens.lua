local files  = require 'files'
local guide  = require 'parser.guide'
local await  = require 'await'
local conv   = require 'proto.converter'
local getRef = require 'core.reference'
local lang   = require 'language'

---@class parser.state
---@field package _codeLens? codeLens

---@class codeLens.resolving
---@field mode    'reference'
---@field source? parser.object

---@class codeLens.result
---@field position integer
---@field id       integer

---@class codeLens
local mt = {}
mt.__index = mt
mt.type = 'codeLens'
mt.id = 0

---@param uri uri
---@return boolean
function mt:init(uri)
    self.state     = files.getState(uri)
    if not self.state then
        return false
    end
    ---@type uri
    self.uri       = uri
    ---@type codeLens.result[]
    self.results   = {}
    ---@type table<integer, codeLens.resolving>
    self.resolving = {}
    return true
end

---@param pos integer
---@param resolving codeLens.resolving
function mt:addResult(pos, resolving)
    self.id = self.id + 1
    self.results[#self.results+1] = {
        position = pos,
        id       = self.id,
    }
    self.resolving[self.id] = resolving
end

---@async
---@param id integer
---@return proto.command?
function mt:resolve(id)
    local resolving = self.resolving[id]
    if not resolving then
        return nil
    end
    if resolving.mode == 'reference' then
        return self:resolveReference(resolving.source)
    end
end

---@async
function mt:collectReferences()
    await.delay()
    ---@async
    guide.eachSourceType(self.state.ast, 'function', function (src)
        local parent = src.parent
        if guide.isAssign(parent) then
            src = parent
        elseif parent.type == 'return' then
        else
            return
        end
        await.delay()
        self:addResult(src.start, {
            mode   = 'reference',
            source = src,
        })
    end)
end

---@async
---@param source parser.object
---@return proto.command?
function mt:resolveReference(source)
    local refs = getRef(self.uri, source.finish, false)
    local count = refs and #refs or 0
    local command = conv.command(
        lang.script('COMMAND_REFERENCE_COUNT', count),
        '',
        {}
    )
    return command
end

---@async
---@param uri uri
---@return codeLens.result[]?
local function getCodeLens(uri)
    local state = files.getState(uri)
    if not state then
        return nil
    end
    local codeLens = setmetatable({}, mt)
    local suc = codeLens:init(uri)
    if not suc then
        return nil
    end
    state._codeLens = codeLens

    codeLens:collectReferences()

    if #codeLens.results == 0 then
        return nil
    end

    return codeLens.results
end

---@async
---@param id integer
---@return proto.command?
local function resolve(uri, id)
    local state = files.getState(uri)
    if not state then
        return nil
    end
    local codeLens = state._codeLens
    if not codeLens then
        return nil
    end
    local command = codeLens:resolve(id)
    return command
end

return {
    codeLens = getCodeLens,
    resolve  = resolve,
}
