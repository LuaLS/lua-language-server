local progress = require 'progress'
local lang     = require 'language'
local await    = require 'await'
local files    = require 'files'
local config   = require 'config.config'
local client   = require 'client'
local pub      = require 'pub.pub'

---@class workspace.loading
---@field scp scope
---@field _bar progress
---@field _stash function[]
local mt = {}
mt.__index = mt

mt._loadLock = false
mt.read      = 0
mt.max       = 0
mt.preload   = 0

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
function mt:scanFile(uri, libraryUri)
    if files.isLua(uri) then
        if not libraryUri then
            self.preload = self.preload + 1
            if not self:checkMaxPreload(uri) then
                return
            end
        end
        self.max = self.max + 1
        self:update()
        pub.task('loadFile', uri, function (content)
            self._stash[#self._stash+1] = function ()
                self.read = self.read + 1
                self:update()
                if not content then
                    return
                end
                log.info(('Preload file at: %s , size = %.3f KB'):format(uri, #content / 1024.0))
                if libraryUri then
                    log.info('++++As library of:', libraryUri)
                    files.setLibraryUri(uri, libraryUri)
                end
                files.setText(uri, content, false)
            end
        end)
    elseif files.isDll(uri) then
        self.max = self.max + 1
        self:update()
        pub.task('loadFile', uri, function (content)
            self.read = self.read + 1
            self:update()
            if not content then
                return
            end
            log.info(('Preload dll at: %s , size = %.3f KB'):format(uri, #content / 1024.0))
            if libraryUri then
                log.info('++++As library of:', libraryUri)
            end
            files.saveDll(uri, content)
        end)
        await.delay()
    end
end

function mt:loadStashed()
    self:update()
    if self._loadLock then
        return
    end
    self._loadLock = true
    ---@async
    await.call(function ()
        while true do
            local loader = table.remove(self._stash)
            if not loader then
                break
            end
            loader()
            await.delay()
        end
        self._loadLock = false
    end)
end

---@async
function mt:loadAll()
    while self.read < self.max do
        log.info(('Loaded %d/%d files'):format(self.read, self.max))
        self:loadStashed()
        await.sleep(0.1)
    end
end

function mt:remove()
    self._bar:remove()
end

function mt:__close()
    self:remove()
end

---@class workspace.loading.manager
local m = {}

---@return workspace.loading
function m.create(scp)
    local loading = setmetatable({
        scp    = scp,
        _bar   = progress.create(lang.script('WORKSPACE_LOADING', scp.uri)),
        _stash = {},
    }, mt)
    return loading
end

return m
