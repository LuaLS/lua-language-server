local fw    = require 'bee.filewatch'
local fs    = require 'bee.filesystem'
local await = require 'await'

local MODIFY = 1 << 0
local RENAME = 1 << 1

local function isExists(filename)
    local path = fs.path(filename)
    local suc, exists = pcall(fs.exists, path)
    if not suc or not exists then
        return false
    end
    local suc, res = pcall(fs.canonical, path)
    if not suc or res:string() ~= path:string() then
        return false
    end
    return true
end

---@class filewatch
local m = {}

m._eventList = {}
m._watchings = {}

function m.watch(path)
    if m._watchings[path] then
        m._watchings[path].count = m._watchings[path].count + 1
    else
        m._watchings[path] = {
            count = 1,
            id    = fw.add(path),
        }
        log.debug('fw.add', path)
    end
    local removed
    return function ()
        if removed then
            return
        end
        removed = true
        m._watchings[path].count = m._watchings[path].count - 1
        if m._watchings[path].count == 0 then
            fw.remove(m._watchings[path].id)
            m._watchings[path] = nil
            log.debug('fw.remove', path)
        end
    end
end

---@param callback async fun()
function m.event(callback)
    m._eventList[#m._eventList+1] = callback
end

function m._callEvent(ev, path)
    for _, callback in ipairs(m._eventList) do
        await.call(function ()
            callback(ev, path)
        end)
    end
end

function m.update()
    local collect
    for _ = 1, 10000 do
        local ev, path = fw.select()
        if not ev then
            break
        end
        log.debug('filewatch:', ev, path)
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

    for path, flag in pairs(collect) do
        if flag & RENAME ~= 0 then
            if isExists(path) then
                m._callEvent('create', path)
            else
                m._callEvent('delete', path)
            end
        elseif flag & MODIFY ~= 0 then
            m._callEvent('change', path)
        end
    end

end

return m
