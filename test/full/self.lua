local files  = require 'files'
local fsu    = require 'fs-utility'
local furi   = require 'file-uri'
local diag   = require 'provider.diagnostic'
local config = require 'config'
local ws     = require 'workspace'
files.removeAll()

local path = ROOT / 'script'

fsu.scanDirectory(path, function (path)
    if path:extension():string() ~= '.lua' then
        return
    end
    local uri  = furi.encode(path:string())
    local text = fsu.loadFile(path)
    files.setText(uri, text)
    files.open(uri)
end)

print('基准诊断目录：', path)

ws.ready = true
diag.start()

local clock = os.clock()

---@diagnostic disable: await-in-sync
for uri in files.eachFile() do
    local fileClock = os.clock()
    diag.doDiagnostic(uri)
    print('诊断文件耗时：', os.clock() - fileClock, uri)
end

local passed = os.clock() - clock
print('基准全量诊断用时：', passed)
