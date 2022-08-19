local fs          = require 'bee.filesystem'
local linkedTable = require 'linked-table'

local setmt = setmetatable
local pairs = pairs
local iopen = io.open
local mmax  = math.max

_ENV = nil

---@class lazy-cacher
---@field _opening linked-table
---@field _openingMap table<string, file*>
---@field _dir string
local mt = {}
mt.__index = mt
mt.type = 'lazy-cacher'

mt.maxOpendFiles = 50
mt.maxFileSize   = 100 * 1024 * 1024 -- 100MB
mt.openingFiles  = {}

mt.errorHandler = function (err) end

---@param fileID string
function mt:_closeFile(fileID)
    self._opening:pop(fileID)
    self._openingMap[fileID]:close()
    self._openingMap[fileID] = nil
end

---@param fileID string
---@return file*?
---@return string? errorMessage
function mt:_getFile(fileID)
    if self._openingMap[fileID] then
        self._opening:pop(fileID)
        self._opening:pushTail(fileID)
        return self._openingMap[fileID]
    end
    local fullPath = self._dir .. '/' .. fileID
    local file, err = iopen(fullPath, 'a+b')
    if not file then
        return nil, err
    end
    self._opening:pushTail(fileID)
    self._openingMap[fileID] = file
    if self._opening:getSize() > self.maxOpendFiles then
        local oldest = self._opening:getHead()
        self:_closeFile(oldest)
    end
    return file
end

---@param fileID string
---@return fun(id: integer, code: string): boolean
---@return fun(id: integer): string?
function mt:writterAndReader(fileID)
    local maxFileSize = self.maxFileSize
    local map = {}
    ---@param file file*
    local function resize(file)
        local codes = {}
        for id, data in pairs(map) do
            local offset = data // 1000000
            local len    = data %  1000000
            local suc, err = file:seek('set', offset)
            if not suc then
                self.errorHandler(err)
                return
            end
            local code = file:read(len)
            codes[id] = code
        end

        self:_closeFile(fileID)
        local fullPath = self._dir .. '/' .. fileID
        local file, err = iopen(fullPath, 'wb')
        if not file then
            self.errorHandler(err)
            return
        end

        local offset = 0
        for id, code in pairs(codes) do
            file:write(code)
            map[id] = offset * 1000000 + #code
            offset = offset + #code
        end
        file:close()
    end
    ---@param id integer
    ---@param code string
    ---@return boolean
    local function writter(id, code)
        if not code then
            map[id] = nil
            return true
        end
        if #code > 1000000 then
            return false
        end
        local file, err = self:_getFile(fileID)
        if not file then
            self.errorHandler(err)
            return false
        end
        local offset, err = file:seek('end')
        if not offset then
            self.errorHandler(err)
            return false
        end
        if offset > maxFileSize then
            resize(file)
            file, err = self:_getFile(fileID)
            if not file then
                self.errorHandler(err)
                return false
            end
            offset, err = file:seek('end')
            if not offset then
                self.errorHandler(err)
                return false
            end
            maxFileSize = mmax(maxFileSize, (offset + #code) * 2)
        end
        local suc, err = file:write(code)
        if not suc then
            self.errorHandler(err)
            return false
        end
        map[id] = offset * 1000000 + #code
        return true
    end
    ---@param id integer
    ---@return string?
    local function reader(id)
        if not map[id] then
            return nil
        end
        local file, err = self:_getFile(fileID)
        if not file then
            self.errorHandler(err)
            return nil
        end
        local offset = map[id] // 1000000
        local len    = map[id] %  1000000
        local suc, err = file:seek('set', offset)
        if not suc then
            self.errorHandler(err)
            return nil
        end
        local code = file:read(len)
        return code
    end
    return writter, reader
end

---@param dir string
---@param errorHandle? fun(string)
---@return lazy-cacher?
return function (dir, errorHandle)
    fs.create_directories(fs.path(dir))
    local self = setmt({
        _dir         = dir,
        _opening     = linkedTable(),
        _openingMap  = {},
        errorHandler = errorHandle,
    }, mt)
    return self
end
