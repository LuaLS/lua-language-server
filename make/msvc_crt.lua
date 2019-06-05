require 'bee'
local sp = require 'bee.subprocess'
local fs = require 'bee.filesystem'
local registry = require 'bee.registry'

local vswhere = fs.path(os.getenv('ProgramFiles(x86)')) / 'Microsoft Visual Studio' / 'Installer' / 'vswhere.exe'

local function strtrim(str)
    return str:gsub("^%s*(.-)%s*$", "%1")
end

local InstallDir = (function ()
    local process = assert(sp.spawn {
        vswhere,
        '-latest',
        '-products', '*',
        '-requires', 'Microsoft.VisualStudio.Component.VC.Tools.x86.x64',
        '-property', 'installationPath',
        stdout = true,
    })
    local result = strtrim(process.stdout:read 'a')
    process.stdout:close()
    process:wait()
    assert(result ~= "", "can't find msvc.")
    return fs.path(result)
end)()

local RedistVersion = (function ()
    local verfile = InstallDir / 'VC' / 'Auxiliary' / 'Build' / 'Microsoft.VCRedistVersion.default.txt'
    local f = assert(io.open(verfile:string(), 'r'))
    local r = f:read 'a'
    f:close()
    return strtrim(r)
end)()

local function crtpath(platform)
    return InstallDir / 'VC' / 'Redist' / 'MSVC' / RedistVersion / platform / 'Microsoft.VC142.CRT'
end

local function sdkpath()
    local reg = registry.open [[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows Kits\Installed Roots]]
    return fs.path(reg.KitsRoot10)
end

local function ucrtpath(platform)
    return sdkpath() / 'Redist' / 'ucrt' / 'DLLs' / platform
end

return function (platform, target)
    fs.create_directories(target)
    fs.copy_file(crtpath(platform) / 'msvcp140.dll', target / 'msvcp140.dll', true)
    fs.copy_file(crtpath(platform) / 'vcruntime140.dll', target / 'vcruntime140.dll', true)
    for dll in ucrtpath(platform):list_directory() do
        fs.copy_file(dll, target / dll:filename(), true)
    end
end
