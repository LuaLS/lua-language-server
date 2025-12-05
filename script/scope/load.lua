---@class Scope
local M = Class 'Scope'

function M:initGlob()
    if self.glob then
        return
    end
    self.glob = ls.glob.gitignore()
    self.glob:setOption('root', self.uri)
    self.glob:setOption('ignoreCase', true)
    self.glob:setInterface('type', function (uri)
        return self.fs.getType(uri)
    end)
    self.glob:setInterface('list', function (uri)
        do -- 顺便加载该目录下的 `.luarc.json` 配置文件
            local rcUri = uri / '.luarc.json'
            self.config:loadRC(rcUri)
        end
        return self.fs.getChilds(uri)
    end)
    self.glob:setInterface('patterns', function (uri)
        local patterns = {}
        do -- 忽略配置 `Lua.workspace.ignoreDir` 中定义的文件
            local ignoreDirs = self.config:getRaw(uri, 'Lua.workspace.ignoreDir')
            if ignoreDirs then
                ls.util.arrayMerge(patterns, ignoreDirs)
            end
        end
        -- 应用 .gitignore 中定义的规则
        if self.config:get(uri, 'Lua.workspace.useGitIgnore') then
            local ignoreUri = uri / '.gitignore'
            local content = self.fs.read(ignoreUri)
            if content then
                for line in ls.util.eachLine(content) do
                    local path = ls.util.trim(line)
                    if  #path > 0
                    and not ls.util.stringStartWith(path, '#') then
                        patterns[#patterns+1] = path
                    end
                end
            end
        end
        -- 忽略子模块
        if self.config:get(uri, 'Lua.workspace.ignoreSubmodules') then
            local submoduleUri = uri / '.gitmodules'
            local content = self.fs.read(submoduleUri)
            if content then
                for line in ls.util.eachLine(content) do
                    local trimmedLine = ls.util.trim(line)
                    if ls.util.stringStartWith(trimmedLine, 'path = ') then
                        local path = trimmedLine:sub(8)
                        if #path > 0 then
                            patterns[#patterns+1] = path
                        end
                    end
                end
            end
        end
        return patterns
    end)
end

---@alias Scope.Load.Event
---| 'start'
---| 'finding'
---| 'found'
---| 'loading'
---| 'loaded'
---| 'indexing'
---| 'indexed'
---| 'finish'

---@class Scope.Load.Status
---@field found integer
---@field loaded integer
---@field indexed integer
---@field uris Uri[]

---@async
---@param callback fun(event: Scope.Load.Event, status: Scope.Load.Status, uri?: Uri)
---@return Scope.Load.Status
function M:load(callback)
    self:initGlob()

    ---@type Uri[]
    self.uris = {}

    ---@type Scope.Load.Status
    local status = {
        found = 0,
        loaded = 0,
        indexed = 0,
        uris = self.uris,
    }

    xpcall(callback, log.error, 'start', status)

    self:loadFiles(callback, status)

    xpcall(callback, log.error, 'finish', status)

    return status
end

---@package
---@async
---@param callback fun(event: Scope.Load.Event, status: Scope.Load.Status, uri?: Uri)
---@param status Scope.Load.Status
function M:loadFiles(callback, status)
    self.glob:scan(self.uri, function (uri)
        if self:isValidUri(uri) then
            self.uris[#self.uris+1] = uri
            status.found = status.found + 1
            xpcall(callback, log.error, 'finding', status, uri)
        end
    end)
    xpcall(callback, log.error, 'found', status)

    local loadTasks = {}

    for _, uri in ipairs(self.uris) do
        ---@async
        loadTasks[#loadTasks+1] = function ()
            local content = self.fs.read(uri)
            if content then
                ls.file.setServerText(uri, content)
            end
            status.loaded = status.loaded + 1

            xpcall(callback, log.error, 'loading', status, uri)

            if status.loaded == status.found then
                xpcall(callback, log.error, 'loaded', status)
            end

            ls.await.sleep(0)

            self.vm:awaitIndexFile(uri)
            status.indexed = status.indexed + 1

            xpcall(callback, log.error, 'indexing', status, uri)
        end
    end

    ls.await.waitAll(loadTasks)

    xpcall(callback, log.error, 'indexed', status)
end
