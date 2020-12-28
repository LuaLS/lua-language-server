local files = require 'files'
local fsu   = require 'fs-utility'
local furi  = require 'file-uri'
local diag  = require 'provider.diagnostic'
local config = require 'config'
files.removeAll()

fsu.scanDirectory(ROOT, function (path)
    if path:extension():string() ~= '.lua' then
        return
    end
    local uri  = furi.encode(path:string())
    local text = fsu.loadFile(path)
    files.setText(uri, text)
    files.open(uri)
end)

config.config.diagnostics.disable['undefined-field'] = true
config.config.diagnostics.disable['redundant-parameter'] = true
diag.start()

local clock = os.clock()

for uri in files.eachFile() do
    diag.doDiagnostic(uri)
end

local passed = os.clock() - clock
print('基准全量诊断用时：', passed)
