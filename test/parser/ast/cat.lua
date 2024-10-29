local function TEST(code)
    return function (expect)
        local ast = New 'LuaParser.Ast' (code)
        local node = ast:parseMain()
        assert(node)
        Match(node, expect)
    end
end

TEST [[
---@class A
---@field a string
---@field b 1
]]
{
    childs = {
        [1] = {
            kind  = 'cat',
            value = {
                kind = 'catclass',
                classID = {
                    kind = 'catid',
                    id   = 'A',
                },
            }
        },
        [2] = {
            kind  = 'cat',
            value = {
                kind = 'catfield',
                key  = {
                    kind = 'catfieldname',
                    id   = 'a',
                },
                value = {
                    kind = 'catid',
                    id   = 'string',
                }
            }
        },
        [3] = {
            kind  = 'cat',
            value = {
                kind = 'catfield',
                key  = {
                    kind = 'catfieldname',
                    id   = 'b',
                },
                value = {
                    kind  = 'catinteger',
                    value = 1,
                }
            }
        }
    }
}
