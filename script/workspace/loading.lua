local progress = require 'progress'
local lang     = require 'language'
local await    = require 'await'
local files    = require 'files'
local config   = require 'config.config'
local client   = require 'client'
local util     = require 'utility'
local furi     = require 'file-uri'

---@class workspace.loading
---@field scp scope
---@field _bar progress
---@field _stash function[]
---@field _refs uri[]
---@field _cache table<uri, boolean>
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
            lang.script
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
---@param libraryUri boolean
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
        self._stash[#self._stash+1] = function ()
            self.read = self.read + 1
            if files.getFile(uri) then
                files.addRef(uri)
                log.info(('Skip loaded file: %s'):format(uri))
                return
            end
            local content = util.loadFile(furi.decode(uri))
            self:update()
            if not content then
                return
            end
            if self._cache[uri] then
                return
            end
            log.info(('Preload file at: %s , size = %.3f KB'):format(uri, #content / 1024.0))
            self._cache[uri] = true
            files.setText(uri, content, false)
            files.addRef(uri)
            if libraryUri then
                log.info('++++As library of:', libraryUri)
                files.setLibraryUri(self.scp, uri, libraryUri)
            end
        end
    elseif files.isDll(uri) then
        self.max = self.max + 1
        self:update()
        self._stash[#self._stash+1] = function ()
            self.read = self.read + 1
            if files.getFile(uri) then
                files.addRef(uri)
                log.info(('Skip loaded file: %s'):format(uri))
                return
            end
            local content = util.loadFile(furi.decode(uri))
            self:update()
            if not content then
                return
            end
            if self._cache[uri] then
                return
            end
            log.info(('Preload dll at: %s , size = %.3f KB'):format(uri, #content / 1024.0))
            self._cache[uri] = true
            files.saveDll(uri, content)
            files.addRef(uri)
            if libraryUri then
                log.info('++++As library of:', libraryUri)
            end
        end
    end
    await.delay()
end

---@async
function mt:loadStashed(max)
    for _ = 1, max do
        local loader = table.remove(self._stash)
        if not loader then
            return false
        end
        loader()
        await.delay()
    end
    return true
end

---@async
function mt:loadAll()
    while true do
        log.info(('Loaded %d/%d files'):format(self.read, self.max))
        local suc = self:loadStashed(10)
        self:update()
        if not suc then
            break
        end
    end
    log.info('Loaded finish.')
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
        _bar   = progress.create(scp, lang.script('WORKSPACE_LOADING', scp.uri), 0.5),
        _stash = {},
        _cache = {},
    }, mt)
    scp:set('cachedUris', loading._cache)
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
