---@meta
C_Social = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Social.GetLastAchievement)
---@return number achievementID
---@return string achievementName
---@return string achievementDesc
---@return number iconFileID
function C_Social.GetLastAchievement() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Social.GetLastItem)
---@return number itemID
---@return string itemName
---@return number iconFileID
---@return number itemQuality
---@return number itemLevel
---@return string itemLinkString
function C_Social.GetLastItem() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Social.GetLastScreenshotIndex)
---@return number screenShotIndex
function C_Social.GetLastScreenshotIndex() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Social.GetMaxTweetLength)
---@return number maxTweetLength
function C_Social.GetMaxTweetLength() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Social.GetScreenshotInfoByIndex)
---@param index number
---@return number screenWidth
---@return number screenHeight
function C_Social.GetScreenshotInfoByIndex(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Social.GetTweetLength)
---@param tweetText string
---@return number tweetLength
function C_Social.GetTweetLength(tweetText) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Social.IsSocialEnabled)
---@return boolean isEnabled
function C_Social.IsSocialEnabled() end

---Not allowed to be called by addons
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Social.TwitterCheckStatus)
function C_Social.TwitterCheckStatus() end

---Not allowed to be called by addons
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Social.TwitterConnect)
function C_Social.TwitterConnect() end

---Not allowed to be called by addons
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Social.TwitterDisconnect)
function C_Social.TwitterDisconnect() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Social.TwitterGetMSTillCanPost)
---@return number msTimeLeft
function C_Social.TwitterGetMSTillCanPost() end

---Not allowed to be called by addons
---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Social.TwitterPostMessage)
---@param message string
function C_Social.TwitterPostMessage(message) end
