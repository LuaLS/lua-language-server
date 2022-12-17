local files  = require 'files'
local guide  = require 'parser.guide'
local await  = require 'await'
local conv   = require 'proto.converter'
local getRef = require 'core.reference'

---@type codeLens
local latestCodeLens

---@class codeLens.resolving
---@field mode   'reference'
---@field source parser.object

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
    guide.eachSourceType(self.state.ast, 'function', function (src)
        local assign = src.parent
        if not guide.isSet(assign) then
            return
        end
        self:addResult(src.start, {
            mode   = 'reference',
            source = assign,
        })
    end)
end

---@async
---@param source parser.object
---@return proto.command?
function mt:resolveReference(source)
    local refs = getRef(self.uri, source.start, false)
    local count = refs and #refs or 0
    local command = conv.command(
        ('%d个引用'):format(count),
        'editor.action.showReferences',
        {
            self.uri,
            conv.packPosition(self.state, source.start),
        }
    )
    return command
end

---@async
---@param uri uri
---@return codeLens.result[]?
local function codeLens(uri)
    latestCodeLens = setmetatable({}, mt)
    local suc = latestCodeLens:init(uri)
    if not suc then
        return nil
    end

    latestCodeLens:collectReferences()

    if #latestCodeLens.results == 0 then
        return nil
    end

    return latestCodeLens.results
end

---@async
---@param id integer
---@return proto.command?
local function resolve(id)
    if not latestCodeLens then
        return nil
    end
    local command = latestCodeLens:resolve(id)
    return command
end

return {
    codeLens = codeLens,
    resolve  = resolve,
}
