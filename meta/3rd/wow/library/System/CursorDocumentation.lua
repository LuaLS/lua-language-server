---@meta
C_Cursor = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Cursor.DropCursorCommunitiesStream)
function C_Cursor.DropCursorCommunitiesStream() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Cursor.GetCursorCommunitiesStream)
---@return string clubId
---@return string streamId
function C_Cursor.GetCursorCommunitiesStream() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Cursor.GetCursorItem)
---@return ItemLocationMixin item
function C_Cursor.GetCursorItem() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Cursor.SetCursorCommunitiesStream)
---@param clubId string
---@param streamId string
function C_Cursor.SetCursorCommunitiesStream(clubId, streamId) end
