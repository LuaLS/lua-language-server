local class = require 'class'

require 'parser.ast.ast'

---@class LuaParser
local LuaParser = class.get 'LuaParser'

---@alias LuaParser.LuaVersion
---| 'Lua 5.1'
---| 'Lua 5.2'
---| 'Lua 5.3'
---| 'Lua 5.4'

---@alias LuaParser.NonestandardSymbol
---|'//' | '/**/'
---|'`'
---|'+=' | '-=' | '*=' | '/=' | '%=' | '^=' | '//='
---|'|=' | '&=' | '<<=' | '>>='
---|'||' | '&&' | '!' | '!='
---|'continue',

---@class LuaParser.CompileOptions
---@field jit? boolean # 是否为LuaJIT，默认为 false
---@field nonestandardSymbols? LuaParser.NonestandardSymbol[] # 支持的非标准符号
---@field unicodeName? boolean # 是否支持Unicode标识符，默认为 false
---@field envMode? 'auto' | '_ENV' | 'fenv' # 环境模式，默认为 'auto'，会根据版本自动选择

-- 编译lua代码
---@param code string # lua代码
---@param version? LuaParser.LuaVersion # 默认为 '5.4'
---@param options? LuaParser.CompileOptions
---@return LuaParser.Ast
function LuaParser.compile(code, version, options)
    local ast = class.new 'LuaParser.Ast' (code, version, options)
    ast.main = ast:parseMain()

    ---@diagnostic disable-next-line: invisible
    ast:resolveAllGoto()
    ---@diagnostic disable-next-line: invisible
    ast:checkAssignConst()

    return ast
end
