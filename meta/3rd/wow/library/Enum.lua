---@meta
Enum = {
	---@class AddSoulbindConduitReason
	AddSoulbindConduitReason = {
		None = 0,
		Cheat = 1,
		SpellEffect = 2,
		Upgrade = 3,
	},
	---@class AnimaDiversionNodeState
	AnimaDiversionNodeState = {
		Unavailable = 0,
		Available = 1,
		SelectedTemporary = 2,
		SelectedPermanent = 3,
		Cooldown = 4,
	},
	---@class AuctionHouseCommoditySortOrder
	AuctionHouseCommoditySortOrder = {
		UnitPrice = 0,
		Quantity = 1,
	},
	---@class AuctionHouseError
	AuctionHouseError = {
		NotEnoughMoney = 0,
		HigherBid = 1,
		BidIncrement = 2,
		BidOwn = 3,
		ItemNotFound = 4,
		RestrictedAccountTrial = 5,
		HasRestriction = 6,
		IsBusy = 7,
		Unavailable = 8,
		ItemHasQuote = 9,
		DatabaseError = 10,
		MinBid = 11,
		NotEnoughItems = 12,
		RepairItem = 13,
		UsedCharges = 14,
		QuestItem = 15,
		BoundItem = 16,
		ConjuredItem = 17,
		LimitedDurationItem = 18,
		IsBag = 19,
		EquippedBag = 20,
		WrappedItem = 21,
		LootItem = 22,
	},
	---@class AuctionHouseFilter
	AuctionHouseFilter = {
		UncollectedOnly = 0,
		UsableOnly = 1,
		UpgradesOnly = 2,
		ExactMatch = 3,
		PoorQuality = 4,
		CommonQuality = 5,
		UncommonQuality = 6,
		RareQuality = 7,
		EpicQuality = 8,
		LegendaryQuality = 9,
		ArtifactQuality = 10,
		LegendaryCraftedItemOnly = 11,
	},
	---@class AuctionHouseFilterCategory
	AuctionHouseFilterCategory = {
		Uncategorized = 0,
		Equipment = 1,
		Rarity = 2,
	},
	---@class AuctionHouseItemSortOrder
	AuctionHouseItemSortOrder = {
		Bid = 0,
		Buyout = 1,
	},
	---@class AuctionHouseNotification
	AuctionHouseNotification = {
		BidPlaced = 0,
		AuctionRemoved = 1,
		AuctionWon = 2,
		AuctionOutbid = 3,
		AuctionSold = 4,
		AuctionExpired = 5,
	},
	---@class AuctionHouseSortOrder
	AuctionHouseSortOrder = {
		Price = 0,
		Name = 1,
		Level = 2,
		Bid = 3,
		Buyout = 4,
		TimeRemaining = 5,
	},
	---@class AuctionHouseTimeLeftBand
	AuctionHouseTimeLeftBand = {
		Short = 0,
		Medium = 1,
		Long = 2,
		VeryLong = 3,
	},
	---@class AuctionStatus
	AuctionStatus = {
		Active = 0,
		Sold = 1,
	},
	---@class AzeriteEssenceSlot
	AzeriteEssenceSlot = {
		MainSlot = 0,
		PassiveOneSlot = 1,
		PassiveTwoSlot = 2,
		PassiveThreeSlot = 3,
	},
	---@class AzeritePowerLevel
	AzeritePowerLevel = {
		Base = 0,
		Upgraded = 1,
		Downgraded = 2,
	},
	---@class BattlePetAbilityFlag
	BattlePetAbilityFlag = {
		DisplayAsHostileDebuff = 1,
		HideStrongWeakHints = 2,
		Passive = 4,
		ServerOnlyAura = 8,
		ShowCast = 16,
		StartOnCooldown = 32,
	},
	---@class BattlePetAbilitySlot
	BattlePetAbilitySlot = {
		A = 0,
		B = 1,
		C = 2,
	},
	---@class BattlePetAbilityTargets
	BattlePetAbilityTargets = {
		EnemyFrontPet = 0,
		FriendlyFrontPet = 1,
		Weather = 2,
		EnemyPad = 3,
		FriendlyPad = 4,
		EnemyBackPet_1 = 5,
		EnemyBackPet_2 = 6,
		FriendlyBackPet_1 = 7,
		FriendlyBackPet_2 = 8,
		Caster = 9,
		Owner = 10,
		Specific = 11,
		ProcTarget = 12,
	},
	---@class BattlePetAbilityTurnFlag
	BattlePetAbilityTurnFlag = {
		CanProcFromProc = 1,
		TriggerBySelf = 2,
		TriggerByFriend = 4,
		TriggerByEnemy = 8,
		TriggerByWeather = 16,
		TriggerByAuraCaster = 32,
	},
	---@class BattlePetAbilityTurnType
	BattlePetAbilityTurnType = {
		Normal = 0,
		TriggeredEffect = 1,
	},
	---@class BattlePetAbilityType
	BattlePetAbilityType = {
		Ability = 0,
		Aura = 1,
	},
	---@class BattlePetAction
	BattlePetAction = {
		None = 0,
		Ability = 1,
		SwitchPet = 2,
		Trap = 3,
		Skip = 4,
	},
	---@class BattlePetBreedQuality
	BattlePetBreedQuality = {
		Poor = 0,
		Common = 1,
		Uncommon = 2,
		Rare = 3,
		Epic = 4,
		Legendary = 5,
	},
	---@class BattlePetEffectFlags
	BattlePetEffectFlags = {
		EnableAbilityPicker = 1,
		LuaNeedsAllPets = 2,
	},
	---@class BattlePetEffectParamType
	BattlePetEffectParamType = {
		Int = 0,
		Ability = 1,
	},
	---@class BattlePetEvent
	BattlePetEvent = {
		OnAuraApplied = 0,
		OnDamageTaken = 1,
		OnDamageDealt = 2,
		OnHealTaken = 3,
		OnHealDealt = 4,
		OnAuraRemoved = 5,
		OnRoundStart = 6,
		OnRoundEnd = 7,
		OnTurn = 8,
		OnAbility = 9,
		OnSwapIn = 10,
		OnSwapOut = 11,
		PostAuraTicks = 12,
	},
	---@class BattlePetNpcEmote
	BattlePetNpcEmote = {
		BattleUnused = 0,
		BattleStart = 1,
		BattleWin = 2,
		BattleLose = 3,
		PetSwap = 4,
		PetKill = 5,
		PetDie = 6,
		PetAbility = 7,
	},
	---@class BattlePetNpcTeamFlag
	BattlePetNpcTeamFlag = {
		MatchPlayerHighPetLevel = 1,
		NoPlayerXp = 2,
	},
	---@class BattlePetOwner
	BattlePetOwner = {
		Weather = 0,
		Ally = 1,
		Enemy = 2,
	},
	---@class BattlePetSources
	BattlePetSources = {
		Drop = 0,
		Quest = 1,
		Vendor = 2,
		Profession = 3,
		WildPet = 4,
		Achievement = 5,
		WorldEvent = 6,
		Promotion = 7,
		Tcg = 8,
		PetStore = 9,
		Discovery = 10,
	},
	---@class BattlePetSpeciesFlags
	BattlePetSpeciesFlags = {
		NoRename = 1,
		WellKnown = 2,
		NotAcccountwide = 4,
		Capturable = 8,
		NotTradable = 16,
		HideFromJournal = 32,
		LegacyAccountUnique = 64,
		CantBattle = 128,
		HordeOnly = 256,
		AllianceOnly = 512,
		Boss = 1024,
		RandomDisplay = 2048,
		NoLicenseRequired = 4096,
		AddsAllowedWithBoss = 8192,
		HideUntilLearned = 16384,
		MatchPlayerHighPetLevel = 32768,
	},
	---@class BattlePetStateFlag
	BattlePetStateFlag = {
		None = 0,
		SwapOutLock = 1,
		TurnLock = 2,
		SpeedBonus = 4,
		Client = 8,
		MaxHealthBonus = 16,
		Stamina = 32,
		QualityDoesNotEffect = 64,
		DynamicScaling = 128,
		Power = 256,
		SpeedMult = 512,
		SwapInLock = 1024,
		ServerOnly = 2048,
	},
	---@class BattlePetTypes
	BattlePetTypes = {
		Humanoid = 0,
		Dragonkin = 1,
		Flying = 2,
		Undead = 3,
		Critter = 4,
		Magic = 5,
		Elemental = 6,
		Beast = 7,
		Aquatic = 8,
		Mechanical = 9,
	},
	---@class BattlePetVisualFlag
	BattlePetVisualFlag = {
		Test1 = 1,
		Test2 = 2,
		Test3 = 4,
	},
	---@class BattlePetVisualRange
	BattlePetVisualRange = {
		Melee = 0,
		Ranged = 1,
		InPlace = 2,
		PointBlank = 3,
		BehindMelee = 4,
		BehindRanged = 5,
	},
	---@class BattlepetDbFlags
	BattlepetDbFlags = {
		None = 0,
		Favorite = 1,
		Converted = 2,
		Revoked = 4,
		LockedForConvert = 8,
		LockMask = 12,
		Ability0Selection = 16,
		Ability1Selection = 32,
		Ability2Selection = 64,
		FanfareNeeded = 128,
		DisplayOverridden = 256,
	},
	---@class BattlepetDeletedReason
	BattlepetDeletedReason = {
		Unknown = 0,
		PlayerReleased = 1,
		PlayerCaged = 2,
		Gm = 3,
		CageError = 4,
		DelJournal = 5,
	},
	---@class BattlepetSlotLockCheat
	BattlepetSlotLockCheat = {
		Cheat_2_Locked = -3,
		Cheat_1_Locked = -2,
		Cheat_0_Locked = -1,
		CheatOff = 0,
		UnlockAll = 1,
	},
	---@class BrawlType
	BrawlType = {
		None = 0,
		Battleground = 1,
		Arena = 2,
		Lfg = 3,
	},
	---@class CachedRewardType
	CachedRewardType = {
		None = 0,
		Item = 1,
		Currency = 2,
		Quest = 3,
	},
	---@class CalendarCommandType
	CalendarCommandType = {
		CalendarCommandCreate = 0,
		CalendarCommandInvite = 1,
		CalendarCommandRsvp = 2,
		CalendarCommandRemoveInvite = 3,
		CalendarCommandRemoveEvent = 4,
		CalendarCommandStatus = 5,
		CalendarCommandModeratorStatus = 6,
		CalendarCommandGetCalendar = 7,
		CalendarCommandGetEvent = 8,
		CalendarCommandUpdateEvent = 9,
		CalendarCommandComplain = 10,
		CalendarCommandNotes = 11,
	},
	---@class CalendarErrorType
	CalendarErrorType = {
		CalendarErrorSuccess = 0,
		CalendarErrorCommunityEventsExceeded = 1,
		CalendarErrorEventsExceeded = 2,
		CalendarErrorSelfInvitesExceeded = 3,
		CalendarErrorOtherInvitesExceeded = 4,
		CalendarErrorNoPermission = 5,
		CalendarErrorEventInvalid = 6,
		CalendarErrorNotInvited = 7,
		CalendarErrorUnknownError = 8,
		CalendarErrorNotInGuild = 9,
		CalendarErrorNotInCommunity = 10,
		CalendarErrorTargetAlreadyInvited = 11,
		CalendarErrorNameNotFound = 12,
		CalendarErrorWrongFaction = 13,
		CalendarErrorIgnored = 14,
		CalendarErrorInvitesExceeded = 15,
		CalendarErrorInvalidMaxSize = 16,
		CalendarErrorInvalidDate = 17,
		CalendarErrorInvalidTime = 18,
		CalendarErrorNoInvites = 19,
		CalendarErrorNeedsTitle = 20,
		CalendarErrorEventPassed = 21,
		CalendarErrorEventLocked = 22,
		CalendarErrorDeleteCreatorFailed = 23,
		CalendarErrorDataAlreadySet = 24,
		CalendarErrorCalendarDisabled = 25,
		CalendarErrorRestrictedAccount = 26,
		CalendarErrorArenaEventsExceeded = 27,
		CalendarErrorRestrictedLevel = 28,
		CalendarErrorSquelched = 29,
		CalendarErrorNoInvite = 30,
		CalendarErrorComplaintDisabled = 31,
		CalendarErrorComplaintSelf = 32,
		CalendarErrorComplaintSameGuild = 33,
		CalendarErrorComplaintGm = 34,
		CalendarErrorComplaintLimit = 35,
		CalendarErrorComplaintNotFound = 36,
		CalendarErrorEventWrongServer = 37,
		CalendarErrorNoCommunityInvites = 38,
		CalendarErrorInvalidSignup = 39,
		CalendarErrorNoModerator = 40,
		CalendarErrorModeratorRestricted = 41,
		CalendarErrorInvalidNotes = 42,
		CalendarErrorInvalidTitle = 43,
		CalendarErrorInvalidDescription = 44,
		CalendarErrorInvalidClub = 45,
		CalendarErrorCreatorNotFound = 46,
		CalendarErrorEventThrottled = 47,
		CalendarErrorInviteThrottled = 48,
		CalendarErrorInternal = 49,
		CalendarErrorComplaintAdded = 50,
	},
	---@class CalendarEventBits
	CalendarEventBits = {
		CalendarEventBitPlayer = 1,
		CalendarEventBitGuildDeprecated = 2,
		CalendarEventBitSystem = 4,
		CalendarEventBitHoliday = 8,
		CalendarEventBitLocked = 16,
		CalendarEventBitAutoApprove = 32,
		CalendarEventBitCommunityAnnouncement = 64,
		CalendarEventBitRaidLockout = 128,
		CalendarEventBitArenaDeprecated = 256,
		CalendarEventBitRaidResetDeprecated = 512,
		CalendarEventBitCommunitySignup = 1024,
		CalendarEventBitGuildSignup = 2048,
		CommunityWide = 3136,
		PlayerCreated = 3395,
		CantComplain = 3788,
	},
	---@class CalendarEventRepeatOptions
	CalendarEventRepeatOptions = {
		CalendarRepeatNever = 0,
		CalendarRepeatWeekly = 1,
		CalendarRepeatBiweekly = 2,
		CalendarRepeatMonthly = 3,
	},
	---@class CalendarEventType
	CalendarEventType = {
		Raid = 0,
		Dungeon = 1,
		PvP = 2,
		Meeting = 3,
		Other = 4,
		HeroicDeprecated = 5,
	},
	---@class CalendarFilterFlags
	CalendarFilterFlags = {
		WeeklyHoliday = 1,
		Darkmoon = 2,
		Battleground = 4,
		RaidLockout = 8,
		RaidReset = 16,
	},
	---@class CalendarGetEventType
	CalendarGetEventType = {
		DefaultCalendarGetEventType = 0,
		Get = 0,
		Add = 1,
		Copy = 2,
	},
	---@class CalendarHolidayFilterType
	CalendarHolidayFilterType = {
		Weekly = 0,
		Darkmoon = 1,
		Battleground = 2,
	},
	---@class CalendarInviteBits
	CalendarInviteBits = {
		CalendarInviteBitPendingInvite = 1,
		CalendarInviteBitModerator = 2,
		CalendarInviteBitCreator = 4,
		CalendarInviteBitSignup = 8,
	},
	---@class CalendarInviteSortType
	CalendarInviteSortType = {
		CalendarInviteSortName = 0,
		CalendarInviteSortLevel = 1,
		CalendarInviteSortClass = 2,
		CalendarInviteSortStatus = 3,
		CalendarInviteSortParty = 4,
		CalendarInviteSortNotes = 5,
	},
	---@class CalendarInviteType
	CalendarInviteType = {
		Normal = 0,
		Signup = 1,
	},
	---@class CalendarModeratorStatus
	CalendarModeratorStatus = {
		CalendarModeratorNone = 0,
		CalendarModeratorModerator = 1,
		CalendarModeratorCreator = 2,
	},
	---@class CalendarStatus
	CalendarStatus = {
		Invited = 0,
		Available = 1,
		Declined = 2,
		Confirmed = 3,
		Out = 4,
		Standby = 5,
		Signedup = 6,
		NotSignedup = 7,
		Tentative = 8,
	},
	---@class CalendarType
	CalendarType = {
		Player = 0,
		Community = 1,
		RaidLockout = 2,
		RaidResetDeprecated = 3,
		Holiday = 4,
		HolidayWeekly = 5,
		HolidayDarkmoon = 6,
		HolidayBattleground = 7,
	},
	---@class CalendarWebActionType
	CalendarWebActionType = {
		Accept = 0,
		Decline = 1,
		Remove = 2,
		ReportSpam = 3,
		Signup = 4,
		Tentative = 5,
		TentativeSignup = 6,
	},
	---@class CallingStates
	CallingStates = {
		QuestOffer = 0,
		QuestActive = 1,
		QuestCompleted = 2,
	},
	---@class CampaignState
	CampaignState = {
		Invalid = 0,
		Complete = 1,
		InProgress = 2,
		Stalled = 3,
	},
	---@class CaptureBarWidgetFillDirectionType
	CaptureBarWidgetFillDirectionType = {
		RightToLeft = 0,
		LeftToRight = 1,
	},
	---@class CaptureBarWidgetGlowAnimType
	CaptureBarWidgetGlowAnimType = {
		None = 0,
		Pulse = 1,
	},
	---@class CharacterServiceInfoFlag
	CharacterServiceInfoFlag = {
		RestrictToRecommendedSpecs = 1,
	},
	---@class ChatChannelRuleset
	ChatChannelRuleset = {
		None = 0,
		Mentor = 1,
		Disabled = 2,
		ChromieTimeCataclysm = 3,
		ChromieTimeBuringCrusade = 4,
		ChromieTimeWrath = 5,
		ChromieTimeMists = 6,
		ChromieTimeWoD = 7,
		ChromieTimeLegion = 8,
	},
	---@class ChatChannelType
	ChatChannelType = {
		None = 0,
		Custom = 1,
		Private_Party = 2,
		Public_Party = 3,
		Communities = 4,
	},
	---@class ChrCustomizationCategoryFlag
	ChrCustomizationCategoryFlag = {
		UndressModel = 1,
	},
	---@class ChrCustomizationOptionType
	ChrCustomizationOptionType = {
		SelectionPopout = 0,
		Checkbox = 1,
		Slider = 2,
	},
	---@class ClickBindingInteraction
	ClickBindingInteraction = {
		Target = 1,
		OpenContextMenu = 2,
	},
	---@class ClickBindingType
	ClickBindingType = {
		None = 0,
		Spell = 1,
		Macro = 2,
		Interaction = 3,
	},
	---@class ClientSceneType
	ClientSceneType = {
		DefaultSceneType = 0,
		MinigameSceneType = 1,
	},
	---@class ClubActionType
	ClubActionType = {
		ErrorClubActionSubscribe = 0,
		ErrorClubActionCreate = 1,
		ErrorClubActionEdit = 2,
		ErrorClubActionDestroy = 3,
		ErrorClubActionLeave = 4,
		ErrorClubActionCreateTicket = 5,
		ErrorClubActionDestroyTicket = 6,
		ErrorClubActionRedeemTicket = 7,
		ErrorClubActionGetTicket = 8,
		ErrorClubActionGetTickets = 9,
		ErrorClubActionGetBans = 10,
		ErrorClubActionGetInvitations = 11,
		ErrorClubActionRevokeInvitation = 12,
		ErrorClubActionAcceptInvitation = 13,
		ErrorClubActionDeclineInvitation = 14,
		ErrorClubActionCreateStream = 15,
		ErrorClubActionEditStream = 16,
		ErrorClubActionDestroyStream = 17,
		ErrorClubActionInviteMember = 18,
		ErrorClubActionEditMember = 19,
		ErrorClubActionEditMemberNote = 20,
		ErrorClubActionKickMember = 21,
		ErrorClubActionAddBan = 22,
		ErrorClubActionRemoveBan = 23,
		ErrorClubActionCreateMessage = 24,
		ErrorClubActionEditMessage = 25,
		ErrorClubActionDestroyMessage = 26,
	},
	---@class ClubErrorType
	ClubErrorType = {
		ErrorCommunitiesNone = 0,
		ErrorCommunitiesUnknown = 1,
		ErrorCommunitiesNeutralFaction = 2,
		ErrorCommunitiesUnknownRealm = 3,
		ErrorCommunitiesBadTarget = 4,
		ErrorCommunitiesWrongFaction = 5,
		ErrorCommunitiesRestricted = 6,
		ErrorCommunitiesIgnored = 7,
		ErrorCommunitiesGuild = 8,
		ErrorCommunitiesWrongRegion = 9,
		ErrorCommunitiesUnknownTicket = 10,
		ErrorCommunitiesMissingShortName = 11,
		ErrorCommunitiesProfanity = 12,
		ErrorCommunitiesTrial = 13,
		ErrorCommunitiesVeteranTrial = 14,
		ErrorCommunitiesChatMute = 15,
		ErrorClubFull = 16,
		ErrorClubNoClub = 17,
		ErrorClubNotMember = 18,
		ErrorClubAlreadyMember = 19,
		ErrorClubNoSuchMember = 20,
		ErrorClubNoSuchInvitation = 21,
		ErrorClubInvitationAlreadyExists = 22,
		ErrorClubInvalidRoleID = 23,
		ErrorClubInsufficientPrivileges = 24,
		ErrorClubTooManyClubsJoined = 25,
		ErrorClubVoiceFull = 26,
		ErrorClubStreamNoStream = 27,
		ErrorClubStreamInvalidName = 28,
		ErrorClubStreamCountAtMin = 29,
		ErrorClubStreamCountAtMax = 30,
		ErrorClubMemberHasRequiredRole = 31,
		ErrorClubSentInvitationCountAtMax = 32,
		ErrorClubReceivedInvitationCountAtMax = 33,
		ErrorClubTargetIsBanned = 34,
		ErrorClubBanAlreadyExists = 35,
		ErrorClubBanCountAtMax = 36,
		ErrorClubTicketCountAtMax = 37,
		ErrorClubTicketNoSuchTicket = 38,
		ErrorClubTicketHasConsumedAllowedRedeemCount = 39,
	},
	---@class ClubFieldType
	ClubFieldType = {
		ClubName = 0,
		ClubShortName = 1,
		ClubDescription = 2,
		ClubBroadcast = 3,
		ClubStreamName = 4,
		ClubStreamSubject = 5,
		NumTypes = 6,
	},
	---@class ClubFinderApplicationUpdateType
	ClubFinderApplicationUpdateType = {
		None = 0,
		AcceptInvite = 1,
		DeclineInvite = 2,
		Cancel = 3,
	},
	---@class ClubFinderClubPostingStatusFlags
	ClubFinderClubPostingStatusFlags = {
		None = 0,
		NeedsCacheUpdate = 1,
		ForceDescriptionChange = 2,
		ForceNameChange = 3,
		UnderReview = 4,
		Banned = 5,
		FakePost = 6,
		PendingDelete = 7,
		PostDelisted = 8,
	},
	---@class ClubFinderDisableReason
	ClubFinderDisableReason = {
		Muted = 0,
		Silenced = 1,
		VeteranTrial = 2,
	},
	---@class ClubFinderPostingReportType
	ClubFinderPostingReportType = {
		PostersName = 0,
		ClubName = 1,
		PostingDescription = 2,
		ApplicantsName = 3,
		JoinNote = 4,
	},
	---@class ClubFinderRequestType
	ClubFinderRequestType = {
		None = 0,
		Guild = 1,
		Community = 2,
		All = 3,
	},
	---@class ClubFinderSettingFlags
	ClubFinderSettingFlags = {
		None = 0,
		Dungeons = 1,
		Raids = 2,
		PvP = 3,
		RP = 4,
		Social = 5,
		Small = 6,
		Medium = 7,
		Large = 8,
		Tank = 9,
		Healer = 10,
		Damage = 11,
		EnableListing = 12,
		MaxLevelOnly = 13,
		AutoAccept = 14,
		FactionHorde = 15,
		FactionAlliance = 16,
		FactionNeutral = 17,
		SortRelevance = 18,
		SortMemberCount = 19,
		SortNewest = 20,
		LanguageReserved1 = 21,
		LanguageReserved2 = 22,
		LanguageReserved3 = 23,
		LanguageReserved4 = 24,
		LanguageReserved5 = 25,
	},
	---@class ClubInvitationCandidateStatus
	ClubInvitationCandidateStatus = {
		Available = 0,
		InvitePending = 1,
		AlreadyMember = 2,
	},
	---@class ClubMemberPresence
	ClubMemberPresence = {
		Unknown = 0,
		Online = 1,
		OnlineMobile = 2,
		Offline = 3,
		Away = 4,
		Busy = 5,
	},
	---@class ClubRemovedReason
	ClubRemovedReason = {
		None = 0,
		Banned = 1,
		Removed = 2,
		ClubDestroyed = 3,
	},
	---@class ClubRestrictionReason
	ClubRestrictionReason = {
		None = 0,
		Unavailable = 1,
	},
	---@class ClubRoleIdentifier
	ClubRoleIdentifier = {
		Owner = 1,
		Leader = 2,
		Moderator = 3,
		Member = 4,
	},
	---@class ClubStreamNotificationFilter
	ClubStreamNotificationFilter = {
		None = 0,
		Mention = 1,
		All = 2,
	},
	---@class ClubStreamType
	ClubStreamType = {
		General = 0,
		Guild = 1,
		Officer = 2,
		Other = 3,
	},
	---@class ClubType
	ClubType = {
		BattleNet = 0,
		Character = 1,
		Guild = 2,
		Other = 3,
	},
	---@class CommunicationMode
	CommunicationMode = {
		PushToTalk = 0,
		OpenMic = 1,
	},
	---@class ConquestProgressBarDisplayType
	ConquestProgressBarDisplayType = {
		FirstChest = 0,
		AdditionalChest = 1,
		Seasonal = 2,
	},
	---@class ConsoleCategory
	ConsoleCategory = {
		Debug = 0,
		Graphics = 1,
		Console = 2,
		Combat = 3,
		Game = 4,
		Default = 5,
		Net = 6,
		Sound = 7,
		Gm = 8,
		Reveal = 9,
		None = 10,
	},
	---@class ConsoleColorType
	ConsoleColorType = {
		DefaultColor = 0,
		InputColor = 1,
		EchoColor = 2,
		ErrorColor = 3,
		WarningColor = 4,
		GlobalColor = 5,
		AdminColor = 6,
		HighlightColor = 7,
		BackgroundColor = 8,
		ClickbufferColor = 9,
		PrivateColor = 10,
		DefaultGreen = 11,
	},
	---@class ConsoleCommandType
	ConsoleCommandType = {
		Cvar = 0,
		Command = 1,
		Macro = 2,
		Script = 3,
	},
	---@class ContributionAppearanceFlags
	ContributionAppearanceFlags = {
		TooltipUseTimeRemaining = 0,
	},
	---@class ContributionResult
	ContributionResult = {
		Success = 0,
		MustBeNearNpc = 1,
		IncorrectState = 2,
		InvalidID = 3,
		QuestDataMissing = 4,
		FailedConditionCheck = 5,
		UnableToCompleteTurnIn = 6,
		InternalError = 7,
	},
	---@class ContributionState
	ContributionState = {
		None = 0,
		Building = 1,
		Active = 2,
		UnderAttack = 3,
		Destroyed = 4,
	},
	---@class CovenantAbilityType
	CovenantAbilityType = {
		Class = 0,
		Signature = 1,
		Soulbind = 2,
	},
	---@class CovenantSkill
	CovenantSkill = {
		Kyrian = 2730,
		Venthyr = 2731,
		NightFae = 2732,
		Necrolord = 2733,
	},
	---@class CovenantType
	CovenantType = {
		None = 0,
		Kyrian = 1,
		Venthyr = 2,
		NightFae = 3,
		Necrolord = 4,
	},
	---@class CurrencyDestroyReason
	CurrencyDestroyReason = {
		Cheat = 0,
		Spell = 1,
		VersionUpdate = 2,
		QuestTurnin = 3,
		Vendor = 4,
		Trade = 5,
		Capped = 6,
		Garrison = 7,
		DroppedToCorpse = 8,
		BonusRoll = 9,
		FactionConversion = 10,
		Last = 11,
	},
	---@class CurrencyFlags
	CurrencyFlags = {
		CurrencyTradable = 1,
		CurrencyAppearsInLootWindow = 2,
		CurrencyComputedWeeklyMaximum = 4,
		Currency_100_Scaler = 8,
		CurrencyNoLowLevelDrop = 16,
		CurrencyIgnoreMaxQtyOnLoad = 32,
		CurrencyLogOnWorldChange = 64,
		CurrencyTrackQuantity = 128,
		CurrencyResetTrackedQuantity = 256,
		CurrencyUpdateVersionIgnoreMax = 512,
		CurrencySuppressChatMessageOnVersionChange = 1024,
		CurrencySingleDropInLoot = 2048,
		CurrencyHasWeeklyCatchup = 4096,
		CurrencyDoNotCompressChat = 8192,
		CurrencyDoNotLogAcquisitionToBi = 16384,
		CurrencyNoRaidDrop = 32768,
		CurrencyNotPersistent = 65536,
		CurrencyDeprecated = 131072,
		CurrencyDynamicMaximum = 262144,
		CurrencySuppressChatMessages = 524288,
		CurrencyDoNotToast = 1048576,
		CurrencyDestroyExtraOnLoot = 2097152,
		CurrencyDontShowTotalInTooltip = 4194304,
		CurrencyDontCoalesceInLootWindow = 8388608,
		CurrencyAccountWide = 16777216,
		CurrencyAllowOverflowMailer = 33554432,
		CurrencyHideAsReward = 67108864,
		CurrencyHasWarmodeBonus = 134217728,
		CurrencyIsAllianceOnly = 268435456,
		CurrencyIsHordeOnly = 536870912,
		CurrencyLimitWarmodeBonusOncePerTooltip = 1073741824,
		DeprecatedCurrencyFlag = 2147483648,
	},
	---@class CurrencyFlagsB
	CurrencyFlagsB = {
		CurrencyBUseTotalEarnedForEarned = 1,
		CurrencyBShowQuestXpGainInTooltip = 2,
		CurrencyBNoNotificationMailOnOfflineProgress = 4,
	},
	---@class CurrencyGainFlags
	CurrencyGainFlags = {
		BonusAward = 1,
		DroppedFromDeath = 2,
		FromAccountServer = 4,
	},
	---@class CurrencySource
	CurrencySource = {
		ConvertOldItem = 0,
		ConvertOldPvPCurrency = 1,
		ItemRefund = 2,
		QuestReward = 3,
		Cheat = 4,
		Vendor = 5,
		PvPKillCredit = 6,
		PvPMetaCredit = 7,
		PvPScriptedAward = 8,
		Loot = 9,
		UpdatingVersion = 10,
		LfgReward = 11,
		Trade = 12,
		Spell = 13,
		ItemDeletion = 14,
		RatedBattleground = 15,
		RandomBattleground = 16,
		Arena = 17,
		ExceededMaxQty = 18,
		PvPCompletionBonus = 19,
		Script = 20,
		GuildBankWithdrawal = 21,
		Pushloot = 22,
		GarrisonBuilding = 23,
		PvPDrop = 24,
		GarrisonFollowerActivation = 25,
		GarrisonBuildingRefund = 26,
		GarrisonMissionReward = 27,
		GarrisonResourceOverTime = 28,
		QuestRewardIgnoreCaps = 29,
		GarrisonTalent = 30,
		GarrisonWorldQuestBonus = 31,
		PvPHonorReward = 32,
		BonusRoll = 33,
		AzeriteRespec = 34,
		WorldQuestReward = 35,
		WorldQuestRewardIgnoreCaps = 36,
		FactionConversion = 37,
		DailyQuestReward = 38,
		DailyQuestWarModeReward = 39,
		WeeklyQuestReward = 40,
		WeeklyQuestWarModeReward = 41,
		AccountCopy = 42,
		WeeklyRewardChest = 43,
		GarrisonTalentTreeReset = 44,
		DailyReset = 45,
		AddConduitToCollection = 46,
		Barbershop = 47,
		ConvertItemsToCurrencyValue = 48,
		PvPTeamContribution = 49,
		Transmogrify = 50,
		AuctionDeposit = 51,
		Last = 52,
	},
	---@class CurrencyTokenCategoryFlags
	CurrencyTokenCategoryFlags = {
		FlagSortLast = 1,
		FlagPlayerItemAssignment = 2,
		Hidden = 4,
		Virtual = 8,
	},
	---@class CustomBindingType
	CustomBindingType = {
		VoicePushToTalk = 0,
	},
	---@class Damageclass
	Damageclass = {
		MaskNone = 0,
		Physical = 0,
		AllPhysical = 1,
		Holy = 1,
		MaskPhysical = 1,
		Fire = 2,
		FirstResist = 2,
		MaskHoly = 2,
		MaskHolystrike = 3,
		Nature = 3,
		Frost = 4,
		MaskFire = 4,
		MaskFlamestrike = 5,
		Shadow = 5,
		Arcane = 6,
		LastResist = 6,
		MaskHolyfire = 6,
		NumClasses = 7,
		MaskNature = 8,
		MaskStormstrike = 9,
		MaskHolystorm = 10,
		MaskFirestorm = 12,
		MaskFrost = 16,
		MaskFroststrike = 17,
		MaskHolyfrost = 18,
		MaskFrostfire = 20,
		MaskFroststorm = 24,
		MaskElemental = 28,
		MaskShadow = 32,
		MaskShadowstrike = 33,
		MaskTwilight = 34,
		MaskShadowflame = 36,
		MaskShadowstorm = 40,
		MaskShadowfrost = 48,
		MaskChromatic = 62,
		MaskArcane = 64,
		MaskSpellstrike = 65,
		MaskDivine = 66,
		MaskSpellfire = 68,
		MaskSpellstorm = 72,
		MaskSpellfrost = 80,
		MaskSpellshadow = 96,
		MaskCosmic = 106,
		MaskChaos = 124,
		AllMagical = 126,
		MaskMagical = 126,
		All = 127,
	},
	---@class DamageclassType
	DamageclassType = {
		Physical = 0,
		Magical = 1,
	},
	---@class EnvironmentalDamageFlags
	EnvironmentalDamageFlags = {
		OneTime = 1,
		DmgIsPct = 2,
	},
	---@class Environmentaldamagetype
	Environmentaldamagetype = {
		Fatigue = 0,
		Drowning = 1,
		Falling = 2,
		Lava = 3,
		Slime = 4,
		Fire = 5,
	},
	---@class EventToastDisplayType
	EventToastDisplayType = {
		NormalSingleLine = 0,
		NormalBlockText = 1,
		NormalTitleAndSubTitle = 2,
		NormalTextWithIcon = 3,
		LargeTextWithIcon = 4,
		NormalTextWithIconAndRarity = 5,
		Scenario = 6,
		ChallengeMode = 7,
		ScenarioClickExpand = 8,
	},
	---@class EventToastEventType
	EventToastEventType = {
		LevelUp = 0,
		LevelUpSpell = 1,
		LevelUpDungeon = 2,
		LevelUpRaid = 3,
		LevelUpPvP = 4,
		PetBattleNewAbility = 5,
		PetBattleFinalRound = 6,
		PetBattleCapture = 7,
		BattlePetLevelChanged = 8,
		BattlePetLevelUpAbility = 9,
		QuestBossEmote = 10,
		MythicPlusWeeklyRecord = 11,
		QuestTurnedIn = 12,
		WorldStateChange = 13,
		Scenario = 14,
		LevelUpOther = 15,
		PlayerAuraAdded = 16,
		PlayerAuraRemoved = 17,
		SpellScript = 18,
		CriteriaUpdated = 19,
		PvPTierUpdate = 20,
	},
	---@class FlightPathFaction
	FlightPathFaction = {
		Neutral = 0,
		Horde = 1,
		Alliance = 2,
	},
	---@class FlightPathState
	FlightPathState = {
		Current = 0,
		Reachable = 1,
		Unreachable = 2,
	},
	---@class FollowerAbilityCastResult
	FollowerAbilityCastResult = {
		Success = 0,
		Failure = 1,
		NoPendingCast = 2,
		InvalidTarget = 3,
		InvalidFollowerSpell = 4,
		RerollNotAllowed = 5,
		SingleMissionDuration = 6,
		MustTargetFollower = 7,
		MustTargetTrait = 8,
		InvalidFollowerType = 9,
		MustBeUnique = 10,
		CannotTargetLimitedUseFollower = 11,
		MustTargetLimitedUseFollower = 12,
		AlreadyAtMaxDurability = 13,
		CannotTargetNonAutoMissionFollower = 14,
	},
	---@class GarrAutoBoardIndex
	GarrAutoBoardIndex = {
		None = -1,
		AllyLeftBack = 0,
		AllyRightBack = 1,
		AllyLeftFront = 2,
		AllyCenterFront = 3,
		AllyRightFront = 4,
		EnemyLeftFront = 5,
		EnemyCenterLeftFront = 6,
		EnemyCenterRightFront = 7,
		EnemyRightFront = 8,
		EnemyLeftBack = 9,
		EnemyCenterLeftBack = 10,
		EnemyCenterRightBack = 11,
		EnemyRightBack = 12,
	},
	---@class GarrAutoCombatSpellTutorialFlag
	GarrAutoCombatSpellTutorialFlag = {
		None = 0,
		Single = 1,
		Column = 2,
		Row = 3,
		All = 4,
	},
	---@class GarrAutoCombatTutorial
	GarrAutoCombatTutorial = {
		SelectMission = 1,
		PlaceCompanion = 2,
		HealCompanion = 4,
		LevelHeal = 8,
		BeneficialEffect = 16,
		AttackSingle = 32,
		AttackColumn = 64,
		AttackRow = 128,
		AttackAll = 256,
		TroopTutorial = 512,
		EnvironmentalEffect = 1024,
	},
	---@class GarrAutoCombatantRole
	GarrAutoCombatantRole = {
		None = 0,
		Melee = 1,
		RangedPhysical = 2,
		RangedMagic = 3,
		HealSupport = 4,
		Tank = 5,
	},
	---@class GarrAutoEventFlags
	GarrAutoEventFlags = {
		None = 0,
		AutoAttack = 1,
		Passive = 2,
		Environment = 4,
	},
	---@class GarrAutoMissionEventType
	GarrAutoMissionEventType = {
		MeleeDamage = 0,
		RangeDamage = 1,
		SpellMeleeDamage = 2,
		SpellRangeDamage = 3,
		Heal = 4,
		PeriodicDamage = 5,
		PeriodicHeal = 6,
		ApplyAura = 7,
		RemoveAura = 8,
		Died = 9,
	},
	---@class GarrAutoPreviewTargetType
	GarrAutoPreviewTargetType = {
		None = 0,
		Damage = 1,
		Heal = 2,
		Buff = 4,
		Debuff = 8,
	},
	---@class GarrFollowerMissionCompleteState
	GarrFollowerMissionCompleteState = {
		Alive = 0,
		KilledByMissionFailure = 1,
		SavedByPreventDeath = 2,
		OutOfDurability = 3,
	},
	---@class GarrFollowerQuality
	GarrFollowerQuality = {
		None = 0,
		Common = 1,
		Uncommon = 2,
		Rare = 3,
		Epic = 4,
		Legendary = 5,
		Title = 6,
	},
	---@class GarrTalentCostType
	GarrTalentCostType = {
		Initial = 0,
		Respec = 1,
		MakePermanent = 2,
		TreeReset = 3,
	},
	---@class GarrTalentFeatureSubtype
	GarrTalentFeatureSubtype = {
		Generic = 0,
		Bastion = 1,
		Revendreth = 2,
		Ardenweald = 3,
		Maldraxxus = 4,
	},
	---@class GarrTalentFeatureType
	GarrTalentFeatureType = {
		Generic = 0,
		AnimaDiversion = 1,
		TravelPortals = 2,
		Adventures = 3,
		ReservoirUpgrades = 4,
		SanctumUnique = 5,
		SoulBinds = 6,
		AnimaDiversionMap = 7,
		Cyphers = 8,
	},
	---@class GarrTalentResearchCostSource
	GarrTalentResearchCostSource = {
		Talent = 0,
		Tree = 1,
	},
	---@class GarrTalentSocketType
	GarrTalentSocketType = {
		None = 0,
		Spell = 1,
		Conduit = 2,
	},
	---@class GarrTalentTreeType
	GarrTalentTreeType = {
		Tiers = 0,
		Classic = 1,
	},
	---@class GarrTalentType
	GarrTalentType = {
		Standard = 0,
		Minor = 1,
		Major = 2,
		Socket = 3,
	},
	---@class GarrTalentUI
	GarrTalentUI = {
		Generic = 0,
		CovenantSanctum = 1,
		SoulBinds = 2,
		AnimaDiversionMap = 3,
	},
	---@class GarrisonFollowerType
	GarrisonFollowerType = {
		FollowerType_6_0 = 1,
		FollowerType_6_2 = 2,
		FollowerType_7_0 = 4,
		FollowerType_8_0 = 22,
		FollowerType_9_0 = 123,
	},
	---@class GarrisonTalentAvailability
	GarrisonTalentAvailability = {
		Available = 0,
		Unavailable = 1,
		UnavailableAnotherIsResearching = 2,
		UnavailableNotEnoughResources = 3,
		UnavailableNotEnoughGold = 4,
		UnavailableTierUnavailable = 5,
		UnavailablePlayerCondition = 6,
		UnavailableAlreadyHave = 7,
		UnavailableRequiresPrerequisiteTalent = 8,
	},
	---@class GarrisonType
	GarrisonType = {
		Type_6_0 = 2,
		Type_7_0 = 3,
		Type_8_0 = 9,
		Type_9_0 = 111,
	},
	---@class GossipOptionRewardType
	GossipOptionRewardType = {
		Item = 0,
		Currency = 1,
	},
	---@class GossipOptionStatus
	GossipOptionStatus = {
		Available = 0,
		Unavailable = 1,
		Locked = 2,
		AlreadyComplete = 3,
	},
	---@class HolidayCalendarFlags
	HolidayCalendarFlags = {
		Alliance = 1,
		Horde = 2,
	},
	---@class HolidayFlags
	HolidayFlags = {
		IsRegionwide = 1,
		DontShowInCalendar = 2,
		DontDisplayEnd = 4,
		DontDisplayBanner = 8,
		NotAvailableClientSide = 16,
	},
	---@class IconAndTextWidgetState
	IconAndTextWidgetState = {
		Hidden = 0,
		Shown = 1,
		ShownWithDynamicIconFlashing = 2,
		ShownWithDynamicIconNotFlashing = 3,
	},
	---@class IconState
	IconState = {
		Hidden = 0,
		ShowState1 = 1,
		ShowState2 = 2,
	},
	---@class InputContext
	InputContext = {
		None = 0,
		Keyboard = 1,
		Mouse = 2,
		GamePad = 3,
	},
	---@class InventoryType
	InventoryType = {
		IndexNonEquipType = 0,
		IndexHeadType = 1,
		IndexNeckType = 2,
		IndexShoulderType = 3,
		IndexBodyType = 4,
		IndexChestType = 5,
		IndexWaistType = 6,
		IndexLegsType = 7,
		IndexFeetType = 8,
		IndexWristType = 9,
		IndexHandType = 10,
		IndexFingerType = 11,
		IndexTrinketType = 12,
		IndexWeaponType = 13,
		IndexShieldType = 14,
		IndexRangedType = 15,
		IndexCloakType = 16,
		Index2HweaponType = 17,
		IndexBagType = 18,
		IndexTabardType = 19,
		IndexRobeType = 20,
		IndexWeaponmainhandType = 21,
		IndexWeaponoffhandType = 22,
		IndexHoldableType = 23,
		IndexAmmoType = 24,
		IndexThrownType = 25,
		IndexRangedrightType = 26,
		IndexQuiverType = 27,
		IndexRelicType = 28,
	},
	---@class ItemArmorSubclass
	ItemArmorSubclass = {
		Generic = 0,
		Cloth = 1,
		Leather = 2,
		Mail = 3,
		Plate = 4,
		Cosmetic = 5,
		Shield = 6,
		Libram = 7,
		Idol = 8,
		Totem = 9,
		Sigil = 10,
		Relic = 11,
	},
	---@class ItemClass
	ItemClass = {
		Consumable = 0,
		Container = 1,
		Weapon = 2,
		Gem = 3,
		Armor = 4,
		Reagent = 5,
		Projectile = 6,
		Tradegoods = 7,
		ItemEnhancement = 8,
		Recipe = 9,
		CurrencyTokenObsolete = 10,
		Quiver = 11,
		Questitem = 12,
		Key = 13,
		PermanentObsolete = 14,
		Miscellaneous = 15,
		Glyph = 16,
		Battlepet = 17,
		WoWToken = 18,
	},
	---@class ItemCommodityStatus
	ItemCommodityStatus = {
		Unknown = 0,
		Item = 1,
		Commodity = 2,
	},
	---@class ItemConsumableSubclass
	ItemConsumableSubclass = {
		Generic = 0,
		Potion = 1,
		Elixir = 2,
		Scroll = 3,
		Fooddrink = 4,
		Itemenhancement = 5,
		Bandage = 6,
		Other = 7,
	},
	---@class ItemGemSubclass
	ItemGemSubclass = {
		Intellect = 0,
		Agility = 1,
		Strength = 2,
		Stamina = 3,
		Spirit = 4,
		Criticalstrike = 5,
		Mastery = 6,
		Haste = 7,
		Versatility = 8,
		Other = 9,
		Multiplestats = 10,
		Artifactrelic = 11,
	},
	---@class ItemMiscellaneousSubclass
	ItemMiscellaneousSubclass = {
		Junk = 0,
		Reagent = 1,
		CompanionPet = 2,
		Holiday = 3,
		Other = 4,
		Mount = 5,
		MountEquipment = 6,
	},
	---@class ItemQuality
	ItemQuality = {
		Poor = 0,
		Common = 1,
		Uncommon = 2,
		Rare = 3,
		Epic = 4,
		Legendary = 5,
		Artifact = 6,
		Heirloom = 7,
		WoWToken = 8,
	},
	---@class ItemReagentSubclass
	ItemReagentSubclass = {
		Reagent = 0,
		Keystone = 1,
		ContextToken = 2,
	},
	---@class ItemRecipeSubclass
	ItemRecipeSubclass = {
		Book = 0,
		Leatherworking = 1,
		Tailoring = 2,
		Engineering = 3,
		Blacksmithing = 4,
		Cooking = 5,
		Alchemy = 6,
		FirstAid = 7,
		Enchanting = 8,
		Fishing = 9,
		Jewelcrafting = 10,
		Inscription = 11,
	},
	---@class ItemSlotFilterType
	ItemSlotFilterType = {
		Head = 0,
		Neck = 1,
		Shoulder = 2,
		Cloak = 3,
		Chest = 4,
		Wrist = 5,
		Hand = 6,
		Waist = 7,
		Legs = 8,
		Feet = 9,
		MainHand = 10,
		OffHand = 11,
		Finger = 12,
		Trinket = 13,
		Other = 14,
		NoFilter = 15,
	},
	---@class ItemTryOnReason
	ItemTryOnReason = {
		Success = 0,
		WrongRace = 1,
		NotEquippable = 2,
		DataPending = 3,
	},
	---@class ItemWeaponSubclass
	ItemWeaponSubclass = {
		Axe1H = 0,
		Axe2H = 1,
		Bows = 2,
		Guns = 3,
		Mace1H = 4,
		Mace2H = 5,
		Polearm = 6,
		Sword1H = 7,
		Sword2H = 8,
		Warglaive = 9,
		Staff = 10,
		Bearclaw = 11,
		Catclaw = 12,
		Unarmed = 13,
		Generic = 14,
		Dagger = 15,
		Thrown = 16,
		Obsolete3 = 17,
		Crossbow = 18,
		Wand = 19,
		Fishingpole = 20,
	},
	---@class Itemclassfilterflags
	Itemclassfilterflags = {
		Consumable = 1,
		Container = 2,
		Weapon = 4,
		Gem = 8,
		Armor = 16,
		Reagent = 32,
		Projectile = 64,
		Tradegoods = 128,
		ItemEnhancement = 256,
		Recipe = 512,
		CurrencyTokenObsolete = 1024,
		Quiver = 2048,
		Questitemclassfilterflags = 4096,
		Key = 8192,
		PermanentObsolete = 16384,
		Miscellaneous = 32768,
		Glyph = 65536,
		Battlepet = 131072,
	},
	---@class Itemsetflags
	Itemsetflags = {
		Legacy = 1,
		UseItemHistorySetSlots = 2,
		RequiresPvPTalentsActive = 4,
	},
	---@class JailersTowerType
	JailersTowerType = {
		TwistingCorridors = 0,
		SkoldusHalls = 1,
		FractureChambers = 2,
		Soulforges = 3,
		Coldheart = 4,
		Mortregar = 5,
		UpperReaches = 6,
		ArkobanHall = 7,
		TormentChamberJaina = 8,
		TormentChamberThrall = 9,
		TormentChamberAnduin = 10,
		AdamantVaults = 11,
		ForgottenCatacombs = 12,
		Ossuary = 13,
		BossRush = 14,
	},
	---@class LanguageFlag
	LanguageFlag = {
		IsExotic = 1,
		HiddenFromPlayer = 2,
	},
	---@class LfgEntryPlaystyle
	LfgEntryPlaystyle = {
		None = 0,
		Standard = 1,
		Casual = 2,
		Hardcore = 3,
	},
	---@class LfgListDisplayType
	LfgListDisplayType = {
		RoleCount = 0,
		RoleEnumerate = 1,
		ClassEnumerate = 2,
		HideAll = 3,
		PlayerCount = 4,
	},
	---@class LinkedCurrencyFlags
	LinkedCurrencyFlags = {
		IgnoreAdd = 1,
		IgnoreSubtract = 2,
		SuppressChatLog = 4,
	},
	---@class ManipulatorEventType
	ManipulatorEventType = {
		Start = 0,
		Move = 1,
		Complete = 2,
		Delete = 3,
	},
	---@class MapCanvasPosition
	MapCanvasPosition = {
		None = 0,
		BottomLeft = 1,
		BottomRight = 2,
		TopLeft = 3,
		TopRight = 4,
	},
	---@class MapOverlayDisplayLocation
	MapOverlayDisplayLocation = {
		Default = 0,
		BottomLeft = 1,
		TopLeft = 2,
		BottomRight = 3,
		TopRight = 4,
		Hidden = 5,
	},
	---@class ModelSceneSetting
	ModelSceneSetting = {
		AlignLightToOrbitDelta = 1,
	},
	---@class ModelSceneType
	ModelSceneType = {
		MountJournal = 0,
		PetJournalCard = 1,
		ShopCard = 2,
		EncounterJournal = 3,
		PetJournalLoadout = 4,
		ArtifactTier2 = 5,
		ArtifactTier2ForgingScene = 6,
		ArtifactTier2SlamEffect = 7,
		CommentatorVictoryFanfare = 8,
		ArtifactRelicTalentEffect = 9,
		PvPWarModeOrb = 10,
		PvPWarModeFire = 11,
		PartyPose = 12,
		AzeriteItemLevelUpToast = 13,
		AzeritePowers = 14,
		AzeriteRewardGlow = 15,
		HeartOfAzeroth = 16,
		WorldMapThreat = 17,
		Soulbinds = 18,
		JailersTowerAnimaGlow = 19,
	},
	---@class MountType
	MountType = {
		Ground = 0,
		Flying = 1,
		Aquatic = 2,
	},
	---@class MountTypeFlag
	MountTypeFlag = {
		IsFlyingMount = 1,
		IsAquaticMount = 2,
	},
	---@class NavigationState
	NavigationState = {
		Invalid = 0,
		Occluded = 1,
		InRange = 2,
	},
	---@class OptionalReagentItemFlag
	OptionalReagentItemFlag = {
		TooltipShowsAsStatModifications = 0,
	},
	---@class PartyRequestJoinRelation
	PartyRequestJoinRelation = {
		None = 0,
		Friend = 1,
		Guild = 2,
		Club = 3,
		NumPartyRequestJoinRelations = 4,
	},
	---@class PermanentChatChannelType
	PermanentChatChannelType = {
		None = 0,
		Zone = 1,
		Communities = 2,
		Custom = 3,
	},
	---@class PetJournalError
	PetJournalError = {
		None = 0,
		PetIsDead = 1,
		JournalIsLocked = 2,
		InvalidFaction = 3,
		NoFavoritesToSummon = 4,
		NoValidRandomSummon = 5,
		InvalidCovenant = 6,
	},
	---@class PetbattleAuraStateFlags
	PetbattleAuraStateFlags = {
		None = 0,
		Infinite = 1,
		Canceled = 2,
		InitDisabled = 4,
		CountdownFirstRound = 8,
		JustApplied = 16,
		RemoveEventHandled = 32,
	},
	---@class PetbattleCheatFlags
	PetbattleCheatFlags = {
		None = 0,
		AutoPlay = 1,
	},
	---@class PetbattleEffectFlags
	PetbattleEffectFlags = {
		None = 0,
		InvalidTarget = 1,
		Miss = 2,
		Crit = 4,
		Blocked = 8,
		Dodge = 16,
		Heal = 32,
		Unkillable = 64,
		Reflect = 128,
		Absorb = 256,
		Immune = 512,
		Strong = 1024,
		Weak = 2048,
		SuccessChain = 4096,
		AuraReapply = 8192,
	},
	---@class PetbattleEffectType
	PetbattleEffectType = {
		SetHealth = 0,
		AuraApply = 1,
		AuraCancel = 2,
		AuraChange = 3,
		PetSwap = 4,
		StatusChange = 5,
		SetState = 6,
		SetMaxHealth = 7,
		SetSpeed = 8,
		SetPower = 9,
		TriggerAbility = 10,
		AbilityChange = 11,
		NpcEmote = 12,
		AuraProcessingBegin = 13,
		AuraProcessingEnd = 14,
		ReplacePet = 15,
		OverrideAbility = 16,
		WorldStateUpdate = 17,
	},
	---@class PetbattleEnviros
	PetbattleEnviros = {
		Pad0 = 0,
		Pad1 = 1,
		Weather = 2,
	},
	---@class PetbattleInputMoveMsgDebugFlag
	PetbattleInputMoveMsgDebugFlag = {
		None = 0,
		DontValidate = 1,
		EnemyCast = 2,
	},
	---@class PetbattleMoveType
	PetbattleMoveType = {
		Quit = 0,
		Ability = 1,
		Swap = 2,
		Trap = 3,
		FinalRoundOk = 4,
		Pass = 5,
	},
	---@class PetbattlePboid
	PetbattlePboid = {
		P0Pet_0 = 0,
		P0Pet_1 = 1,
		P0Pet_2 = 2,
		P1Pet_0 = 3,
		P1Pet_1 = 4,
		P1Pet_2 = 5,
		EnvPad_0 = 6,
		EnvPad_1 = 7,
		EnvWeather = 8,
	},
	---@class PetbattlePetStatus
	PetbattlePetStatus = {
		FlagNone = 0,
		FlagTrapped = 1,
		Stunned = 2,
		SwapOutLocked = 4,
		SwapInLocked = 8,
	},
	---@class PetbattlePlayer
	PetbattlePlayer = {
		Player_0 = 0,
		Player_1 = 1,
	},
	---@class PetbattlePlayerInputFlags
	PetbattlePlayerInputFlags = {
		None = 0,
		TurnInProgress = 1,
		AbilityLocked = 2,
		SwapLocked = 4,
		WaitingForPet = 8,
	},
	---@class PetbattleResult
	PetbattleResult = {
		FailUnknown = 0,
		FailNotHere = 1,
		FailNotHereOnTransport = 2,
		FailNotHereUnevenGround = 3,
		FailNotHereObstructed = 4,
		FailNotWhileInCombat = 5,
		FailNotWhileDead = 6,
		FailNotWhileFlying = 7,
		FailTargetInvalid = 8,
		FailTargetOutOfRange = 9,
		FailTargetNotCapturable = 10,
		FailNotATrainer = 11,
		FailDeclined = 12,
		FailInBattle = 13,
		FailInvalidLoadout = 14,
		FailInvalidLoadoutAllDead = 15,
		FailInvalidLoadoutNoneSlotted = 16,
		FailNoJournalLock = 17,
		FailWildPetTapped = 18,
		FailRestrictedAccount = 19,
		FailOpponentNotAvailable = 20,
		FailLogout = 21,
		FailDisconnect = 22,
		Success = 23,
	},
	---@class PetbattleSlot
	PetbattleSlot = {
		Slot_0 = 0,
		Slot_1 = 1,
		Slot_2 = 2,
	},
	---@class PetbattleSlotAbility
	PetbattleSlotAbility = {
		Ability_0 = 0,
		Ability_1 = 1,
		Ability_2 = 2,
	},
	---@class PetbattleSlotResult
	PetbattleSlotResult = {
		Success = 0,
		SlotLocked = 1,
		SlotEmpty = 2,
		NoTracker = 3,
		NoSpeciesRec = 4,
		CantBattle = 5,
		Revoked = 6,
		Dead = 7,
		NoPet = 8,
	},
	---@class PetbattleState
	PetbattleState = {
		Created = 0,
		WaitingPreBattle = 1,
		RoundInProgress = 2,
		WaitingForFrontPets = 3,
		CreatedFailed = 4,
		FinalRound = 5,
		Finished = 6,
	},
	---@class PetbattleTrapstatus
	PetbattleTrapstatus = {
		Invalid = 0,
		CanTrap = 1,
		CantTrapNewbie = 2,
		CantTrapPetDead = 3,
		CantTrapPetHealth = 4,
		CantTrapNoRoomInJournal = 5,
		CantTrapPetNotCapturable = 6,
		CantTrapTrainerBattle = 7,
		CantTrapTwice = 8,
	},
	---@class PetbattleType
	PetbattleType = {
		PvE = 0,
		PvP = 1,
		Lfpb = 2,
		Npc = 3,
	},
	---@class PhaseReason
	PhaseReason = {
		Phasing = 0,
		Sharding = 1,
		WarMode = 2,
		ChromieTime = 3,
	},
	---@class PlayerChoiceRarity
	PlayerChoiceRarity = {
		Common = 0,
		Uncommon = 1,
		Rare = 2,
		Epic = 3,
	},
	---@class PlayerClubRequestStatus
	PlayerClubRequestStatus = {
		None = 0,
		Pending = 1,
		AutoApproved = 2,
		Declined = 3,
		Approved = 4,
		Joined = 5,
		JoinedAnother = 6,
		Canceled = 7,
	},
	---@class PlayerCurrencyFlags
	PlayerCurrencyFlags = {
		Incremented = 1,
		Loading = 2,
	},
	---@class PlayerCurrencyFlagsDbFlags
	PlayerCurrencyFlagsDbFlags = {
		IgnoreMaxQtyOnload = 1,
		Reuse1 = 2,
		InBackpack = 4,
		UnusedInUI = 8,
		Reuse2 = 16,
	},
	---@class PlayerMentorshipApplicationResult
	PlayerMentorshipApplicationResult = {
		Success = 0,
		AlreadyMentor = 1,
		Ineligible = 2,
	},
	---@class PlayerMentorshipStatus
	PlayerMentorshipStatus = {
		None = 0,
		Newcomer = 1,
		Mentor = 2,
	},
	---@class PowerType
	PowerType = {
		HealthCost = -2,
		None = -1,
		Mana = 0,
		Rage = 1,
		Focus = 2,
		Energy = 3,
		ComboPoints = 4,
		Runes = 5,
		RunicPower = 6,
		SoulShards = 7,
		LunarPower = 8,
		HolyPower = 9,
		Alternate = 10,
		Maelstrom = 11,
		Chi = 12,
		Insanity = 13,
		Obsolete = 14,
		Obsolete2 = 15,
		ArcaneCharges = 16,
		Fury = 17,
		Pain = 18,
		NumPowerTypes = 19,
	},
	---@class PvPMatchState
	PvPMatchState = {
		Inactive = 0,
		Active = 1,
		Complete = 2,
	},
	---@class PvPUnitClassification
	PvPUnitClassification = {
		FlagCarrierHorde = 0,
		FlagCarrierAlliance = 1,
		FlagCarrierNeutral = 2,
		CartRunnerHorde = 3,
		CartRunnerAlliance = 4,
		AssassinHorde = 5,
		AssassinAlliance = 6,
		OrbCarrierBlue = 7,
		OrbCarrierGreen = 8,
		OrbCarrierOrange = 9,
		OrbCarrierPurple = 10,
	},
	---@class QuestFrequency
	QuestFrequency = {
		Default = 0,
		Daily = 1,
		Weekly = 2,
	},
	---@class QuestLineFloorLocation
	QuestLineFloorLocation = {
		Above = 0,
		Below = 1,
		Same = 2,
	},
	---@class QuestPOIQuestTypes
	QuestPOIQuestTypes = {
		Normal = 1,
		Campaign = 2,
		Calling = 3,
	},
	---@class QuestSessionCommand
	QuestSessionCommand = {
		None = 0,
		Start = 1,
		Stop = 2,
		SessionActiveNoCommand = 3,
	},
	---@class QuestSessionResult
	QuestSessionResult = {
		Ok = 0,
		NotInParty = 1,
		InvalidOwner = 2,
		AlreadyActive = 3,
		NotActive = 4,
		InRaid = 5,
		OwnerRefused = 6,
		Timeout = 7,
		Disabled = 8,
		Started = 9,
		Stopped = 10,
		Joined = 11,
		Left = 12,
		OwnerLeft = 13,
		ReadyCheckFailed = 14,
		PartyDestroyed = 15,
		MemberTimeout = 16,
		AlreadyMember = 17,
		NotOwner = 18,
		AlreadyOwner = 19,
		AlreadyJoined = 20,
		NotMember = 21,
		Busy = 22,
		JoinRejected = 23,
		Logout = 24,
		Empty = 25,
		QuestNotCompleted = 26,
		Resync = 27,
		Restricted = 28,
		InPetBattle = 29,
		InvalidPublicParty = 30,
		Unknown = 31,
		InCombat = 32,
		MemberInCombat = 33,
	},
	---@class QuestTag
	QuestTag = {
		Group = 1,
		PvP = 41,
		Raid = 62,
		Dungeon = 81,
		Legendary = 83,
		Heroic = 85,
		Raid10 = 88,
		Raid25 = 89,
		Scenario = 98,
		Account = 102,
		CombatAlly = 266,
	},
	---@class QuestTagType
	QuestTagType = {
		Tag = 0,
		Profession = 1,
		Normal = 2,
		PvP = 3,
		PetBattle = 4,
		Bounty = 5,
		Dungeon = 6,
		Invasion = 7,
		Raid = 8,
		Contribution = 9,
		RatedReward = 10,
		InvasionWrapper = 11,
		FactionAssault = 12,
		Islands = 13,
		Threat = 14,
		CovenantCalling = 15,
	},
	---@class QuestWatchType
	QuestWatchType = {
		Automatic = 0,
		Manual = 1,
	},
	---@class RafLinkType
	RafLinkType = {
		None = 0,
		Recruit = 1,
		Friend = 2,
		Both = 3,
	},
	---@class RafRecruitActivityState
	RafRecruitActivityState = {
		Incomplete = 0,
		Complete = 1,
		RewardClaimed = 2,
	},
	---@class RafRecruitSubStatus
	RafRecruitSubStatus = {
		Trial = 0,
		Active = 1,
		Inactive = 2,
	},
	---@class RafRewardType
	RafRewardType = {
		Pet = 0,
		Mount = 1,
		Appearance = 2,
		Title = 3,
		GameTime = 4,
		AppearanceSet = 5,
		Illusion = 6,
		Invalid = 7,
	},
	---@class RelativeContentDifficulty
	RelativeContentDifficulty = {
		Trivial = 0,
		Easy = 1,
		Fair = 2,
		Difficult = 3,
		Impossible = 4,
	},
	---@class RuneforgePowerFilter
	RuneforgePowerFilter = {
		All = 0,
		Relevant = 1,
		Available = 2,
		Unavailable = 3,
	},
	---@class RuneforgePowerState
	RuneforgePowerState = {
		Available = 0,
		Unavailable = 1,
		Invalid = 2,
	},
	---@class ScriptedAnimationBehavior
	ScriptedAnimationBehavior = {
		None = 0,
		TargetShake = 1,
		TargetKnockBack = 2,
		SourceRecoil = 3,
		SourceCollideWithTarget = 4,
		UIParentShake = 5,
	},
	---@class ScriptedAnimationFlags
	ScriptedAnimationFlags = {
		UseTargetAsSource = 1,
	},
	---@class ScriptedAnimationTrajectory
	ScriptedAnimationTrajectory = {
		AtSource = 0,
		AtTarget = 1,
		Straight = 2,
		CurveLeft = 3,
		CurveRight = 4,
		CurveRandom = 5,
		HalfwayBetween = 6,
	},
	---@class SelfResurrectOptionType
	SelfResurrectOptionType = {
		Spell = 0,
		Item = 1,
	},
	---@class SkinningState
	SkinningState = {
		None = 0,
		Reserved = 1,
		Skinning = 2,
		Looting = 3,
		Skinned = 4,
	},
	---@class SoulbindConduitFlags
	SoulbindConduitFlags = {
		VisibleToGetallsoulbindconduitScript = 1,
	},
	---@class SoulbindConduitInstallResult
	SoulbindConduitInstallResult = {
		Success = 0,
		InvalidItem = 1,
		InvalidConduit = 2,
		InvalidTalent = 3,
		DuplicateConduit = 4,
		ForgeNotInProximity = 5,
		SocketNotEmpty = 6,
	},
	---@class SoulbindConduitTransactionType
	SoulbindConduitTransactionType = {
		Install = 0,
		Uninstall = 1,
	},
	---@class SoulbindConduitType
	SoulbindConduitType = {
		Finesse = 0,
		Potency = 1,
		Endurance = 2,
		Flex = 3,
	},
	---@class SoulbindNodeState
	SoulbindNodeState = {
		Unavailable = 0,
		Unselected = 1,
		Selectable = 2,
		Selected = 3,
	},
	---@class SpellDisplayIconDisplayType
	SpellDisplayIconDisplayType = {
		Buff = 0,
		Debuff = 1,
		Circular = 2,
		NoBorder = 3,
	},
	---@class SpellDisplayIconSizeType
	SpellDisplayIconSizeType = {
		Small = 0,
		Medium = 1,
		Large = 2,
	},
	---@class SpellDisplayTextShownStateType
	SpellDisplayTextShownStateType = {
		Shown = 0,
		Hidden = 1,
	},
	---@class SplashScreenType
	SplashScreenType = {
		WhatsNew = 0,
		SeasonRollOver = 1,
	},
	---@class StatusBarColorTintValue
	StatusBarColorTintValue = {
		None = 0,
		Black = 1,
		White = 2,
		Red = 3,
		Yellow = 4,
		Orange = 5,
		Purple = 6,
		Green = 7,
		Blue = 8,
	},
	---@class StatusBarOverrideBarTextShownType
	StatusBarOverrideBarTextShownType = {
		Never = 0,
		Always = 1,
		OnlyOnMouseover = 2,
		OnlyNotOnMouseover = 3,
	},
	---@class StatusBarValueTextType
	StatusBarValueTextType = {
		Hidden = 0,
		Percentage = 1,
		Value = 2,
		Time = 3,
		TimeShowOneLevelOnly = 4,
		ValueOverMax = 5,
		ValueOverMaxNormalized = 6,
	},
	---@class SubscriptionInterstitialResponseType
	SubscriptionInterstitialResponseType = {
		Clicked = 0,
		Closed = 1,
		WebRedirect = 2,
	},
	---@class SubscriptionInterstitialType
	SubscriptionInterstitialType = {
		Standard = 0,
		LeftNpeArea = 1,
		MaxLevel = 2,
	},
	---@class SummonStatus
	SummonStatus = {
		None = 0,
		Pending = 1,
		Accepted = 2,
		Declined = 3,
	},
	---@class SuperTrackingType
	SuperTrackingType = {
		Quest = 0,
		UserWaypoint = 1,
		Corpse = 2,
		Scenario = 3,
	},
	---@class TooltipSide
	TooltipSide = {
		Left = 0,
		Right = 1,
		Top = 2,
		Bottom = 3,
	},
	---@class TooltipTextureAnchor
	TooltipTextureAnchor = {
		LeftTop = 0,
		LeftCenter = 1,
		LeftBottom = 2,
		RightTop = 3,
		RightCenter = 4,
		RightBottom = 5,
		All = 6,
	},
	---@class TooltipTextureRelativeRegion
	TooltipTextureRelativeRegion = {
		LeftLine = 0,
		RightLine = 1,
	},
	---@class TrackedSpellCategory
	TrackedSpellCategory = {
		Offensive = 0,
		Defensive = 1,
		Debuff = 2,
		Count = 3,
	},
	---@class TransmogCameraVariation
	TransmogCameraVariation = {
		None = 0,
		CloakBackpack = 1,
		RightShoulder = 1,
	},
	---@class TransmogCollectionType
	TransmogCollectionType = {
		None = 0,
		Head = 1,
		Shoulder = 2,
		Back = 3,
		Chest = 4,
		Shirt = 5,
		Tabard = 6,
		Wrist = 7,
		Hands = 8,
		Waist = 9,
		Legs = 10,
		Feet = 11,
		Wand = 12,
		OneHAxe = 13,
		OneHSword = 14,
		OneHMace = 15,
		Dagger = 16,
		Fist = 17,
		Shield = 18,
		Holdable = 19,
		TwoHAxe = 20,
		TwoHSword = 21,
		TwoHMace = 22,
		Staff = 23,
		Polearm = 24,
		Bow = 25,
		Gun = 26,
		Crossbow = 27,
		Warglaives = 28,
		Paired = 29,
	},
	---@class TransmogIllisionFlags
	TransmogIllisionFlags = {
		HideUntilCollected = 1,
		PlayerConditionGrantsOnLogin = 2,
	},
	---@class TransmogModification
	TransmogModification = {
		Main = 0,
		Secondary = 1,
	},
	---@class TransmogPendingType
	TransmogPendingType = {
		Apply = 0,
		Revert = 1,
		ToggleOn = 2,
		ToggleOff = 3,
	},
	---@class TransmogSearchType
	TransmogSearchType = {
		Items = 1,
		BaseSets = 2,
		UsableSets = 3,
	},
	---@class TransmogSlot
	TransmogSlot = {
		Head = 0,
		Shoulder = 1,
		Back = 2,
		Chest = 3,
		Body = 4,
		Tabard = 5,
		Wrist = 6,
		Hand = 7,
		Waist = 8,
		Legs = 9,
		Feet = 10,
		Mainhand = 11,
		Offhand = 12,
	},
	---@class TransmogSource
	TransmogSource = {
		None = 0,
		JournalEncounter = 1,
		Quest = 2,
		Vendor = 3,
		WorldDrop = 4,
		HiddenUntilCollected = 5,
		CantCollect = 6,
		Achievement = 7,
		Profession = 8,
		NotValidForTransmog = 9,
	},
	---@class TransmogType
	TransmogType = {
		Appearance = 0,
		Illusion = 1,
	},
	---@class TransmogUseErrorType
	TransmogUseErrorType = {
		None = 0,
		PlayerCondition = 1,
		Skill = 2,
		Ability = 3,
		Faction = 4,
		Holiday = 5,
		HotRecheckFailed = 6,
	},
	---@class TtsBoolSetting
	TtsBoolSetting = {
		PlaySoundSeparatingChatLineBreaks = 0,
		AddCharacterNameToSpeech = 1,
		PlayActivitySoundWhenNotFocused = 2,
		AlternateSystemVoice = 3,
		NarrateMyMessages = 4,
	},
	---@class TtsVoiceType
	TtsVoiceType = {
		Standard = 0,
		Alternate = 1,
	},
	---@class UICursorType
	UICursorType = {
		Default = 0,
		Item = 1,
		Money = 2,
		Spell = 3,
		PetAction = 4,
		Merchant = 5,
		ActionBar = 6,
		Macro = 7,
		AmmoObsolete = 9,
		Pet = 10,
		GuildBank = 11,
		GuildBankMoney = 12,
		EquipmentSet = 13,
		Currency = 14,
		Flyout = 15,
		VoidItem = 16,
		BattlePet = 17,
		Mount = 18,
		Toy = 19,
		CommunitiesStream = 20,
		ConduitCollectionItem = 21,
	},
	---@class UIFrameType
	UIFrameType = {
		JailersTowerBuffs = 0,
	},
	---@class UIItemInteractionFlags
	UIItemInteractionFlags = {
		DisplayWithInset = 1,
		ConfirmationHasDelay = 2,
		ConversionMode = 4,
		ClickShowsFlyout = 8,
	},
	---@class UIItemInteractionType
	UIItemInteractionType = {
		None = 0,
		CastSpell = 1,
		CleanseCorruption = 2,
		RunecarverScrapping = 3,
		ItemConversion = 4,
	},
	---@class UIMapFlag
	UIMapFlag = {
		NoHighlight = 1,
		ShowOverlays = 2,
		ShowTaxiNodes = 4,
		GarrisonMap = 8,
		FallbackToParentMap = 16,
		NoHighlightTexture = 32,
		ShowTaskObjectives = 64,
		NoWorldPositions = 128,
		HideArchaeologyDigs = 256,
		Deprecated = 512,
		HideIcons = 1024,
		HideVignettes = 2048,
		ForceAllOverlayExplored = 4096,
		FlightMapShowZoomOut = 8192,
		FlightMapAutoZoom = 16384,
		ForceOnNavbar = 32768,
		AlwaysAllowUserWaypoints = 65536,
	},
	---@class UIMapSystem
	UIMapSystem = {
		World = 0,
		Taxi = 1,
		Adventure = 2,
		Minimap = 3,
	},
	---@class UIMapType
	UIMapType = {
		Cosmic = 0,
		World = 1,
		Continent = 2,
		Zone = 3,
		Dungeon = 4,
		Micro = 5,
		Orphan = 6,
	},
	---@class UIWidgetBlendModeType
	UIWidgetBlendModeType = {
		Opaque = 0,
		Additive = 1,
	},
	---@class UIWidgetFlag
	UIWidgetFlag = {
		UniversalWidget = 1,
	},
	---@class UIWidgetFontType
	UIWidgetFontType = {
		Normal = 0,
		Shadow = 1,
		Outline = 2,
	},
	---@class UIWidgetLayoutDirection
	UIWidgetLayoutDirection = {
		Default = 0,
		Vertical = 1,
		Horizontal = 2,
		Overlap = 3,
		HorizontalForceNewRow = 4,
	},
	---@class UIWidgetModelSceneLayer
	UIWidgetModelSceneLayer = {
		None = 0,
		Front = 1,
		Back = 2,
	},
	---@class UIWidgetMotionType
	UIWidgetMotionType = {
		Instant = 0,
		Smooth = 1,
	},
	---@class UIWidgetScale
	UIWidgetScale = {
		OneHundred = 0,
		Ninty = 1,
		Eighty = 2,
		Seventy = 3,
		Sixty = 4,
		Fifty = 5,
	},
	---@class UIWidgetSetLayoutDirection
	UIWidgetSetLayoutDirection = {
		Vertical = 0,
		Horizontal = 1,
	},
	---@class UIWidgetTextSizeType
	UIWidgetTextSizeType = {
		Small = 0,
		Medium = 1,
		Large = 2,
		Huge = 3,
		Standard = 4,
	},
	---@class UIWidgetTooltipLocation
	UIWidgetTooltipLocation = {
		Default = 0,
		BottomLeft = 1,
		Left = 2,
		TopLeft = 3,
		Top = 4,
		TopRight = 5,
		Right = 6,
		BottomRight = 7,
		Bottom = 8,
	},
	---@class UIWidgetVisualizationType
	UIWidgetVisualizationType = {
		IconAndText = 0,
		CaptureBar = 1,
		StatusBar = 2,
		DoubleStatusBar = 3,
		IconTextAndBackground = 4,
		DoubleIconAndText = 5,
		StackedResourceTracker = 6,
		IconTextAndCurrencies = 7,
		TextWithState = 8,
		HorizontalCurrencies = 9,
		BulletTextList = 10,
		ScenarioHeaderCurrenciesAndBackground = 11,
		TextureAndText = 12,
		SpellDisplay = 13,
		DoubleStateIconRow = 14,
		TextureAndTextRow = 15,
		ZoneControl = 16,
		CaptureZone = 17,
		TextureWithAnimation = 18,
		DiscreteProgressSteps = 19,
		ScenarioHeaderTimer = 20,
		TextColumnRow = 21,
		Spacer = 22,
		UnitPowerBar = 23,
	},
	---@class UnitSex
	UnitSex = {
		Male = 0,
		Female = 1,
		None = 2,
		Both = 3,
	},
	---@class ValidateNameResult
	ValidateNameResult = {
		NameSuccess = 0,
		NameFailure = 1,
		NameNoName = 2,
		NameTooShort = 3,
		NameTooLong = 4,
		NameInvalidCharacter = 5,
		NameMixedLanguages = 6,
		NameProfane = 7,
		NameReserved = 8,
		NameInvalidApostrophe = 9,
		NameMultipleApostrophes = 10,
		NameThreeConsecutive = 11,
		NameInvalidSpace = 12,
		NameConsecutiveSpaces = 13,
		NameRussianConsecutiveSilentCharacters = 14,
		NameRussianSilentCharacterAtBeginningOrEnd = 15,
		NameDeclensionDoesntMatchBaseName = 16,
		NameSpacesDisallowed = 17,
	},
	---@class VasPurchaseProgress
	VasPurchaseProgress = {
		Invalid = 0,
		PrePurchase = 1,
		PaymentPending = 2,
		ApplyingLicense = 3,
		WaitingOnQueue = 4,
		Ready = 5,
		ProcessingFactionChange = 6,
		Complete = 7,
	},
	---@class VignetteType
	VignetteType = {
		Normal = 0,
		PvPBounty = 1,
		Torghast = 2,
		Treasure = 3,
	},
	---@class VoiceChannelErrorReason
	VoiceChannelErrorReason = {
		Unknown = 0,
		IsBattleNetChannel = 1,
	},
	---@class VoiceChatStatusCode
	VoiceChatStatusCode = {
		Success = 0,
		OperationPending = 1,
		TooManyRequests = 2,
		LoginProhibited = 3,
		ClientNotInitialized = 4,
		ClientNotLoggedIn = 5,
		ClientAlreadyLoggedIn = 6,
		ChannelNameTooShort = 7,
		ChannelNameTooLong = 8,
		ChannelAlreadyExists = 9,
		AlreadyInChannel = 10,
		TargetNotFound = 11,
		Failure = 12,
		ServiceLost = 13,
		UnableToLaunchProxy = 14,
		ProxyConnectionTimeOut = 15,
		ProxyConnectionUnableToConnect = 16,
		ProxyConnectionUnexpectedDisconnect = 17,
		Disabled = 18,
		UnsupportedChatChannelType = 19,
		InvalidCommunityStream = 20,
		PlayerSilenced = 21,
		PlayerVoiceChatParentalDisabled = 22,
		InvalidInputDevice = 23,
		InvalidOutputDevice = 24,
	},
	---@class VoiceTtsDestination
	VoiceTtsDestination = {
		RemoteTransmission = 0,
		LocalPlayback = 1,
		RemoteTransmissionWithLocalPlayback = 2,
		QueuedRemoteTransmission = 3,
		QueuedLocalPlayback = 4,
		QueuedRemoteTransmissionWithLocalPlayback = 5,
		ScreenReader = 6,
	},
	---@class VoiceTtsStatusCode
	VoiceTtsStatusCode = {
		Success = 0,
		InvalidEngineType = 1,
		EngineAllocationFailed = 2,
		NotSupported = 3,
		MaxCharactersExceeded = 4,
		UtteranceBelowMinimumDuration = 5,
		InputTextEnqueued = 6,
		SdkNotInitialized = 7,
		DestinationQueueFull = 8,
		EnqueueNotNecessary = 9,
		UtteranceNotFound = 10,
		ManagerNotFound = 11,
		InvalidArgument = 12,
		InternalError = 13,
	},
	---@class WeeklyRewardChestThresholdType
	WeeklyRewardChestThresholdType = {
		None = 0,
		MythicPlus = 1,
		RankedPvP = 2,
		Raid = 3,
		AlsoReceive = 4,
		Concession = 5,
	},
	---@class WidgetAnimationType
	WidgetAnimationType = {
		None = 0,
		Fade = 1,
	},
	---@class WidgetCurrencyClass
	WidgetCurrencyClass = {
		Currency = 0,
		Item = 1,
	},
	---@class WidgetEnabledState
	WidgetEnabledState = {
		Disabled = 0,
		Enabled = 1,
		Red = 2,
		White = 3,
		Green = 4,
		Gold = 5,
		Black = 6,
	},
	---@class WidgetShownState
	WidgetShownState = {
		Hidden = 0,
		Shown = 1,
	},
	---@class WidgetTextHorizontalAlignmentType
	WidgetTextHorizontalAlignmentType = {
		Left = 0,
		Center = 1,
		Right = 2,
	},
	---@class WidgetUnitPowerBarFlashMomentType
	WidgetUnitPowerBarFlashMomentType = {
		FlashWhenMax = 0,
		FlashWhenMin = 1,
		NeverFlash = 2,
	},
	---@class WoWEntitlementType
	WoWEntitlementType = {
		Item = 0,
		Mount = 1,
		Battlepet = 2,
		Toy = 3,
		Appearance = 4,
		AppearanceSet = 5,
		GameTime = 6,
		Title = 7,
		Illusion = 8,
		Invalid = 9,
	},
	---@class WorldQuestQuality
	WorldQuestQuality = {
		Common = 0,
		Rare = 1,
		Epic = 2,
	},
	---@class ZoneControlActiveState
	ZoneControlActiveState = {
		Inactive = 0,
		Active = 1,
	},
	---@class ZoneControlDangerFlashType
	ZoneControlDangerFlashType = {
		ShowOnGoodStates = 0,
		ShowOnBadStates = 1,
		ShowOnBoth = 2,
		ShowOnNeither = 3,
	},
	---@class ZoneControlFillType
	ZoneControlFillType = {
		SingleFillClockwise = 0,
		SingleFillCounterClockwise = 1,
		DoubleFillClockwise = 2,
		DoubleFillCounterClockwise = 3,
	},
	---@class ZoneControlLeadingEdgeType
	ZoneControlLeadingEdgeType = {
		NoLeadingEdge = 0,
		UseLeadingEdge = 1,
	},
	---@class ZoneControlMode
	ZoneControlMode = {
		BothStatesAreGood = 0,
		State1IsGood = 1,
		State2IsGood = 2,
		NeitherStateIsGood = 3,
	},
	---@class ZoneControlState
	ZoneControlState = {
		State1 = 0,
		State2 = 1,
	},
}

Constants = {
	Callings = {
		MaxCallings = 3,
	},
	CurrencyConsts = {
		HONOR_PER_CURRENCY = 10,
		PLAYER_CURRENCY_CLIENT_FLAGS = 12,
		CONQUEST_ARENA_AND_BG_META_CURRENCY_ID = 483,
		CONQUEST_RATED_BG_META_CURRENCY_ID = 484,
		CONQUEST_ASHRAN_META_CURRENCY_ID = 692,
		ARTIFACT_KNOWLEDGE_CURRENCY_ID = 1171,
		WAR_RESOURCES_CURRENCY_ID = 1560,
		ACCOUNT_WIDE_HONOR_CURRENCY_ID = 1585,
		ACCOUNT_WIDE_HONOR_LEVEL_CURRENCY_ID = 1586,
		CONQUEST_CURRENCY_ID = 1602,
		HONOR_CURRENCY_ID = 1792,
		ECHOES_OF_NYALOTHA_CURRENCY_ID = 1803,
		CURRENCY_ID_WILLING_SOUL = 1810,
		CURRENCY_ID_RESERVOIR_ANIMA = 1813,
		CURRENCY_ID_RENOWN = 1822,
		CURRENCY_ID_RENOWN_KYRIAN = 1829,
		CURRENCY_ID_RENOWN_VENTHYR = 1830,
		CURRENCY_ID_RENOWN_NIGHT_FAE = 1831,
		CURRENCY_ID_RENOWN_NECROLORD = 1832,
		CLASSIC_ARENA_POINTS_CURRENCY_ID = 1900,
		CLASSIC_HONOR_CURRENCY_ID = 1901,
		QUESTIONMARK_INV_ICON = 134400,
		MAX_CURRENCY_QUANTITY = 100000000,
	},
	ITEM_WEAPON_SUBCLASSConstants = {
		ITEM_WEAPON_SUBCLASS_NONE = -1,
	},
	LevelConstsExposed = {
		MIN_RES_SICKNESS_LEVEL = 10,
	},
	ProfessionIDs = {
		PROFESSION_FIRST_AID = 129,
		PROFESSION_BLACKSMITHING = 164,
		PROFESSION_LEATHERWORKING = 165,
		PROFESSION_ALCHEMY = 171,
		PROFESSION_HERBALISM = 182,
		PROFESSION_COOKING = 185,
		PROFESSION_MINING = 186,
		PROFESSION_TAILORING = 197,
		PROFESSION_ENGINEERING = 202,
		PROFESSION_ENCHANTING = 333,
		PROFESSION_FISHING = 356,
		PROFESSION_SKINNING = 393,
		PROFESSION_JEWELCRAFTING = 755,
		PROFESSION_INSCRIPTION = 773,
		PROFESSION_ARCHAEOLOGY = 794,
	},
	PvpInfoConsts = {
		MaxPlayersPerInstance = 80,
	},
	QuestWatchConsts = {
		MAX_WORLD_QUEST_WATCHES_AUTOMATIC = 1,
		MAX_WORLD_QUEST_WATCHES_MANUAL = 5,
		MAX_QUEST_WATCHES = 25,
	},
	Transmog = {
		MainHandTransmogIsIndividualWeapon = -1,
		MainHandTransmogIsPairedWeapon = 0,
		NoTransmogID = 0,
	},
}
