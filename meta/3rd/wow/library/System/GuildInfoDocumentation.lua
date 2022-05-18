---@meta
C_GuildInfo = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GuildInfo.CanEditOfficerNote)
---@return boolean canEditOfficerNote
function C_GuildInfo.CanEditOfficerNote() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GuildInfo.CanSpeakInGuildChat)
---@return boolean canSpeakInGuildChat
function C_GuildInfo.CanSpeakInGuildChat() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GuildInfo.CanViewOfficerNote)
---@return boolean canViewOfficerNote
function C_GuildInfo.CanViewOfficerNote() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GuildInfo.GetGuildNewsInfo)
---@param index number
---@return GuildNewsInfo newsInfo
function C_GuildInfo.GetGuildNewsInfo(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GuildInfo.GetGuildRankOrder)
---@param guid string
---@return number rankOrder
function C_GuildInfo.GetGuildRankOrder(guid) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GuildInfo.GetGuildTabardInfo)
---@param unit? string
---@return GuildTabardInfo? tabardInfo
function C_GuildInfo.GetGuildTabardInfo(unit) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GuildInfo.GuildControlGetRankFlags)
---@param rankOrder number
---@return boolean[] permissions
function C_GuildInfo.GuildControlGetRankFlags(rankOrder) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GuildInfo.GuildRoster)
function C_GuildInfo.GuildRoster() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GuildInfo.IsGuildOfficer)
---@return boolean isOfficer
function C_GuildInfo.IsGuildOfficer() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GuildInfo.IsGuildRankAssignmentAllowed)
---@param guid string
---@param rankOrder number
---@return boolean isGuildRankAssignmentAllowed
function C_GuildInfo.IsGuildRankAssignmentAllowed(guid, rankOrder) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GuildInfo.QueryGuildMemberRecipes)
---@param guildMemberGUID string
---@param skillLineID number
function C_GuildInfo.QueryGuildMemberRecipes(guildMemberGUID, skillLineID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GuildInfo.QueryGuildMembersForRecipe)
---@param skillLineID number
---@param recipeSpellID number
---@param recipeLevel? number
---@return number updatedRecipeSpellID
function C_GuildInfo.QueryGuildMembersForRecipe(skillLineID, recipeSpellID, recipeLevel) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GuildInfo.RemoveFromGuild)
---@param guid string
function C_GuildInfo.RemoveFromGuild(guid) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GuildInfo.SetGuildRankOrder)
---@param guid string
---@param rankOrder number
function C_GuildInfo.SetGuildRankOrder(guid, rankOrder) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_GuildInfo.SetNote)
---@param guid string
---@param note string
---@param isPublic boolean
function C_GuildInfo.SetNote(guid, note, isPublic) end

---@class GuildNewsInfo
---@field isSticky boolean
---@field isHeader boolean
---@field newsType number
---@field whoText string|nil
---@field whatText string|nil
---@field newsDataID number
---@field data number[]
---@field weekday number
---@field day number
---@field month number
---@field year number
---@field guildMembersPresent number
