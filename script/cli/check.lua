local lang       = require 'language'
local platform   = require 'bee.platform'
local subprocess = require 'bee.subprocess'
local json       = require 'json'
local jsonb      = require 'json-beautify'
local util       = require 'utility'


local numThreads = tonumber(NUM_THREADS or 1)

local exe
local minIndex = -1
while arg[minIndex] do
    exe = arg[minIndex]
    minIndex = minIndex - 1
end
-- TODO: is this necessary? got it from the shell.lua helper in bee.lua tests
if platform.os == 'windows' and not exe:match('%.[eE][xX][eE]$') then
    exe = exe..'.exe'
end

local function logFileForThread(threadId)
    return LOGPATH .. '/check-partial-' .. threadId .. '.json'
end

local function buildArgs(threadId)
    local args = {exe}
    local skipNext = false
    for i = 1, #arg do
        local arg = arg[i]
        -- --check needs to be transformed into --check_worker
        if arg:lower():match('^%-%-check$') or arg:lower():match('^%-%-check=') then
            args[#args + 1] = arg:gsub('%-%-%w*', '--check_worker')
        -- --check_out_path needs to be removed if we have more than one thread
        elseif arg:lower():match('%-%-check_out_path') and numThreads > 1 then
            if not arg:match('%-%-%w*=') then
                skipNext = true
            end
        else
            if skipNext then
                skipNext = false
            else
                args[#args + 1] = arg
            end
        end
    end
    args[#args + 1] = '--thread_id'
    args[#args + 1] = tostring(threadId)
    if numThreads > 1 then
        args[#args + 1] = '--quiet'
        args[#args + 1] = '--check_out_path'
        args[#args + 1] = logFileForThread(threadId)
    end
    return args
end

if numThreads > 1 then
    print(lang.script('CLI_CHECK_MULTIPLE_WORKERS', numThreads))
end

local procs = {}
for i = 1, numThreads do
    local process, err = subprocess.spawn({buildArgs(i)})
    if err then
        print(err)
    end
    if process then
        procs[#procs + 1] = process
    end
end

for _, process in ipairs(procs) do
    process:wait()
end

local outpath = CHECK_OUT_PATH
if outpath == nil then
    outpath = LOGPATH .. '/check.json'
end

if numThreads > 1 then
    local mergedResults = {}
    local count = 0
    for i = 1, numThreads do
        local result = json.decode(util.loadFile(logFileForThread(i)) or '[]')
        for k, v in pairs(result) do
            local entries = mergedResults[k] or {}
            mergedResults[k] = entries
            for _, entry in ipairs(v) do
                entries[#entries + 1] = entry
                count = count + 1
            end
        end
    end
    util.saveFile(outpath, jsonb.beautify(mergedResults))
    if count == 0 then
        print(lang.script('CLI_CHECK_SUCCESS'))
    else
        print(lang.script('CLI_CHECK_RESULTS', count, outpath))
    end
end
