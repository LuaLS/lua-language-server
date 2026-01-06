---@class VM.Vfile: GCHost
local M = Class 'VM.Vfile'

Extends('VM.Vfile', 'GCHost')

--- 已编译的版本
M.version = -1
--- 正在编译中的版本
---@type integer?
M.indexingVersion = nil
--- 即将要编译的最新版本
---@type integer
M.nextVersion = -1
--- 当前使用的 Document
---@type Document?
M.document = nil

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
---@return Coder
function M:makeCoder(document)
    local coder = ls.vm.createCoder()
    coder:makeFromAst(document.ast)
    return coder
end

---@async
---@param document Document
---@return Coder
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

    local version = document.version
    if self.version >= version then
        return
    end

    ls.util.withDuration(function ()
        local coder = self:makeCoder(document)
        if self.coder then
            self.coder:dispose()
        end
        self.coder = coder
    end, function (duration)
        if duration > 0.1 then
            log.warn('Index {} took {%.2f} seconds.' % { self.uri, duration })
        else
            log.debug('Index {} in {%.2f} seconds.' % { self.uri, duration })
        end
    end)
    self:bindGC(self.coder)
    ls.util.withDuration(function ()
        self.coder:run(self)
    end, function (duration)
        if duration > 0.1 then
            log.warn('Run coder for {} took {%.2f} seconds.' % { self.uri, duration })
        else
            log.debug('Run coder for {} in {%.2f} seconds.' % { self.uri, duration })
        end
    end)

    self.version = version
    self.document = document
end

---@async
function M:awaitIndex()
    local document = self.scope:getDocument(self.uri)
    if not document then
        return
    end
    if self.version >= document.version then
        local indexingVersion = self.indexingVersion
        if not indexingVersion then
            -- 没在编译？直接返回
            return
        end
        -- 等待上个编译任务完成
        while indexingVersion == self.indexingVersion do
            ls.await.sleep(0.01)
        end
        return
    end

    local version = document.version

    if self.indexingVersion then
        -- 正在编译？
        if version > self.nextVersion then
            self.nextVersion = version
        end
        -- 等待前一个编译完成再编译新的，防抖
        local indexingVersion = self.indexingVersion
        while indexingVersion == self.indexingVersion do
            ls.await.sleep(0.01)
        end
        if self.nextVersion ~= version then
            -- 有更新的版本，跳过
            return
        end
    end

    self.indexingVersion = version

    ---@async
    ls.util.withDuration(function ()
        local coder = self:awaitMakeCoder(document)
        if self.coder then
            self.coder:dispose()
        end
        self.coder = coder
    end, function (duration)
        if duration > 0.1 then
            log.warn('Index (async) {} took {%.3f} seconds.' % { self.uri, duration })
        else
            log.debug('Index (async) {} in {%.3f} seconds.' % { self.uri, duration })
        end
    end)

    self:bindGC(self.coder)
    ls.util.withDuration(function ()
        self.coder:run(self)
    end, function (duration)
        if duration > 0.1 then
            log.warn('Run coder for {} took {%.3f} seconds.' % { self.uri, duration })
        else
            log.debug('Run coder for {} in {%.3f} seconds.' % { self.uri, duration })
        end
    end)

    self.indexingVersion = nil
    self.version = version
    self.document = document
end

---@param source LuaParser.Node.Base
---@return Node?
function M:getNode(source)
    if not self.coder or not self.coder.map then
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
    if not self.coder or not self.coder.map then
        return nil
    end
    local key = source.uniqueKey
    local node = self.coder.map[key]
    if not node then
        return nil
    end
    if node.kind == 'variable' then
        return node
    end
    return nil
end

---@param name string
---@param offset integer
---@return Node.Variable?
function M:findVariable(name, offset)
    if not self.coder then
        return nil
    end
    return self.coder:findVariable(name, offset)
end

---@param offset integer
---@return Node.Variable[]
function M:findVisibleVariables(offset)
    if not self.coder then
        return {}
    end
    return self.coder:findVisibleVariables(offset)
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
