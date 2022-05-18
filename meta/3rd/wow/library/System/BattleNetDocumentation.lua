---@meta
C_BattleNet = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BattleNet.GetAccountInfoByGUID)
---@param guid string
---@return BNetAccountInfo? accountInfo
function C_BattleNet.GetAccountInfoByGUID(guid) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BattleNet.GetAccountInfoByID)
---@param id number
---@param wowAccountGUID? string
---@return BNetAccountInfo? accountInfo
function C_BattleNet.GetAccountInfoByID(id, wowAccountGUID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BattleNet.GetFriendAccountInfo)
---@param friendIndex number
---@param wowAccountGUID? string
---@return BNetAccountInfo? accountInfo
function C_BattleNet.GetFriendAccountInfo(friendIndex, wowAccountGUID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BattleNet.GetFriendGameAccountInfo)
---@param friendIndex number
---@param accountIndex number
---@return BNetGameAccountInfo? gameAccountInfo
function C_BattleNet.GetFriendGameAccountInfo(friendIndex, accountIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BattleNet.GetFriendNumGameAccounts)
---@param friendIndex number
---@return number numGameAccounts
function C_BattleNet.GetFriendNumGameAccounts(friendIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BattleNet.GetGameAccountInfoByGUID)
---@param guid string
---@return BNetGameAccountInfo? gameAccountInfo
function C_BattleNet.GetGameAccountInfoByGUID(guid) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_BattleNet.GetGameAccountInfoByID)
---@param id number
---@return BNetGameAccountInfo? gameAccountInfo
function C_BattleNet.GetGameAccountInfoByID(id) end

---@class BNetAccountInfo
---@field bnetAccountID number
---@field accountName string
---@field battleTag string
---@field isFriend boolean
---@field isBattleTagFriend boolean
---@field lastOnlineTime number
---@field isAFK boolean
---@field isDND boolean
---@field isFavorite boolean
---@field appearOffline boolean
---@field customMessage string
---@field customMessageTime number
---@field note string
---@field rafLinkType RafLinkType
---@field gameAccountInfo BNetGameAccountInfo

---@class BNetGameAccountInfo
---@field gameAccountID number|nil
---@field clientProgram string
---@field isOnline boolean
---@field isGameBusy boolean
---@field isGameAFK boolean
---@field wowProjectID number|nil
---@field characterName string|nil
---@field realmName string|nil
---@field realmDisplayName string|nil
---@field realmID number|nil
---@field factionName string|nil
---@field raceName string|nil
---@field className string|nil
---@field areaName string|nil
---@field characterLevel number|nil
---@field richPresence string|nil
---@field playerGuid string|nil
---@field isWowMobile boolean
---@field canSummon boolean
---@field hasFocus boolean
---@field regionID number
---@field isInCurrentRegion boolean
