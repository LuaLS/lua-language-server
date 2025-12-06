---@class VM.Vfile: GCHost
local M = Class 'VM.Vfile'

Extends('VM.Vfile', 'GCHost')

M.version = -1

---@param scope Scope
---@param uri Uri
function M:__init(scope, uri)
    self.scope = scope
    self.uri = uri
end

function M:__close()
    self:remove()
end

---@param document Document
---@return VM.Coder
function M:makeCoder(document)
    local coder = ls.vm.createCoder()
    coder:makeFromAst(document.ast)
    return coder
end

---@async
---@param document Document
---@return VM.Coder
function M:awaitMakeCoder(document)
    local coder = ls.vm.createCoder()
    coder:makeFromFile(document.file)
    return coder
end

function M:index()
    local document = self.scope:getDocument(self.uri)
    if not document then
        return
    end
    if self.version >= document.version then
        return
    end
    self.version = document.version
    if self.coder then
        self.coder:dispose()
    end

    self.indexing = true

    ls.util.withDuration(function ()
        self.coder = self:makeCoder(document)
    end, function (duration)
        if duration > 0.1 then
            log.warn('Index {} took {:.2f} seconds.', self.uri, duration)
        else
            log.debug('Index {} in {:.2f} seconds.', self.uri, duration)
        end
    end)
    self:bindGC(self.coder)
    ls.util.withDuration(function ()
        self.coder:run(self)
    end, function (duration)
        if duration > 0.1 then
            log.warn('Run coder for {} took {:.2f} seconds.', self.uri, duration)
        else
            log.debug('Run coder for {} in {:.2f} seconds.', self.uri, duration)
        end
    end)

    self.indexing = false
end

---@async
function M:awaitIndex()
    local document = self.scope:getDocument(self.uri)
    if not document then
        return
    end
    if self.version >= document.version then
        -- 等待之前的编译任务完成
        while self.indexing do
            ls.await.sleep(0.01)
        end
        return
    end
    self.version = document.version

    local version = self.version
    if self.coder then
        self.coder:dispose()
    end

    self.indexing = true

    ---@async
    ls.util.withDuration(function ()
        self.coder = self:awaitMakeCoder(document)
    end, function (duration)
        if duration > 0.1 then
            log.warn('Index (async) {} took {:.3f} seconds.' % { self.uri, duration })
        else
            log.debug('Index (async) {} in {:.3f} seconds.' % { self.uri, duration })
        end
    end)
    if self.version ~= version then
        return
    end
    self:bindGC(self.coder)
    ls.util.withDuration(function ()
        self.coder:run(self)
    end, function (duration)
        if duration > 0.1 then
            log.warn('Run coder for {} took {:.3f} seconds.' % { self.uri, duration })
        else
            log.debug('Run coder for {} in {:.3f} seconds.' % { self.uri, duration })
        end
    end)

    self.indexing = false
end

---@param source LuaParser.Node.Base
---@return Node?
function M:getNode(source)
    if not self.coder then
        return nil
    end
    local key = source.uniqueKey
    local node = self.coder.map[key]
    if not node then
        return nil
    end
    if node.kind == 'variable' then
        return node.value
    end
    return node
end

---@param source LuaParser.Node.Base
---@return Node.Variable?
function M:getVariable(source)
    if not self.coder then
        return nil
    end
    local key = source.uniqueKey
    local node = self.coder.var[key]
    if not node then
        return nil
    end
    if node.kind == 'variable' then
        return node
    end
    return nil
end

function M:remove()
    Delete(self)
end

---@param scope Scope
---@param uri Uri
---@return VM.Vfile
function ls.vm.createVfile(scope, uri)
    return New 'VM.Vfile' (scope, uri)
end
