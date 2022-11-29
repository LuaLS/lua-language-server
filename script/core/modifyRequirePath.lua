local files  = require 'files'
local await  = require 'await'
local guide  = require 'parser.guide'
local rpath  = require 'workspace.require-path'
local furi   = require 'file-uri'
local util   = require 'utility'
local client = require 'client'
local lang   = require 'language'

---@alias rename { oldUri: uri, newUri: uri }

---@param changes table[]
---@param uri uri
---@param renames rename[]
local function checkConvert(changes, uri, renames)
    local state = files.getState(uri)
    if not state then
        return
    end

    guide.eachSpecialOf(state.ast, 'require', function (source)
        local call = source.parent
        if call.type ~= 'call' then
            return
        end
        local nameObj = call.args and call.args[1]
        if not nameObj then
            return
        end
        local name = nameObj.type == 'string' and nameObj[1]
        if type(name) ~= 'string' then
            return
        end
        for _, rename in ipairs(renames) do
            if rpath.isMatchedUri(uri, rename.oldUri, name) then
                local visibles = rpath.getVisiblePath(uri, furi.decode(rename.newUri))
                if #visibles > 0 then
                    local newName = visibles[1].name
                    changes[#changes+1] = {
                        uri    = uri,
                        start  = nameObj.start,
                        finish = nameObj.finish,
                        text   = util.viewString(newName, nameObj[2]),
                    }
                    return
                end
            end
        end
    end)
end

---@async
---@param renames rename[]
return function (renames)
    if #renames == 0 then
        return
    end
    local changes = {}
    for uri in files.eachFile() do
        checkConvert(changes, uri, renames)
        await.delay()
    end
    if #changes == 0 then
        return
    end

    local _, index = client.awaitRequestMessage('Info', lang.script.WINDOW_MODIFY_REQUIRE_PATH, {
        lang.script.WINDOW_MODIFY_REQUIRE_OK
    })

    if index == 1 then
        client.editMultiText(changes)
    end
end
