local fs     = require 'bee.filesystem'
local fsu    = require 'fs-utility'
local json   = require 'json'
local proto  = require 'proto'
local lang   = require 'language'
local config = require 'config.Lua'

local function errorMessage(msg)
    proto.notify('window/showMessage', {
        type = 3,
        message = msg,
    })
end

local m = {}

function m.loadLocalConfig(filename)
    local path = fs.path(filename)
    local ext  = path:extension():string():lower()
    local buf  = fsu.loadFile(path)
    if not buf then
        errorMessage(lang.script('无法读取设置文件：{}', filename))
        return
    end
    if ext == '.json' then
        local suc, res = pcall(json.decode, buf)
        if not suc then
            errorMessage(lang.script('设置文件加载错误：{}', res))
            return
        end
        return res
    elseif ext == '.lua' then
        local suc, res = pcall(function ()
            assert(load(buf, '@' .. filename, 't'))()
        end)
        if not suc then
            errorMessage(lang.script('设置文件加载错误：{}', res))
            return
        end
        return res
    else
        errorMessage(lang.script('设置文件必须是lua或json格式：{}', filename))
        return
    end
end

return m
