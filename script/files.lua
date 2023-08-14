local platform = require 'bee.platform'
local fs       = require 'bee.filesystem'
local config   = require 'config'
local glob     = require 'glob'
local furi     = require 'file-uri'
local parser   = require 'parser'
local lang     = require 'language'
local await    = require 'await'
local timer    = require 'timer'
local util     = require 'utility'
local guide    = require 'parser.guide'
local smerger  = require 'string-merger'
local progress = require "progress"
local encoder  = require 'encoder'
local scope    = require 'workspace.scope'
local lazy     = require 'lazytable'
local cacher   = require 'lazy-cacher'
local sp       = require 'bee.subprocess'
local pub      = require 'pub'

---@class file
---@field uri           uri
---@field ref?          integer
---@field trusted?      boolean
---@field rows?         integer[]
---@field originText?   string
---@field text?         string
---@field version?      integer
---@field originLines?  integer[]
---@field diffInfo?     table[]
---@field cache?        table
---@field id            integer
---@field state?        parser.state
---@field compileCount? integer
---@field words?        table

---@class files
---@field lazyCache?   lazy-cacher
local m = {}

m.watchList      = {}
m.notifyCache    = {}
m.assocVersion   = -1

function m.reset()
    m.openMap        = {}
    ---@type table<string, file>
    m.fileMap        = {}
    m.dllMap         = {}
    m.visible        = {}
    m.globalVersion  = 0
    m.fileCount      = 0
    ---@type table<uri, parser.state>
    m.stateMap       = setmetatable({}, util.MODE_V)
    ---@type table<parser.state, true>
    m.stateTrace     = setmetatable({}, util.MODE_K)
end

m.reset()

local fileID = util.counter()

local uriMap = {}

---@param path fs.path
---@return fs.path
local function getRealParent(path)
    local parent = path:parent_path()
    if parent:string():gsub('^%w+:', string.lower)
    == path  :string():gsub('^%w+:', string.lower) then
        return path
    end
    local res = fs.fullpath(path)
    return getRealParent(parent) / res:filename()
end

-- 获取文件的真实uri，但不穿透软链接
---@param uri uri
---@return uri
function m.getRealUri(uri)
    if platform.OS ~= 'Windows' then
        return furi.normalize(uri)
    end
    if not furi.isValid(uri) then
        return uri
    end
    local filename = furi.decode(uri)
    -- normalize uri
    uri = furi.encode(filename)
    local path = fs.path(filename)
    local suc, exists = pcall(fs.exists, path)
    if not suc or not exists then
        return uri
    end
    local suc, res = pcall(fs.canonical, path)
    if not suc then
        return uri
    end
    filename = res:string()
    local ruri = furi.encode(filename)
    if uri == ruri then
        return ruri
    end
    local real = getRealParent(path:parent_path()) / res:filename()
    ruri = furi.encode(real:string())
    if uri == ruri then
        return ruri
    end
    if not uriMap[uri] then
        uriMap[uri] = true
        log.warn(('Fix real file uri: %s -> %s'):format(uri, ruri))
    end
    return ruri
end

--- 打开文件
---@param uri uri
function m.open(uri)
    m.openMap[uri] = {
        cache = {},
    }
    m.onWatch('open', uri)
end

--- 关闭文件
---@param uri uri
function m.close(uri)
    m.openMap[uri] = nil
    local file = m.fileMap[uri]
    if file then
        file.trusted = false
    end
    m.onWatch('close', uri)
    if file then
        if (file.ref or 0) <= 0 and not m.isOpen(uri) then
            m.remove(uri)
        end
    end
end

--- 是否打开
---@param uri uri
---@return boolean
function m.isOpen(uri)
    return m.openMap[uri] ~= nil
end

function m.getOpenedCache(uri)
    local data = m.openMap[uri]
    if not data then
        return nil
    end
    return data.cache
end

--- 是否是库文件
function m.isLibrary(uri, excludeFolder)
    if excludeFolder then
        for _, scp in ipairs(scope.folders) do
            if scp:isChildUri(uri) then
                return false
            end
        end
    end
    for _, scp in ipairs(scope.folders) do
        if scp:isLinkedUri(uri) then
            return true
        end
    end
    if scope.fallback:isLinkedUri(uri) then
        return true
    end
    return false
end

--- 获取库文件的根目录
---@return uri?
function m.getLibraryUri(suri, uri)
    local scp = scope.getScope(suri)
    return scp:getLinkedUri(uri)
end

--- 是否存在
---@return boolean
function m.exists(uri)
    return m.fileMap[uri] ~= nil
end

---@param file file
---@param text string
---@return string
local function pluginOnSetText(file, text)
    local plugin   = require 'plugin'
    file.diffInfo = nil
    local suc, result = plugin.dispatch('OnSetText', file.uri, text)
    if not suc then
        if DEVELOP and result then
            util.saveFile(LOGPATH .. '/diffed.lua', tostring(result))
        end
        return text
    end
    if type(result) == 'string' then
        return result
    elseif type(result) == 'table' then
        local diffs
        suc, result, diffs = xpcall(smerger.mergeDiff, log.error, text, result)
        if suc then
            file.diffInfo = diffs
            file.originLines = parser.lines(text)
            return result
        else
            if DEVELOP and result then
                util.saveFile(LOGPATH .. '/diffed.lua', tostring(result))
            end
        end
    end
    return text
end

---@param file file
function m.removeState(file)
    file.state = nil
    m.stateMap[file.uri] = nil
end

--- 设置文件文本
---@param uri uri
---@param text? string
---@param isTrust? boolean
---@param callback? function
function m.setText(uri, text, isTrust, callback)
    if not text then
        return
    end
    if #text > 1024 * 1024 * 10 then
        local client = require 'client'
        client.showMessage('Warning', lang.script('WORKSPACE_SKIP_HUGE_FILE', uri))
        return
    end
    --log.debug('setText', uri)
    local create
    if not m.fileMap[uri] then
        m.fileMap[uri] = {
            uri = uri,
            id  = fileID(),
        }
        m.fileCount = m.fileCount + 1
        create = true
        m._pairsCache = nil
    end
    local file = m.fileMap[uri]
    if file.trusted and not isTrust then
        return
    end
    if not isTrust then
        local encoding = config.get(uri, 'Lua.runtime.fileEncoding')
        text = encoder.decode(encoding, text)
    end
    if callback then
        callback(file)
    end
    if file.originText == text then
        return
    end
    local clock = os.clock()
    local newText = pluginOnSetText(file, text)
    m.removeState(file)
    file.text            = newText
    file.trusted         = isTrust
    file.originText      = text
    file.rows            = nil
    file.words           = nil
    file.compileCount    = 0
    file.cache           = {}
    m.globalVersion = m.globalVersion + 1
    m.onWatch('version', uri)
    if create then
        m.onWatch('create', uri)
        m.onWatch('update', uri)
    else
        m.onWatch('update', uri)
    end
    if DEVELOP then
        if text ~= newText then
            util.saveFile(LOGPATH .. '/diffed.lua', newText)
        end
    end
    log.trace('Set text:', uri, 'takes', os.clock() - clock, 'sec.')

    --if instance or TEST then
    --else
    --    await.call(function ()
    --        await.close('update:' .. uri)
    --        await.setID('update:' .. uri)
    --        await.sleep(0.1)
    --        if m.exists(uri) then
    --            m.onWatch('update', uri)
    --        end
    --    end)
    --end
end

function m.resetText(uri)
    local file = m.fileMap[uri]
    if not file then
        return
    end
    local originText = file.originText
    file.originText = nil
    m.setText(uri, originText, file.trusted)
end

function m.setRawText(uri, text)
    if not text then
        return
    end
    local file = m.fileMap[uri]
    file.text             = text
    file.originText       = text
    m.removeState(file)
end

function m.getCachedRows(uri)
    local file = m.fileMap[uri]
    if not file then
        return nil
    end
    return file.rows
end

function m.setCachedRows(uri, rows)
    local file = m.fileMap[uri]
    if not file then
        return
    end
    file.rows = rows
end

function m.getWords(uri)
    local file = m.fileMap[uri]
    if not file then
        return
    end
    if file.words then
        return file.words
    end
    local words = {}
    file.words = words
    local text = file.text
    if not text then
        return
    end
    local mark = {}
    for word in text:gmatch '([%a_][%w_]+)' do
        if #word >= 3 and not mark[word] then
            mark[word] = true
            local head = word:sub(1, 2)
            if not words[head] then
                words[head] = {}
            end
            words[head][#words[head]+1] = word
        end
    end
    return words
end

function m.getWordsOfHead(uri, head)
    local file = m.fileMap[uri]
    if not file then
        return nil
    end
    local words = m.getWords(uri)
    if not words then
        return nil
    end
    return words[head]
end

--- 获取文件版本
function m.getVersion(uri)
    local file = m.fileMap[uri]
    if not file then
        return nil
    end
    return file.version
end

--- 获取文件文本
---@param uri uri
---@return string? text
function m.getText(uri)
    local file = m.fileMap[uri]
    if not file then
        return nil
    end
    return file.text
end

--- 获取文件原始文本
---@param uri uri
---@return string? text
function m.getOriginText(uri)
    local file = m.fileMap[uri]
    if not file then
        return nil
    end
    return file.originText
end

---@param uri uri
---@param text string
function m.setOriginText(uri, text)
    local file = m.fileMap[uri]
    if not file then
        return
    end
    file.originText = text
end

--- 获取文件原始行表
---@param uri uri
---@return integer[]
function m.getOriginLines(uri)
    local file = m.fileMap[uri]
    assert(file, 'file not exists:' .. uri)
    return file.originLines
end

function m.getChildFiles(uri)
    local results = {}
    local uris = m.getAllUris(uri)
    for _, curi in ipairs(uris) do
        if  #curi > #uri
        and curi:sub(1, #uri) == uri
        and curi:sub(#uri+1, #uri+1):match '[/\\]' then
            results[#results+1] = curi
        end
    end
    return results
end

function m.addRef(uri)
    local file = m.fileMap[uri]
    if not file then
        return nil
    end
    file.ref = (file.ref or 0) + 1
    log.debug('add ref', uri, file.ref)
    return function ()
        m.delRef(uri)
    end
end

function m.delRef(uri)
    local file = m.fileMap[uri]
    if not file then
        return
    end
    file.ref = (file.ref or 0) - 1
    log.debug('del ref', uri, file.ref)
    if file.ref <= 0 and not m.isOpen(uri) then
        m.remove(uri)
    end
end

--- 移除文件
---@param uri uri
function m.remove(uri)
    local file = m.fileMap[uri]
    if not file then
        return
    end
    m.removeState(file)
    m.fileMap[uri]        = nil
    m._pairsCache         = nil

    m.fileCount     = m.fileCount - 1
    m.globalVersion = m.globalVersion + 1

    m.onWatch('version', uri)
    m.onWatch('remove', uri)
end

--- 获取一个包含所有文件uri的数组
---@param suri? uri
---@return uri[]
function m.getAllUris(suri)
    local scp = suri and scope.getScope(suri) or nil
    local files = {}
    local i = 0
    for uri in pairs(m.fileMap) do
        if not scp
        or scp:isChildUri(uri)
        or scp:isLinkedUri(uri) then
            i = i + 1
            files[i] = uri
        end
    end
    table.sort(files)
    return files
end

--- 遍历文件
---@param suri? uri
function m.eachFile(suri)
    local files = m.getAllUris(suri)
    local i = 0
    return function ()
        i = i + 1
        local uri = files[i]
        while not m.fileMap[uri] do
            i = i + 1
            uri = files[i]
            if not uri then
                return nil
            end
        end
        return files[i]
    end
end

--- Pairs dll files
function m.eachDll()
    local map = {}
    for uri, file in pairs(m.dllMap) do
        map[uri] = file
    end
    return pairs(map)
end

function m.getLazyCache()
    if not m.lazyCache then
        local cachePath = string.format('%s/cache/%d'
            , LOGPATH
            , sp.get_id()
        )
        m.lazyCache = cacher(cachePath, log.error)
    end
    return m.lazyCache
end

---@param state parser.state
---@param file file
function m.compileStateThen(state, file)
    m.stateTrace[state] = true
    m.stateMap[file.uri] = state
    state.uri = file.uri
    state.lua = file.text
    state.ast.uri = file.uri
    state.diffInfo   = file.diffInfo
    state.originLines = file.originLines
    state.originText  = file.originText

    local clock = os.clock()
    parser.luadoc(state)
    local passed = os.clock() - clock
    if passed > 0.1 then
        log.warn(('Parse LuaDoc of [%s] takes [%.3f] sec, size [%.3f] kb.'):format(file.uri, passed, #file.text / 1000))
    end

    if LAZY and not file.trusted then
        local cache = m.getLazyCache()
        local id = ('%d'):format(file.id)
        clock = os.clock()
        state = lazy.build(state, cache:writterAndReader(id)):entry()
        passed = os.clock() - clock
        if passed > 0.1 then
            log.warn(('Convert lazy-table for [%s] takes [%.3f] sec, size [%.3f] kb.'):format(file.uri, passed, #file.text / 1000))
        end
    end

    file.compileCount = file.compileCount + 1
    if file.compileCount >= 3 then
        file.state = state
        log.debug('State persistence:', file.uri)
    end

    m.onWatch('compile', file.uri)
end

---@param uri uri
---@return boolean
function m.checkPreload(uri)
    local file = m.fileMap[uri]
    if not file then
        return false
    end
    local ws     = require 'workspace'
    local client = require 'client'
    if  not m.isOpen(uri)
    and not m.isLibrary(uri)
    and #file.text >= config.get(uri, 'Lua.workspace.preloadFileSize') * 1000 then
        if not m.notifyCache['preloadFileSize'] then
            m.notifyCache['preloadFileSize'] = {}
            m.notifyCache['skipLargeFileCount'] = 0
        end
        if not m.notifyCache['preloadFileSize'][uri] then
            m.notifyCache['preloadFileSize'][uri] = true
            m.notifyCache['skipLargeFileCount'] = m.notifyCache['skipLargeFileCount'] + 1
            local message = lang.script('WORKSPACE_SKIP_LARGE_FILE'
                        , ws.getRelativePath(uri)
                        , config.get(uri, 'Lua.workspace.preloadFileSize')
                        , #file.text / 1000
                    )
            if m.notifyCache['skipLargeFileCount'] <= 1 then
                client.showMessage('Info', message)
            else
                client.logMessage('Info', message)
            end
        end
        return false
    end
    return true
end

---@param uri uri
---@param callback fun(state: parser.state?)
function m.compileStateAsync(uri, callback)
    local file = m.fileMap[uri]
    if not file then
        callback(nil)
        return
    end
    if m.stateMap[uri] then
        callback(m.stateMap[uri])
        return
    end

    ---@type brave.param.compile.options
    local options = {
        special           = config.get(uri, 'Lua.runtime.special'),
        unicodeName       = config.get(uri, 'Lua.runtime.unicodeName'),
        nonstandardSymbol = util.arrayToHash(config.get(uri, 'Lua.runtime.nonstandardSymbol')),
    }

    ---@type brave.param.compile
    local params = {
        uri     = uri,
        text    = file.text,
        mode    = 'Lua',
        version = config.get(uri, 'Lua.runtime.version'),
        options = options
    }
    pub.task('compile', params, function (result)
        if file.text ~= params.text then
            return
        end
        if not result.state then
            log.error('Compile failed:', uri, result.err)
            callback(nil)
            return
        end
        m.compileStateThen(result.state, file)
        callback(result.state)
    end)
end

---@param uri uri
---@return parser.state?
function m.compileState(uri)
    local file = m.fileMap[uri]
    if not file then
        return
    end
    if m.stateMap[uri] then
        return m.stateMap[uri]
    end
    if not m.checkPreload(uri) then
        return
    end

    ---@type brave.param.compile.options
    local options = {
        special           = config.get(uri, 'Lua.runtime.special'),
        unicodeName       = config.get(uri, 'Lua.runtime.unicodeName'),
        nonstandardSymbol = util.arrayToHash(config.get(uri, 'Lua.runtime.nonstandardSymbol')),
    }

    local ws     = require 'workspace'
    local client = require 'client'
    if not client.isReady() then
        log.error('Client not ready!', uri)
    end
    local prog <close> = progress.create(uri, lang.script.WINDOW_COMPILING, 0.5)
    prog:setMessage(ws.getRelativePath(uri))
    log.trace('Compile State:', uri)
    local clock = os.clock()
    local state, err = parser.compile(file.text
        , 'Lua'
        , config.get(uri, 'Lua.runtime.version')
        , options
    )
    local passed = os.clock() - clock
    if passed > 0.1 then
        log.warn(('Compile [%s] takes [%.3f] sec, size [%.3f] kb.'):format(uri, passed, #file.text / 1000))
    end

    if not state then
        log.error('Compile failed:', uri, err)
        return nil
    end

    m.compileStateThen(state, file)

    return state
end

---@class parser.state
---@field diffInfo? table[]
---@field originLines? integer[]
---@field originText? string
---@field lua? string

--- 获取文件语法树
---@param uri uri
---@return parser.state? state
function m.getState(uri)
    local file = m.fileMap[uri]
    if not file then
        return nil
    end
    local state = m.compileState(uri)
    return state
end

---@param uri uri
---@return parser.state?
function m.getLastState(uri)
    return m.stateMap[uri]
end

function m.getFile(uri)
    return m.fileMap[uri]
        or m.dllMap[uri]
end

---@param text string
local function isNameChar(text)
    if text:match '^[\xC2-\xFD][\x80-\xBF]*$' then
        return true
    end
    if text:match '^[%w_]+$' then
        return true
    end
    return false
end

--- 将应用差异前的offset转换为应用差异后的offset
---@param state  parser.state
---@param offset integer
---@return integer start
---@return integer finish
function m.diffedOffset(state, offset)
    if not state.diffInfo then
        return offset, offset
    end
    return smerger.getOffset(state.diffInfo, offset)
end

--- 将应用差异后的offset转换为应用差异前的offset
---@param state  parser.state
---@param offset integer
---@return integer start
---@return integer finish
function m.diffedOffsetBack(state, offset)
    if not state.diffInfo then
        return offset, offset
    end
    return smerger.getOffsetBack(state.diffInfo, offset)
end

---@param state parser.state
function m.hasDiffed(state)
    return state.diffInfo ~= nil
end

--- 获取文件的自定义缓存信息（在文件内容更新后自动失效）
function m.getCache(uri)
    local file = m.fileMap[uri]
    if not file then
        return nil
    end
    return file.cache
end

--- 获取文件关联
function m.getAssoc(uri)
    local patt = {}
    for k, v in pairs(config.get(uri, 'files.associations')) do
        if v == 'lua' then
            patt[#patt+1] = k
        end
    end
    m.assocMatcher = glob.glob(patt)
    return m.assocMatcher
end

--- 判断是否是Lua文件
---@param uri uri
---@return boolean
function m.isLua(uri)
    if util.stringEndWith(uri:lower(), '.lua') then
        return true
    end
    -- check customed assoc, e.g. `*.lua.txt = *.lua`
    local matcher = m.getAssoc(uri)
    local path = furi.decode(uri)
    return matcher(path)
end

--- Does the uri look like a `Dynamic link library` ?
---@param uri uri
---@return boolean
function m.isDll(uri)
    local ext = uri:match '%.([^%.%/%\\]+)$'
    if not ext then
        return false
    end
    if platform.OS == 'Windows' then
        if ext == 'dll' then
            return true
        end
    else
        if ext == 'so' then
            return true
        end
    end
    return false
end

--- Save dll, makes opens and words, discard content
---@param uri uri
---@param content string
function m.saveDll(uri, content)
    if not content then
        return
    end
    local file = {
        uri   = uri,
        opens = {},
        words = {},
    }
    for word in content:gmatch 'luaopen_([%w_]+)' do
        file.opens[#file.opens+1] = word:gsub('_', '.')
    end
    if #file.opens == 0 then
        return
    end
    local mark = {}
    for word in content:gmatch '(%a[%w_]+)\0' do
        if word:sub(1, 3) ~= 'lua' then
            if not mark[word] then
                mark[word] = true
                file.words[#file.words+1] = word
            end
        end
    end

    m.dllMap[uri] = file
    m.onWatch('dll', uri)
end

---
---@param uri uri
---@return string[]|nil
function m.getDllOpens(uri)
    local file = m.dllMap[uri]
    if not file then
        return nil
    end
    return file.opens
end

---
---@param uri uri
---@return string[]|nil
function m.getDllWords(uri)
    local file = m.dllMap[uri]
    if not file then
        return nil
    end
    return file.words
end

---@return integer
function m.countStates()
    local n = 0
    for _ in pairs(m.stateTrace) do
        n = n + 1
    end
    return n
end

---@param path string
---@return string
function m.normalize(path)
    path = path:gsub('%$%{(.-)%}', function (key)
        if key == '3rd' then
            return (ROOT / 'meta' / '3rd'):string()
        end
        if key:sub(1, 4) == 'env:' then
            local env = os.getenv(key:sub(5))
            return env
        end
    end)
    path = util.expandPath(path)
    path = path:gsub('^%.[/\\]+', '')
    for _ = 1, 1000 do
        if path:sub(1, 2) == '..' then
            break
        end
        local count
        path, count = path:gsub('[^/\\]+[/\\]+%.%.[/\\]', '/', 1)
        if count == 0 then
            break
        end
    end
    if platform.OS == 'Windows' then
        path = path:gsub('[/\\]+', '\\')
                   :gsub('[/\\]+$', '')
                   :gsub('^(%a:)$', '%1\\')
    else
        path = path:gsub('[/\\]+', '/')
                   :gsub('[/\\]+$', '')
    end
    return path
end

--- 注册事件
---@param callback async fun(ev: string, uri: uri)
function m.watch(callback)
    m.watchList[#m.watchList+1] = callback
end

function m.onWatch(ev, uri)
    for _, callback in ipairs(m.watchList) do
        await.call(function ()
            callback(ev, uri)
        end)
    end
end

return m
