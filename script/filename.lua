local platform = require 'bee.platform'
local config = require 'config'
local m = {}

local TrueName = {}

function m.getFileName(path)
    local name = path:string()
    if platform.OS == 'Windows' then
        local lname = name:lower()
        TrueName[lname] = name
        return lname
    else
        return name
    end
end

function m.getTrueName(name)
    return TrueName[name] or name
end

local function split(str, sep)
    local t = {}
    for s in str:gmatch('[^' .. sep .. ']+') do
        t[#t+1] = s
    end
    return t
end

function m.similarity(a, b)
    local ta = split(a, '/\\')
    local tb = split(b, '/\\')
    for i = 1, #ta do
        if ta[i] ~= tb[i] then
            return i - 1
        end
    end
    return #ta
end

function m.isLuaFile(path)
    local pathStr = path:string()
    for k, v in pairs(config.other.associations) do
        if v == 'lua' then
            k = k:gsub('^%*', '')
            if m.fileNameEq(pathStr:sub(-#k), k) then
                return true
            end
        end
    end
    if m.fileNameEq(pathStr:sub(-4), '.lua') then
        return true
    end
    return false
end

function m.fileNameEq(a, b)
    if platform.OS == 'Windows' then
        return a:lower() == b:lower()
    else
        return a == b
    end
end

return m
