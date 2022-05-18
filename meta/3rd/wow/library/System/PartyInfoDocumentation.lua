---@meta
C_PartyInfo = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.AllowedToDoPartyConversion)
---@param toRaid boolean
---@return boolean allowed
function C_PartyInfo.AllowedToDoPartyConversion(toRaid) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.CanInvite)
---@return boolean allowedToInvite
function C_PartyInfo.CanInvite() end

---Immediately convert to raid with no regard for potentially destructive actions.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.ConfirmConvertToRaid)
function C_PartyInfo.ConfirmConvertToRaid() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.ConfirmInviteTravelPass)
---@param targetName string
---@param targetGUID string
function C_PartyInfo.ConfirmInviteTravelPass(targetName, targetGUID) end

---Immediately invites the named unit to a party, with no regard for potentially destructive actions.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.ConfirmInviteUnit)
---@param targetName string
function C_PartyInfo.ConfirmInviteUnit(targetName) end

---Immediately leave the party with no regard for potentially destructive actions
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.ConfirmLeaveParty)
---@param category? number
function C_PartyInfo.ConfirmLeaveParty(category) end

---Immediately request an invite into the target party, this is the confirmation function to call after RequestInviteFromUnit, or if you would like to skip the confirmation process.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.ConfirmRequestInviteFromUnit)
---@param targetName string
---@param tank? boolean
---@param healer? boolean
---@param dps? boolean
function C_PartyInfo.ConfirmRequestInviteFromUnit(targetName, tank, healer, dps) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.ConvertToParty)
function C_PartyInfo.ConvertToParty() end

---Usually this will convert to raid immediately. In some cases (e.g. PartySync) the user will be prompted to confirm converting to raid, because it's potentially destructive.
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.ConvertToRaid)
function C_PartyInfo.ConvertToRaid() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.DoCountdown)
---@param seconds number
function C_PartyInfo.DoCountdown(seconds) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.GetActiveCategories)
---@return number[] categories
function C_PartyInfo.GetActiveCategories() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.GetInviteConfirmationInvalidQueues)
---@param inviteGUID string
---@return QueueSpecificInfo[] invalidQueues
function C_PartyInfo.GetInviteConfirmationInvalidQueues(inviteGUID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.GetInviteReferralInfo)
---@param inviteGUID string
---@return string outReferredByGuid
---@return string outReferredByName
---@return PartyRequestJoinRelation outRelationType
---@return boolean outIsQuickJoin
---@return string outClubId
function C_PartyInfo.GetInviteReferralInfo(inviteGUID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.GetMinLevel)
---@param category? number
---@return number minLevel
function C_PartyInfo.GetMinLevel(category) end

---Attempt to invite the named unit to a party, requires confirmation in some cases (e.g. the party will convert to a raid, or if there is a party sync in progress).
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.InviteUnit)
---@param targetName string
function C_PartyInfo.InviteUnit(targetName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.IsPartyFull)
---@param category? number
---@return boolean isFull
function C_PartyInfo.IsPartyFull(category) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.IsPartyInJailersTower)
---@return boolean isPartyInJailersTower
function C_PartyInfo.IsPartyInJailersTower() end

---Usually this will leave the party immediately. In some cases (e.g. PartySync) the user will be prompted to confirm leaving the party, because it's potentially destructive
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.LeaveParty)
---@param category? number
function C_PartyInfo.LeaveParty(category) end

---Attempt to request an invite into the target party, requires confirmation in some cases (e.g. there is a party sync in progress).
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_PartyInfo.RequestInviteFromUnit)
---@param targetName string
---@param tank? boolean
---@param healer? boolean
---@param dps? boolean
function C_PartyInfo.RequestInviteFromUnit(targetName, tank, healer, dps) end
