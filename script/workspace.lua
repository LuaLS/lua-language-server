local fs = require 'bee.filesystem'
local async = require 'async'
local config = require 'config'
local ll = require 'lpeglabel'
local platform = require 'bee.platform'
local glob = require 'glob'
local uric = require 'uri'
local fn = require 'filename'

--- @class Workspace
local mt = {}
mt.__index = mt

function mt:listenLoadFile()
    self._loadFileRequest = async.run('loadfile', nil, function (filename, mode, buf)
        local path = fs.path(filename)
        local name = fn.getFileName(path)
        local uri = uric.encode(path)
        self.files[name] = uri
        if mode == 'workspace' then
            self.lsp:readText(self, uri, path, buf, self._currentScanCompiled)
        elseif mode == 'library' then
            self.lsp:readLibrary(self, uri, path, buf, self._currentScanCompiled)
        else
            error('Unknown mode:' .. tostring(mode))
        end
    end)
end

function mt:buildScanPattern()
    local pattern = {}

    -- config.workspace.ignoreDir
    for path in pairs(config.config.workspace.ignoreDir) do
        pattern[#pattern+1] = path
    end
    -- config.files.exclude
    for path, ignore in pairs(config.other.exclude) do
        if ignore then
            pattern[#pattern+1] = path
        end
    end
    -- config.workspace.ignoreSubmodules
    if config.config.workspace.ignoreSubmodules then
        local buf = io.load(self.root / '.gitmodules')
        if buf then
            for path in buf:gmatch('path = ([^\r\n]+)') do
                log.info('忽略子模块：', path)
                pattern[#pattern+1] = path
            end
        end
    end
    -- config.workspace.useGitIgnore
    if config.config.workspace.useGitIgnore then
        local buf = io.load(self.root / '.gitignore')
        if buf then
            for line in buf:gmatch '[^\r\n]+' do
                pattern[#pattern+1] = line
            end
        end
    end
    -- config.workspace.library
    for path in pairs(config.config.workspace.library) do
        pattern[#pattern+1] = path
    end

    return pattern
end

---@param options table
function mt:buildLibraryRequests(options)
    local requests = {}
    for path, pattern in pairs(config.config.workspace.library) do
        requests[#requests+1] = {
            mode = 'library',
            root = fs.absolute(fs.path(path)):string(),
            pattern = pattern,
            options = options,
        }
    end
    return table.unpack(requests)
end

function mt:scanFiles()
    if self._scanRequest then
        log.info('Break scan.')
        self._scanRequest:push('stop')
        self._scanRequest = nil
        self._complete = false
        self:reset()
    end

    local pattern = self:buildScanPattern()
    local options = {
        ignoreCase = platform.OS == 'Windows',
    }

    self.gitignore = glob.gitignore(pattern, options)
    self._currentScanCompiled = {}
    local count = 0
    self._scanRequest = async.run('scanfiles', {
        {
            mode = 'workspace',
            root = self.root:string(),
            pattern = pattern,
            options = options,
        },
        self:buildLibraryRequests(options),
    }, function (mode, ...)
        if mode == 'ok' then
            log.info('Scan finish, got', count, 'files.')
            self._complete = true
            self._scanRequest = nil
            self:reset()
            return true
        elseif mode == 'log' then
            log.debug(...)
        elseif mode == 'workspace' then
            local path = fs.path(...)
            if not fn.isLuaFile(path) then
                return
            end
            self._loadFileRequest:push(path:string(), 'workspace')
            count = count + 1
        elseif mode == 'library' then
            local path = fs.path(...)
            if not fn.isLuaFile(path) then
                return
            end
            self._loadFileRequest:push(path:string(), 'library')
            count = count + 1
        elseif mode == 'stop' then
            log.info('Scan stoped.')
            return false
        end
    end)
end

function mt:init(rootUri)
    self.root = uric.decode(rootUri)
    self.uri = rootUri
    if not self.root then
        return
    end
    log.info('Workspace inited, root: ', self.root)
    log.info('Workspace inited, uri: ', rootUri)
    local logPath = ROOT / 'log' / (rootUri:gsub('[/:]+', '_') .. '.log')
    log.info('Log path: ', logPath)
    log.init(ROOT, logPath)
end

function mt:isComplete()
    return self._complete == true
end

function mt:addFile(path)
    if not fn.isLuaFile(path) then
        return
    end
    local name = fn.getFileName(path)
    local uri = uric.encode(path)
    self.files[name] = uri
    self.lsp:readText(self, uri, path)
end

function mt:removeFile(path)
    local name = fn.getFileName(path)
    if not self.files[name] then
        return
    end
    self.files[name] = nil
    local uri = uric.encode(path)
    self.lsp:removeText(uri)
end

function mt:findPath(baseUri, searchers)
    local results = {}
    local basePath = uric.decode(baseUri)
    if not basePath then
        return nil
    end
    local baseName = fn.getFileName(basePath)
    for filename, uri in pairs(self.files) do
        if filename ~= baseName then
            for _, searcher in ipairs(searchers) do
                if filename:sub(-#searcher) == searcher then
                    local sep = filename:sub(-#searcher-1, -#searcher-1)
                    if sep == '/' or sep == '\\' then
                        results[#results+1] = uri
                    end
                end
            end
        end
    end

    if #results == 0 then
        return nil
    end
    local uri
    if #results == 1 then
        uri = results[1]
    else
        table.sort(results, function (a, b)
            return fn.similarity(a, baseUri) > fn.similarity(b, baseUri)
        end)
        uri = results[1]
    end
    return uri
end

function mt:createCompiler(str)
    local state = {
        'Main',
    }
    local function push(c)
        if state.Main then
            state.Main = state.Main * c
        else
            state.Main = c
        end
    end
    local count = 0
    local function code()
        count = count + 1
        local name = 'C' .. tostring(count)
        local nextName = 'C' .. tostring(count + 1)
        state[name] = ll.P(1) * (#ll.V(nextName) + ll.V(name))
        return ll.V(name)
    end
    local function static(c)
        count = count + 1
        local name = 'C' .. tostring(count)
        local nextName = 'C' .. tostring(count + 1)
        local catch = #ll.V(nextName)
        if platform.OS == 'Windows' then
            for i = #c, 1, -1 do
                local char = c:sub(i, i)
                local u = char:upper()
                local l = char:lower()
                if u == l then
                    catch = ll.P(char) * catch
                else
                    catch = (ll.P(u) + ll.P(l)) * catch
                end
            end
        else
            catch = ll.P(c) * catch
        end
        state[name] = catch
        return ll.V(name)
    end
    local function eof()
        count = count + 1
        local name = 'C' .. tostring(count)
        state[name] = ll.Cmt(ll.P(1) + ll.Cp(), function (_, _, c)
            return type(c) == 'number'
        end)
        return ll.V(name)
    end
    local isFirstCode = true
    local firstCode
    local compiler = ll.P {
        'Result',
        Result = (ll.V'Code' + ll.V'Static')^1,
        Code   = ll.P'?' / function ()
            if isFirstCode then
                isFirstCode = false
                push(ll.Cmt(ll.C(code()), function (_, pos, code)
                    firstCode = code
                    return pos, code
                end))
            else
                push(ll.Cmt(
                    ll.C(code()),
                    function (_, _, me)
                        return firstCode == me
                    end
                ))
            end
        end,
        Static = (1 - ll.P'?')^1 / function (c)
            push(static(c))
        end,
    }
    compiler:match(str)
    push(eof())
    return ll.P(state)
end

function mt:compileLuaPath()
    for i, luapath in ipairs(config.config.runtime.path) do
        self.pathMatcher[i] = self:createCompiler(luapath)
    end
end

function mt:convertPathAsRequire(filename, start)
    local list
    for _, matcher in ipairs(self.pathMatcher) do
        local str = matcher:match(filename:sub(start))
        if str then
            if not list then
                list = {}
            end
            list[#list+1] = str:gsub('/', '.')
        end
    end
    return list
end

--- @param baseUri uri
--- @param input string
function mt:matchPath(baseUri, input)
    local first = input:match '^[^%.]+'
    if not first then
        return nil
    end
    first = first:gsub('%W', '%%%1')
    local basePath = uric.decode(baseUri)
    if not basePath then
        return nil
    end
    local baseName = fn.getFileName(basePath)
    local rootLen = #self.root:string(basePath)
    local map = {}
    for filename in pairs(self.files) do
        if filename ~= baseName then
            local trueFilename = fn.getTrueName(filename)
            local start
            if platform.OS == 'Windows' then
                start = filename:find('[/\\]' .. first:lower(), rootLen + 1)
            else
                start = trueFilename:find('[/\\]' .. first, rootLen + 1)
            end
            if start then
                local list = self:convertPathAsRequire(trueFilename, start + 1)
                if list then
                    for _, str in ipairs(list) do
                        if #str >= #input and fn.fileNameEq(str:sub(1, #input), input) then
                            if not map[str] then
                                map[str] = trueFilename
                            else
                                local s1 = fn.similarity(trueFilename, baseName)
                                local s2 = fn.similarity(map[str], baseName)
                                if s1 > s2 then
                                    map[str] = trueFilename
                                elseif s1 == s2 then
                                    if trueFilename < map[str] then
                                        map[str] = trueFilename
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    local list = {}
    for str in pairs(map) do
        list[#list+1] = str
        map[str] = map[str]:sub(rootLen + 2)
    end
    if #list == 0 then
        return nil
    end
    table.sort(list, function (a, b)
        local sa = fn.similarity(map[a], baseName)
        local sb = fn.similarity(map[b], baseName)
        if sa == sb then
            return a < b
        else
            return sa > sb
        end
    end)
    return list, map
end

function mt:searchPath(baseUri, str)
    str = fn.getFileName(fs.path(str))
    if self.searched[baseUri] and self.searched[baseUri][str] then
        return self.searched[baseUri][str]
    end
    str = str:gsub('%.', '/')
             :gsub('%%', '%%%%')
    local searchers = {}
    for i, luapath in ipairs(config.config.runtime.path) do
        searchers[i] = luapath:gsub('%?', str)
    end

    local uri = self:findPath(baseUri, searchers)
    if uri then
        if not self.searched[baseUri] then
            self.searched[baseUri] = {}
        end
        self.searched[baseUri][str] = uri
    end
    return uri
end

function mt:loadPath(baseUri, str)
    local ok, relative = pcall(fs.relative, fs.absolute(self.root / str), self.root)
    if not ok then
        return nil
    end
    str = fn.getFileName(relative)
    if self.loaded[str] then
        return self.loaded[str]
    end

    local searchers = { str }

    local uri = self:findPath(baseUri, searchers)
    if uri then
        self.loaded[str] = uri
    end
    return uri
end

function mt:reset()
    self.searched = {}
    self.loaded = {}
    self.lsp:reCompile()
end

---@param uri uri
---@return path
function mt:relativePathByUri(uri)
    local path = uric.decode(uri)
    if not path then
        return nil
    end
    local relate = fs.relative(path, self.root)
    return relate
end

---@param uri uri
---@return path
function mt:absolutePathByUri(uri)
    local path = uric.decode(uri)
    if not path then
        return nil
    end
    return fs.absolute(path)
end

--- @param lsp LSP
--- @param name string
--- @return Workspace
return function (lsp, name)
    local workspace = setmetatable({
        lsp = lsp,
        name = name,
        files = {},
        searched = {},
        loaded = {},
        pathMatcher = {}
    }, mt)
    workspace:compileLuaPath()
    workspace:listenLoadFile()
    return workspace
end
