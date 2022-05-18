---@meta
C_RecruitAFriend = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_RecruitAFriend.ClaimActivityReward)
---@param activityID number
---@param acceptanceID string
---@return boolean success
function C_RecruitAFriend.ClaimActivityReward(activityID, acceptanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_RecruitAFriend.ClaimNextReward)
---@return boolean success
function C_RecruitAFriend.ClaimNextReward() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_RecruitAFriend.GenerateRecruitmentLink)
---@return boolean success
function C_RecruitAFriend.GenerateRecruitmentLink() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_RecruitAFriend.GetRAFInfo)
---@return RafInfo info
function C_RecruitAFriend.GetRAFInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_RecruitAFriend.GetRAFSystemInfo)
---@return RafSystemInfo systemInfo
function C_RecruitAFriend.GetRAFSystemInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_RecruitAFriend.GetRecruitActivityRequirementsText)
---@param activityID number
---@param acceptanceID string
---@return string[] requirementsText
function C_RecruitAFriend.GetRecruitActivityRequirementsText(activityID, acceptanceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_RecruitAFriend.GetRecruitInfo)
---@return boolean active
---@return number faction
function C_RecruitAFriend.GetRecruitInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_RecruitAFriend.IsEnabled)
---@return boolean enabled
function C_RecruitAFriend.IsEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_RecruitAFriend.IsRecruitingEnabled)
---@return boolean enabled
function C_RecruitAFriend.IsRecruitingEnabled() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_RecruitAFriend.RemoveRAFRecruit)
---@param wowAccountGUID string
---@return boolean success
function C_RecruitAFriend.RemoveRAFRecruit(wowAccountGUID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_RecruitAFriend.RequestUpdatedRecruitmentInfo)
---@return boolean success
function C_RecruitAFriend.RequestUpdatedRecruitmentInfo() end

---@class RafAppearanceInfo
---@field appearanceID number

---@class RafAppearanceSetInfo
---@field setID number
---@field setName string
---@field appearanceIDs number[]

---@class RafIllusionInfo
---@field spellItemEnchantmentID number

---@class RafInfo
---@field lifetimeMonths number
---@field spentMonths number
---@field availableMonths number
---@field claimInProgress boolean
---@field rewards RafReward[]
---@field nextReward RafReward|nil
---@field recruitmentInfo RafRecruitmentinfo|nil
---@field recruits RafRecruit[]

---@class RafMountInfo
---@field spellID number
---@field mountID number

---@class RafPetInfo
---@field creatureID number
---@field speciesID number
---@field displayID number
---@field speciesName string
---@field description string

---@class RafRecruit
---@field bnetAccountID number
---@field wowAccountGUID string
---@field battleTag string
---@field monthsRemaining number
---@field subStatus RafRecruitSubStatus
---@field acceptanceID string
---@field activities RafRecruitActivity[]

---@class RafRecruitActivity
---@field activityID number
---@field rewardQuestID number
---@field state RafRecruitActivityState

---@class RafRecruitmentinfo
---@field recruitmentCode string
---@field recruitmentURL string
---@field expireTime number
---@field remainingTimeSeconds number
---@field totalUses number
---@field remainingUses number
---@field sourceRealm string
---@field sourceFaction string

---@class RafReward
---@field rewardID number
---@field itemID number
---@field rewardType RafRewardType
---@field petInfo RafPetInfo|nil
---@field mountInfo RafMountInfo|nil
---@field appearanceInfo RafAppearanceInfo|nil
---@field titleInfo RafTitleInfo|nil
---@field appearanceSetInfo RafAppearanceSetInfo|nil
---@field illusionInfo RafIllusionInfo|nil
---@field canClaim boolean
---@field claimed boolean
---@field repeatable boolean
---@field repeatableClaimCount number
---@field monthsRequired number
---@field monthCost number
---@field availableInMonths number
---@field iconID number

---@class RafSystemInfo
---@field maxRecruits number
---@field maxRecruitMonths number
---@field maxRecruitmentUses number
---@field daysInCycle number

---@class RafTitleInfo
---@field titleMaskID number
