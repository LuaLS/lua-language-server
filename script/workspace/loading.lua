local progress = require 'progress'
local lang     = require 'language'
local await    = require 'await'
local files    = require 'files'
local config   = require 'config.config'
local client   = require 'client'
local util     = require 'utility'
local furi     = require 'file-uri'
local pub      = require 'pub'

---@class workspace.loading
---@field scp scope
---@field _bar progress
---@field _stash function[]
---@field _refs uri[]
---@field _cache table<uri, boolean>
---@field _sets function[]
---@field _removed boolean
local mt = {}
mt.__index = mt

mt._loadLock = false
mt.read      = 0
mt.max       = 0
mt.preload   = 0

function mt:__close()
    self:remove()
end

function mt:update()
    self._bar:setMessage(('%d/%d'):format(self.read, self.max))
    self._bar:setPercentage(self.read / self.max * 100.0)
end

---@param uri uri
function mt:checkMaxPreload(uri)
    local max = config.get(uri, 'Lua.workspace.maxPreload')
    if self.preload <= max then
        return true
    end
    if self.scp:get 'hasHintedMaxPreload' then
        return false
    end
    self.scp:set('hasHintedMaxPreload', true)
    client.requestMessage('Info'
        , lang.script('MWS_MAX_PRELOAD', max)
        , {
            lang.script('WINDOW_INCREASE_UPPER_LIMIT'),
        }
        , function (_, index)
            if index == 1 then
                client.setConfig {
                    {
                        key    = 'Lua.workspace.maxPreload',
                        uri    = self.scp.uri,
                        action = 'set',
                        value  = max + math.max(1000, max),
                    }
                }
            end
        end
    )
    return false
end

---@param uri uri
---@param libraryUri? uri
---@async
function mt:loadFile(uri, libraryUri)
    if files.isLua(uri) then
        if not libraryUri then
            self.preload = self.preload + 1
            if not self:checkMaxPreload(uri) then
                return
            end
        end
        self.max = self.max + 1
        self:update()
        ---@async
        self._stash[#self._stash+1] = function ()
            if files.getFile(uri) then
                self.read = self.read + 1
                self:update()
                if not self._cache[uri] then
                    files.addRef(uri)
                end
                self._cache[uri] = true
                log.info(('Skip loaded file: %s'):format(uri))
            else
                local content = pub.awaitTask('loadFile', furi.decode(uri))
                self.read = self.read + 1
                self:update()
                if not content then
                    return
                end
                if files.getFile(uri) then
                    log.info(('Skip loaded file: %s'):format(uri))
                    return
                end
                log.info(('Preload file at: %s , size = %.3f KB'):format(uri, #content / 1024.0))
                --await.wait(function (waker)
                --    self._sets[#self._sets+1] = waker
                --end)
                files.setText(uri, content, false)
                files.compileState(uri)
                if not self._cache[uri] then
                    files.addRef(uri)
                end
                self._cache[uri] = true
            end
            if libraryUri then
                log.info('++++As library of:', libraryUri)
            end
        end
    elseif files.isDll(uri) then
        self.max = self.max + 1
        self:update()
        ---@async
        self._stash[#self._stash+1] = function ()
            if files.getFile(uri) then
                self.read = self.read + 1
                self:update()
                if not self._cache[uri] then
                    files.addRef(uri)
                end
                self._cache[uri] = true
                log.info(('Skip loaded file: %s'):format(uri))
            else
                local content = pub.awaitTask('loadFile', furi.decode(uri))
                self.read = self.read + 1
                self:update()
                if not content then
                    return
                end
                if files.getFile(uri) then
                    log.info(('Skip loaded file: %s'):format(uri))
                    return
                end
                log.info(('Preload dll at: %s , size = %.3f KB'):format(uri, #content / 1024.0))
                --await.wait(function (waker)
                --    self._sets[#self._sets+1] = waker
                --end)
                files.saveDll(uri, content)
                if not self._cache[uri] then
                    files.addRef(uri)
                end
                self._cache[uri] = true
            end
            if libraryUri then
                log.info('++++As library of:', libraryUri)
            end
        end
    end
    await.delay()
end

---@async
function mt:loadAll(fileName)
    local startClock = os.clock()
    log.info('Load files from disk:', fileName)
    while self.read < self.max do
        self:update()
        local loader = table.remove(self._stash)
        if loader then
            await.call(loader)
            await.delay()
        else
            await.sleep(0.1)
        end
    end
    local loadedClock = os.clock()
    log.info(('Loaded files takes [%.3f] sec: %s'):format(loadedClock - startClock, fileName))
    self._bar:remove()
    self._bar = progress.create(self.scp.uri, lang.script('WORKSPACE_LOADING', self.scp.uri), 0)
    for i, set in ipairs(self._sets) do
        await.delay()
        set()
        self.read = i
        self:update()
    end
    log.info(('Compile files takes [%.3f] sec: %s'):format(os.clock() - loadedClock, fileName))
    log.info('Loaded finish:', fileName)
end

function mt:remove()
    if self._removed then
        return
    end
    self._removed = true
    self._bar:remove()
end

function mt:isRemoved()
    return self._removed == true
end

---@class workspace.loading.manager
local m = {}

---@type table<workspace.loading, boolean>
m._loadings = setmetatable({}, { __mode = 'k' })

---@return workspace.loading
function m.create(scp)
    local loading = setmetatable({
        scp    = scp,
        _bar   = progress.create(scp.uri, lang.script('WORKSPACE_LOADING', scp.uri), 0.5),
        _stash = {},
        _cache = {},
        _sets  = {},
    }, mt)
    m._loadings[loading] = true
    return loading
end

function m.count()
    local num = 0
    for ld in pairs(m._loadings) do
        if ld:isRemoved() then
            m._loadings[ld] = nil
        else
            num = num + 1
        end
    end
    return num
end

return m
