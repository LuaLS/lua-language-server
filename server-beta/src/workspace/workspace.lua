local pub  = require 'pub'
local fs   = require 'bee.filesystem'
local furi = require 'file-uri'

local m = {}
m.type = 'workspace'

--- 初始化工作区
function m.init(name, uri)
    m.name = name
    m.uri  = uri
end

--- 预读工作区内所有文件（异步）
function m.preload()
    if not m.uri then
        return
    end
    log.info('Preload start.')
    local function scan(dir, callback)
        local result = pub.task('listDirectory', dir)
        if not result then
            return
        end
        for i = 1, #result.uris do
            local childUri = result.uris[i]
            if result.dirs[childUri] then
                scan(childUri, callback)
            else
                callback(childUri)
            end
        end
    end
    scan(m.uri, function (uri)
        local text = pub.task('loadFile', uri)
        log.debug('Preload file at: ' .. uri, #text)
    end)
    log.info('Preload finish.')
end

return m
