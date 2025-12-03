local fs           = require 'bee.filesystem'

local type         = type
local ioOpen       = io.open
local pcall        = pcall
local pairs        = pairs
local setmetatable = setmetatable
local next         = next
local ipairs       = ipairs
local tostring     = tostring
local tableSort    = table.sort

_ENV = nil

---@alias fsu.path string|bee.fspath|fsu.dummyfs

---@class fsu
local m = {}
--- 读取文件
---@param path fsu.path
---@param keepBom? boolean
---@return string?
---@return string?
function m.loadFile(path, keepBom)
    if type(path) ~= 'string' then
        ---@diagnostic disable-next-line: undefined-field
        path = path:string()
    end
    local f, e = ioOpen(path, 'rb')
    if not f then
        return nil, e
    end
    local text = f:read 'a'
    f:close()
    if not keepBom then
        if text:sub(1, 3) == '\xEF\xBB\xBF' then
            return text:sub(4)
        end
        if text:sub(1, 2) == '\xFF\xFE'
        or text:sub(1, 2) == '\xFE\xFF' then
            return text:sub(3)
        end
    end
    return text
end

--- 写入文件
---@param path fsu.path
---@param content string
---@return boolean
---@return string?
function m.saveFile(path, content)
    if type(path) ~= 'string' then
        ---@diagnostic disable-next-line: undefined-field
        path = path:string()
    end
    local f, e = ioOpen(path, "wb")

    if f then
        f:write(content)
        f:close()
        return true
    else
        return false, e
    end
end

---@param path bee.fspath
---@param base bee.fspath
---@return bee.fspath?
function m.relative(path, base)
    local sPath = fs.absolute(path):string()
    local sBase = fs.absolute(base):string()
    --TODO 先只支持最简单的情况
    if  sPath:sub(1, #sBase) == sBase
    and sPath:sub(#sBase + 1, #sBase + 1):match '^[/\\]' then
        return fs.path(sPath:sub(#sBase + 1):gsub('^[/\\]+', ''))
    end
    return nil
end

---@class fsu.state
---@field add string[]
---@field del string[]
---@field mod string[]
---@field err string[]

local function buildState(state)
    state     = state     or {}
    state.add = state.add or {}
    state.del = state.del or {}
    state.mod = state.mod or {}
    state.err = state.err or {}
    return state
end

local function split(str, sep)
    local t = {}
    local current = 1
    while current <= #str do
        local s, e = str:find(sep, current)
        if not s then
            t[#t+1] = str:sub(current)
            break
        end
        if s > 1 then
            t[#t+1] = str:sub(current, s - 1)
        end
        current = e + 1
    end
    return t
end

---@class fsu.dummyfs
---@operator div(string|bee.fspath|fsu.dummyfs): fsu.dummyfs
---@field files table
local dfs = {}
dfs.__index = dfs
dfs.type = 'dummy'
dfs.path = ''

---@param t { [string]: string }
---@return fsu.dummyfs
function m.dummyFS(t)
    return setmetatable({
        files = t or {},
    }, dfs)
end

function dfs:__tostring()
    return 'dummy:' .. tostring(self.path)
end

function dfs:__div(filename)
    if type(filename) ~= 'string' then
        filename = filename:string()
    end
    local new = m.dummyFS(self.files)
    if self.path:sub(-1):match '[^/\\]' then
        new.path = self.path .. '\\' .. filename
    else
        new.path = self.path .. filename
    end
    return new
end

---@package
function dfs:_open(index)
    local paths = split(self.path, '[/\\]')
    local current = self.files
    if not index then
        index = #paths
    elseif index < 0 then
        index = #paths + index + 1
    end
    for i = 1, index do
        local path = paths[i]
        if current[path] then
            current = current[path]
        else
            return nil
        end
    end
    return current
end

---@package
function dfs:_filename()
    return self.path:match '[^/\\]+$'
end

function dfs:parent_path()
    local new = m.dummyFS(self.files)
    if self.path:find('[/\\]') then
        new.path = self.path:gsub('[/\\]+[^/\\]*$', '')
    else
        new.path = ''
    end
    return new
end

function dfs:filename()
    local new = m.dummyFS(self.files)
    new.path = self:_filename()
    return new
end

function dfs:string()
    return self.path
end

---@return fun(): fsu.dummyfs?
function dfs:listDirectory()
    local dir = self:_open()
    if type(dir) ~= 'table' then
        return function () end
    end
    local keys = {}
    for k in pairs(dir) do
        keys[#keys+1] = k
    end
    tableSort(keys)
    local i = 0
    return function ()
        i = i + 1
        local k = keys[i]
        if not k then
            return nil
        end
        return self / k
    end
end

function dfs:isDirectory()
    local target = self:_open()
    if type(target) == 'table' then
        return true
    end
    return false
end

function dfs:remove()
    local dir = self:_open(-2)
    local filename = self:_filename()
    if not filename then
        return
    end
    dir[filename] = nil
end

function dfs:exists()
    local target = self:_open()
    return target ~= nil
end

---@param path? fsu.path
---@return boolean
function dfs:createDirectories(path)
    if not path then
        return false
    end
    if type(path) ~= 'string' then
        path = path:string()
    end
    local paths = split(path, '[/\\]+')
    local current = self.files
    for i = 1, #paths do
        local sub = paths[i]
        if current[sub] then
            if type(current[sub]) ~= 'table' then
                return false
            end
        else
            current[sub] = {}
        end
        current = current[sub]
    end
    return true
end

function dfs:saveFile(path, text)
    if not path then
        return false, 'no path'
    end
    if type(path) ~= 'string' then
        path = path:string()
    end
    local temp = m.dummyFS(self.files)
    temp.path = path
    local dir = temp:_open(-2)
    if not dir then
        return false, '无法打开:' .. path
    end
    local filename = temp:_filename()
    if not filename then
        return false, '无法打开:' .. path
    end
    if type(dir[filename]) == 'table' then
        return false, '无法打开:' .. path
    end
    dir[filename] = text
    return true
end

---@param path   string|bee.fspath|fsu.dummyfs
---@param state table
---@return bee.fspath|fsu.dummyfs?
local function fsAbsolute(path, state)
    if type(path) == 'string' then
        local suc, res = pcall(fs.path, path)
        if not suc then
            state.err[#state.err+1] = res
            return nil
        end
        path = res
    elseif type(path) == 'table' then
        return path
    end
    local suc, res = pcall(fs.absolute, path)
    if not suc then
        state.err[#state.err+1] = res
        return nil
    end
    return res
end

local function fsIsDirectory(path)
    if not path then
        return false
    end
    if path.type == 'dummy' then
        return path:isDirectory()
    end
    ---@cast path -fsu.dummyfs
    local status = fs.symlink_status(path):type()
    return status == 'directory'
end

---@param path bee.fspath|fsu.dummyfs|nil
---@param state table
---@return fun(): bee.fspath|fsu.dummyfs|nil
local function fsPairs(path, state)
    if not path then
        return function () end
    end
    if path.type == 'dummy' then
        return path:listDirectory()
    end
    local suc, res = pcall(fs.pairs, path)
    if not suc then
        state.err[#state.err+1] = res
        return function () end
    end
    return res
end

local function fsRemove(path, state)
    if not path then
        return false
    end
    if path.type == 'dummy' then
        return path:remove()
    end
    local suc, res = pcall(fs.remove, path)
    if not suc then
        state.err[#state.err+1] = res
    end
    state.del[#state.del+1] = path:string()
end

local function fsExists(path, state)
    if not path then
        return false
    end
    if path.type == 'dummy' then
        return path:exists()
    end
    local suc, res = pcall(fs.exists, path)
    if not suc then
        state.err[#state.err+1] = res
        return false
    end
    return res
end

local function fsSave(path, text, state)
    if not path then
        return false
    end
    if path.type == 'dummy' then
        ---@cast path -bee.fspath
        local dir = path:_open(-2)
        if not dir then
            state.err[#state.err+1] = '无法打开:' .. path:string()
            return false
        end
        local filename = path:_filename()
        if not filename then
            state.err[#state.err+1] = '无法打开:' .. path:string()
            return false
        end
        if type(dir[filename]) == 'table' then
            state.err[#state.err+1] = '无法打开:' .. path:string()
            return false
        end
        dir[filename] = text
    else
        local suc, err = m.saveFile(path, text)
        if suc then
            return true
        end
        state.err[#state.err+1] = err
        return false
    end
end

local function fsLoad(path, state)
    if not path then
        return nil
    end
    if path.type == 'dummy' then
        local text = path:_open()
        if type(text) == 'string' then
            return text
        else
            state.err[#state.err+1] = '无法打开:' .. path:string()
            return nil
        end
    else
        ---@cast path -fsu.dummyfs
        local text, err = m.loadFile(path)
        if text then
            return text
        else
            state.err[#state.err+1] = err
            return nil
        end
    end
end

local function fsCopy(source, target, state)
    if not source or not target then
        return
    end
    if source.type == 'dummy' then
        local sourceText = source:_open()
        if not sourceText then
            state.err[#state.err+1] = '无法打开:' .. source:string()
            return false
        end
        return fsSave(target, sourceText, state)
    else
        ---@cast source -fsu.dummyfs
        if target.type == 'dummy' then
            local sourceText, err = m.loadFile(source)
            if not sourceText then
                state.err[#state.err+1] = err
                return false
            end
            return fsSave(target, sourceText, state)
        else
            local suc, res = pcall(fs.copy_file, source, target, fs.copy_options.overwrite_existing)
            if not suc then
                state.err[#state.err+1] = res
                return false
            end
        end
    end
    return true
end

---@param path fsu.dummyfs|bee.fspath
---@param state fsu.state
---@return boolean
local function fsCreateDirectories(path, state)
    if not path then
        return false
    end
    if path.type == 'dummy' then
        return path:createDirectories()
    end
    local suc, res = pcall(fs.create_directories, path)
    if not suc then
        state.err[#state.err+1] = res --[[@as string]]
        return false
    end
    return true
end

local function fileRemove(path, state)
    if not path then
        return
    end
    if state.onRemove and state.onRemove(path) == false then
        return
    end
    if fsIsDirectory(path) then
        for child in fsPairs(path, state) do
            fileRemove(child, state)
        end
    end
    if fsRemove(path, state) then
        state.del[#state.del+1] = path:string()
    end
end

---@param source bee.fspath|fsu.dummyfs?
---@param target bee.fspath|fsu.dummyfs?
---@param state fsu.state
local function fileCopy(source, target, state)
    if not source or not target then
        return
    end
    local isDir1   = fsIsDirectory(source)
    local isDir2   = fsIsDirectory(target)
    local isExists = fsExists(target, state)
    if isDir1 then
        if isDir2 or fsCreateDirectories(target, state) then
            for filePath in fsPairs(source, state) do
                local name = filePath:filename():string()
                fileCopy(filePath, target / name, state)
            end
        end
    else
        if isExists and not isDir2 then
            local buf1 = fsLoad(source, state)
            local buf2 = fsLoad(target, state)
            if buf1 and buf2 then
                if buf1 ~= buf2 then
                    if fsCopy(source, target, state) then
                        state.mod[#state.mod+1] = target:string()
                    end
                end
            end
        else
            if fsCopy(source, target, state) then
                state.add[#state.add+1] = target:string()
            end
        end
    end
end

---@param source bee.fspath|fsu.dummyfs?
---@param target bee.fspath|fsu.dummyfs?
---@param state fsu.state
local function fileSync(source, target, state)
    if not source or not target then
        return
    end
    local isDir1   = fsIsDirectory(source)
    local isDir2   = fsIsDirectory(target)
    local isExists = fsExists(target, state)
    if isDir1 then
        if isDir2 then
            local fileList = m.fileList()
            if type(target) == 'table' then
                ---@cast target fsu.dummyfs
                for filePath in target:listDirectory() do
                    fileList[filePath] = true
                end
            else
                ---@cast target bee.fspath
                for filePath in fs.pairs(target) do
                    fileList[filePath] = true
                end
            end
            for filePath in fsPairs(source, state) do
                local name = filePath:filename():string()
                local targetPath = target / name
                fileSync(filePath, targetPath, state)
                fileList[targetPath] = nil
            end
            for path in pairs(fileList) do
                fileRemove(path, state)
            end
        else
            if isExists then
                fileRemove(target, state)
            end
            if fsCreateDirectories(target, state) then
                for filePath in fsPairs(source, state) do
                    local name = filePath:filename():string()
                    fileCopy(filePath, target / name, state)
                end
            end
        end
    else
        if isDir2 then
            fileRemove(target, state)
        end
        if isExists then
            local buf1 = fsLoad(source, state)
            local buf2 = fsLoad(target, state)
            if buf1 and buf2 then
                if buf1 ~= buf2 then
                    if fsCopy(source, target, state) then
                        state.mod[#state.mod+1] = target:string()
                    end
                end
            end
        else
            if fsCopy(source, target, state) then
                state.add[#state.add+1] = target:string()
            end
        end
    end
end

--- 文件列表
function m.fileList(state)
    state = state or buildState(state)
    local keyMap = {}
    local fileList = {}
    local function computeKey(path)
        local abpath = fsAbsolute(path, state)
        if not abpath then
            return nil
        end
        return abpath:string()
    end
    return setmetatable({}, {
        __index = function (_, path)
            local key = computeKey(path)
            return fileList[key]
        end,
        __newindex = function (_, path, value)
            local key = computeKey(path)
            if not key then
                return
            end
            if value == nil then
                keyMap[key] = nil
            else
                keyMap[key] = path
                fileList[key] = value
            end
        end,
        __pairs = function ()
            local key, path
            return function ()
                key, path = next(keyMap, key)
                return path, fileList[key]
            end
        end,
    })
end

--- 删除文件（夹）
function m.fileRemove(path, state)
    state = buildState(state)
    path = fsAbsolute(path, state)

    fileRemove(path, state)

    return state
end

--- 复制文件（夹）
---@param source fsu.path
---@param target fsu.path
---@param state? fsu.state
---@return fsu.state
function m.fileCopy(source, target, state)
    state = buildState(state)
    local fsSource = fsAbsolute(source, state)
    local fsTarget = fsAbsolute(target, state)

    fileCopy(fsSource, fsTarget, state)

    return state
end

--- 同步文件（夹）
---@param source fsu.path
---@param target fsu.path
---@param state? fsu.state
---@return fsu.state
function m.fileSync(source, target, state)
    state = buildState(state)
    local fsSource = fsAbsolute(source, state)
    local fsTarget = fsAbsolute(target, state)

    fileSync(fsSource, fsTarget, state)

    return state
end

---@param dir string|bee.fspath
---@param callback fun(fullPath: bee.fspath)
function m.scanDirectory(dir, callback)
    if type(dir) == 'string' then
        dir = fs.path(dir)
    end
    for fullpath in fs.pairs(dir) do
        local status = fs.symlink_status(fullpath):type()
        if status == 'directory' then
            m.scanDirectory(fullpath, callback)
        elseif status == 'regular' then
            callback(fullpath)
        end
    end
end

---@param dir fsu.path
---@return fun(): bee.fspath
function m.listDirectory(dir)
    if dir.type == 'dummy' then
        ---@cast dir fsu.dummyfs
        return dir:listDirectory()
    else
        if type(dir) == 'string' then
            dir = fs.path(dir)
        end
        ---@cast dir bee.fspath
        return fs.pairs(dir)
    end
end

return m
