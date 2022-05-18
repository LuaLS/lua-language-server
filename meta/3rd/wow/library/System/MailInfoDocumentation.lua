---@meta
C_Mail = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Mail.CanCheckInbox)
---@return boolean canCheckInbox
---@return number secondsUntilAllowed
function C_Mail.CanCheckInbox() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Mail.HasInboxMoney)
---@param inboxIndex number
---@return boolean inboxItemHasMoneyAttached
function C_Mail.HasInboxMoney(inboxIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Mail.IsCommandPending)
---@return boolean isCommandPending
function C_Mail.IsCommandPending() end
