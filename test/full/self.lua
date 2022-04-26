local files  = require 'files'
local fsu    = require 'fs-utility'
local furi   = require 'file-uri'
local diag   = require 'provider.diagnostic'
local config = require 'config'
local ws     = require 'workspace'
local guide  = require 'parser.guide'
local vm     = require 'vm'
local util   = require 'utility'

local path = ROOT / 'script'

local uris = {}

files.reset()
fsu.scanDirectory(path, function (path)
    if path:extension():string() ~= '.lua' then
        return
    end
    local uri  = furi.encode(path:string())
    local text = fsu.loadFile(path)
    files.setText(uri, text)
    files.open(uri)
    uris[#uris+1] = uri
end)

local _ <close> = function ()
    for _, uri in ipairs(uris) do
        files.remove(uri)
    end
end

print('基准诊断目录：', path)

ws.ready = true
diag.diagnosticsScope(furi.encode(path:string()))

local clock = os.clock()

---@diagnostic disable: await-in-sync
for uri in files.eachFile() do
    local status = files.getState(uri)
    guide.eachSource(status.ast, function (src)
        assert(src.parent ~= nil or src.type == 'main')
    end)
    local fileClock = os.clock()
    diag.doDiagnostic(uri, true)
    print('诊断文件耗时：', os.clock() - fileClock, uri)
end

local passed = os.clock() - clock
print('基准全量诊断用时：', passed)

vm.clearNodeCache()

local compileDatas = {}

for uri in files.eachFile() do
    local state = files.getState(uri)
    local clock = os.clock()
    guide.eachSource(state.ast, function (src)
        vm.compileNode(src)
    end)
    compileDatas[uri] = {
        passed = os.clock() - clock,
        uri    = uri,
    }
end

local printTexts = {}
for uri, data in util.sortPairs(compileDatas, function (a, b)
    return compileDatas[a].passed > compileDatas[b].passed
end) do
    printTexts[#printTexts+1] = ('全量编译耗时：%05.3f [%s]'):format(data.passed, uri)
    if #printTexts >= 10 then
        break
    end
end

util.revertTable(printTexts)

for _, text in ipairs(printTexts) do
    print(text)
end

local passed = os.clock() - clock
print('基准全量编译用时：', passed)
