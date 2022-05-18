---@meta
C_TTSSettings = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.GetChannelEnabled)
---@param channelInfo ChatChannelInfo
---@return boolean enabled
function C_TTSSettings.GetChannelEnabled(channelInfo) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.GetCharacterSettingsSaved)
---@return boolean settingsBeenSaved
function C_TTSSettings.GetCharacterSettingsSaved() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.GetChatTypeEnabled)
---@param chatName string
---@return boolean enabled
function C_TTSSettings.GetChatTypeEnabled(chatName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.GetSetting)
---@param setting TtsBoolSetting
---@return boolean enabled
function C_TTSSettings.GetSetting(setting) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.GetSpeechRate)
---@return number rate
function C_TTSSettings.GetSpeechRate() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.GetSpeechVolume)
---@return number volume
function C_TTSSettings.GetSpeechVolume() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.GetVoiceOptionID)
---@param voiceType TtsVoiceType
---@return number voiceID
function C_TTSSettings.GetVoiceOptionID(voiceType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.GetVoiceOptionName)
---@param voiceType TtsVoiceType
---@return string voiceName
function C_TTSSettings.GetVoiceOptionName(voiceType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.MarkCharacterSettingsSaved)
function C_TTSSettings.MarkCharacterSettingsSaved() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.SetChannelEnabled)
---@param channelInfo ChatChannelInfo
---@param newVal boolean
function C_TTSSettings.SetChannelEnabled(channelInfo, newVal) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.SetChannelKeyEnabled)
---@param channelKey string
---@param newVal boolean
function C_TTSSettings.SetChannelKeyEnabled(channelKey, newVal) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.SetChatTypeEnabled)
---@param chatName string
---@param newVal boolean
function C_TTSSettings.SetChatTypeEnabled(chatName, newVal) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.SetDefaultSettings)
function C_TTSSettings.SetDefaultSettings() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.SetSetting)
---@param setting TtsBoolSetting
---@param newVal boolean
function C_TTSSettings.SetSetting(setting, newVal) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.SetSpeechRate)
---@param newVal number
function C_TTSSettings.SetSpeechRate(newVal) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.SetSpeechVolume)
---@param newVal number
function C_TTSSettings.SetSpeechVolume(newVal) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.SetVoiceOption)
---@param voiceType TtsVoiceType
---@param voiceID number
function C_TTSSettings.SetVoiceOption(voiceType, voiceID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.SetVoiceOptionName)
---@param voiceType TtsVoiceType
---@param voiceName string
function C_TTSSettings.SetVoiceOptionName(voiceType, voiceName) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TTSSettings.ShouldOverrideMessage)
---@param language number
---@return boolean overrideMessage
function C_TTSSettings.ShouldOverrideMessage(language) end
