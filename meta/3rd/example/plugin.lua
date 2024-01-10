-- if this file exists, then change setting `Lua.runtime.plugin`
-- see https://luals.github.io/wiki/plugins

function OnSetText(uri, text)
    local diffs = {}

    for start, finish in text:gmatch '()pairs()' do
        diffs[#diffs+1] = {
            start  = start,
            finish = finish - 1,
            text   = 'safepairs'
        }
    end

    return diffs
end
