---@class VM.Vfile: GCHost
local M = Class 'VM.Vfile'

Extends('VM.Vfile', 'GCHost')

--- 已编译的版本
M.version = -1
--- 编译时的 runtime 代数
M.rtGeneration = -1
--- 正在编译中的版本
---@type integer?
M.indexingVersion = nil
--- 即将要编译的最新版本
---@type integer
M.nextVersion = -1
--- 当前使用的 Document
---@type Document?
M.document = nil

M.traceMap = ls.util.weakKTable()

---@param scope Scope
---@param uri Uri
function M:__init(scope, uri)
    self.scope = scope
    self.uri = uri
    self.onDidIndex = ls.sevent.create()
    M.traceMap[self] = true
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
    coder:makeFromFile(document.file, self.scope:makeCompileOptions(self.uri))
    return coder
end

function M:index()
    local document = self.scope:getDocument(self.uri)
    if not document then
        return
    end

    local rtGeneration = self.scope.rt.generation
    local version = document.version
    if self.version >= version
    and self.rtGeneration == rtGeneration then
        return
    end

    local _ <close> = function ()
        self.version = version
        self.rtGeneration = rtGeneration
        self.document = document

        self.onDidIndex:fire(self)
        self.scope.vm.onDidIndex:fire(self)
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
end

---@async
function M:awaitIndex()
    local document = self.scope:getDocument(self.uri)
    if not document then
        return
    end
    if self.version >= document.version
    and self.rtGeneration == self.scope.rt.generation then
        local indexingVersion = self.indexingVersion
        if not indexingVersion then
            -- 没在编译？直接返回
            return
        end
        -- 等待上个编译任务完成
        ls.await.yield(function (resume)
            self.onDidIndex:once(resume)
        end)
        return
    end

    local version = document.version

    if self.indexingVersion then
        -- 正在编译？
        if version > self.nextVersion then
            self.nextVersion = version
        end
        -- 等待前一个编译完成再编译新的，防抖
        ls.await.yield(function (resume)
            self.onDidIndex:once(resume)
        end)
        if self.nextVersion ~= version then
            -- 有更新的版本，跳过
            return
        end
    end

    self.indexingVersion = version
    table.insert(self.scope.vm.indexingFiles, self)

    local _ <close> = function ()
        self.indexingVersion = nil
        self.version = version
        self.rtGeneration = self.scope.rt.generation
        self.document = document

        ls.util.arrayRemove(self.scope.vm.indexingFiles, self, true)
        self.onDidIndex:fire(self)
        self.scope.vm.onDidIndex:fire(self)
    end

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

--- 判断字符串是否为合法标识符（`Lua.runtime` 配置自动生效：
--- rule 取 `Lua.runtime.version`，unicode 缺省取 `Lua.runtime.unicodeName`，
--- extra 取 `Lua.runtime.nonstandardSymbol` 中的标识符形态符号）。
---@param str string
---@param unicode? boolean # 显式指定是否允许高位字节，缺省读配置
---@param allowSoft? boolean # 允许软关键字作为标识符，默认允许
---@return boolean
function M:isLegalName(str, unicode, allowSoft)
    local config = self.scope.config
    local extra
    local symbols = config:get(self.uri, 'Lua.runtime.nonstandardSymbol')
    if type(symbols) == 'table' then
        for _, symbol in ipairs(symbols) do
            if symbol == 'continue' then
                extra = { 'continue' }
                break
            end
        end
    end
    if unicode == nil then
        unicode = config:get(self.uri, 'Lua.runtime.unicodeName')
    end
    return ls.guide.isLegalName(
        str,
        config:get(self.uri, 'Lua.runtime.version'),
        unicode,
        allowSoft,
        extra
    )
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

--- 文件根主函数（记录文件根 return 的返回值）
---@return Node.Function?
function M:getMainFunc()
    if not self.coder or not self.coder.map then
        return nil
    end
    ---@type Node.Function?
    local main = self.coder.map['@main']
    if main and main.kind == 'function' then
        return main
    end
    return nil
end

--- 文件根 return 的第一个返回值
---@return Node?
function M:getMainReturn()
    local main = self:getMainFunc()
    if not main then
        return nil
    end
    return main:getReturn(1)
end

--- 调试用：遍历本文件 coder.map 中所有节点，打印其 key/kind/view（带 pcall 保护）。
--- 便于排查节点缓存/推导异常。
---@param filter? string  # 可选，仅打印 key 包含该子串的节点
function M:dumpNodes(filter)
    if not self.coder or not self.coder.map then
        print('[dumpNodes] 无 coder.map')
        return
    end
    local r = self.coder.map
    local keys = {}
    for k in pairs(r) do
        keys[#keys+1] = k
    end
    table.sort(keys)
    print('[dumpNodes] ===== begin (' .. tostring(#keys) .. ' nodes) =====')
    for _, k in ipairs(keys) do
        if not filter or k:find(filter, 1, true) then
            local node = r[k]
            local ok, v = pcall(function ()
                return node:view()
            end)
            print(('[dumpNodes] %-42s kind=%s view=%s'):format(k, tostring(node.kind), ok and v or 'ERR'))
        end
    end
    print('[dumpNodes] ===== end =====')
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

return M
