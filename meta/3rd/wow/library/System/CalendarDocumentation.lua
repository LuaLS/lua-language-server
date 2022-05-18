---@meta
C_Calendar = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.AddEvent)
function C_Calendar.AddEvent() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.AreNamesReady)
---@return boolean ready
function C_Calendar.AreNamesReady() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.CanAddEvent)
---@return boolean canAddEvent
function C_Calendar.CanAddEvent() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.CanSendInvite)
---@return boolean canSendInvite
function C_Calendar.CanSendInvite() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.CloseEvent)
function C_Calendar.CloseEvent() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.ContextMenuEventCanComplain)
---@param offsetMonths number
---@param monthDay number
---@param eventIndex number
---@return boolean canComplain
function C_Calendar.ContextMenuEventCanComplain(offsetMonths, monthDay, eventIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.ContextMenuEventCanEdit)
---@param offsetMonths number
---@param monthDay number
---@param eventIndex number
---@return boolean canEdit
function C_Calendar.ContextMenuEventCanEdit(offsetMonths, monthDay, eventIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.ContextMenuEventCanRemove)
---@param offsetMonths number
---@param monthDay number
---@param eventIndex number
---@return boolean canRemove
function C_Calendar.ContextMenuEventCanRemove(offsetMonths, monthDay, eventIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.ContextMenuEventClipboard)
---@return boolean exists
function C_Calendar.ContextMenuEventClipboard() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.ContextMenuEventComplain)
function C_Calendar.ContextMenuEventComplain() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.ContextMenuEventCopy)
function C_Calendar.ContextMenuEventCopy() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.ContextMenuEventGetCalendarType)
---@return string? calendarType
function C_Calendar.ContextMenuEventGetCalendarType() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.ContextMenuEventPaste)
---@param offsetMonths number
---@param monthDay number
function C_Calendar.ContextMenuEventPaste(offsetMonths, monthDay) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.ContextMenuEventRemove)
function C_Calendar.ContextMenuEventRemove() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.ContextMenuEventSignUp)
function C_Calendar.ContextMenuEventSignUp() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.ContextMenuGetEventIndex)
---@return CalendarEventIndexInfo info
function C_Calendar.ContextMenuGetEventIndex() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.ContextMenuInviteAvailable)
function C_Calendar.ContextMenuInviteAvailable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.ContextMenuInviteDecline)
function C_Calendar.ContextMenuInviteDecline() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.ContextMenuInviteRemove)
function C_Calendar.ContextMenuInviteRemove() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.ContextMenuInviteTentative)
function C_Calendar.ContextMenuInviteTentative() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.ContextMenuSelectEvent)
---@param offsetMonths number
---@param monthDay number
---@param eventIndex number
function C_Calendar.ContextMenuSelectEvent(offsetMonths, monthDay, eventIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.CreateCommunitySignUpEvent)
function C_Calendar.CreateCommunitySignUpEvent() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.CreateGuildAnnouncementEvent)
function C_Calendar.CreateGuildAnnouncementEvent() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.CreateGuildSignUpEvent)
function C_Calendar.CreateGuildSignUpEvent() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.CreatePlayerEvent)
function C_Calendar.CreatePlayerEvent() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventAvailable)
function C_Calendar.EventAvailable() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventCanEdit)
---@return boolean canEdit
function C_Calendar.EventCanEdit() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventClearAutoApprove)
function C_Calendar.EventClearAutoApprove() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventClearLocked)
function C_Calendar.EventClearLocked() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventClearModerator)
---@param inviteIndex number
function C_Calendar.EventClearModerator(inviteIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventDecline)
function C_Calendar.EventDecline() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventGetCalendarType)
---@return string? calendarType
function C_Calendar.EventGetCalendarType() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventGetClubId)
---@return string? info
function C_Calendar.EventGetClubId() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventGetInvite)
---@param eventIndex number
---@return CalendarEventInviteInfo info
function C_Calendar.EventGetInvite(eventIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventGetInviteResponseTime)
---@param eventIndex number
---@return CalendarTime time
function C_Calendar.EventGetInviteResponseTime(eventIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventGetInviteSortCriterion)
---@return string criterion
---@return boolean reverse
function C_Calendar.EventGetInviteSortCriterion() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventGetSelectedInvite)
---@return number? inviteIndex
function C_Calendar.EventGetSelectedInvite() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventGetStatusOptions)
---@param eventIndex number
---@return CalendarEventStatusOption[] options
function C_Calendar.EventGetStatusOptions(eventIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventGetTextures)
---@param eventType CalendarEventType
---@return CalendarEventTextureInfo[] textures
function C_Calendar.EventGetTextures(eventType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventGetTypes)
---@return string[] types
function C_Calendar.EventGetTypes() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventGetTypesDisplayOrdered)
---@return CalendarEventTypeDisplayInfo[] infos
function C_Calendar.EventGetTypesDisplayOrdered() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventHasPendingInvite)
---@return boolean hasPendingInvite
function C_Calendar.EventHasPendingInvite() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventHaveSettingsChanged)
---@return boolean haveSettingsChanged
function C_Calendar.EventHaveSettingsChanged() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventInvite)
---@param name string
function C_Calendar.EventInvite(name) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventRemoveInvite)
---@param inviteIndex number
function C_Calendar.EventRemoveInvite(inviteIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventRemoveInviteByGuid)
---@param guid string
function C_Calendar.EventRemoveInviteByGuid(guid) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventSelectInvite)
---@param inviteIndex number
function C_Calendar.EventSelectInvite(inviteIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventSetAutoApprove)
function C_Calendar.EventSetAutoApprove() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventSetClubId)
---@param clubId? string
function C_Calendar.EventSetClubId(clubId) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventSetDate)
---@param month number
---@param monthDay number
---@param year number
function C_Calendar.EventSetDate(month, monthDay, year) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventSetDescription)
---@param description string
function C_Calendar.EventSetDescription(description) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventSetInviteStatus)
---@param eventIndex number
---@param status CalendarStatus
function C_Calendar.EventSetInviteStatus(eventIndex, status) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventSetLocked)
function C_Calendar.EventSetLocked() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventSetModerator)
---@param inviteIndex number
function C_Calendar.EventSetModerator(inviteIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventSetTextureID)
---@param textureIndex number
function C_Calendar.EventSetTextureID(textureIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventSetTime)
---@param hour number
---@param minute number
function C_Calendar.EventSetTime(hour, minute) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventSetTitle)
---@param title string
function C_Calendar.EventSetTitle(title) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventSetType)
---@param typeIndex CalendarEventType
function C_Calendar.EventSetType(typeIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventSignUp)
function C_Calendar.EventSignUp() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventSortInvites)
---@param criterion string
---@param reverse boolean
function C_Calendar.EventSortInvites(criterion, reverse) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.EventTentative)
function C_Calendar.EventTentative() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetClubCalendarEvents)
---@param clubId string
---@param startTime CalendarTime
---@param endTime CalendarTime
---@return CalendarDayEvent[] events
function C_Calendar.GetClubCalendarEvents(clubId, startTime, endTime) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetDayEvent)
---@param monthOffset number
---@param monthDay number
---@param index number
---@return CalendarDayEvent event
function C_Calendar.GetDayEvent(monthOffset, monthDay, index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetDefaultGuildFilter)
---@return CalendarGuildFilterInfo info
function C_Calendar.GetDefaultGuildFilter() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetEventIndex)
---@return CalendarEventIndexInfo info
function C_Calendar.GetEventIndex() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetEventIndexInfo)
---@param eventID string
---@param monthOffset? number
---@param monthDay? number
---@return CalendarEventIndexInfo? eventIndexInfo
function C_Calendar.GetEventIndexInfo(eventID, monthOffset, monthDay) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetEventInfo)
---@return CalendarEventInfo info
function C_Calendar.GetEventInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetFirstPendingInvite)
---@param offsetMonths number
---@param monthDay number
---@return number? firstPendingInvite
function C_Calendar.GetFirstPendingInvite(offsetMonths, monthDay) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetGuildEventInfo)
---@param index number
---@return CalendarGuildEventInfo info
function C_Calendar.GetGuildEventInfo(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetGuildEventSelectionInfo)
---@param index number
---@return CalendarEventIndexInfo info
function C_Calendar.GetGuildEventSelectionInfo(index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetHolidayInfo)
---@param monthOffset number
---@param monthDay number
---@param index number
---@return CalendarHolidayInfo event
function C_Calendar.GetHolidayInfo(monthOffset, monthDay, index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetMaxCreateDate)
---@return CalendarTime maxCreateDate
function C_Calendar.GetMaxCreateDate() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetMinDate)
---@return CalendarTime minDate
function C_Calendar.GetMinDate() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetMonthInfo)
---@param offsetMonths number
---@return CalendarMonthInfo monthInfo
function C_Calendar.GetMonthInfo(offsetMonths) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetNextClubId)
---@return string? clubId
function C_Calendar.GetNextClubId() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetNumDayEvents)
---@param offsetMonths number
---@param monthDay number
---@return number numDayEvents
function C_Calendar.GetNumDayEvents(offsetMonths, monthDay) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetNumGuildEvents)
---@return number numGuildEvents
function C_Calendar.GetNumGuildEvents() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetNumInvites)
---@return number num
function C_Calendar.GetNumInvites() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetNumPendingInvites)
---@return number num
function C_Calendar.GetNumPendingInvites() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.GetRaidInfo)
---@param offsetMonths number
---@param monthDay number
---@param eventIndex number
---@return CalendarRaidInfo info
function C_Calendar.GetRaidInfo(offsetMonths, monthDay, eventIndex) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.IsActionPending)
---@return boolean actionPending
function C_Calendar.IsActionPending() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.IsEventOpen)
---@return boolean isOpen
function C_Calendar.IsEventOpen() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.MassInviteCommunity)
---@param clubId string
---@param minLevel number
---@param maxLevel number
---@param maxRankOrder? number
function C_Calendar.MassInviteCommunity(clubId, minLevel, maxLevel, maxRankOrder) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.MassInviteGuild)
---@param minLevel number
---@param maxLevel number
---@param maxRankOrder number
function C_Calendar.MassInviteGuild(minLevel, maxLevel, maxRankOrder) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.OpenCalendar)
function C_Calendar.OpenCalendar() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.OpenEvent)
---@param offsetMonths number
---@param monthDay number
---@param index number
---@return boolean success
function C_Calendar.OpenEvent(offsetMonths, monthDay, index) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.RemoveEvent)
function C_Calendar.RemoveEvent() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.SetAbsMonth)
---@param month number
---@param year number
function C_Calendar.SetAbsMonth(month, year) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.SetMonth)
---@param offsetMonths number
function C_Calendar.SetMonth(offsetMonths) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.SetNextClubId)
---@param clubId? string
function C_Calendar.SetNextClubId(clubId) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_Calendar.UpdateEvent)
function C_Calendar.UpdateEvent() end

---@class CalendarDayEvent
---@field eventID string
---@field title string
---@field isCustomTitle boolean
---@field startTime CalendarTime
---@field endTime CalendarTime
---@field calendarType string
---@field sequenceType string
---@field eventType CalendarEventType
---@field iconTexture number|nil
---@field modStatus string
---@field inviteStatus number
---@field invitedBy string
---@field difficulty number
---@field inviteType number
---@field sequenceIndex number
---@field numSequenceDays number
---@field difficultyName string
---@field dontDisplayBanner boolean
---@field dontDisplayEnd boolean
---@field clubID string
---@field isLocked boolean

---@class CalendarEventIndexInfo
---@field offsetMonths number
---@field monthDay number
---@field eventIndex number

---@class CalendarEventInfo
---@field title string
---@field description string
---@field creator string|nil
---@field eventType CalendarEventType
---@field repeatOption number
---@field maxSize number
---@field textureIndex number|nil
---@field time CalendarTime
---@field lockoutTime CalendarTime
---@field isLocked boolean
---@field isAutoApprove boolean
---@field hasPendingInvite boolean
---@field inviteStatus number|nil
---@field inviteType number|nil
---@field calendarType string
---@field communityName string|nil

---@class CalendarEventInviteInfo
---@field name string|nil
---@field level number
---@field className string|nil
---@field classFilename string|nil
---@field inviteStatus number|nil
---@field modStatus string|nil
---@field inviteIsMine boolean
---@field type number
---@field notes string
---@field classID number|nil
---@field guid string

---@class CalendarEventStatusOption
---@field status CalendarStatus
---@field statusString string

---@class CalendarEventTextureInfo
---@field title string
---@field iconTexture number
---@field expansionLevel number
---@field difficultyId number|nil
---@field mapId number|nil
---@field isLfr boolean|nil

---@class CalendarEventTypeDisplayInfo
---@field displayString string
---@field eventType CalendarEventType

---@class CalendarGuildEventInfo
---@field eventID string
---@field year number
---@field month number
---@field monthDay number
---@field weekday number
---@field hour number
---@field minute number
---@field eventType CalendarEventType
---@field title string
---@field calendarType string
---@field texture number
---@field inviteStatus number
---@field clubID string

---@class CalendarGuildFilterInfo
---@field minLevel number
---@field maxLevel number
---@field rank number

---@class CalendarHolidayInfo
---@field name string
---@field description string
---@field texture number
---@field startTime CalendarTime|nil
---@field endTime CalendarTime|nil

---@class CalendarMonthInfo
---@field month number
---@field year number
---@field numDays number
---@field firstWeekday number

---@class CalendarRaidInfo
---@field name string
---@field calendarType string
---@field raidID number
---@field time CalendarTime
---@field difficulty number
---@field difficultyName string|nil
