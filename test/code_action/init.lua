local core  = require 'core.code-action'
local files = require 'files'
local lang  = require 'language'

rawset(_G, 'TEST', true)

function TEST(script)
    return function (expect)
        files.removeAll()
        local start  = script:find('<?', 1, true)
        local finish = script:find('?>', 1, true)
        local pos = (start + finish) // 2 + 1
        local new_script = script:gsub('<[!?]', '  '):gsub('[!?]>', '  ')
        files.setText('', new_script)
        local results = core('', pos)
        assert(results)
        assert(expect == results)
    end
end

TEST [[
print(<?a?>, b, c)
]]
{
    {
        title = lang.script.ACTION_SWAP_PARAMS,
        kind  = 'refactor.rewrite',
        edit  = {
            change = {
                ['file:///.lua'] = {
                    
                }
            }
        }
    }
}
