---@meta _

---@class Range
---@field [1] integer # start offset
---@field [2] integer # end offset

---@class Location
---@field uri Uri
---@field range Range
---@field originRange? Range
---@field selectRange? Range # 必须在 `range` 内部

--- 内部（provider 侧）文本编辑，使用字节偏移而非 LSP Range
---@class TextEdit
---@field start  integer  # 替换起始字节偏移（0-based）
---@field finish integer  # 替换结束字节偏移（0-based，exclusive）
---@field newText string  # 替换后的文本

--- 内部（provider 侧）补全项；textEdit / additionalTextEdits 使用字节偏移
--- capability 层在返回给客户端前将其转换为带正确编码的 LSP.Range
---@class CompletionItem : LSP.CompletionItem
---@field textEdit? TextEdit
---@field additionalTextEdits? TextEdit[]
