---@meta
C_PlayerChoice = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerChoice.GetCurrentPlayerChoiceInfo)
---@return PlayerChoiceInfo choiceInfo
function C_PlayerChoice.GetCurrentPlayerChoiceInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerChoice.GetNumRerolls)
---@return number numRerolls
function C_PlayerChoice.GetNumRerolls() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerChoice.GetRemainingTime)
---@return number? remainingTime
function C_PlayerChoice.GetRemainingTime() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerChoice.IsWaitingForPlayerChoiceResponse)
---@return boolean isWaitingForResponse
function C_PlayerChoice.IsWaitingForPlayerChoiceResponse() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerChoice.OnUIClosed)
function C_PlayerChoice.OnUIClosed() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerChoice.RequestRerollPlayerChoice)
function C_PlayerChoice.RequestRerollPlayerChoice() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PlayerChoice.SendPlayerChoiceResponse)
---@param responseID number
function C_PlayerChoice.SendPlayerChoiceResponse(responseID) end

---@class PlayerChoiceInfo
---@field objectGUID string
---@field choiceID number
---@field questionText string
---@field pendingChoiceText string
---@field uiTextureKit string
---@field hideWarboardHeader boolean
---@field keepOpenAfterChoice boolean
---@field options PlayerChoiceOptionInfo[]
---@field soundKitID number|nil
---@field closeUISoundKitID number|nil

---@class PlayerChoiceOptionButtonInfo
---@field id number
---@field text string
---@field disabled boolean
---@field confirmation string|nil
---@field tooltip string|nil
---@field rewardQuestID number|nil
---@field soundKitID number|nil

---@class PlayerChoiceOptionInfo
---@field id number
---@field description string
---@field header string
---@field choiceArtID number
---@field desaturatedArt boolean
---@field disabledOption boolean
---@field hasRewards boolean
---@field rewardInfo PlayerChoiceOptionRewardInfo
---@field uiTextureKit string
---@field maxStacks number
---@field buttons PlayerChoiceOptionButtonInfo[]
---@field widgetSetID number|nil
---@field spellID number|nil
---@field rarity PlayerChoiceRarity|nil
---@field rarityColor ColorMixin|nil
---@field typeArtID number|nil
---@field headerIconAtlasElement string|nil
---@field subHeader string|nil

---@class PlayerChoiceOptionRewardInfo
---@field currencyRewards PlayerChoiceRewardCurrencyInfo[]
---@field itemRewards PlayerChoiceRewardItemInfo[]
---@field repRewards PlayerChoiceRewardReputationInfo[]

---@class PlayerChoiceRewardCurrencyInfo
---@field currencyId number
---@field name string
---@field currencyTexture number
---@field quantity number
---@field isCurrencyContainer boolean

---@class PlayerChoiceRewardItemInfo
---@field itemId number
---@field name string
---@field quantity number

---@class PlayerChoiceRewardReputationInfo
---@field factionId number
---@field quantity number
