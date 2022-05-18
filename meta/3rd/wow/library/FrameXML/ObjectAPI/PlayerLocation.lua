---@meta
PlayerLocation = {}

---[Documentation](https://wowpedia.fandom.com/wiki/PlayerLocationMixin)
---@class PlayerLocationMixin
PlayerLocationMixin = {}

---@param guid string
---@return PlayerLocationMixin
function PlayerLocation:CreateFromGUID(guid) end

---@param unit string
---@return PlayerLocationMixin
function PlayerLocation:CreateFromUnit(unit) end

---@param lineID number
---@return PlayerLocationMixin
function PlayerLocation:CreateFromChatLineID(lineID) end

---@param clubID string
---@param streamID string
---@param epoch number
---@param position number
---@return PlayerLocationMixin
function PlayerLocation:CreateFromCommunityChatData(clubID, streamID, epoch, position) end

---@param clubID string
---@param guid string
---@return PlayerLocationMixin
function PlayerLocation:CreateFromCommunityInvitation(clubID, guid) end

---@param battlefieldScoreIndex number
---@return PlayerLocationMixin
function PlayerLocation:CreateFromBattlefieldScoreIndex(battlefieldScoreIndex) end

---@param memberID number
---@param channelID number
---@return PlayerLocationMixin
function PlayerLocation:CreateFromVoiceID(memberID, channelID) end

---@param battleNetID number
---@return PlayerLocationMixin
function PlayerLocation:CreateFromBattleNetID(battleNetID) end

--[[public api]]
---@param guid string
function PlayerLocationMixin:SetGUID(guid) end

---@return boolean
function PlayerLocationMixin:IsValid() end

---@return boolean
function PlayerLocationMixin:IsGUID() end

---@return boolean
function PlayerLocationMixin:IsBattleNetGUID() end

---@return string
function PlayerLocationMixin:GetGUID() end

---@param unit string
function PlayerLocationMixin:SetUnit(unit) end

---@return boolean
function PlayerLocationMixin:IsUnit() end

---@return string
function PlayerLocationMixin:GetUnit() end

---@param lineID number
function PlayerLocationMixin:SetChatLineID(lineID) end

---@return boolean
function PlayerLocationMixin:IsChatLineID() end

---@return number
function PlayerLocationMixin:GetChatLineID() end

---@param index number
function PlayerLocationMixin:SetBattlefieldScoreIndex(index) end

---@return boolean
function PlayerLocationMixin:IsBattlefieldScoreIndex() end

---@return number
function PlayerLocationMixin:GetBattlefieldScoreIndex() end

---@param memberID number
---@param channelID number
function PlayerLocationMixin:SetVoiceID(memberID, channelID) end

---@return boolean
function PlayerLocationMixin:IsVoiceID() end

---@return number voiceMemberID
---@return number voiceChannelID
function PlayerLocationMixin:GetVoiceID() end

---@param battleNetID number
function PlayerLocationMixin:SetBattleNetID(battleNetID) end

---@return boolean
function PlayerLocationMixin:IsBattleNetID() end

---@return number
function PlayerLocationMixin:GetBattleNetID() end

---@param clubID string
---@param streamID string
---@param epoch number
---@param position number
function PlayerLocationMixin:SetCommunityData(clubID, streamID, epoch, position) end

---@return boolean
function PlayerLocationMixin:IsCommunityData() end

---@param clubID string
---@param guid string
function PlayerLocationMixin:SetCommunityInvitation(clubID, guid) end

---@return boolean
function PlayerLocationMixin:IsCommunityInvitation() end

--[[private api]]
function PlayerLocationMixin:Clear() end

---@param fieldName string
---@param field any
function PlayerLocationMixin:ClearAndSetField(fieldName, field) end
