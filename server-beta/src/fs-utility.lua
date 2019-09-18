local fs           = require 'bee.filesystem'
local platform     = require 'bee.platform'

local type         = type
local ioOpen       = io.open
local pcall        = pcall
local pairs        = pairs
local setmetatable = setmetatable
local next         = next

_ENV = nil

local m = {}
--- 读取文件
---@param path string
function m.loadFile(path)
    if type(path) ~= 'string' then
        path = path:string()
    end
    local f, e = ioOpen(path, 'rb')
    if not f then
        return nil, e
    end
    if f:read(3) ~= '\xEF\xBB\xBF' then
        f:seek("set")
    end
    local buf = f:read 'a'
    f:close()
    return buf
end

--- 写入文件
---@param path string
---@param content string
function m.saveFile(path, content)
    if type(path) ~= 'string' then
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

local function buildOptional(optional)
    optional     = optional     or {}
    optional.add = optional.add or {}
    optional.del = optional.del or {}
    optional.mod = optional.mod or {}
    optional.err = optional.err or {}
    return optional
end

local function fsAbsolute(path, optional)
    if type(path) == 'string' then
        local suc, res = pcall(fs.path, path)
        if not suc then
            optional.err[#optional.err+1] = res
            return nil
        end
        path = res
    end
    local suc, res = pcall(fs.absolute, path)
    if not suc then
        optional.err[#optional.err+1] = res
        return nil
    end
    return res
end

local function fsIsDirectory(path, optional)
    local suc, res = pcall(fs.is_directory, path)
    if not suc then
        optional.err[#optional.err+1] = res
        return false
    end
    return res
end

local function fsRemove(path, optional)
    local suc, res = pcall(fs.remove, path)
    if not suc then
        optional.err[#optional.err+1] = res
    end
    optional.del[#optional.del+1] = path:string()
end

local function fsExists(path, optional)
    local suc, res = pcall(fs.exists, path)
    if not suc then
        optional.err[#optional.err+1] = res
        return false
    end
    return res
end

local function fsCopy(source, target, optional)
    local suc, res = pcall(fs.copy_file, source, target, true)
    if not suc then
        optional.err[#optional.err+1] = res
        return false
    end
    return true
end

local function fsCreateDirectories(path, optional)
    local suc, res = pcall(fs.create_directories, path)
    if not suc then
        optional.err[#optional.err+1] = res
        return false
    end
    return true
end

local function fileRemove(path, optional)
    if optional.onRemove and optional.onRemove(path) == false then
        return
    end
    if fsIsDirectory(path, optional) then
        for child in path:list_directory() do
            fileRemove(child, optional)
        end
    end
    if fsRemove(path, optional) then
        optional.del[#optional.del+1] = path:string()
    end
end

local function fileCopy(source, target, optional)
    local isDir1   = fsIsDirectory(source, optional)
    local isDir2   = fsIsDirectory(target, optional)
    local isExists = fsExists(target, optional)
    if isDir1 then
        if isDir2 or fsCreateDirectories(target) then
            for filePath in source:list_directory() do
                local name = filePath:filename()
                fileCopy(filePath, target / name, optional)
            end
        end
    else
        if isExists and not isDir2 then
            local buf1, err1 = m.loadFile(source)
            local buf2, err2 = m.loadFile(target)
            if buf1 and buf2 then
                if buf1 ~= buf2 then
                    if fsCopy(source, target, optional) then
                        optional.mod[#optional.mod+1] = target:string()
                    end
                end
            else
                if not buf1 then
                    optional.err[#optional.err+1] = err1
                end
                if not buf2 then
                    optional.err[#optional.err+1] = err2
                end
            end
        else
            if fsCopy(source, target, optional) then
                optional.add[#optional.add+1] = target:string()
            end
        end
    end
end

local function fileSync(source, target, optional)
    local isDir1   = fsIsDirectory(source, optional)
    local isDir2   = fsIsDirectory(target, optional)
    local isExists = fsExists(target, optional)
    if isDir1 then
        if isDir2 then
            local fileList = m.fileList()
            for filePath in target:list_directory() do
                fileList[filePath] = true
            end
            for filePath in source:list_directory() do
                local name = filePath:filename()
                local targetPath = target / name
                fileSync(filePath, targetPath, optional)
                fileList[targetPath] = nil
            end
            for path in pairs(fileList) do
                fileRemove(path, optional)
            end
        else
            if isExists then
                fileRemove(target, optional)
            end
            if fsCreateDirectories(target) then
                for filePath in source:list_directory() do
                    local name = filePath:filename()
                    fileCopy(filePath, target / name, optional)
                end
            end
        end
    else
        if isDir2 then
            fileRemove(target, optional)
        end
        if isExists then
            local buf1, err1 = m.loadFile(source)
            local buf2, err2 = m.loadFile(target)
            if buf1 and buf2 then
                if buf1 ~= buf2 then
                    if fsCopy(source, target, optional) then
                        optional.mod[#optional.mod+1] = target:string()
                    end
                end
            else
                if not buf1 then
                    optional.err[#optional.err+1] = err1
                end
                if not buf2 then
                    optional.err[#optional.err+1] = err2
                end
            end
        else
            if fsCopy(source, target, optional) then
                optional.add[#optional.add+1] = target:string()
            end
        end
    end
end

--- 文件列表
function m.fileList(optional)
    optional = optional or buildOptional(optional)
    local os = platform.OS
    local keyMap = {}
    local fileList = {}
    local function computeKey(path)
        path = fsAbsolute(path, optional)
        if not path then
            return nil
        end
        local key
        if os == 'Windows' then
            key = path:string():lower()
        else
            key = path:string()
        end
        return key
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
function m.fileRemove(path, optional)
    optional = buildOptional(optional)
    path = fsAbsolute(path, optional)

    fileRemove(path, optional)

    return optional
end

--- 复制文件（夹）
---@param source string
---@param target string
---@return table
function m.fileCopy(source, target, optional)
    optional = buildOptional(optional)
    source = fsAbsolute(source, optional)
    target = fsAbsolute(target, optional)

    fileCopy(source, target, optional)

    return optional
end

--- 同步文件（夹）
---@param source string
---@param target string
---@return table
function m.fileSync(source, target, optional)
    optional = buildOptional(optional)
    source = fsAbsolute(source, optional)
    target = fsAbsolute(target, optional)

    fileSync(source, target, optional)

    return optional
end

return m
