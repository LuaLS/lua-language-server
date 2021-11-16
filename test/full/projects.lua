local files  = require 'files'
local fsu    = require 'fs-utility'
local furi   = require 'file-uri'
local diag   = require 'provider.diagnostic'
local config = require 'config'
local ws     = require 'workspace'
local fs     = require 'bee.filesystem'

config.set('Lua.workspace.preloadFileSize',    1000000)
config.set('Lua.diagnostics.neededFileStatus', {
    ['await-in-sync'] = 'Any',
    ['not-yieldable'] = 'Any',
})

---@diagnostic disable: await-in-sync
local function doProjects(pathname)
    files.removeAll()

    local path = fs.path(pathname)
    if not fs.exists(path) then
        return
    end

    print('基准诊断目录：', path)
    fsu.scanDirectory(path, function (path)
        if path:extension():string() ~= '.lua' then
            return
        end
        local uri  = furi.encode(path:string())
        local text = fsu.loadFile(path)
        files.setText(uri, text)
        files.open(uri)
    end)

    print('开始诊断...')

    ws.ready = true
    diag.start()

    local clock = os.clock()

    for uri in files.eachFile() do
        local fileClock = os.clock()
        diag.doDiagnostic(uri)
        print('诊断文件耗时：', os.clock() - fileClock, uri)
    end

    local passed = os.clock() - clock
    print('基准全量诊断用时：', passed)
end

--doProjects [[C:\SSSEditor\client\Output\Lua]]
doProjects [[C:\W3-Server\script]]
