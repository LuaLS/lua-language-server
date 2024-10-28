local files  = require 'files'
local furi   = require 'file-uri'
local rpath  = require 'workspace.require-path'
local client = require 'client'
local lang   = require 'language'
local guide  = require 'parser.guide'

local function inComment(state, pos)
    for _, comm in ipairs(state.comms) do
        if comm.start <= pos and comm.finish >= pos then
            return true
        end
        if comm.start > pos then
            break
        end
    end
    return false
end

local function findInsertRow(uri)
    local text  = files.getText(uri)
    local state = files.getState(uri)
    if not state or not text then
        return
    end
    local lines = state.lines
    local fmt   = {
        pair = false,
        quot = '"',
        col  = nil,
    }
    local row
    for i = 0, #lines do
        if inComment(state, guide.positionOf(i, 0)) then
            goto CONTINUE
        end
        local ln = lines[i]
        local lnText = text:match('[^\r\n]*', ln)
        if not lnText:find('require', 1, true) then
            if row then
                break
            end
            if  not lnText:match '^local%s'
            and not lnText:match '^%s*$'
            and not lnText:match '^%-%-' then
                break
            end
        else
            row = i + 1
            local lpPos = lnText:find '%('
            if lpPos then
                fmt.pair = true
            else
                fmt.pair = false
            end
            local quot = lnText:match [=[(['"])]=]
            fmt.quot = quot or fmt.quot
            local eqPos = lnText:find '='
            if eqPos then
                fmt.col = eqPos
            end
        end
        ::CONTINUE::
    end
    return row or 0, fmt
end

---@async
local function askAutoRequire(uri, visiblePaths)
    local selects = {}
    local nameMap = {}
    for _, visible in ipairs(visiblePaths) do
        local expect = visible.name
        local select = lang.script(expect)
        if not nameMap[select] then
            nameMap[select] = expect
            selects[#selects+1] = select
        end
    end
    local disable = lang.script.COMPLETION_DISABLE_AUTO_REQUIRE
    selects[#selects+1] = disable

    local result = client.awaitRequestMessage('Info'
        , lang.script.COMPLETION_ASK_AUTO_REQUIRE
        , selects
    )
    if not result then
        return
    end
    if result == disable then
        client.setConfig {
            {
                key    = 'Lua.completion.autoRequire',
                action = 'set',
                value  = false,
                uri    = uri,
            }
        }
        return
    end
    return nameMap[result]
end

local function applyAutoRequire(uri, row, name, result, fmt, fullKeyPath)
    local quotedResult = ('%q'):format(result)
    if fmt.quot == "'" then
        quotedResult = ([['%s']]):format(quotedResult:sub(2, -2)
            :gsub([[']], [[\']])
            :gsub([[\"]], [["]])
        )
    end
    if fmt.pair then
        quotedResult = ('(%s)'):format(quotedResult)
    else
        quotedResult = (' %s'):format(quotedResult)
    end
    local sp = ' '
    local text = ('local %s'):format(name)
    if fmt.col and fmt.col > #text then
        sp = (' '):rep(fmt.col - #text - 1)
    end
    text = ('local %s%s= require%s%s\n'):format(name, sp, quotedResult, fullKeyPath)
    client.editText(uri, {
        {
            start  = guide.positionOf(row, 0),
            finish = guide.positionOf(row, 0),
            text   = text,
        }
    })
end

---@async
return function (data)
    ---@type uri
    local uri    = data.uri
    local target = data.target
    local name   = data.name
    local requireName   = data.requireName
    local state  = files.getState(uri)
    if not state then
        return
    end

    local path = furi.decode(target)
    local visiblePaths = rpath.getVisiblePath(uri, path)
    if not visiblePaths or #visiblePaths == 0 then
        return
    end
    table.sort(visiblePaths, function (a, b)
        return #a.name < #b.name
    end)

    if not requireName then
        requireName = askAutoRequire(uri, visiblePaths)
        if not requireName then
            return
        end
    end

    local offset, fmt = findInsertRow(uri)
    if offset and fmt then
        applyAutoRequire(uri, offset, name, requireName, fmt, data.fullKeyPath or '')
    end
end
