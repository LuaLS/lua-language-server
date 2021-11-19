local fw    = require 'bee.filewatch'
local fs    = require 'bee.filesystem'
local await = require 'await'

local MODIFY = 1 << 0
local RENAME = 1 << 1

local function exists(filename)
    local path = fs.path(filename)
    local suc, res = pcall(fs.exists, path)
    if not suc or not res then
        return false
    end
    suc, res = pcall(fs.canonical, path)
    if not suc or res:string() ~= path:string() then
        return false
    end
    return true
end

---@class filewatch
local m = {}

m._eventList = {}

function m.watch(path)
    local id = fw.add(path)
    return function ()
        fw.remove(id)
    end
end

---@param callback async fun()
function m.event(callback)
    m._eventList[#m._eventList+1] = callback
end

function m._callEvent(changes)
    for _, callback in ipairs(m._eventList) do
        await.call(function ()
            callback(changes)
        end)
    end
end

function m.update()
    local collect
    for _ = 1, 100 do
        local ev, path = fw.select()
        if not ev then
            break
        end
        if not collect then
            collect = {}
        end
        if ev == 'modify' then
            collect[path] = (collect[path] or 0) | MODIFY
        elseif ev == 'rename' then
            collect[path] = (collect[path] or 0) | RENAME
        end
    end

    if not collect or not next(collect) then
        return
    end

    local changes = {}
    for path, flag in pairs(collect) do
        if flag & RENAME ~= 0 then
            if exists(path) then
                changes[#changes+1] = {
                    type = 'create',
                    path = path,
                }
            else
                changes[#changes+1] = {
                    type = 'delete',
                    path = path,
                }
            end
        elseif flag & MODIFY ~= 0 then
            changes[#changes+1] = {
                type = 'change',
                path = path,
            }
        end
    end

    m._callEvent(changes)
end

return m
