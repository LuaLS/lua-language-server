---@meta
C_DateAndTime = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_DateAndTime.AdjustTimeByDays)
---@param date CalendarTime
---@param days number
---@return CalendarTime newDate
function C_DateAndTime.AdjustTimeByDays(date, days) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_DateAndTime.AdjustTimeByMinutes)
---@param date CalendarTime
---@param minutes number
---@return CalendarTime newDate
function C_DateAndTime.AdjustTimeByMinutes(date, minutes) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_DateAndTime.CompareCalendarTime)
---@param lhsCalendarTime CalendarTime
---@param rhsCalendarTime CalendarTime
---@return number comparison
function C_DateAndTime.CompareCalendarTime(lhsCalendarTime, rhsCalendarTime) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_DateAndTime.GetCalendarTimeFromEpoch)
---@param epoch number
---@return CalendarTime date
function C_DateAndTime.GetCalendarTimeFromEpoch(epoch) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_DateAndTime.GetCurrentCalendarTime)
---@return CalendarTime date
function C_DateAndTime.GetCurrentCalendarTime() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_DateAndTime.GetSecondsUntilDailyReset)
---@return number seconds
function C_DateAndTime.GetSecondsUntilDailyReset() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_DateAndTime.GetSecondsUntilWeeklyReset)
---@return number seconds
function C_DateAndTime.GetSecondsUntilWeeklyReset() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_DateAndTime.GetServerTimeLocal)
---@return number serverTimeLocal
function C_DateAndTime.GetServerTimeLocal() end
