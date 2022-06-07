---@meta
---@class real
---@class handle
---@class agent
---@class event
---@class player
---@class widget
---@class unit
---@class destructable
---@class item
---@class ability
---@class buff
---@class force
---@class group
---@class trigger
---@class triggercondition
---@class triggeraction
---@class timer
---@class location
---@class region
---@class rect
---@class boolexpr
---@class sound
---@class conditionfunc
---@class filterfunc
---@class unitpool
---@class itempool
---@class race
---@class alliancetype
---@class racepreference
---@class gamestate
---@class igamestate
---@class fgamestate
---@class playerstate
---@class playerscore
---@class playergameresult
---@class unitstate
---@class aidifficulty
---@class eventid
---@class gameevent
---@class playerevent
---@class playerunitevent
---@class unitevent
---@class limitop
---@class widgetevent
---@class dialogevent
---@class unittype
---@class gamespeed
---@class gamedifficulty
---@class gametype
---@class mapflag
---@class mapvisibility
---@class mapsetting
---@class mapdensity
---@class mapcontrol
---@class minimapicon
---@class playerslotstate
---@class volumegroup
---@class camerafield
---@class camerasetup
---@class playercolor
---@class placement
---@class startlocprio
---@class raritycontrol
---@class blendmode
---@class texmapflags
---@class effect
---@class effecttype
---@class weathereffect
---@class terraindeformation
---@class fogstate
---@class fogmodifier
---@class dialog
---@class button
---@class quest
---@class questitem
---@class defeatcondition
---@class timerdialog
---@class leaderboard
---@class multiboard
---@class multiboarditem
---@class trackable
---@class gamecache
---@class version
---@class itemtype
---@class texttag
---@class attacktype
---@class damagetype
---@class weapontype
---@class soundtype
---@class lightning
---@class pathingtype
---@class mousebuttontype
---@class animtype
---@class subanimtype
---@class image
---@class ubersplat
---@class hashtable
---@class framehandle
---@class originframetype
---@class framepointtype
---@class textaligntype
---@class frameeventtype
---@class oskeytype
---@class abilityintegerfield
---@class abilityrealfield
---@class abilitybooleanfield
---@class abilitystringfield
---@class abilityintegerlevelfield
---@class abilityreallevelfield
---@class abilitybooleanlevelfield
---@class abilitystringlevelfield
---@class abilityintegerlevelarrayfield
---@class abilityreallevelarrayfield
---@class abilitybooleanlevelarrayfield
---@class abilitystringlevelarrayfield
---@class unitintegerfield
---@class unitrealfield
---@class unitbooleanfield
---@class unitstringfield
---@class unitweaponintegerfield
---@class unitweaponrealfield
---@class unitweaponbooleanfield
---@class unitweaponstringfield
---@class itemintegerfield
---@class itemrealfield
---@class itembooleanfield
---@class itemstringfield
---@class movetype
---@class targetflag
---@class armortype
---@class heroattribute
---@class defensetype
---@class regentype
---@class unitcategory
---@class pathingflag
---@class commandbuttoneffect

---'common'
---@class common
---
---FALSE 'common.FALSE'
---@field FALSE	boolean	_false
---
---TRUE 'common.TRUE'
---@field TRUE	boolean	_true
---
---JASS_MAX_ARRAY_SIZE 'common.JASS_MAX_ARRAY_SIZE'
---@field JASS_MAX_ARRAY_SIZE	integer	_8192
---
---PLAYER_NEUTRAL_PASSIVE 'common.PLAYER_NEUTRAL_PASSIVE'
---@field PLAYER_NEUTRAL_PASSIVE	integer	_GetPlayerNeutralPassive()
---
---PLAYER_NEUTRAL_AGGRESSIVE 'common.PLAYER_NEUTRAL_AGGRESSIVE'
---@field PLAYER_NEUTRAL_AGGRESSIVE	integer	_GetPlayerNeutralAggressive()
---
---PLAYER_COLOR_RED 'common.PLAYER_COLOR_RED'
---@field PLAYER_COLOR_RED	playercolor	_ConvertPlayerColor(0)
---
---PLAYER_COLOR_BLUE 'common.PLAYER_COLOR_BLUE'
---@field PLAYER_COLOR_BLUE	playercolor	_ConvertPlayerColor(1)
---
---PLAYER_COLOR_CYAN 'common.PLAYER_COLOR_CYAN'
---@field PLAYER_COLOR_CYAN	playercolor	_ConvertPlayerColor(2)
---
---PLAYER_COLOR_PURPLE 'common.PLAYER_COLOR_PURPLE'
---@field PLAYER_COLOR_PURPLE	playercolor	_ConvertPlayerColor(3)
---
---PLAYER_COLOR_YELLOW 'common.PLAYER_COLOR_YELLOW'
---@field PLAYER_COLOR_YELLOW	playercolor	_ConvertPlayerColor(4)
---
---PLAYER_COLOR_ORANGE 'common.PLAYER_COLOR_ORANGE'
---@field PLAYER_COLOR_ORANGE	playercolor	_ConvertPlayerColor(5)
---
---PLAYER_COLOR_GREEN 'common.PLAYER_COLOR_GREEN'
---@field PLAYER_COLOR_GREEN	playercolor	_ConvertPlayerColor(6)
---
---PLAYER_COLOR_PINK 'common.PLAYER_COLOR_PINK'
---@field PLAYER_COLOR_PINK	playercolor	_ConvertPlayerColor(7)
---
---PLAYER_COLOR_LIGHT_GRAY 'common.PLAYER_COLOR_LIGHT_GRAY'
---@field PLAYER_COLOR_LIGHT_GRAY	playercolor	_ConvertPlayerColor(8)
---
---PLAYER_COLOR_LIGHT_BLUE 'common.PLAYER_COLOR_LIGHT_BLUE'
---@field PLAYER_COLOR_LIGHT_BLUE	playercolor	_ConvertPlayerColor(9)
---
---PLAYER_COLOR_AQUA 'common.PLAYER_COLOR_AQUA'
---@field PLAYER_COLOR_AQUA	playercolor	_ConvertPlayerColor(10)
---
---PLAYER_COLOR_BROWN 'common.PLAYER_COLOR_BROWN'
---@field PLAYER_COLOR_BROWN	playercolor	_ConvertPlayerColor(11)
---
---PLAYER_COLOR_MAROON 'common.PLAYER_COLOR_MAROON'
---@field PLAYER_COLOR_MAROON	playercolor	_ConvertPlayerColor(12)
---
---PLAYER_COLOR_NAVY 'common.PLAYER_COLOR_NAVY'
---@field PLAYER_COLOR_NAVY	playercolor	_ConvertPlayerColor(13)
---
---PLAYER_COLOR_TURQUOISE 'common.PLAYER_COLOR_TURQUOISE'
---@field PLAYER_COLOR_TURQUOISE	playercolor	_ConvertPlayerColor(14)
---
---PLAYER_COLOR_VIOLET 'common.PLAYER_COLOR_VIOLET'
---@field PLAYER_COLOR_VIOLET	playercolor	_ConvertPlayerColor(15)
---
---PLAYER_COLOR_WHEAT 'common.PLAYER_COLOR_WHEAT'
---@field PLAYER_COLOR_WHEAT	playercolor	_ConvertPlayerColor(16)
---
---PLAYER_COLOR_PEACH 'common.PLAYER_COLOR_PEACH'
---@field PLAYER_COLOR_PEACH	playercolor	_ConvertPlayerColor(17)
---
---PLAYER_COLOR_MINT 'common.PLAYER_COLOR_MINT'
---@field PLAYER_COLOR_MINT	playercolor	_ConvertPlayerColor(18)
---
---PLAYER_COLOR_LAVENDER 'common.PLAYER_COLOR_LAVENDER'
---@field PLAYER_COLOR_LAVENDER	playercolor	_ConvertPlayerColor(19)
---
---PLAYER_COLOR_COAL 'common.PLAYER_COLOR_COAL'
---@field PLAYER_COLOR_COAL	playercolor	_ConvertPlayerColor(20)
---
---PLAYER_COLOR_SNOW 'common.PLAYER_COLOR_SNOW'
---@field PLAYER_COLOR_SNOW	playercolor	_ConvertPlayerColor(21)
---
---PLAYER_COLOR_EMERALD 'common.PLAYER_COLOR_EMERALD'
---@field PLAYER_COLOR_EMERALD	playercolor	_ConvertPlayerColor(22)
---
---PLAYER_COLOR_PEANUT 'common.PLAYER_COLOR_PEANUT'
---@field PLAYER_COLOR_PEANUT	playercolor	_ConvertPlayerColor(23)
---
---RACE_HUMAN 'common.RACE_HUMAN'
---@field RACE_HUMAN	race	_ConvertRace(1)
---
---RACE_ORC 'common.RACE_ORC'
---@field RACE_ORC	race	_ConvertRace(2)
---
---RACE_UNDEAD 'common.RACE_UNDEAD'
---@field RACE_UNDEAD	race	_ConvertRace(3)
---
---RACE_NIGHTELF 'common.RACE_NIGHTELF'
---@field RACE_NIGHTELF	race	_ConvertRace(4)
---
---RACE_DEMON 'common.RACE_DEMON'
---@field RACE_DEMON	race	_ConvertRace(5)
---
---RACE_OTHER 'common.RACE_OTHER'
---@field RACE_OTHER	race	_ConvertRace(7)
---
---PLAYER_GAME_RESULT_VICTORY 'common.PLAYER_GAME_RESULT_VICTORY'
---@field PLAYER_GAME_RESULT_VICTORY	playergameresult	_ConvertPlayerGameResult(0)
---
---PLAYER_GAME_RESULT_DEFEAT 'common.PLAYER_GAME_RESULT_DEFEAT'
---@field PLAYER_GAME_RESULT_DEFEAT	playergameresult	_ConvertPlayerGameResult(1)
---
---PLAYER_GAME_RESULT_TIE 'common.PLAYER_GAME_RESULT_TIE'
---@field PLAYER_GAME_RESULT_TIE	playergameresult	_ConvertPlayerGameResult(2)
---
---PLAYER_GAME_RESULT_NEUTRAL 'common.PLAYER_GAME_RESULT_NEUTRAL'
---@field PLAYER_GAME_RESULT_NEUTRAL	playergameresult	_ConvertPlayerGameResult(3)
---
---ALLIANCE_PASSIVE 'common.ALLIANCE_PASSIVE'
---@field ALLIANCE_PASSIVE	alliancetype	_ConvertAllianceType(0)
---
---ALLIANCE_HELP_REQUEST 'common.ALLIANCE_HELP_REQUEST'
---@field ALLIANCE_HELP_REQUEST	alliancetype	_ConvertAllianceType(1)
---
---ALLIANCE_HELP_RESPONSE 'common.ALLIANCE_HELP_RESPONSE'
---@field ALLIANCE_HELP_RESPONSE	alliancetype	_ConvertAllianceType(2)
---
---ALLIANCE_SHARED_XP 'common.ALLIANCE_SHARED_XP'
---@field ALLIANCE_SHARED_XP	alliancetype	_ConvertAllianceType(3)
---
---ALLIANCE_SHARED_SPELLS 'common.ALLIANCE_SHARED_SPELLS'
---@field ALLIANCE_SHARED_SPELLS	alliancetype	_ConvertAllianceType(4)
---
---ALLIANCE_SHARED_VISION 'common.ALLIANCE_SHARED_VISION'
---@field ALLIANCE_SHARED_VISION	alliancetype	_ConvertAllianceType(5)
---
---ALLIANCE_SHARED_CONTROL 'common.ALLIANCE_SHARED_CONTROL'
---@field ALLIANCE_SHARED_CONTROL	alliancetype	_ConvertAllianceType(6)
---
---ALLIANCE_SHARED_ADVANCED_CONTROL 'common.ALLIANCE_SHARED_ADVANCED_CONTROL'
---@field ALLIANCE_SHARED_ADVANCED_CONTROL	alliancetype	_ConvertAllianceType(7)
---
---ALLIANCE_RESCUABLE 'common.ALLIANCE_RESCUABLE'
---@field ALLIANCE_RESCUABLE	alliancetype	_ConvertAllianceType(8)
---
---ALLIANCE_SHARED_VISION_FORCED 'common.ALLIANCE_SHARED_VISION_FORCED'
---@field ALLIANCE_SHARED_VISION_FORCED	alliancetype	_ConvertAllianceType(9)
---
---VERSION_REIGN_OF_CHAOS 'common.VERSION_REIGN_OF_CHAOS'
---@field VERSION_REIGN_OF_CHAOS	version	_ConvertVersion(0)
---
---VERSION_FROZEN_THRONE 'common.VERSION_FROZEN_THRONE'
---@field VERSION_FROZEN_THRONE	version	_ConvertVersion(1)
---
---ATTACK_TYPE_NORMAL 'common.ATTACK_TYPE_NORMAL'
---@field ATTACK_TYPE_NORMAL	attacktype	_ConvertAttackType(0)
---
---ATTACK_TYPE_MELEE 'common.ATTACK_TYPE_MELEE'
---@field ATTACK_TYPE_MELEE	attacktype	_ConvertAttackType(1)
---
---ATTACK_TYPE_PIERCE 'common.ATTACK_TYPE_PIERCE'
---@field ATTACK_TYPE_PIERCE	attacktype	_ConvertAttackType(2)
---
---ATTACK_TYPE_SIEGE 'common.ATTACK_TYPE_SIEGE'
---@field ATTACK_TYPE_SIEGE	attacktype	_ConvertAttackType(3)
---
---ATTACK_TYPE_MAGIC 'common.ATTACK_TYPE_MAGIC'
---@field ATTACK_TYPE_MAGIC	attacktype	_ConvertAttackType(4)
---
---ATTACK_TYPE_CHAOS 'common.ATTACK_TYPE_CHAOS'
---@field ATTACK_TYPE_CHAOS	attacktype	_ConvertAttackType(5)
---
---ATTACK_TYPE_HERO 'common.ATTACK_TYPE_HERO'
---@field ATTACK_TYPE_HERO	attacktype	_ConvertAttackType(6)
---
---DAMAGE_TYPE_UNKNOWN 'common.DAMAGE_TYPE_UNKNOWN'
---@field DAMAGE_TYPE_UNKNOWN	damagetype	_ConvertDamageType(0)
---
---DAMAGE_TYPE_NORMAL 'common.DAMAGE_TYPE_NORMAL'
---@field DAMAGE_TYPE_NORMAL	damagetype	_ConvertDamageType(4)
---
---DAMAGE_TYPE_ENHANCED 'common.DAMAGE_TYPE_ENHANCED'
---@field DAMAGE_TYPE_ENHANCED	damagetype	_ConvertDamageType(5)
---
---DAMAGE_TYPE_FIRE 'common.DAMAGE_TYPE_FIRE'
---@field DAMAGE_TYPE_FIRE	damagetype	_ConvertDamageType(8)
---
---DAMAGE_TYPE_COLD 'common.DAMAGE_TYPE_COLD'
---@field DAMAGE_TYPE_COLD	damagetype	_ConvertDamageType(9)
---
---DAMAGE_TYPE_LIGHTNING 'common.DAMAGE_TYPE_LIGHTNING'
---@field DAMAGE_TYPE_LIGHTNING	damagetype	_ConvertDamageType(10)
---
---DAMAGE_TYPE_POISON 'common.DAMAGE_TYPE_POISON'
---@field DAMAGE_TYPE_POISON	damagetype	_ConvertDamageType(11)
---
---DAMAGE_TYPE_DISEASE 'common.DAMAGE_TYPE_DISEASE'
---@field DAMAGE_TYPE_DISEASE	damagetype	_ConvertDamageType(12)
---
---DAMAGE_TYPE_DIVINE 'common.DAMAGE_TYPE_DIVINE'
---@field DAMAGE_TYPE_DIVINE	damagetype	_ConvertDamageType(13)
---
---DAMAGE_TYPE_MAGIC 'common.DAMAGE_TYPE_MAGIC'
---@field DAMAGE_TYPE_MAGIC	damagetype	_ConvertDamageType(14)
---
---DAMAGE_TYPE_SONIC 'common.DAMAGE_TYPE_SONIC'
---@field DAMAGE_TYPE_SONIC	damagetype	_ConvertDamageType(15)
---
---DAMAGE_TYPE_ACID 'common.DAMAGE_TYPE_ACID'
---@field DAMAGE_TYPE_ACID	damagetype	_ConvertDamageType(16)
---
---DAMAGE_TYPE_FORCE 'common.DAMAGE_TYPE_FORCE'
---@field DAMAGE_TYPE_FORCE	damagetype	_ConvertDamageType(17)
---
---DAMAGE_TYPE_DEATH 'common.DAMAGE_TYPE_DEATH'
---@field DAMAGE_TYPE_DEATH	damagetype	_ConvertDamageType(18)
---
---DAMAGE_TYPE_MIND 'common.DAMAGE_TYPE_MIND'
---@field DAMAGE_TYPE_MIND	damagetype	_ConvertDamageType(19)
---
---DAMAGE_TYPE_PLANT 'common.DAMAGE_TYPE_PLANT'
---@field DAMAGE_TYPE_PLANT	damagetype	_ConvertDamageType(20)
---
---DAMAGE_TYPE_DEFENSIVE 'common.DAMAGE_TYPE_DEFENSIVE'
---@field DAMAGE_TYPE_DEFENSIVE	damagetype	_ConvertDamageType(21)
---
---DAMAGE_TYPE_DEMOLITION 'common.DAMAGE_TYPE_DEMOLITION'
---@field DAMAGE_TYPE_DEMOLITION	damagetype	_ConvertDamageType(22)
---
---DAMAGE_TYPE_SLOW_POISON 'common.DAMAGE_TYPE_SLOW_POISON'
---@field DAMAGE_TYPE_SLOW_POISON	damagetype	_ConvertDamageType(23)
---
---DAMAGE_TYPE_SPIRIT_LINK 'common.DAMAGE_TYPE_SPIRIT_LINK'
---@field DAMAGE_TYPE_SPIRIT_LINK	damagetype	_ConvertDamageType(24)
---
---DAMAGE_TYPE_SHADOW_STRIKE 'common.DAMAGE_TYPE_SHADOW_STRIKE'
---@field DAMAGE_TYPE_SHADOW_STRIKE	damagetype	_ConvertDamageType(25)
---
---DAMAGE_TYPE_UNIVERSAL 'common.DAMAGE_TYPE_UNIVERSAL'
---@field DAMAGE_TYPE_UNIVERSAL	damagetype	_ConvertDamageType(26)
---
---WEAPON_TYPE_WHOKNOWS 'common.WEAPON_TYPE_WHOKNOWS'
---@field WEAPON_TYPE_WHOKNOWS	weapontype	_ConvertWeaponType(0)
---
---WEAPON_TYPE_METAL_LIGHT_CHOP 'common.WEAPON_TYPE_METAL_LIGHT_CHOP'
---@field WEAPON_TYPE_METAL_LIGHT_CHOP	weapontype	_ConvertWeaponType(1)
---
---WEAPON_TYPE_METAL_MEDIUM_CHOP 'common.WEAPON_TYPE_METAL_MEDIUM_CHOP'
---@field WEAPON_TYPE_METAL_MEDIUM_CHOP	weapontype	_ConvertWeaponType(2)
---
---WEAPON_TYPE_METAL_HEAVY_CHOP 'common.WEAPON_TYPE_METAL_HEAVY_CHOP'
---@field WEAPON_TYPE_METAL_HEAVY_CHOP	weapontype	_ConvertWeaponType(3)
---
---WEAPON_TYPE_METAL_LIGHT_SLICE 'common.WEAPON_TYPE_METAL_LIGHT_SLICE'
---@field WEAPON_TYPE_METAL_LIGHT_SLICE	weapontype	_ConvertWeaponType(4)
---
---WEAPON_TYPE_METAL_MEDIUM_SLICE 'common.WEAPON_TYPE_METAL_MEDIUM_SLICE'
---@field WEAPON_TYPE_METAL_MEDIUM_SLICE	weapontype	_ConvertWeaponType(5)
---
---WEAPON_TYPE_METAL_HEAVY_SLICE 'common.WEAPON_TYPE_METAL_HEAVY_SLICE'
---@field WEAPON_TYPE_METAL_HEAVY_SLICE	weapontype	_ConvertWeaponType(6)
---
---WEAPON_TYPE_METAL_MEDIUM_BASH 'common.WEAPON_TYPE_METAL_MEDIUM_BASH'
---@field WEAPON_TYPE_METAL_MEDIUM_BASH	weapontype	_ConvertWeaponType(7)
---
---WEAPON_TYPE_METAL_HEAVY_BASH 'common.WEAPON_TYPE_METAL_HEAVY_BASH'
---@field WEAPON_TYPE_METAL_HEAVY_BASH	weapontype	_ConvertWeaponType(8)
---
---WEAPON_TYPE_METAL_MEDIUM_STAB 'common.WEAPON_TYPE_METAL_MEDIUM_STAB'
---@field WEAPON_TYPE_METAL_MEDIUM_STAB	weapontype	_ConvertWeaponType(9)
---
---WEAPON_TYPE_METAL_HEAVY_STAB 'common.WEAPON_TYPE_METAL_HEAVY_STAB'
---@field WEAPON_TYPE_METAL_HEAVY_STAB	weapontype	_ConvertWeaponType(10)
---
---WEAPON_TYPE_WOOD_LIGHT_SLICE 'common.WEAPON_TYPE_WOOD_LIGHT_SLICE'
---@field WEAPON_TYPE_WOOD_LIGHT_SLICE	weapontype	_ConvertWeaponType(11)
---
---WEAPON_TYPE_WOOD_MEDIUM_SLICE 'common.WEAPON_TYPE_WOOD_MEDIUM_SLICE'
---@field WEAPON_TYPE_WOOD_MEDIUM_SLICE	weapontype	_ConvertWeaponType(12)
---
---WEAPON_TYPE_WOOD_HEAVY_SLICE 'common.WEAPON_TYPE_WOOD_HEAVY_SLICE'
---@field WEAPON_TYPE_WOOD_HEAVY_SLICE	weapontype	_ConvertWeaponType(13)
---
---WEAPON_TYPE_WOOD_LIGHT_BASH 'common.WEAPON_TYPE_WOOD_LIGHT_BASH'
---@field WEAPON_TYPE_WOOD_LIGHT_BASH	weapontype	_ConvertWeaponType(14)
---
---WEAPON_TYPE_WOOD_MEDIUM_BASH 'common.WEAPON_TYPE_WOOD_MEDIUM_BASH'
---@field WEAPON_TYPE_WOOD_MEDIUM_BASH	weapontype	_ConvertWeaponType(15)
---
---WEAPON_TYPE_WOOD_HEAVY_BASH 'common.WEAPON_TYPE_WOOD_HEAVY_BASH'
---@field WEAPON_TYPE_WOOD_HEAVY_BASH	weapontype	_ConvertWeaponType(16)
---
---WEAPON_TYPE_WOOD_LIGHT_STAB 'common.WEAPON_TYPE_WOOD_LIGHT_STAB'
---@field WEAPON_TYPE_WOOD_LIGHT_STAB	weapontype	_ConvertWeaponType(17)
---
---WEAPON_TYPE_WOOD_MEDIUM_STAB 'common.WEAPON_TYPE_WOOD_MEDIUM_STAB'
---@field WEAPON_TYPE_WOOD_MEDIUM_STAB	weapontype	_ConvertWeaponType(18)
---
---WEAPON_TYPE_CLAW_LIGHT_SLICE 'common.WEAPON_TYPE_CLAW_LIGHT_SLICE'
---@field WEAPON_TYPE_CLAW_LIGHT_SLICE	weapontype	_ConvertWeaponType(19)
---
---WEAPON_TYPE_CLAW_MEDIUM_SLICE 'common.WEAPON_TYPE_CLAW_MEDIUM_SLICE'
---@field WEAPON_TYPE_CLAW_MEDIUM_SLICE	weapontype	_ConvertWeaponType(20)
---
---WEAPON_TYPE_CLAW_HEAVY_SLICE 'common.WEAPON_TYPE_CLAW_HEAVY_SLICE'
---@field WEAPON_TYPE_CLAW_HEAVY_SLICE	weapontype	_ConvertWeaponType(21)
---
---WEAPON_TYPE_AXE_MEDIUM_CHOP 'common.WEAPON_TYPE_AXE_MEDIUM_CHOP'
---@field WEAPON_TYPE_AXE_MEDIUM_CHOP	weapontype	_ConvertWeaponType(22)
---
---WEAPON_TYPE_ROCK_HEAVY_BASH 'common.WEAPON_TYPE_ROCK_HEAVY_BASH'
---@field WEAPON_TYPE_ROCK_HEAVY_BASH	weapontype	_ConvertWeaponType(23)
---
---PATHING_TYPE_ANY 'common.PATHING_TYPE_ANY'
---@field PATHING_TYPE_ANY	pathingtype	_ConvertPathingType(0)
---
---PATHING_TYPE_WALKABILITY 'common.PATHING_TYPE_WALKABILITY'
---@field PATHING_TYPE_WALKABILITY	pathingtype	_ConvertPathingType(1)
---
---PATHING_TYPE_FLYABILITY 'common.PATHING_TYPE_FLYABILITY'
---@field PATHING_TYPE_FLYABILITY	pathingtype	_ConvertPathingType(2)
---
---PATHING_TYPE_BUILDABILITY 'common.PATHING_TYPE_BUILDABILITY'
---@field PATHING_TYPE_BUILDABILITY	pathingtype	_ConvertPathingType(3)
---
---PATHING_TYPE_PEONHARVESTPATHING 'common.PATHING_TYPE_PEONHARVESTPATHING'
---@field PATHING_TYPE_PEONHARVESTPATHING	pathingtype	_ConvertPathingType(4)
---
---PATHING_TYPE_BLIGHTPATHING 'common.PATHING_TYPE_BLIGHTPATHING'
---@field PATHING_TYPE_BLIGHTPATHING	pathingtype	_ConvertPathingType(5)
---
---PATHING_TYPE_FLOATABILITY 'common.PATHING_TYPE_FLOATABILITY'
---@field PATHING_TYPE_FLOATABILITY	pathingtype	_ConvertPathingType(6)
---
---PATHING_TYPE_AMPHIBIOUSPATHING 'common.PATHING_TYPE_AMPHIBIOUSPATHING'
---@field PATHING_TYPE_AMPHIBIOUSPATHING	pathingtype	_ConvertPathingType(7)
---
---MOUSE_BUTTON_TYPE_LEFT 'common.MOUSE_BUTTON_TYPE_LEFT'
---@field MOUSE_BUTTON_TYPE_LEFT	mousebuttontype	_ConvertMouseButtonType(1)
---
---MOUSE_BUTTON_TYPE_MIDDLE 'common.MOUSE_BUTTON_TYPE_MIDDLE'
---@field MOUSE_BUTTON_TYPE_MIDDLE	mousebuttontype	_ConvertMouseButtonType(2)
---
---MOUSE_BUTTON_TYPE_RIGHT 'common.MOUSE_BUTTON_TYPE_RIGHT'
---@field MOUSE_BUTTON_TYPE_RIGHT	mousebuttontype	_ConvertMouseButtonType(3)
---
---ANIM_TYPE_BIRTH 'common.ANIM_TYPE_BIRTH'
---@field ANIM_TYPE_BIRTH	animtype	_ConvertAnimType(0)
---
---ANIM_TYPE_DEATH 'common.ANIM_TYPE_DEATH'
---@field ANIM_TYPE_DEATH	animtype	_ConvertAnimType(1)
---
---ANIM_TYPE_DECAY 'common.ANIM_TYPE_DECAY'
---@field ANIM_TYPE_DECAY	animtype	_ConvertAnimType(2)
---
---ANIM_TYPE_DISSIPATE 'common.ANIM_TYPE_DISSIPATE'
---@field ANIM_TYPE_DISSIPATE	animtype	_ConvertAnimType(3)
---
---ANIM_TYPE_STAND 'common.ANIM_TYPE_STAND'
---@field ANIM_TYPE_STAND	animtype	_ConvertAnimType(4)
---
---ANIM_TYPE_WALK 'common.ANIM_TYPE_WALK'
---@field ANIM_TYPE_WALK	animtype	_ConvertAnimType(5)
---
---ANIM_TYPE_ATTACK 'common.ANIM_TYPE_ATTACK'
---@field ANIM_TYPE_ATTACK	animtype	_ConvertAnimType(6)
---
---ANIM_TYPE_MORPH 'common.ANIM_TYPE_MORPH'
---@field ANIM_TYPE_MORPH	animtype	_ConvertAnimType(7)
---
---ANIM_TYPE_SLEEP 'common.ANIM_TYPE_SLEEP'
---@field ANIM_TYPE_SLEEP	animtype	_ConvertAnimType(8)
---
---ANIM_TYPE_SPELL 'common.ANIM_TYPE_SPELL'
---@field ANIM_TYPE_SPELL	animtype	_ConvertAnimType(9)
---
---ANIM_TYPE_PORTRAIT 'common.ANIM_TYPE_PORTRAIT'
---@field ANIM_TYPE_PORTRAIT	animtype	_ConvertAnimType(10)
---
---SUBANIM_TYPE_ROOTED 'common.SUBANIM_TYPE_ROOTED'
---@field SUBANIM_TYPE_ROOTED	subanimtype	_ConvertSubAnimType(11)
---
---SUBANIM_TYPE_ALTERNATE_EX 'common.SUBANIM_TYPE_ALTERNATE_EX'
---@field SUBANIM_TYPE_ALTERNATE_EX	subanimtype	_ConvertSubAnimType(12)
---
---SUBANIM_TYPE_LOOPING 'common.SUBANIM_TYPE_LOOPING'
---@field SUBANIM_TYPE_LOOPING	subanimtype	_ConvertSubAnimType(13)
---
---SUBANIM_TYPE_SLAM 'common.SUBANIM_TYPE_SLAM'
---@field SUBANIM_TYPE_SLAM	subanimtype	_ConvertSubAnimType(14)
---
---SUBANIM_TYPE_THROW 'common.SUBANIM_TYPE_THROW'
---@field SUBANIM_TYPE_THROW	subanimtype	_ConvertSubAnimType(15)
---
---SUBANIM_TYPE_SPIKED 'common.SUBANIM_TYPE_SPIKED'
---@field SUBANIM_TYPE_SPIKED	subanimtype	_ConvertSubAnimType(16)
---
---SUBANIM_TYPE_FAST 'common.SUBANIM_TYPE_FAST'
---@field SUBANIM_TYPE_FAST	subanimtype	_ConvertSubAnimType(17)
---
---SUBANIM_TYPE_SPIN 'common.SUBANIM_TYPE_SPIN'
---@field SUBANIM_TYPE_SPIN	subanimtype	_ConvertSubAnimType(18)
---
---SUBANIM_TYPE_READY 'common.SUBANIM_TYPE_READY'
---@field SUBANIM_TYPE_READY	subanimtype	_ConvertSubAnimType(19)
---
---SUBANIM_TYPE_CHANNEL 'common.SUBANIM_TYPE_CHANNEL'
---@field SUBANIM_TYPE_CHANNEL	subanimtype	_ConvertSubAnimType(20)
---
---SUBANIM_TYPE_DEFEND 'common.SUBANIM_TYPE_DEFEND'
---@field SUBANIM_TYPE_DEFEND	subanimtype	_ConvertSubAnimType(21)
---
---SUBANIM_TYPE_VICTORY 'common.SUBANIM_TYPE_VICTORY'
---@field SUBANIM_TYPE_VICTORY	subanimtype	_ConvertSubAnimType(22)
---
---SUBANIM_TYPE_TURN 'common.SUBANIM_TYPE_TURN'
---@field SUBANIM_TYPE_TURN	subanimtype	_ConvertSubAnimType(23)
---
---SUBANIM_TYPE_LEFT 'common.SUBANIM_TYPE_LEFT'
---@field SUBANIM_TYPE_LEFT	subanimtype	_ConvertSubAnimType(24)
---
---SUBANIM_TYPE_RIGHT 'common.SUBANIM_TYPE_RIGHT'
---@field SUBANIM_TYPE_RIGHT	subanimtype	_ConvertSubAnimType(25)
---
---SUBANIM_TYPE_FIRE 'common.SUBANIM_TYPE_FIRE'
---@field SUBANIM_TYPE_FIRE	subanimtype	_ConvertSubAnimType(26)
---
---SUBANIM_TYPE_FLESH 'common.SUBANIM_TYPE_FLESH'
---@field SUBANIM_TYPE_FLESH	subanimtype	_ConvertSubAnimType(27)
---
---SUBANIM_TYPE_HIT 'common.SUBANIM_TYPE_HIT'
---@field SUBANIM_TYPE_HIT	subanimtype	_ConvertSubAnimType(28)
---
---SUBANIM_TYPE_WOUNDED 'common.SUBANIM_TYPE_WOUNDED'
---@field SUBANIM_TYPE_WOUNDED	subanimtype	_ConvertSubAnimType(29)
---
---SUBANIM_TYPE_LIGHT 'common.SUBANIM_TYPE_LIGHT'
---@field SUBANIM_TYPE_LIGHT	subanimtype	_ConvertSubAnimType(30)
---
---SUBANIM_TYPE_MODERATE 'common.SUBANIM_TYPE_MODERATE'
---@field SUBANIM_TYPE_MODERATE	subanimtype	_ConvertSubAnimType(31)
---
---SUBANIM_TYPE_SEVERE 'common.SUBANIM_TYPE_SEVERE'
---@field SUBANIM_TYPE_SEVERE	subanimtype	_ConvertSubAnimType(32)
---
---SUBANIM_TYPE_CRITICAL 'common.SUBANIM_TYPE_CRITICAL'
---@field SUBANIM_TYPE_CRITICAL	subanimtype	_ConvertSubAnimType(33)
---
---SUBANIM_TYPE_COMPLETE 'common.SUBANIM_TYPE_COMPLETE'
---@field SUBANIM_TYPE_COMPLETE	subanimtype	_ConvertSubAnimType(34)
---
---SUBANIM_TYPE_GOLD 'common.SUBANIM_TYPE_GOLD'
---@field SUBANIM_TYPE_GOLD	subanimtype	_ConvertSubAnimType(35)
---
---SUBANIM_TYPE_LUMBER 'common.SUBANIM_TYPE_LUMBER'
---@field SUBANIM_TYPE_LUMBER	subanimtype	_ConvertSubAnimType(36)
---
---SUBANIM_TYPE_WORK 'common.SUBANIM_TYPE_WORK'
---@field SUBANIM_TYPE_WORK	subanimtype	_ConvertSubAnimType(37)
---
---SUBANIM_TYPE_TALK 'common.SUBANIM_TYPE_TALK'
---@field SUBANIM_TYPE_TALK	subanimtype	_ConvertSubAnimType(38)
---
---SUBANIM_TYPE_FIRST 'common.SUBANIM_TYPE_FIRST'
---@field SUBANIM_TYPE_FIRST	subanimtype	_ConvertSubAnimType(39)
---
---SUBANIM_TYPE_SECOND 'common.SUBANIM_TYPE_SECOND'
---@field SUBANIM_TYPE_SECOND	subanimtype	_ConvertSubAnimType(40)
---
---SUBANIM_TYPE_THIRD 'common.SUBANIM_TYPE_THIRD'
---@field SUBANIM_TYPE_THIRD	subanimtype	_ConvertSubAnimType(41)
---
---SUBANIM_TYPE_FOURTH 'common.SUBANIM_TYPE_FOURTH'
---@field SUBANIM_TYPE_FOURTH	subanimtype	_ConvertSubAnimType(42)
---
---SUBANIM_TYPE_FIFTH 'common.SUBANIM_TYPE_FIFTH'
---@field SUBANIM_TYPE_FIFTH	subanimtype	_ConvertSubAnimType(43)
---
---SUBANIM_TYPE_ONE 'common.SUBANIM_TYPE_ONE'
---@field SUBANIM_TYPE_ONE	subanimtype	_ConvertSubAnimType(44)
---
---SUBANIM_TYPE_TWO 'common.SUBANIM_TYPE_TWO'
---@field SUBANIM_TYPE_TWO	subanimtype	_ConvertSubAnimType(45)
---
---SUBANIM_TYPE_THREE 'common.SUBANIM_TYPE_THREE'
---@field SUBANIM_TYPE_THREE	subanimtype	_ConvertSubAnimType(46)
---
---SUBANIM_TYPE_FOUR 'common.SUBANIM_TYPE_FOUR'
---@field SUBANIM_TYPE_FOUR	subanimtype	_ConvertSubAnimType(47)
---
---SUBANIM_TYPE_FIVE 'common.SUBANIM_TYPE_FIVE'
---@field SUBANIM_TYPE_FIVE	subanimtype	_ConvertSubAnimType(48)
---
---SUBANIM_TYPE_SMALL 'common.SUBANIM_TYPE_SMALL'
---@field SUBANIM_TYPE_SMALL	subanimtype	_ConvertSubAnimType(49)
---
---SUBANIM_TYPE_MEDIUM 'common.SUBANIM_TYPE_MEDIUM'
---@field SUBANIM_TYPE_MEDIUM	subanimtype	_ConvertSubAnimType(50)
---
---SUBANIM_TYPE_LARGE 'common.SUBANIM_TYPE_LARGE'
---@field SUBANIM_TYPE_LARGE	subanimtype	_ConvertSubAnimType(51)
---
---SUBANIM_TYPE_UPGRADE 'common.SUBANIM_TYPE_UPGRADE'
---@field SUBANIM_TYPE_UPGRADE	subanimtype	_ConvertSubAnimType(52)
---
---SUBANIM_TYPE_DRAIN 'common.SUBANIM_TYPE_DRAIN'
---@field SUBANIM_TYPE_DRAIN	subanimtype	_ConvertSubAnimType(53)
---
---SUBANIM_TYPE_FILL 'common.SUBANIM_TYPE_FILL'
---@field SUBANIM_TYPE_FILL	subanimtype	_ConvertSubAnimType(54)
---
---SUBANIM_TYPE_CHAINLIGHTNING 'common.SUBANIM_TYPE_CHAINLIGHTNING'
---@field SUBANIM_TYPE_CHAINLIGHTNING	subanimtype	_ConvertSubAnimType(55)
---
---SUBANIM_TYPE_EATTREE 'common.SUBANIM_TYPE_EATTREE'
---@field SUBANIM_TYPE_EATTREE	subanimtype	_ConvertSubAnimType(56)
---
---SUBANIM_TYPE_PUKE 'common.SUBANIM_TYPE_PUKE'
---@field SUBANIM_TYPE_PUKE	subanimtype	_ConvertSubAnimType(57)
---
---SUBANIM_TYPE_FLAIL 'common.SUBANIM_TYPE_FLAIL'
---@field SUBANIM_TYPE_FLAIL	subanimtype	_ConvertSubAnimType(58)
---
---SUBANIM_TYPE_OFF 'common.SUBANIM_TYPE_OFF'
---@field SUBANIM_TYPE_OFF	subanimtype	_ConvertSubAnimType(59)
---
---SUBANIM_TYPE_SWIM 'common.SUBANIM_TYPE_SWIM'
---@field SUBANIM_TYPE_SWIM	subanimtype	_ConvertSubAnimType(60)
---
---SUBANIM_TYPE_ENTANGLE 'common.SUBANIM_TYPE_ENTANGLE'
---@field SUBANIM_TYPE_ENTANGLE	subanimtype	_ConvertSubAnimType(61)
---
---SUBANIM_TYPE_BERSERK 'common.SUBANIM_TYPE_BERSERK'
---@field SUBANIM_TYPE_BERSERK	subanimtype	_ConvertSubAnimType(62)
---
---RACE_PREF_HUMAN 'common.RACE_PREF_HUMAN'
---@field RACE_PREF_HUMAN	racepreference	_ConvertRacePref(1)
---
---RACE_PREF_ORC 'common.RACE_PREF_ORC'
---@field RACE_PREF_ORC	racepreference	_ConvertRacePref(2)
---
---RACE_PREF_NIGHTELF 'common.RACE_PREF_NIGHTELF'
---@field RACE_PREF_NIGHTELF	racepreference	_ConvertRacePref(4)
---
---RACE_PREF_UNDEAD 'common.RACE_PREF_UNDEAD'
---@field RACE_PREF_UNDEAD	racepreference	_ConvertRacePref(8)
---
---RACE_PREF_DEMON 'common.RACE_PREF_DEMON'
---@field RACE_PREF_DEMON	racepreference	_ConvertRacePref(16)
---
---RACE_PREF_RANDOM 'common.RACE_PREF_RANDOM'
---@field RACE_PREF_RANDOM	racepreference	_ConvertRacePref(32)
---
---RACE_PREF_USER_SELECTABLE 'common.RACE_PREF_USER_SELECTABLE'
---@field RACE_PREF_USER_SELECTABLE	racepreference	_ConvertRacePref(64)
---
---MAP_CONTROL_USER 'common.MAP_CONTROL_USER'
---@field MAP_CONTROL_USER	mapcontrol	_ConvertMapControl(0)
---
---MAP_CONTROL_COMPUTER 'common.MAP_CONTROL_COMPUTER'
---@field MAP_CONTROL_COMPUTER	mapcontrol	_ConvertMapControl(1)
---
---MAP_CONTROL_RESCUABLE 'common.MAP_CONTROL_RESCUABLE'
---@field MAP_CONTROL_RESCUABLE	mapcontrol	_ConvertMapControl(2)
---
---MAP_CONTROL_NEUTRAL 'common.MAP_CONTROL_NEUTRAL'
---@field MAP_CONTROL_NEUTRAL	mapcontrol	_ConvertMapControl(3)
---
---MAP_CONTROL_CREEP 'common.MAP_CONTROL_CREEP'
---@field MAP_CONTROL_CREEP	mapcontrol	_ConvertMapControl(4)
---
---MAP_CONTROL_NONE 'common.MAP_CONTROL_NONE'
---@field MAP_CONTROL_NONE	mapcontrol	_ConvertMapControl(5)
---
---GAME_TYPE_MELEE 'common.GAME_TYPE_MELEE'
---@field GAME_TYPE_MELEE	gametype	_ConvertGameType(1)
---
---GAME_TYPE_FFA 'common.GAME_TYPE_FFA'
---@field GAME_TYPE_FFA	gametype	_ConvertGameType(2)
---
---GAME_TYPE_USE_MAP_SETTINGS 'common.GAME_TYPE_USE_MAP_SETTINGS'
---@field GAME_TYPE_USE_MAP_SETTINGS	gametype	_ConvertGameType(4)
---
---GAME_TYPE_BLIZ 'common.GAME_TYPE_BLIZ'
---@field GAME_TYPE_BLIZ	gametype	_ConvertGameType(8)
---
---GAME_TYPE_ONE_ON_ONE 'common.GAME_TYPE_ONE_ON_ONE'
---@field GAME_TYPE_ONE_ON_ONE	gametype	_ConvertGameType(16)
---
---GAME_TYPE_TWO_TEAM_PLAY 'common.GAME_TYPE_TWO_TEAM_PLAY'
---@field GAME_TYPE_TWO_TEAM_PLAY	gametype	_ConvertGameType(32)
---
---GAME_TYPE_THREE_TEAM_PLAY 'common.GAME_TYPE_THREE_TEAM_PLAY'
---@field GAME_TYPE_THREE_TEAM_PLAY	gametype	_ConvertGameType(64)
---
---GAME_TYPE_FOUR_TEAM_PLAY 'common.GAME_TYPE_FOUR_TEAM_PLAY'
---@field GAME_TYPE_FOUR_TEAM_PLAY	gametype	_ConvertGameType(128)
---
---MAP_FOG_HIDE_TERRAIN 'common.MAP_FOG_HIDE_TERRAIN'
---@field MAP_FOG_HIDE_TERRAIN	mapflag	_ConvertMapFlag(1)
---
---MAP_FOG_MAP_EXPLORED 'common.MAP_FOG_MAP_EXPLORED'
---@field MAP_FOG_MAP_EXPLORED	mapflag	_ConvertMapFlag(2)
---
---MAP_FOG_ALWAYS_VISIBLE 'common.MAP_FOG_ALWAYS_VISIBLE'
---@field MAP_FOG_ALWAYS_VISIBLE	mapflag	_ConvertMapFlag(4)
---
---MAP_USE_HANDICAPS 'common.MAP_USE_HANDICAPS'
---@field MAP_USE_HANDICAPS	mapflag	_ConvertMapFlag(8)
---
---MAP_OBSERVERS 'common.MAP_OBSERVERS'
---@field MAP_OBSERVERS	mapflag	_ConvertMapFlag(16)
---
---MAP_OBSERVERS_ON_DEATH 'common.MAP_OBSERVERS_ON_DEATH'
---@field MAP_OBSERVERS_ON_DEATH	mapflag	_ConvertMapFlag(32)
---
---MAP_FIXED_COLORS 'common.MAP_FIXED_COLORS'
---@field MAP_FIXED_COLORS	mapflag	_ConvertMapFlag(128)
---
---MAP_LOCK_RESOURCE_TRADING 'common.MAP_LOCK_RESOURCE_TRADING'
---@field MAP_LOCK_RESOURCE_TRADING	mapflag	_ConvertMapFlag(256)
---
---MAP_RESOURCE_TRADING_ALLIES_ONLY 'common.MAP_RESOURCE_TRADING_ALLIES_ONLY'
---@field MAP_RESOURCE_TRADING_ALLIES_ONLY	mapflag	_ConvertMapFlag(512)
---
---MAP_LOCK_ALLIANCE_CHANGES 'common.MAP_LOCK_ALLIANCE_CHANGES'
---@field MAP_LOCK_ALLIANCE_CHANGES	mapflag	_ConvertMapFlag(1024)
---
---MAP_ALLIANCE_CHANGES_HIDDEN 'common.MAP_ALLIANCE_CHANGES_HIDDEN'
---@field MAP_ALLIANCE_CHANGES_HIDDEN	mapflag	_ConvertMapFlag(2048)
---
---MAP_CHEATS 'common.MAP_CHEATS'
---@field MAP_CHEATS	mapflag	_ConvertMapFlag(4096)
---
---MAP_CHEATS_HIDDEN 'common.MAP_CHEATS_HIDDEN'
---@field MAP_CHEATS_HIDDEN	mapflag	_ConvertMapFlag(8192)
---
---MAP_LOCK_SPEED 'common.MAP_LOCK_SPEED'
---@field MAP_LOCK_SPEED	mapflag	_ConvertMapFlag(8192*2)
---
---MAP_LOCK_RANDOM_SEED 'common.MAP_LOCK_RANDOM_SEED'
---@field MAP_LOCK_RANDOM_SEED	mapflag	_ConvertMapFlag(8192*4)
---
---MAP_SHARED_ADVANCED_CONTROL 'common.MAP_SHARED_ADVANCED_CONTROL'
---@field MAP_SHARED_ADVANCED_CONTROL	mapflag	_ConvertMapFlag(8192*8)
---
---MAP_RANDOM_HERO 'common.MAP_RANDOM_HERO'
---@field MAP_RANDOM_HERO	mapflag	_ConvertMapFlag(8192*16)
---
---MAP_RANDOM_RACES 'common.MAP_RANDOM_RACES'
---@field MAP_RANDOM_RACES	mapflag	_ConvertMapFlag(8192*32)
---
---MAP_RELOADED 'common.MAP_RELOADED'
---@field MAP_RELOADED	mapflag	_ConvertMapFlag(8192*64)
---
---MAP_PLACEMENT_RANDOM 'common.MAP_PLACEMENT_RANDOM'
---@field MAP_PLACEMENT_RANDOM	placement	_ConvertPlacement(0)
---
---MAP_PLACEMENT_FIXED 'common.MAP_PLACEMENT_FIXED'
---@field MAP_PLACEMENT_FIXED	placement	_ConvertPlacement(1)
---
---MAP_PLACEMENT_USE_MAP_SETTINGS 'common.MAP_PLACEMENT_USE_MAP_SETTINGS'
---@field MAP_PLACEMENT_USE_MAP_SETTINGS	placement	_ConvertPlacement(2)
---
---MAP_PLACEMENT_TEAMS_TOGETHER 'common.MAP_PLACEMENT_TEAMS_TOGETHER'
---@field MAP_PLACEMENT_TEAMS_TOGETHER	placement	_ConvertPlacement(3)
---
---MAP_LOC_PRIO_LOW 'common.MAP_LOC_PRIO_LOW'
---@field MAP_LOC_PRIO_LOW	startlocprio	_ConvertStartLocPrio(0)
---
---MAP_LOC_PRIO_HIGH 'common.MAP_LOC_PRIO_HIGH'
---@field MAP_LOC_PRIO_HIGH	startlocprio	_ConvertStartLocPrio(1)
---
---MAP_LOC_PRIO_NOT 'common.MAP_LOC_PRIO_NOT'
---@field MAP_LOC_PRIO_NOT	startlocprio	_ConvertStartLocPrio(2)
---
---MAP_DENSITY_NONE 'common.MAP_DENSITY_NONE'
---@field MAP_DENSITY_NONE	mapdensity	_ConvertMapDensity(0)
---
---MAP_DENSITY_LIGHT 'common.MAP_DENSITY_LIGHT'
---@field MAP_DENSITY_LIGHT	mapdensity	_ConvertMapDensity(1)
---
---MAP_DENSITY_MEDIUM 'common.MAP_DENSITY_MEDIUM'
---@field MAP_DENSITY_MEDIUM	mapdensity	_ConvertMapDensity(2)
---
---MAP_DENSITY_HEAVY 'common.MAP_DENSITY_HEAVY'
---@field MAP_DENSITY_HEAVY	mapdensity	_ConvertMapDensity(3)
---
---MAP_DIFFICULTY_EASY 'common.MAP_DIFFICULTY_EASY'
---@field MAP_DIFFICULTY_EASY	gamedifficulty	_ConvertGameDifficulty(0)
---
---MAP_DIFFICULTY_NORMAL 'common.MAP_DIFFICULTY_NORMAL'
---@field MAP_DIFFICULTY_NORMAL	gamedifficulty	_ConvertGameDifficulty(1)
---
---MAP_DIFFICULTY_HARD 'common.MAP_DIFFICULTY_HARD'
---@field MAP_DIFFICULTY_HARD	gamedifficulty	_ConvertGameDifficulty(2)
---
---MAP_DIFFICULTY_INSANE 'common.MAP_DIFFICULTY_INSANE'
---@field MAP_DIFFICULTY_INSANE	gamedifficulty	_ConvertGameDifficulty(3)
---
---MAP_SPEED_SLOWEST 'common.MAP_SPEED_SLOWEST'
---@field MAP_SPEED_SLOWEST	gamespeed	_ConvertGameSpeed(0)
---
---MAP_SPEED_SLOW 'common.MAP_SPEED_SLOW'
---@field MAP_SPEED_SLOW	gamespeed	_ConvertGameSpeed(1)
---
---MAP_SPEED_NORMAL 'common.MAP_SPEED_NORMAL'
---@field MAP_SPEED_NORMAL	gamespeed	_ConvertGameSpeed(2)
---
---MAP_SPEED_FAST 'common.MAP_SPEED_FAST'
---@field MAP_SPEED_FAST	gamespeed	_ConvertGameSpeed(3)
---
---MAP_SPEED_FASTEST 'common.MAP_SPEED_FASTEST'
---@field MAP_SPEED_FASTEST	gamespeed	_ConvertGameSpeed(4)
---
---PLAYER_SLOT_STATE_EMPTY 'common.PLAYER_SLOT_STATE_EMPTY'
---@field PLAYER_SLOT_STATE_EMPTY	playerslotstate	_ConvertPlayerSlotState(0)
---
---PLAYER_SLOT_STATE_PLAYING 'common.PLAYER_SLOT_STATE_PLAYING'
---@field PLAYER_SLOT_STATE_PLAYING	playerslotstate	_ConvertPlayerSlotState(1)
---
---PLAYER_SLOT_STATE_LEFT 'common.PLAYER_SLOT_STATE_LEFT'
---@field PLAYER_SLOT_STATE_LEFT	playerslotstate	_ConvertPlayerSlotState(2)
---
---SOUND_VOLUMEGROUP_UNITMOVEMENT 'common.SOUND_VOLUMEGROUP_UNITMOVEMENT'
---@field SOUND_VOLUMEGROUP_UNITMOVEMENT	volumegroup	_ConvertVolumeGroup(0)
---
---SOUND_VOLUMEGROUP_UNITSOUNDS 'common.SOUND_VOLUMEGROUP_UNITSOUNDS'
---@field SOUND_VOLUMEGROUP_UNITSOUNDS	volumegroup	_ConvertVolumeGroup(1)
---
---SOUND_VOLUMEGROUP_COMBAT 'common.SOUND_VOLUMEGROUP_COMBAT'
---@field SOUND_VOLUMEGROUP_COMBAT	volumegroup	_ConvertVolumeGroup(2)
---
---SOUND_VOLUMEGROUP_SPELLS 'common.SOUND_VOLUMEGROUP_SPELLS'
---@field SOUND_VOLUMEGROUP_SPELLS	volumegroup	_ConvertVolumeGroup(3)
---
---SOUND_VOLUMEGROUP_UI 'common.SOUND_VOLUMEGROUP_UI'
---@field SOUND_VOLUMEGROUP_UI	volumegroup	_ConvertVolumeGroup(4)
---
---SOUND_VOLUMEGROUP_MUSIC 'common.SOUND_VOLUMEGROUP_MUSIC'
---@field SOUND_VOLUMEGROUP_MUSIC	volumegroup	_ConvertVolumeGroup(5)
---
---SOUND_VOLUMEGROUP_AMBIENTSOUNDS 'common.SOUND_VOLUMEGROUP_AMBIENTSOUNDS'
---@field SOUND_VOLUMEGROUP_AMBIENTSOUNDS	volumegroup	_ConvertVolumeGroup(6)
---
---SOUND_VOLUMEGROUP_FIRE 'common.SOUND_VOLUMEGROUP_FIRE'
---@field SOUND_VOLUMEGROUP_FIRE	volumegroup	_ConvertVolumeGroup(7)
---
---GAME_STATE_DIVINE_INTERVENTION 'common.GAME_STATE_DIVINE_INTERVENTION'
---@field GAME_STATE_DIVINE_INTERVENTION	igamestate	_ConvertIGameState(0)
---
---GAME_STATE_DISCONNECTED 'common.GAME_STATE_DISCONNECTED'
---@field GAME_STATE_DISCONNECTED	igamestate	_ConvertIGameState(1)
---
---GAME_STATE_TIME_OF_DAY 'common.GAME_STATE_TIME_OF_DAY'
---@field GAME_STATE_TIME_OF_DAY	fgamestate	_ConvertFGameState(2)
---
---PLAYER_STATE_GAME_RESULT 'common.PLAYER_STATE_GAME_RESULT'
---@field PLAYER_STATE_GAME_RESULT	playerstate	_ConvertPlayerState(0)
---
---current resource levels 'common.PLAYER_STATE_RESOURCE_GOLD'
---@field PLAYER_STATE_RESOURCE_GOLD	playerstate	_ConvertPlayerState(1)
---
---PLAYER_STATE_RESOURCE_LUMBER 'common.PLAYER_STATE_RESOURCE_LUMBER'
---@field PLAYER_STATE_RESOURCE_LUMBER	playerstate	_ConvertPlayerState(2)
---
---PLAYER_STATE_RESOURCE_HERO_TOKENS 'common.PLAYER_STATE_RESOURCE_HERO_TOKENS'
---@field PLAYER_STATE_RESOURCE_HERO_TOKENS	playerstate	_ConvertPlayerState(3)
---
---PLAYER_STATE_RESOURCE_FOOD_CAP 'common.PLAYER_STATE_RESOURCE_FOOD_CAP'
---@field PLAYER_STATE_RESOURCE_FOOD_CAP	playerstate	_ConvertPlayerState(4)
---
---PLAYER_STATE_RESOURCE_FOOD_USED 'common.PLAYER_STATE_RESOURCE_FOOD_USED'
---@field PLAYER_STATE_RESOURCE_FOOD_USED	playerstate	_ConvertPlayerState(5)
---
---PLAYER_STATE_FOOD_CAP_CEILING 'common.PLAYER_STATE_FOOD_CAP_CEILING'
---@field PLAYER_STATE_FOOD_CAP_CEILING	playerstate	_ConvertPlayerState(6)
---
---PLAYER_STATE_GIVES_BOUNTY 'common.PLAYER_STATE_GIVES_BOUNTY'
---@field PLAYER_STATE_GIVES_BOUNTY	playerstate	_ConvertPlayerState(7)
---
---PLAYER_STATE_ALLIED_VICTORY 'common.PLAYER_STATE_ALLIED_VICTORY'
---@field PLAYER_STATE_ALLIED_VICTORY	playerstate	_ConvertPlayerState(8)
---
---PLAYER_STATE_PLACED 'common.PLAYER_STATE_PLACED'
---@field PLAYER_STATE_PLACED	playerstate	_ConvertPlayerState(9)
---
---PLAYER_STATE_OBSERVER_ON_DEATH 'common.PLAYER_STATE_OBSERVER_ON_DEATH'
---@field PLAYER_STATE_OBSERVER_ON_DEATH	playerstate	_ConvertPlayerState(10)
---
---PLAYER_STATE_OBSERVER 'common.PLAYER_STATE_OBSERVER'
---@field PLAYER_STATE_OBSERVER	playerstate	_ConvertPlayerState(11)
---
---PLAYER_STATE_UNFOLLOWABLE 'common.PLAYER_STATE_UNFOLLOWABLE'
---@field PLAYER_STATE_UNFOLLOWABLE	playerstate	_ConvertPlayerState(12)
---
---taxation rate for each resource 'common.PLAYER_STATE_GOLD_UPKEEP_RATE'
---@field PLAYER_STATE_GOLD_UPKEEP_RATE	playerstate	_ConvertPlayerState(13)
---
---PLAYER_STATE_LUMBER_UPKEEP_RATE 'common.PLAYER_STATE_LUMBER_UPKEEP_RATE'
---@field PLAYER_STATE_LUMBER_UPKEEP_RATE	playerstate	_ConvertPlayerState(14)
---
---cumulative resources collected by the player during the mission 'common.PLAYER_STATE_GOLD_GATHERED'
---@field PLAYER_STATE_GOLD_GATHERED	playerstate	_ConvertPlayerState(15)
---
---PLAYER_STATE_LUMBER_GATHERED 'common.PLAYER_STATE_LUMBER_GATHERED'
---@field PLAYER_STATE_LUMBER_GATHERED	playerstate	_ConvertPlayerState(16)
---
---PLAYER_STATE_NO_CREEP_SLEEP 'common.PLAYER_STATE_NO_CREEP_SLEEP'
---@field PLAYER_STATE_NO_CREEP_SLEEP	playerstate	_ConvertPlayerState(25)
---
---UNIT_STATE_LIFE 'common.UNIT_STATE_LIFE'
---@field UNIT_STATE_LIFE	unitstate	_ConvertUnitState(0)
---
---UNIT_STATE_MAX_LIFE 'common.UNIT_STATE_MAX_LIFE'
---@field UNIT_STATE_MAX_LIFE	unitstate	_ConvertUnitState(1)
---
---UNIT_STATE_MANA 'common.UNIT_STATE_MANA'
---@field UNIT_STATE_MANA	unitstate	_ConvertUnitState(2)
---
---UNIT_STATE_MAX_MANA 'common.UNIT_STATE_MAX_MANA'
---@field UNIT_STATE_MAX_MANA	unitstate	_ConvertUnitState(3)
---
---AI_DIFFICULTY_NEWBIE 'common.AI_DIFFICULTY_NEWBIE'
---@field AI_DIFFICULTY_NEWBIE	aidifficulty	_ConvertAIDifficulty(0)
---
---AI_DIFFICULTY_NORMAL 'common.AI_DIFFICULTY_NORMAL'
---@field AI_DIFFICULTY_NORMAL	aidifficulty	_ConvertAIDifficulty(1)
---
---AI_DIFFICULTY_INSANE 'common.AI_DIFFICULTY_INSANE'
---@field AI_DIFFICULTY_INSANE	aidifficulty	_ConvertAIDifficulty(2)
---
---player score values 'common.PLAYER_SCORE_UNITS_TRAINED'
---@field PLAYER_SCORE_UNITS_TRAINED	playerscore	_ConvertPlayerScore(0)
---
---PLAYER_SCORE_UNITS_KILLED 'common.PLAYER_SCORE_UNITS_KILLED'
---@field PLAYER_SCORE_UNITS_KILLED	playerscore	_ConvertPlayerScore(1)
---
---PLAYER_SCORE_STRUCT_BUILT 'common.PLAYER_SCORE_STRUCT_BUILT'
---@field PLAYER_SCORE_STRUCT_BUILT	playerscore	_ConvertPlayerScore(2)
---
---PLAYER_SCORE_STRUCT_RAZED 'common.PLAYER_SCORE_STRUCT_RAZED'
---@field PLAYER_SCORE_STRUCT_RAZED	playerscore	_ConvertPlayerScore(3)
---
---PLAYER_SCORE_TECH_PERCENT 'common.PLAYER_SCORE_TECH_PERCENT'
---@field PLAYER_SCORE_TECH_PERCENT	playerscore	_ConvertPlayerScore(4)
---
---PLAYER_SCORE_FOOD_MAXPROD 'common.PLAYER_SCORE_FOOD_MAXPROD'
---@field PLAYER_SCORE_FOOD_MAXPROD	playerscore	_ConvertPlayerScore(5)
---
---PLAYER_SCORE_FOOD_MAXUSED 'common.PLAYER_SCORE_FOOD_MAXUSED'
---@field PLAYER_SCORE_FOOD_MAXUSED	playerscore	_ConvertPlayerScore(6)
---
---PLAYER_SCORE_HEROES_KILLED 'common.PLAYER_SCORE_HEROES_KILLED'
---@field PLAYER_SCORE_HEROES_KILLED	playerscore	_ConvertPlayerScore(7)
---
---PLAYER_SCORE_ITEMS_GAINED 'common.PLAYER_SCORE_ITEMS_GAINED'
---@field PLAYER_SCORE_ITEMS_GAINED	playerscore	_ConvertPlayerScore(8)
---
---PLAYER_SCORE_MERCS_HIRED 'common.PLAYER_SCORE_MERCS_HIRED'
---@field PLAYER_SCORE_MERCS_HIRED	playerscore	_ConvertPlayerScore(9)
---
---PLAYER_SCORE_GOLD_MINED_TOTAL 'common.PLAYER_SCORE_GOLD_MINED_TOTAL'
---@field PLAYER_SCORE_GOLD_MINED_TOTAL	playerscore	_ConvertPlayerScore(10)
---
---PLAYER_SCORE_GOLD_MINED_UPKEEP 'common.PLAYER_SCORE_GOLD_MINED_UPKEEP'
---@field PLAYER_SCORE_GOLD_MINED_UPKEEP	playerscore	_ConvertPlayerScore(11)
---
---PLAYER_SCORE_GOLD_LOST_UPKEEP 'common.PLAYER_SCORE_GOLD_LOST_UPKEEP'
---@field PLAYER_SCORE_GOLD_LOST_UPKEEP	playerscore	_ConvertPlayerScore(12)
---
---PLAYER_SCORE_GOLD_LOST_TAX 'common.PLAYER_SCORE_GOLD_LOST_TAX'
---@field PLAYER_SCORE_GOLD_LOST_TAX	playerscore	_ConvertPlayerScore(13)
---
---PLAYER_SCORE_GOLD_GIVEN 'common.PLAYER_SCORE_GOLD_GIVEN'
---@field PLAYER_SCORE_GOLD_GIVEN	playerscore	_ConvertPlayerScore(14)
---
---PLAYER_SCORE_GOLD_RECEIVED 'common.PLAYER_SCORE_GOLD_RECEIVED'
---@field PLAYER_SCORE_GOLD_RECEIVED	playerscore	_ConvertPlayerScore(15)
---
---PLAYER_SCORE_LUMBER_TOTAL 'common.PLAYER_SCORE_LUMBER_TOTAL'
---@field PLAYER_SCORE_LUMBER_TOTAL	playerscore	_ConvertPlayerScore(16)
---
---PLAYER_SCORE_LUMBER_LOST_UPKEEP 'common.PLAYER_SCORE_LUMBER_LOST_UPKEEP'
---@field PLAYER_SCORE_LUMBER_LOST_UPKEEP	playerscore	_ConvertPlayerScore(17)
---
---PLAYER_SCORE_LUMBER_LOST_TAX 'common.PLAYER_SCORE_LUMBER_LOST_TAX'
---@field PLAYER_SCORE_LUMBER_LOST_TAX	playerscore	_ConvertPlayerScore(18)
---
---PLAYER_SCORE_LUMBER_GIVEN 'common.PLAYER_SCORE_LUMBER_GIVEN'
---@field PLAYER_SCORE_LUMBER_GIVEN	playerscore	_ConvertPlayerScore(19)
---
---PLAYER_SCORE_LUMBER_RECEIVED 'common.PLAYER_SCORE_LUMBER_RECEIVED'
---@field PLAYER_SCORE_LUMBER_RECEIVED	playerscore	_ConvertPlayerScore(20)
---
---PLAYER_SCORE_UNIT_TOTAL 'common.PLAYER_SCORE_UNIT_TOTAL'
---@field PLAYER_SCORE_UNIT_TOTAL	playerscore	_ConvertPlayerScore(21)
---
---PLAYER_SCORE_HERO_TOTAL 'common.PLAYER_SCORE_HERO_TOTAL'
---@field PLAYER_SCORE_HERO_TOTAL	playerscore	_ConvertPlayerScore(22)
---
---PLAYER_SCORE_RESOURCE_TOTAL 'common.PLAYER_SCORE_RESOURCE_TOTAL'
---@field PLAYER_SCORE_RESOURCE_TOTAL	playerscore	_ConvertPlayerScore(23)
---
---PLAYER_SCORE_TOTAL 'common.PLAYER_SCORE_TOTAL'
---@field PLAYER_SCORE_TOTAL	playerscore	_ConvertPlayerScore(24)
---
---EVENT_GAME_VICTORY 'common.EVENT_GAME_VICTORY'
---@field EVENT_GAME_VICTORY	gameevent	_ConvertGameEvent(0)
---
---EVENT_GAME_END_LEVEL 'common.EVENT_GAME_END_LEVEL'
---@field EVENT_GAME_END_LEVEL	gameevent	_ConvertGameEvent(1)
---
---EVENT_GAME_VARIABLE_LIMIT 'common.EVENT_GAME_VARIABLE_LIMIT'
---@field EVENT_GAME_VARIABLE_LIMIT	gameevent	_ConvertGameEvent(2)
---
---EVENT_GAME_STATE_LIMIT 'common.EVENT_GAME_STATE_LIMIT'
---@field EVENT_GAME_STATE_LIMIT	gameevent	_ConvertGameEvent(3)
---
---EVENT_GAME_TIMER_EXPIRED 'common.EVENT_GAME_TIMER_EXPIRED'
---@field EVENT_GAME_TIMER_EXPIRED	gameevent	_ConvertGameEvent(4)
---
---EVENT_GAME_ENTER_REGION 'common.EVENT_GAME_ENTER_REGION'
---@field EVENT_GAME_ENTER_REGION	gameevent	_ConvertGameEvent(5)
---
---EVENT_GAME_LEAVE_REGION 'common.EVENT_GAME_LEAVE_REGION'
---@field EVENT_GAME_LEAVE_REGION	gameevent	_ConvertGameEvent(6)
---
---EVENT_GAME_TRACKABLE_HIT 'common.EVENT_GAME_TRACKABLE_HIT'
---@field EVENT_GAME_TRACKABLE_HIT	gameevent	_ConvertGameEvent(7)
---
---EVENT_GAME_TRACKABLE_TRACK 'common.EVENT_GAME_TRACKABLE_TRACK'
---@field EVENT_GAME_TRACKABLE_TRACK	gameevent	_ConvertGameEvent(8)
---
---EVENT_GAME_SHOW_SKILL 'common.EVENT_GAME_SHOW_SKILL'
---@field EVENT_GAME_SHOW_SKILL	gameevent	_ConvertGameEvent(9)
---
---EVENT_GAME_BUILD_SUBMENU 'common.EVENT_GAME_BUILD_SUBMENU'
---@field EVENT_GAME_BUILD_SUBMENU	gameevent	_ConvertGameEvent(10)
---
---For use with TriggerRegisterPlayerEvent 'common.EVENT_PLAYER_STATE_LIMIT'
---@field EVENT_PLAYER_STATE_LIMIT	playerevent	_ConvertPlayerEvent(11)
---
---EVENT_PLAYER_ALLIANCE_CHANGED 'common.EVENT_PLAYER_ALLIANCE_CHANGED'
---@field EVENT_PLAYER_ALLIANCE_CHANGED	playerevent	_ConvertPlayerEvent(12)
---
---EVENT_PLAYER_DEFEAT 'common.EVENT_PLAYER_DEFEAT'
---@field EVENT_PLAYER_DEFEAT	playerevent	_ConvertPlayerEvent(13)
---
---EVENT_PLAYER_VICTORY 'common.EVENT_PLAYER_VICTORY'
---@field EVENT_PLAYER_VICTORY	playerevent	_ConvertPlayerEvent(14)
---
---EVENT_PLAYER_LEAVE 'common.EVENT_PLAYER_LEAVE'
---@field EVENT_PLAYER_LEAVE	playerevent	_ConvertPlayerEvent(15)
---
---EVENT_PLAYER_CHAT 'common.EVENT_PLAYER_CHAT'
---@field EVENT_PLAYER_CHAT	playerevent	_ConvertPlayerEvent(16)
---
---EVENT_PLAYER_END_CINEMATIC 'common.EVENT_PLAYER_END_CINEMATIC'
---@field EVENT_PLAYER_END_CINEMATIC	playerevent	_ConvertPlayerEvent(17)
---
---玩家單位被攻擊 'common.EVENT_PLAYER_UNIT_ATTACKED'
---@field EVENT_PLAYER_UNIT_ATTACKED	playerunitevent	_ConvertPlayerUnitEvent(18)
---
---玩家單位被救援 'common.EVENT_PLAYER_UNIT_RESCUED'
---@field EVENT_PLAYER_UNIT_RESCUED	playerunitevent	_ConvertPlayerUnitEvent(19)
---
---玩家單位死亡 'common.EVENT_PLAYER_UNIT_DEATH'
---@field EVENT_PLAYER_UNIT_DEATH	playerunitevent	_ConvertPlayerUnitEvent(20)
---
---玩家單位開始腐爛 'common.EVENT_PLAYER_UNIT_DECAY'
---@field EVENT_PLAYER_UNIT_DECAY	playerunitevent	_ConvertPlayerUnitEvent(21)
---
---EVENT_PLAYER_UNIT_DETECTED 'common.EVENT_PLAYER_UNIT_DETECTED'
---@field EVENT_PLAYER_UNIT_DETECTED	playerunitevent	_ConvertPlayerUnitEvent(22)
---
---EVENT_PLAYER_UNIT_HIDDEN 'common.EVENT_PLAYER_UNIT_HIDDEN'
---@field EVENT_PLAYER_UNIT_HIDDEN	playerunitevent	_ConvertPlayerUnitEvent(23)
---
---EVENT_PLAYER_UNIT_SELECTED 'common.EVENT_PLAYER_UNIT_SELECTED'
---@field EVENT_PLAYER_UNIT_SELECTED	playerunitevent	_ConvertPlayerUnitEvent(24)
---
---EVENT_PLAYER_UNIT_DESELECTED 'common.EVENT_PLAYER_UNIT_DESELECTED'
---@field EVENT_PLAYER_UNIT_DESELECTED	playerunitevent	_ConvertPlayerUnitEvent(25)
---
---EVENT_PLAYER_UNIT_CONSTRUCT_START 'common.EVENT_PLAYER_UNIT_CONSTRUCT_START'
---@field EVENT_PLAYER_UNIT_CONSTRUCT_START	playerunitevent	_ConvertPlayerUnitEvent(26)
---
---EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL 'common.EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL'
---@field EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL	playerunitevent	_ConvertPlayerUnitEvent(27)
---
---EVENT_PLAYER_UNIT_CONSTRUCT_FINISH 'common.EVENT_PLAYER_UNIT_CONSTRUCT_FINISH'
---@field EVENT_PLAYER_UNIT_CONSTRUCT_FINISH	playerunitevent	_ConvertPlayerUnitEvent(28)
---
---EVENT_PLAYER_UNIT_UPGRADE_START 'common.EVENT_PLAYER_UNIT_UPGRADE_START'
---@field EVENT_PLAYER_UNIT_UPGRADE_START	playerunitevent	_ConvertPlayerUnitEvent(29)
---
---EVENT_PLAYER_UNIT_UPGRADE_CANCEL 'common.EVENT_PLAYER_UNIT_UPGRADE_CANCEL'
---@field EVENT_PLAYER_UNIT_UPGRADE_CANCEL	playerunitevent	_ConvertPlayerUnitEvent(30)
---
---EVENT_PLAYER_UNIT_UPGRADE_FINISH 'common.EVENT_PLAYER_UNIT_UPGRADE_FINISH'
---@field EVENT_PLAYER_UNIT_UPGRADE_FINISH	playerunitevent	_ConvertPlayerUnitEvent(31)
---
---EVENT_PLAYER_UNIT_TRAIN_START 'common.EVENT_PLAYER_UNIT_TRAIN_START'
---@field EVENT_PLAYER_UNIT_TRAIN_START	playerunitevent	_ConvertPlayerUnitEvent(32)
---
---EVENT_PLAYER_UNIT_TRAIN_CANCEL 'common.EVENT_PLAYER_UNIT_TRAIN_CANCEL'
---@field EVENT_PLAYER_UNIT_TRAIN_CANCEL	playerunitevent	_ConvertPlayerUnitEvent(33)
---
---EVENT_PLAYER_UNIT_TRAIN_FINISH 'common.EVENT_PLAYER_UNIT_TRAIN_FINISH'
---@field EVENT_PLAYER_UNIT_TRAIN_FINISH	playerunitevent	_ConvertPlayerUnitEvent(34)
---
---EVENT_PLAYER_UNIT_RESEARCH_START 'common.EVENT_PLAYER_UNIT_RESEARCH_START'
---@field EVENT_PLAYER_UNIT_RESEARCH_START	playerunitevent	_ConvertPlayerUnitEvent(35)
---
---EVENT_PLAYER_UNIT_RESEARCH_CANCEL 'common.EVENT_PLAYER_UNIT_RESEARCH_CANCEL'
---@field EVENT_PLAYER_UNIT_RESEARCH_CANCEL	playerunitevent	_ConvertPlayerUnitEvent(36)
---
---EVENT_PLAYER_UNIT_RESEARCH_FINISH 'common.EVENT_PLAYER_UNIT_RESEARCH_FINISH'
---@field EVENT_PLAYER_UNIT_RESEARCH_FINISH	playerunitevent	_ConvertPlayerUnitEvent(37)
---
---EVENT_PLAYER_UNIT_ISSUED_ORDER 'common.EVENT_PLAYER_UNIT_ISSUED_ORDER'
---@field EVENT_PLAYER_UNIT_ISSUED_ORDER	playerunitevent	_ConvertPlayerUnitEvent(38)
---
---EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER 'common.EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER'
---@field EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER	playerunitevent	_ConvertPlayerUnitEvent(39)
---
---EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER 'common.EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER'
---@field EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER	playerunitevent	_ConvertPlayerUnitEvent(40)
---
---EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER 'common.EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER'
---@field EVENT_PLAYER_UNIT_ISSUED_UNIT_ORDER	playerunitevent	_ConvertPlayerUnitEvent(40)
---
---EVENT_PLAYER_HERO_LEVEL 'common.EVENT_PLAYER_HERO_LEVEL'
---@field EVENT_PLAYER_HERO_LEVEL	playerunitevent	_ConvertPlayerUnitEvent(41)
---
---EVENT_PLAYER_HERO_SKILL 'common.EVENT_PLAYER_HERO_SKILL'
---@field EVENT_PLAYER_HERO_SKILL	playerunitevent	_ConvertPlayerUnitEvent(42)
---
---EVENT_PLAYER_HERO_REVIVABLE 'common.EVENT_PLAYER_HERO_REVIVABLE'
---@field EVENT_PLAYER_HERO_REVIVABLE	playerunitevent	_ConvertPlayerUnitEvent(43)
---
---EVENT_PLAYER_HERO_REVIVE_START 'common.EVENT_PLAYER_HERO_REVIVE_START'
---@field EVENT_PLAYER_HERO_REVIVE_START	playerunitevent	_ConvertPlayerUnitEvent(44)
---
---EVENT_PLAYER_HERO_REVIVE_CANCEL 'common.EVENT_PLAYER_HERO_REVIVE_CANCEL'
---@field EVENT_PLAYER_HERO_REVIVE_CANCEL	playerunitevent	_ConvertPlayerUnitEvent(45)
---
---EVENT_PLAYER_HERO_REVIVE_FINISH 'common.EVENT_PLAYER_HERO_REVIVE_FINISH'
---@field EVENT_PLAYER_HERO_REVIVE_FINISH	playerunitevent	_ConvertPlayerUnitEvent(46)
---
---EVENT_PLAYER_UNIT_SUMMON 'common.EVENT_PLAYER_UNIT_SUMMON'
---@field EVENT_PLAYER_UNIT_SUMMON	playerunitevent	_ConvertPlayerUnitEvent(47)
---
---EVENT_PLAYER_UNIT_DROP_ITEM 'common.EVENT_PLAYER_UNIT_DROP_ITEM'
---@field EVENT_PLAYER_UNIT_DROP_ITEM	playerunitevent	_ConvertPlayerUnitEvent(48)
---
---EVENT_PLAYER_UNIT_PICKUP_ITEM 'common.EVENT_PLAYER_UNIT_PICKUP_ITEM'
---@field EVENT_PLAYER_UNIT_PICKUP_ITEM	playerunitevent	_ConvertPlayerUnitEvent(49)
---
---EVENT_PLAYER_UNIT_USE_ITEM 'common.EVENT_PLAYER_UNIT_USE_ITEM'
---@field EVENT_PLAYER_UNIT_USE_ITEM	playerunitevent	_ConvertPlayerUnitEvent(50)
---
---EVENT_PLAYER_UNIT_LOADED 'common.EVENT_PLAYER_UNIT_LOADED'
---@field EVENT_PLAYER_UNIT_LOADED	playerunitevent	_ConvertPlayerUnitEvent(51)
---
---EVENT_PLAYER_UNIT_DAMAGED 'common.EVENT_PLAYER_UNIT_DAMAGED'
---@field EVENT_PLAYER_UNIT_DAMAGED	playerunitevent	_ConvertPlayerUnitEvent(308)
---
---EVENT_PLAYER_UNIT_DAMAGING 'common.EVENT_PLAYER_UNIT_DAMAGING'
---@field EVENT_PLAYER_UNIT_DAMAGING	playerunitevent	_ConvertPlayerUnitEvent(315)
---
---EVENT_UNIT_DAMAGED 'common.EVENT_UNIT_DAMAGED'
---@field EVENT_UNIT_DAMAGED	unitevent	_ConvertUnitEvent(52)
---
---EVENT_UNIT_DAMAGING 'common.EVENT_UNIT_DAMAGING'
---@field EVENT_UNIT_DAMAGING	unitevent	_ConvertUnitEvent(314)
---
---EVENT_UNIT_DEATH 'common.EVENT_UNIT_DEATH'
---@field EVENT_UNIT_DEATH	unitevent	_ConvertUnitEvent(53)
---
---EVENT_UNIT_DECAY 'common.EVENT_UNIT_DECAY'
---@field EVENT_UNIT_DECAY	unitevent	_ConvertUnitEvent(54)
---
---EVENT_UNIT_DETECTED 'common.EVENT_UNIT_DETECTED'
---@field EVENT_UNIT_DETECTED	unitevent	_ConvertUnitEvent(55)
---
---EVENT_UNIT_HIDDEN 'common.EVENT_UNIT_HIDDEN'
---@field EVENT_UNIT_HIDDEN	unitevent	_ConvertUnitEvent(56)
---
---EVENT_UNIT_SELECTED 'common.EVENT_UNIT_SELECTED'
---@field EVENT_UNIT_SELECTED	unitevent	_ConvertUnitEvent(57)
---
---EVENT_UNIT_DESELECTED 'common.EVENT_UNIT_DESELECTED'
---@field EVENT_UNIT_DESELECTED	unitevent	_ConvertUnitEvent(58)
---
---EVENT_UNIT_STATE_LIMIT 'common.EVENT_UNIT_STATE_LIMIT'
---@field EVENT_UNIT_STATE_LIMIT	unitevent	_ConvertUnitEvent(59)
---
---Events which may have a filter for the "other unit" 'common.EVENT_UNIT_ACQUIRED_TARGET'
---@field EVENT_UNIT_ACQUIRED_TARGET	unitevent	_ConvertUnitEvent(60)
---
---EVENT_UNIT_TARGET_IN_RANGE 'common.EVENT_UNIT_TARGET_IN_RANGE'
---@field EVENT_UNIT_TARGET_IN_RANGE	unitevent	_ConvertUnitEvent(61)
---
---EVENT_UNIT_ATTACKED 'common.EVENT_UNIT_ATTACKED'
---@field EVENT_UNIT_ATTACKED	unitevent	_ConvertUnitEvent(62)
---
---EVENT_UNIT_RESCUED 'common.EVENT_UNIT_RESCUED'
---@field EVENT_UNIT_RESCUED	unitevent	_ConvertUnitEvent(63)
---
---EVENT_UNIT_CONSTRUCT_CANCEL 'common.EVENT_UNIT_CONSTRUCT_CANCEL'
---@field EVENT_UNIT_CONSTRUCT_CANCEL	unitevent	_ConvertUnitEvent(64)
---
---EVENT_UNIT_CONSTRUCT_FINISH 'common.EVENT_UNIT_CONSTRUCT_FINISH'
---@field EVENT_UNIT_CONSTRUCT_FINISH	unitevent	_ConvertUnitEvent(65)
---
---EVENT_UNIT_UPGRADE_START 'common.EVENT_UNIT_UPGRADE_START'
---@field EVENT_UNIT_UPGRADE_START	unitevent	_ConvertUnitEvent(66)
---
---EVENT_UNIT_UPGRADE_CANCEL 'common.EVENT_UNIT_UPGRADE_CANCEL'
---@field EVENT_UNIT_UPGRADE_CANCEL	unitevent	_ConvertUnitEvent(67)
---
---EVENT_UNIT_UPGRADE_FINISH 'common.EVENT_UNIT_UPGRADE_FINISH'
---@field EVENT_UNIT_UPGRADE_FINISH	unitevent	_ConvertUnitEvent(68)
---
---Events which involve the specified unit performing
---training of other units 'common.EVENT_UNIT_TRAIN_START'
---@field EVENT_UNIT_TRAIN_START	unitevent	_ConvertUnitEvent(69)
---
---EVENT_UNIT_TRAIN_CANCEL 'common.EVENT_UNIT_TRAIN_CANCEL'
---@field EVENT_UNIT_TRAIN_CANCEL	unitevent	_ConvertUnitEvent(70)
---
---EVENT_UNIT_TRAIN_FINISH 'common.EVENT_UNIT_TRAIN_FINISH'
---@field EVENT_UNIT_TRAIN_FINISH	unitevent	_ConvertUnitEvent(71)
---
---EVENT_UNIT_RESEARCH_START 'common.EVENT_UNIT_RESEARCH_START'
---@field EVENT_UNIT_RESEARCH_START	unitevent	_ConvertUnitEvent(72)
---
---EVENT_UNIT_RESEARCH_CANCEL 'common.EVENT_UNIT_RESEARCH_CANCEL'
---@field EVENT_UNIT_RESEARCH_CANCEL	unitevent	_ConvertUnitEvent(73)
---
---EVENT_UNIT_RESEARCH_FINISH 'common.EVENT_UNIT_RESEARCH_FINISH'
---@field EVENT_UNIT_RESEARCH_FINISH	unitevent	_ConvertUnitEvent(74)
---
---EVENT_UNIT_ISSUED_ORDER 'common.EVENT_UNIT_ISSUED_ORDER'
---@field EVENT_UNIT_ISSUED_ORDER	unitevent	_ConvertUnitEvent(75)
---
---EVENT_UNIT_ISSUED_POINT_ORDER 'common.EVENT_UNIT_ISSUED_POINT_ORDER'
---@field EVENT_UNIT_ISSUED_POINT_ORDER	unitevent	_ConvertUnitEvent(76)
---
---EVENT_UNIT_ISSUED_TARGET_ORDER 'common.EVENT_UNIT_ISSUED_TARGET_ORDER'
---@field EVENT_UNIT_ISSUED_TARGET_ORDER	unitevent	_ConvertUnitEvent(77)
---
---EVENT_UNIT_HERO_LEVEL 'common.EVENT_UNIT_HERO_LEVEL'
---@field EVENT_UNIT_HERO_LEVEL	unitevent	_ConvertUnitEvent(78)
---
---EVENT_UNIT_HERO_SKILL 'common.EVENT_UNIT_HERO_SKILL'
---@field EVENT_UNIT_HERO_SKILL	unitevent	_ConvertUnitEvent(79)
---
---EVENT_UNIT_HERO_REVIVABLE 'common.EVENT_UNIT_HERO_REVIVABLE'
---@field EVENT_UNIT_HERO_REVIVABLE	unitevent	_ConvertUnitEvent(80)
---
---EVENT_UNIT_HERO_REVIVE_START 'common.EVENT_UNIT_HERO_REVIVE_START'
---@field EVENT_UNIT_HERO_REVIVE_START	unitevent	_ConvertUnitEvent(81)
---
---EVENT_UNIT_HERO_REVIVE_CANCEL 'common.EVENT_UNIT_HERO_REVIVE_CANCEL'
---@field EVENT_UNIT_HERO_REVIVE_CANCEL	unitevent	_ConvertUnitEvent(82)
---
---EVENT_UNIT_HERO_REVIVE_FINISH 'common.EVENT_UNIT_HERO_REVIVE_FINISH'
---@field EVENT_UNIT_HERO_REVIVE_FINISH	unitevent	_ConvertUnitEvent(83)
---
---EVENT_UNIT_SUMMON 'common.EVENT_UNIT_SUMMON'
---@field EVENT_UNIT_SUMMON	unitevent	_ConvertUnitEvent(84)
---
---EVENT_UNIT_DROP_ITEM 'common.EVENT_UNIT_DROP_ITEM'
---@field EVENT_UNIT_DROP_ITEM	unitevent	_ConvertUnitEvent(85)
---
---EVENT_UNIT_PICKUP_ITEM 'common.EVENT_UNIT_PICKUP_ITEM'
---@field EVENT_UNIT_PICKUP_ITEM	unitevent	_ConvertUnitEvent(86)
---
---EVENT_UNIT_USE_ITEM 'common.EVENT_UNIT_USE_ITEM'
---@field EVENT_UNIT_USE_ITEM	unitevent	_ConvertUnitEvent(87)
---
---EVENT_UNIT_LOADED 'common.EVENT_UNIT_LOADED'
---@field EVENT_UNIT_LOADED	unitevent	_ConvertUnitEvent(88)
---
---EVENT_WIDGET_DEATH 'common.EVENT_WIDGET_DEATH'
---@field EVENT_WIDGET_DEATH	widgetevent	_ConvertWidgetEvent(89)
---
---EVENT_DIALOG_BUTTON_CLICK 'common.EVENT_DIALOG_BUTTON_CLICK'
---@field EVENT_DIALOG_BUTTON_CLICK	dialogevent	_ConvertDialogEvent(90)
---
---EVENT_DIALOG_CLICK 'common.EVENT_DIALOG_CLICK'
---@field EVENT_DIALOG_CLICK	dialogevent	_ConvertDialogEvent(91)
---
---EVENT_GAME_LOADED 'common.EVENT_GAME_LOADED'
---@field EVENT_GAME_LOADED	gameevent	_ConvertGameEvent(256)
---
---EVENT_GAME_TOURNAMENT_FINISH_SOON 'common.EVENT_GAME_TOURNAMENT_FINISH_SOON'
---@field EVENT_GAME_TOURNAMENT_FINISH_SOON	gameevent	_ConvertGameEvent(257)
---
---EVENT_GAME_TOURNAMENT_FINISH_NOW 'common.EVENT_GAME_TOURNAMENT_FINISH_NOW'
---@field EVENT_GAME_TOURNAMENT_FINISH_NOW	gameevent	_ConvertGameEvent(258)
---
---EVENT_GAME_SAVE 'common.EVENT_GAME_SAVE'
---@field EVENT_GAME_SAVE	gameevent	_ConvertGameEvent(259)
---
---EVENT_GAME_CUSTOM_UI_FRAME 'common.EVENT_GAME_CUSTOM_UI_FRAME'
---@field EVENT_GAME_CUSTOM_UI_FRAME	gameevent	_ConvertGameEvent(310)
---
---EVENT_PLAYER_ARROW_LEFT_DOWN 'common.EVENT_PLAYER_ARROW_LEFT_DOWN'
---@field EVENT_PLAYER_ARROW_LEFT_DOWN	playerevent	_ConvertPlayerEvent(261)
---
---EVENT_PLAYER_ARROW_LEFT_UP 'common.EVENT_PLAYER_ARROW_LEFT_UP'
---@field EVENT_PLAYER_ARROW_LEFT_UP	playerevent	_ConvertPlayerEvent(262)
---
---EVENT_PLAYER_ARROW_RIGHT_DOWN 'common.EVENT_PLAYER_ARROW_RIGHT_DOWN'
---@field EVENT_PLAYER_ARROW_RIGHT_DOWN	playerevent	_ConvertPlayerEvent(263)
---
---EVENT_PLAYER_ARROW_RIGHT_UP 'common.EVENT_PLAYER_ARROW_RIGHT_UP'
---@field EVENT_PLAYER_ARROW_RIGHT_UP	playerevent	_ConvertPlayerEvent(264)
---
---EVENT_PLAYER_ARROW_DOWN_DOWN 'common.EVENT_PLAYER_ARROW_DOWN_DOWN'
---@field EVENT_PLAYER_ARROW_DOWN_DOWN	playerevent	_ConvertPlayerEvent(265)
---
---EVENT_PLAYER_ARROW_DOWN_UP 'common.EVENT_PLAYER_ARROW_DOWN_UP'
---@field EVENT_PLAYER_ARROW_DOWN_UP	playerevent	_ConvertPlayerEvent(266)
---
---EVENT_PLAYER_ARROW_UP_DOWN 'common.EVENT_PLAYER_ARROW_UP_DOWN'
---@field EVENT_PLAYER_ARROW_UP_DOWN	playerevent	_ConvertPlayerEvent(267)
---
---EVENT_PLAYER_ARROW_UP_UP 'common.EVENT_PLAYER_ARROW_UP_UP'
---@field EVENT_PLAYER_ARROW_UP_UP	playerevent	_ConvertPlayerEvent(268)
---
---EVENT_PLAYER_MOUSE_DOWN 'common.EVENT_PLAYER_MOUSE_DOWN'
---@field EVENT_PLAYER_MOUSE_DOWN	playerevent	_ConvertPlayerEvent(305)
---
---EVENT_PLAYER_MOUSE_UP 'common.EVENT_PLAYER_MOUSE_UP'
---@field EVENT_PLAYER_MOUSE_UP	playerevent	_ConvertPlayerEvent(306)
---
---EVENT_PLAYER_MOUSE_MOVE 'common.EVENT_PLAYER_MOUSE_MOVE'
---@field EVENT_PLAYER_MOUSE_MOVE	playerevent	_ConvertPlayerEvent(307)
---
---EVENT_PLAYER_SYNC_DATA 'common.EVENT_PLAYER_SYNC_DATA'
---@field EVENT_PLAYER_SYNC_DATA	playerevent	_ConvertPlayerEvent(309)
---
---EVENT_PLAYER_KEY 'common.EVENT_PLAYER_KEY'
---@field EVENT_PLAYER_KEY	playerevent	_ConvertPlayerEvent(311)
---
---EVENT_PLAYER_KEY_DOWN 'common.EVENT_PLAYER_KEY_DOWN'
---@field EVENT_PLAYER_KEY_DOWN	playerevent	_ConvertPlayerEvent(312)
---
---EVENT_PLAYER_KEY_UP 'common.EVENT_PLAYER_KEY_UP'
---@field EVENT_PLAYER_KEY_UP	playerevent	_ConvertPlayerEvent(313)
---
---EVENT_PLAYER_UNIT_SELL 'common.EVENT_PLAYER_UNIT_SELL'
---@field EVENT_PLAYER_UNIT_SELL	playerunitevent	_ConvertPlayerUnitEvent(269)
---
---玩家單位更改所有者 'common.EVENT_PLAYER_UNIT_CHANGE_OWNER'
---@field EVENT_PLAYER_UNIT_CHANGE_OWNER	playerunitevent	_ConvertPlayerUnitEvent(270)
---
---玩家單位出售物品 'common.EVENT_PLAYER_UNIT_SELL_ITEM'
---@field EVENT_PLAYER_UNIT_SELL_ITEM	playerunitevent	_ConvertPlayerUnitEvent(271)
---
---玩家單位準備施放技能 'common.EVENT_PLAYER_UNIT_SPELL_CHANNEL'
---@field EVENT_PLAYER_UNIT_SPELL_CHANNEL	playerunitevent	_ConvertPlayerUnitEvent(272)
---
---玩家單位開始施放技能 'common.EVENT_PLAYER_UNIT_SPELL_CAST'
---@field EVENT_PLAYER_UNIT_SPELL_CAST	playerunitevent	_ConvertPlayerUnitEvent(273)
---
---玩家單位發動技能效果 'common.EVENT_PLAYER_UNIT_SPELL_EFFECT'
---@field EVENT_PLAYER_UNIT_SPELL_EFFECT	playerunitevent	_ConvertPlayerUnitEvent(274)
---
---玩家單位釋放技能結束 'common.EVENT_PLAYER_UNIT_SPELL_FINISH'
---@field EVENT_PLAYER_UNIT_SPELL_FINISH	playerunitevent	_ConvertPlayerUnitEvent(275)
---
---玩家單位停止施放技能 'common.EVENT_PLAYER_UNIT_SPELL_ENDCAST'
---@field EVENT_PLAYER_UNIT_SPELL_ENDCAST	playerunitevent	_ConvertPlayerUnitEvent(276)
---
---玩家單位抵押物品 'common.EVENT_PLAYER_UNIT_PAWN_ITEM'
---@field EVENT_PLAYER_UNIT_PAWN_ITEM	playerunitevent	_ConvertPlayerUnitEvent(277)
---
---For use with TriggerRegisterUnitEvent
---单位出售 'common.EVENT_UNIT_SELL'
---@field EVENT_UNIT_SELL	unitevent	_ConvertUnitEvent(286)
---
---单位所属改变 'common.EVENT_UNIT_CHANGE_OWNER'
---@field EVENT_UNIT_CHANGE_OWNER	unitevent	_ConvertUnitEvent(287)
---
---出售物品 'common.EVENT_UNIT_SELL_ITEM'
---@field EVENT_UNIT_SELL_ITEM	unitevent	_ConvertUnitEvent(288)
---
---准备施放技能 (前摇开始) 'common.EVENT_UNIT_SPELL_CHANNEL'
---@field EVENT_UNIT_SPELL_CHANNEL	unitevent	_ConvertUnitEvent(289)
---
---开始施放技能 (前摇结束) 'common.EVENT_UNIT_SPELL_CAST'
---@field EVENT_UNIT_SPELL_CAST	unitevent	_ConvertUnitEvent(290)
---
---发动技能效果 (后摇开始) 'common.EVENT_UNIT_SPELL_EFFECT'
---@field EVENT_UNIT_SPELL_EFFECT	unitevent	_ConvertUnitEvent(291)
---
---发动技能结束 (后摇结束) 'common.EVENT_UNIT_SPELL_FINISH'
---@field EVENT_UNIT_SPELL_FINISH	unitevent	_ConvertUnitEvent(292)
---
---停止施放技能 'common.EVENT_UNIT_SPELL_ENDCAST'
---@field EVENT_UNIT_SPELL_ENDCAST	unitevent	_ConvertUnitEvent(293)
---
---抵押物品 'common.EVENT_UNIT_PAWN_ITEM'
---@field EVENT_UNIT_PAWN_ITEM	unitevent	_ConvertUnitEvent(294)
---
---LESS_THAN 'common.LESS_THAN'
---@field LESS_THAN	limitop	_ConvertLimitOp(0)
---
---LESS_THAN_OR_EQUAL 'common.LESS_THAN_OR_EQUAL'
---@field LESS_THAN_OR_EQUAL	limitop	_ConvertLimitOp(1)
---
---EQUAL 'common.EQUAL'
---@field EQUAL	limitop	_ConvertLimitOp(2)
---
---GREATER_THAN_OR_EQUAL 'common.GREATER_THAN_OR_EQUAL'
---@field GREATER_THAN_OR_EQUAL	limitop	_ConvertLimitOp(3)
---
---GREATER_THAN 'common.GREATER_THAN'
---@field GREATER_THAN	limitop	_ConvertLimitOp(4)
---
---NOT_EQUAL 'common.NOT_EQUAL'
---@field NOT_EQUAL	limitop	_ConvertLimitOp(5)
---
---UNIT_TYPE_HERO 'common.UNIT_TYPE_HERO'
---@field UNIT_TYPE_HERO	unittype	_ConvertUnitType(0)
---
---UNIT_TYPE_DEAD 'common.UNIT_TYPE_DEAD'
---@field UNIT_TYPE_DEAD	unittype	_ConvertUnitType(1)
---
---UNIT_TYPE_STRUCTURE 'common.UNIT_TYPE_STRUCTURE'
---@field UNIT_TYPE_STRUCTURE	unittype	_ConvertUnitType(2)
---
---UNIT_TYPE_FLYING 'common.UNIT_TYPE_FLYING'
---@field UNIT_TYPE_FLYING	unittype	_ConvertUnitType(3)
---
---UNIT_TYPE_GROUND 'common.UNIT_TYPE_GROUND'
---@field UNIT_TYPE_GROUND	unittype	_ConvertUnitType(4)
---
---UNIT_TYPE_ATTACKS_FLYING 'common.UNIT_TYPE_ATTACKS_FLYING'
---@field UNIT_TYPE_ATTACKS_FLYING	unittype	_ConvertUnitType(5)
---
---UNIT_TYPE_ATTACKS_GROUND 'common.UNIT_TYPE_ATTACKS_GROUND'
---@field UNIT_TYPE_ATTACKS_GROUND	unittype	_ConvertUnitType(6)
---
---UNIT_TYPE_MELEE_ATTACKER 'common.UNIT_TYPE_MELEE_ATTACKER'
---@field UNIT_TYPE_MELEE_ATTACKER	unittype	_ConvertUnitType(7)
---
---UNIT_TYPE_RANGED_ATTACKER 'common.UNIT_TYPE_RANGED_ATTACKER'
---@field UNIT_TYPE_RANGED_ATTACKER	unittype	_ConvertUnitType(8)
---
---UNIT_TYPE_GIANT 'common.UNIT_TYPE_GIANT'
---@field UNIT_TYPE_GIANT	unittype	_ConvertUnitType(9)
---
---UNIT_TYPE_SUMMONED 'common.UNIT_TYPE_SUMMONED'
---@field UNIT_TYPE_SUMMONED	unittype	_ConvertUnitType(10)
---
---UNIT_TYPE_STUNNED 'common.UNIT_TYPE_STUNNED'
---@field UNIT_TYPE_STUNNED	unittype	_ConvertUnitType(11)
---
---UNIT_TYPE_PLAGUED 'common.UNIT_TYPE_PLAGUED'
---@field UNIT_TYPE_PLAGUED	unittype	_ConvertUnitType(12)
---
---UNIT_TYPE_SNARED 'common.UNIT_TYPE_SNARED'
---@field UNIT_TYPE_SNARED	unittype	_ConvertUnitType(13)
---
---UNIT_TYPE_UNDEAD 'common.UNIT_TYPE_UNDEAD'
---@field UNIT_TYPE_UNDEAD	unittype	_ConvertUnitType(14)
---
---UNIT_TYPE_MECHANICAL 'common.UNIT_TYPE_MECHANICAL'
---@field UNIT_TYPE_MECHANICAL	unittype	_ConvertUnitType(15)
---
---UNIT_TYPE_PEON 'common.UNIT_TYPE_PEON'
---@field UNIT_TYPE_PEON	unittype	_ConvertUnitType(16)
---
---UNIT_TYPE_SAPPER 'common.UNIT_TYPE_SAPPER'
---@field UNIT_TYPE_SAPPER	unittype	_ConvertUnitType(17)
---
---UNIT_TYPE_TOWNHALL 'common.UNIT_TYPE_TOWNHALL'
---@field UNIT_TYPE_TOWNHALL	unittype	_ConvertUnitType(18)
---
---UNIT_TYPE_ANCIENT 'common.UNIT_TYPE_ANCIENT'
---@field UNIT_TYPE_ANCIENT	unittype	_ConvertUnitType(19)
---
---UNIT_TYPE_TAUREN 'common.UNIT_TYPE_TAUREN'
---@field UNIT_TYPE_TAUREN	unittype	_ConvertUnitType(20)
---
---UNIT_TYPE_POISONED 'common.UNIT_TYPE_POISONED'
---@field UNIT_TYPE_POISONED	unittype	_ConvertUnitType(21)
---
---UNIT_TYPE_POLYMORPHED 'common.UNIT_TYPE_POLYMORPHED'
---@field UNIT_TYPE_POLYMORPHED	unittype	_ConvertUnitType(22)
---
---UNIT_TYPE_SLEEPING 'common.UNIT_TYPE_SLEEPING'
---@field UNIT_TYPE_SLEEPING	unittype	_ConvertUnitType(23)
---
---UNIT_TYPE_RESISTANT 'common.UNIT_TYPE_RESISTANT'
---@field UNIT_TYPE_RESISTANT	unittype	_ConvertUnitType(24)
---
---UNIT_TYPE_ETHEREAL 'common.UNIT_TYPE_ETHEREAL'
---@field UNIT_TYPE_ETHEREAL	unittype	_ConvertUnitType(25)
---
---UNIT_TYPE_MAGIC_IMMUNE 'common.UNIT_TYPE_MAGIC_IMMUNE'
---@field UNIT_TYPE_MAGIC_IMMUNE	unittype	_ConvertUnitType(26)
---
---ITEM_TYPE_PERMANENT 'common.ITEM_TYPE_PERMANENT'
---@field ITEM_TYPE_PERMANENT	itemtype	_ConvertItemType(0)
---
---ITEM_TYPE_CHARGED 'common.ITEM_TYPE_CHARGED'
---@field ITEM_TYPE_CHARGED	itemtype	_ConvertItemType(1)
---
---ITEM_TYPE_POWERUP 'common.ITEM_TYPE_POWERUP'
---@field ITEM_TYPE_POWERUP	itemtype	_ConvertItemType(2)
---
---ITEM_TYPE_ARTIFACT 'common.ITEM_TYPE_ARTIFACT'
---@field ITEM_TYPE_ARTIFACT	itemtype	_ConvertItemType(3)
---
---ITEM_TYPE_PURCHASABLE 'common.ITEM_TYPE_PURCHASABLE'
---@field ITEM_TYPE_PURCHASABLE	itemtype	_ConvertItemType(4)
---
---ITEM_TYPE_CAMPAIGN 'common.ITEM_TYPE_CAMPAIGN'
---@field ITEM_TYPE_CAMPAIGN	itemtype	_ConvertItemType(5)
---
---ITEM_TYPE_MISCELLANEOUS 'common.ITEM_TYPE_MISCELLANEOUS'
---@field ITEM_TYPE_MISCELLANEOUS	itemtype	_ConvertItemType(6)
---
---ITEM_TYPE_UNKNOWN 'common.ITEM_TYPE_UNKNOWN'
---@field ITEM_TYPE_UNKNOWN	itemtype	_ConvertItemType(7)
---
---ITEM_TYPE_ANY 'common.ITEM_TYPE_ANY'
---@field ITEM_TYPE_ANY	itemtype	_ConvertItemType(8)
---
---Deprecated, should use ITEM_TYPE_POWERUP 'common.ITEM_TYPE_TOME'
---@field ITEM_TYPE_TOME	itemtype	_ConvertItemType(2)
---
---CAMERA_FIELD_TARGET_DISTANCE 'common.CAMERA_FIELD_TARGET_DISTANCE'
---@field CAMERA_FIELD_TARGET_DISTANCE	camerafield	_ConvertCameraField(0)
---
---CAMERA_FIELD_FARZ 'common.CAMERA_FIELD_FARZ'
---@field CAMERA_FIELD_FARZ	camerafield	_ConvertCameraField(1)
---
---CAMERA_FIELD_ANGLE_OF_ATTACK 'common.CAMERA_FIELD_ANGLE_OF_ATTACK'
---@field CAMERA_FIELD_ANGLE_OF_ATTACK	camerafield	_ConvertCameraField(2)
---
---CAMERA_FIELD_FIELD_OF_VIEW 'common.CAMERA_FIELD_FIELD_OF_VIEW'
---@field CAMERA_FIELD_FIELD_OF_VIEW	camerafield	_ConvertCameraField(3)
---
---CAMERA_FIELD_ROLL 'common.CAMERA_FIELD_ROLL'
---@field CAMERA_FIELD_ROLL	camerafield	_ConvertCameraField(4)
---
---CAMERA_FIELD_ROTATION 'common.CAMERA_FIELD_ROTATION'
---@field CAMERA_FIELD_ROTATION	camerafield	_ConvertCameraField(5)
---
---CAMERA_FIELD_ZOFFSET 'common.CAMERA_FIELD_ZOFFSET'
---@field CAMERA_FIELD_ZOFFSET	camerafield	_ConvertCameraField(6)
---
---CAMERA_FIELD_NEARZ 'common.CAMERA_FIELD_NEARZ'
---@field CAMERA_FIELD_NEARZ	camerafield	_ConvertCameraField(7)
---
---CAMERA_FIELD_LOCAL_PITCH 'common.CAMERA_FIELD_LOCAL_PITCH'
---@field CAMERA_FIELD_LOCAL_PITCH	camerafield	_ConvertCameraField(8)
---
---CAMERA_FIELD_LOCAL_YAW 'common.CAMERA_FIELD_LOCAL_YAW'
---@field CAMERA_FIELD_LOCAL_YAW	camerafield	_ConvertCameraField(9)
---
---CAMERA_FIELD_LOCAL_ROLL 'common.CAMERA_FIELD_LOCAL_ROLL'
---@field CAMERA_FIELD_LOCAL_ROLL	camerafield	_ConvertCameraField(10)
---
---BLEND_MODE_NONE 'common.BLEND_MODE_NONE'
---@field BLEND_MODE_NONE	blendmode	_ConvertBlendMode(0)
---
---BLEND_MODE_DONT_CARE 'common.BLEND_MODE_DONT_CARE'
---@field BLEND_MODE_DONT_CARE	blendmode	_ConvertBlendMode(0)
---
---BLEND_MODE_KEYALPHA 'common.BLEND_MODE_KEYALPHA'
---@field BLEND_MODE_KEYALPHA	blendmode	_ConvertBlendMode(1)
---
---BLEND_MODE_BLEND 'common.BLEND_MODE_BLEND'
---@field BLEND_MODE_BLEND	blendmode	_ConvertBlendMode(2)
---
---BLEND_MODE_ADDITIVE 'common.BLEND_MODE_ADDITIVE'
---@field BLEND_MODE_ADDITIVE	blendmode	_ConvertBlendMode(3)
---
---BLEND_MODE_MODULATE 'common.BLEND_MODE_MODULATE'
---@field BLEND_MODE_MODULATE	blendmode	_ConvertBlendMode(4)
---
---BLEND_MODE_MODULATE_2X 'common.BLEND_MODE_MODULATE_2X'
---@field BLEND_MODE_MODULATE_2X	blendmode	_ConvertBlendMode(5)
---
---RARITY_FREQUENT 'common.RARITY_FREQUENT'
---@field RARITY_FREQUENT	raritycontrol	_ConvertRarityControl(0)
---
---RARITY_RARE 'common.RARITY_RARE'
---@field RARITY_RARE	raritycontrol	_ConvertRarityControl(1)
---
---TEXMAP_FLAG_NONE 'common.TEXMAP_FLAG_NONE'
---@field TEXMAP_FLAG_NONE	texmapflags	_ConvertTexMapFlags(0)
---
---TEXMAP_FLAG_WRAP_U 'common.TEXMAP_FLAG_WRAP_U'
---@field TEXMAP_FLAG_WRAP_U	texmapflags	_ConvertTexMapFlags(1)
---
---TEXMAP_FLAG_WRAP_V 'common.TEXMAP_FLAG_WRAP_V'
---@field TEXMAP_FLAG_WRAP_V	texmapflags	_ConvertTexMapFlags(2)
---
---TEXMAP_FLAG_WRAP_UV 'common.TEXMAP_FLAG_WRAP_UV'
---@field TEXMAP_FLAG_WRAP_UV	texmapflags	_ConvertTexMapFlags(3)
---
---FOG_OF_WAR_MASKED 'common.FOG_OF_WAR_MASKED'
---@field FOG_OF_WAR_MASKED	fogstate	_ConvertFogState(1)
---
---FOG_OF_WAR_FOGGED 'common.FOG_OF_WAR_FOGGED'
---@field FOG_OF_WAR_FOGGED	fogstate	_ConvertFogState(2)
---
---FOG_OF_WAR_VISIBLE 'common.FOG_OF_WAR_VISIBLE'
---@field FOG_OF_WAR_VISIBLE	fogstate	_ConvertFogState(4)
---
---CAMERA_MARGIN_LEFT 'common.CAMERA_MARGIN_LEFT'
---@field CAMERA_MARGIN_LEFT	integer	_0
---
---CAMERA_MARGIN_RIGHT 'common.CAMERA_MARGIN_RIGHT'
---@field CAMERA_MARGIN_RIGHT	integer	_1
---
---CAMERA_MARGIN_TOP 'common.CAMERA_MARGIN_TOP'
---@field CAMERA_MARGIN_TOP	integer	_2
---
---CAMERA_MARGIN_BOTTOM 'common.CAMERA_MARGIN_BOTTOM'
---@field CAMERA_MARGIN_BOTTOM	integer	_3
---
---EFFECT_TYPE_EFFECT 'common.EFFECT_TYPE_EFFECT'
---@field EFFECT_TYPE_EFFECT	effecttype	_ConvertEffectType(0)
---
---EFFECT_TYPE_TARGET 'common.EFFECT_TYPE_TARGET'
---@field EFFECT_TYPE_TARGET	effecttype	_ConvertEffectType(1)
---
---EFFECT_TYPE_CASTER 'common.EFFECT_TYPE_CASTER'
---@field EFFECT_TYPE_CASTER	effecttype	_ConvertEffectType(2)
---
---EFFECT_TYPE_SPECIAL 'common.EFFECT_TYPE_SPECIAL'
---@field EFFECT_TYPE_SPECIAL	effecttype	_ConvertEffectType(3)
---
---EFFECT_TYPE_AREA_EFFECT 'common.EFFECT_TYPE_AREA_EFFECT'
---@field EFFECT_TYPE_AREA_EFFECT	effecttype	_ConvertEffectType(4)
---
---EFFECT_TYPE_MISSILE 'common.EFFECT_TYPE_MISSILE'
---@field EFFECT_TYPE_MISSILE	effecttype	_ConvertEffectType(5)
---
---EFFECT_TYPE_LIGHTNING 'common.EFFECT_TYPE_LIGHTNING'
---@field EFFECT_TYPE_LIGHTNING	effecttype	_ConvertEffectType(6)
---
---SOUND_TYPE_EFFECT 'common.SOUND_TYPE_EFFECT'
---@field SOUND_TYPE_EFFECT	soundtype	_ConvertSoundType(0)
---
---SOUND_TYPE_EFFECT_LOOPED 'common.SOUND_TYPE_EFFECT_LOOPED'
---@field SOUND_TYPE_EFFECT_LOOPED	soundtype	_ConvertSoundType(1)
---
---ORIGIN_FRAME_GAME_UI 'common.ORIGIN_FRAME_GAME_UI'
---@field ORIGIN_FRAME_GAME_UI	originframetype	_ConvertOriginFrameType(0)
---
---ORIGIN_FRAME_COMMAND_BUTTON 'common.ORIGIN_FRAME_COMMAND_BUTTON'
---@field ORIGIN_FRAME_COMMAND_BUTTON	originframetype	_ConvertOriginFrameType(1)
---
---ORIGIN_FRAME_HERO_BAR 'common.ORIGIN_FRAME_HERO_BAR'
---@field ORIGIN_FRAME_HERO_BAR	originframetype	_ConvertOriginFrameType(2)
---
---ORIGIN_FRAME_HERO_BUTTON 'common.ORIGIN_FRAME_HERO_BUTTON'
---@field ORIGIN_FRAME_HERO_BUTTON	originframetype	_ConvertOriginFrameType(3)
---
---ORIGIN_FRAME_HERO_HP_BAR 'common.ORIGIN_FRAME_HERO_HP_BAR'
---@field ORIGIN_FRAME_HERO_HP_BAR	originframetype	_ConvertOriginFrameType(4)
---
---ORIGIN_FRAME_HERO_MANA_BAR 'common.ORIGIN_FRAME_HERO_MANA_BAR'
---@field ORIGIN_FRAME_HERO_MANA_BAR	originframetype	_ConvertOriginFrameType(5)
---
---ORIGIN_FRAME_HERO_BUTTON_INDICATOR 'common.ORIGIN_FRAME_HERO_BUTTON_INDICATOR'
---@field ORIGIN_FRAME_HERO_BUTTON_INDICATOR	originframetype	_ConvertOriginFrameType(6)
---
---ORIGIN_FRAME_ITEM_BUTTON 'common.ORIGIN_FRAME_ITEM_BUTTON'
---@field ORIGIN_FRAME_ITEM_BUTTON	originframetype	_ConvertOriginFrameType(7)
---
---ORIGIN_FRAME_MINIMAP 'common.ORIGIN_FRAME_MINIMAP'
---@field ORIGIN_FRAME_MINIMAP	originframetype	_ConvertOriginFrameType(8)
---
---ORIGIN_FRAME_MINIMAP_BUTTON 'common.ORIGIN_FRAME_MINIMAP_BUTTON'
---@field ORIGIN_FRAME_MINIMAP_BUTTON	originframetype	_ConvertOriginFrameType(9)
---
---ORIGIN_FRAME_SYSTEM_BUTTON 'common.ORIGIN_FRAME_SYSTEM_BUTTON'
---@field ORIGIN_FRAME_SYSTEM_BUTTON	originframetype	_ConvertOriginFrameType(10)
---
---ORIGIN_FRAME_TOOLTIP 'common.ORIGIN_FRAME_TOOLTIP'
---@field ORIGIN_FRAME_TOOLTIP	originframetype	_ConvertOriginFrameType(11)
---
---ORIGIN_FRAME_UBERTOOLTIP 'common.ORIGIN_FRAME_UBERTOOLTIP'
---@field ORIGIN_FRAME_UBERTOOLTIP	originframetype	_ConvertOriginFrameType(12)
---
---ORIGIN_FRAME_CHAT_MSG 'common.ORIGIN_FRAME_CHAT_MSG'
---@field ORIGIN_FRAME_CHAT_MSG	originframetype	_ConvertOriginFrameType(13)
---
---ORIGIN_FRAME_UNIT_MSG 'common.ORIGIN_FRAME_UNIT_MSG'
---@field ORIGIN_FRAME_UNIT_MSG	originframetype	_ConvertOriginFrameType(14)
---
---ORIGIN_FRAME_TOP_MSG 'common.ORIGIN_FRAME_TOP_MSG'
---@field ORIGIN_FRAME_TOP_MSG	originframetype	_ConvertOriginFrameType(15)
---
---ORIGIN_FRAME_PORTRAIT 'common.ORIGIN_FRAME_PORTRAIT'
---@field ORIGIN_FRAME_PORTRAIT	originframetype	_ConvertOriginFrameType(16)
---
---ORIGIN_FRAME_WORLD_FRAME 'common.ORIGIN_FRAME_WORLD_FRAME'
---@field ORIGIN_FRAME_WORLD_FRAME	originframetype	_ConvertOriginFrameType(17)
---
---ORIGIN_FRAME_SIMPLE_UI_PARENT 'common.ORIGIN_FRAME_SIMPLE_UI_PARENT'
---@field ORIGIN_FRAME_SIMPLE_UI_PARENT	originframetype	_ConvertOriginFrameType(18)
---
---ORIGIN_FRAME_PORTRAIT_HP_TEXT 'common.ORIGIN_FRAME_PORTRAIT_HP_TEXT'
---@field ORIGIN_FRAME_PORTRAIT_HP_TEXT	originframetype	_ConvertOriginFrameType(19)
---
---ORIGIN_FRAME_PORTRAIT_MANA_TEXT 'common.ORIGIN_FRAME_PORTRAIT_MANA_TEXT'
---@field ORIGIN_FRAME_PORTRAIT_MANA_TEXT	originframetype	_ConvertOriginFrameType(20)
---
---ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR 'common.ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR'
---@field ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR	originframetype	_ConvertOriginFrameType(21)
---
---ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR_LABEL 'common.ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR_LABEL'
---@field ORIGIN_FRAME_UNIT_PANEL_BUFF_BAR_LABEL	originframetype	_ConvertOriginFrameType(22)
---
---FRAMEPOINT_TOPLEFT 'common.FRAMEPOINT_TOPLEFT'
---@field FRAMEPOINT_TOPLEFT	framepointtype	_ConvertFramePointType(0)
---
---FRAMEPOINT_TOP 'common.FRAMEPOINT_TOP'
---@field FRAMEPOINT_TOP	framepointtype	_ConvertFramePointType(1)
---
---FRAMEPOINT_TOPRIGHT 'common.FRAMEPOINT_TOPRIGHT'
---@field FRAMEPOINT_TOPRIGHT	framepointtype	_ConvertFramePointType(2)
---
---FRAMEPOINT_LEFT 'common.FRAMEPOINT_LEFT'
---@field FRAMEPOINT_LEFT	framepointtype	_ConvertFramePointType(3)
---
---FRAMEPOINT_CENTER 'common.FRAMEPOINT_CENTER'
---@field FRAMEPOINT_CENTER	framepointtype	_ConvertFramePointType(4)
---
---FRAMEPOINT_RIGHT 'common.FRAMEPOINT_RIGHT'
---@field FRAMEPOINT_RIGHT	framepointtype	_ConvertFramePointType(5)
---
---FRAMEPOINT_BOTTOMLEFT 'common.FRAMEPOINT_BOTTOMLEFT'
---@field FRAMEPOINT_BOTTOMLEFT	framepointtype	_ConvertFramePointType(6)
---
---FRAMEPOINT_BOTTOM 'common.FRAMEPOINT_BOTTOM'
---@field FRAMEPOINT_BOTTOM	framepointtype	_ConvertFramePointType(7)
---
---FRAMEPOINT_BOTTOMRIGHT 'common.FRAMEPOINT_BOTTOMRIGHT'
---@field FRAMEPOINT_BOTTOMRIGHT	framepointtype	_ConvertFramePointType(8)
---
---TEXT_JUSTIFY_TOP 'common.TEXT_JUSTIFY_TOP'
---@field TEXT_JUSTIFY_TOP	textaligntype	_ConvertTextAlignType(0)
---
---TEXT_JUSTIFY_MIDDLE 'common.TEXT_JUSTIFY_MIDDLE'
---@field TEXT_JUSTIFY_MIDDLE	textaligntype	_ConvertTextAlignType(1)
---
---TEXT_JUSTIFY_BOTTOM 'common.TEXT_JUSTIFY_BOTTOM'
---@field TEXT_JUSTIFY_BOTTOM	textaligntype	_ConvertTextAlignType(2)
---
---TEXT_JUSTIFY_LEFT 'common.TEXT_JUSTIFY_LEFT'
---@field TEXT_JUSTIFY_LEFT	textaligntype	_ConvertTextAlignType(3)
---
---TEXT_JUSTIFY_CENTER 'common.TEXT_JUSTIFY_CENTER'
---@field TEXT_JUSTIFY_CENTER	textaligntype	_ConvertTextAlignType(4)
---
---TEXT_JUSTIFY_RIGHT 'common.TEXT_JUSTIFY_RIGHT'
---@field TEXT_JUSTIFY_RIGHT	textaligntype	_ConvertTextAlignType(5)
---
---FRAMEEVENT_CONTROL_CLICK 'common.FRAMEEVENT_CONTROL_CLICK'
---@field FRAMEEVENT_CONTROL_CLICK	frameeventtype	_ConvertFrameEventType(1)
---
---FRAMEEVENT_MOUSE_ENTER 'common.FRAMEEVENT_MOUSE_ENTER'
---@field FRAMEEVENT_MOUSE_ENTER	frameeventtype	_ConvertFrameEventType(2)
---
---FRAMEEVENT_MOUSE_LEAVE 'common.FRAMEEVENT_MOUSE_LEAVE'
---@field FRAMEEVENT_MOUSE_LEAVE	frameeventtype	_ConvertFrameEventType(3)
---
---FRAMEEVENT_MOUSE_UP 'common.FRAMEEVENT_MOUSE_UP'
---@field FRAMEEVENT_MOUSE_UP	frameeventtype	_ConvertFrameEventType(4)
---
---FRAMEEVENT_MOUSE_DOWN 'common.FRAMEEVENT_MOUSE_DOWN'
---@field FRAMEEVENT_MOUSE_DOWN	frameeventtype	_ConvertFrameEventType(5)
---
---FRAMEEVENT_MOUSE_WHEEL 'common.FRAMEEVENT_MOUSE_WHEEL'
---@field FRAMEEVENT_MOUSE_WHEEL	frameeventtype	_ConvertFrameEventType(6)
---
---FRAMEEVENT_CHECKBOX_CHECKED 'common.FRAMEEVENT_CHECKBOX_CHECKED'
---@field FRAMEEVENT_CHECKBOX_CHECKED	frameeventtype	_ConvertFrameEventType(7)
---
---FRAMEEVENT_CHECKBOX_UNCHECKED 'common.FRAMEEVENT_CHECKBOX_UNCHECKED'
---@field FRAMEEVENT_CHECKBOX_UNCHECKED	frameeventtype	_ConvertFrameEventType(8)
---
---FRAMEEVENT_EDITBOX_TEXT_CHANGED 'common.FRAMEEVENT_EDITBOX_TEXT_CHANGED'
---@field FRAMEEVENT_EDITBOX_TEXT_CHANGED	frameeventtype	_ConvertFrameEventType(9)
---
---FRAMEEVENT_POPUPMENU_ITEM_CHANGED 'common.FRAMEEVENT_POPUPMENU_ITEM_CHANGED'
---@field FRAMEEVENT_POPUPMENU_ITEM_CHANGED	frameeventtype	_ConvertFrameEventType(10)
---
---FRAMEEVENT_MOUSE_DOUBLECLICK 'common.FRAMEEVENT_MOUSE_DOUBLECLICK'
---@field FRAMEEVENT_MOUSE_DOUBLECLICK	frameeventtype	_ConvertFrameEventType(11)
---
---FRAMEEVENT_SPRITE_ANIM_UPDATE 'common.FRAMEEVENT_SPRITE_ANIM_UPDATE'
---@field FRAMEEVENT_SPRITE_ANIM_UPDATE	frameeventtype	_ConvertFrameEventType(12)
---
---FRAMEEVENT_SLIDER_VALUE_CHANGED 'common.FRAMEEVENT_SLIDER_VALUE_CHANGED'
---@field FRAMEEVENT_SLIDER_VALUE_CHANGED	frameeventtype	_ConvertFrameEventType(13)
---
---FRAMEEVENT_DIALOG_CANCEL 'common.FRAMEEVENT_DIALOG_CANCEL'
---@field FRAMEEVENT_DIALOG_CANCEL	frameeventtype	_ConvertFrameEventType(14)
---
---FRAMEEVENT_DIALOG_ACCEPT 'common.FRAMEEVENT_DIALOG_ACCEPT'
---@field FRAMEEVENT_DIALOG_ACCEPT	frameeventtype	_ConvertFrameEventType(15)
---
---FRAMEEVENT_EDITBOX_ENTER 'common.FRAMEEVENT_EDITBOX_ENTER'
---@field FRAMEEVENT_EDITBOX_ENTER	frameeventtype	_ConvertFrameEventType(16)
---
---OSKEY_BACKSPACE 'common.OSKEY_BACKSPACE'
---@field OSKEY_BACKSPACE	oskeytype	_ConvertOsKeyType($08)
---
---OSKEY_TAB 'common.OSKEY_TAB'
---@field OSKEY_TAB	oskeytype	_ConvertOsKeyType($09)
---
---OSKEY_CLEAR 'common.OSKEY_CLEAR'
---@field OSKEY_CLEAR	oskeytype	_ConvertOsKeyType($0C)
---
---OSKEY_RETURN 'common.OSKEY_RETURN'
---@field OSKEY_RETURN	oskeytype	_ConvertOsKeyType($0D)
---
---OSKEY_SHIFT 'common.OSKEY_SHIFT'
---@field OSKEY_SHIFT	oskeytype	_ConvertOsKeyType($10)
---
---OSKEY_CONTROL 'common.OSKEY_CONTROL'
---@field OSKEY_CONTROL	oskeytype	_ConvertOsKeyType($11)
---
---OSKEY_ALT 'common.OSKEY_ALT'
---@field OSKEY_ALT	oskeytype	_ConvertOsKeyType($12)
---
---OSKEY_PAUSE 'common.OSKEY_PAUSE'
---@field OSKEY_PAUSE	oskeytype	_ConvertOsKeyType($13)
---
---OSKEY_CAPSLOCK 'common.OSKEY_CAPSLOCK'
---@field OSKEY_CAPSLOCK	oskeytype	_ConvertOsKeyType($14)
---
---OSKEY_KANA 'common.OSKEY_KANA'
---@field OSKEY_KANA	oskeytype	_ConvertOsKeyType($15)
---
---OSKEY_HANGUL 'common.OSKEY_HANGUL'
---@field OSKEY_HANGUL	oskeytype	_ConvertOsKeyType($15)
---
---OSKEY_JUNJA 'common.OSKEY_JUNJA'
---@field OSKEY_JUNJA	oskeytype	_ConvertOsKeyType($17)
---
---OSKEY_FINAL 'common.OSKEY_FINAL'
---@field OSKEY_FINAL	oskeytype	_ConvertOsKeyType($18)
---
---OSKEY_HANJA 'common.OSKEY_HANJA'
---@field OSKEY_HANJA	oskeytype	_ConvertOsKeyType($19)
---
---OSKEY_KANJI 'common.OSKEY_KANJI'
---@field OSKEY_KANJI	oskeytype	_ConvertOsKeyType($19)
---
---OSKEY_ESCAPE 'common.OSKEY_ESCAPE'
---@field OSKEY_ESCAPE	oskeytype	_ConvertOsKeyType($1B)
---
---OSKEY_CONVERT 'common.OSKEY_CONVERT'
---@field OSKEY_CONVERT	oskeytype	_ConvertOsKeyType($1C)
---
---OSKEY_NONCONVERT 'common.OSKEY_NONCONVERT'
---@field OSKEY_NONCONVERT	oskeytype	_ConvertOsKeyType($1D)
---
---OSKEY_ACCEPT 'common.OSKEY_ACCEPT'
---@field OSKEY_ACCEPT	oskeytype	_ConvertOsKeyType($1E)
---
---OSKEY_MODECHANGE 'common.OSKEY_MODECHANGE'
---@field OSKEY_MODECHANGE	oskeytype	_ConvertOsKeyType($1F)
---
---OSKEY_SPACE 'common.OSKEY_SPACE'
---@field OSKEY_SPACE	oskeytype	_ConvertOsKeyType($20)
---
---OSKEY_PAGEUP 'common.OSKEY_PAGEUP'
---@field OSKEY_PAGEUP	oskeytype	_ConvertOsKeyType($21)
---
---OSKEY_PAGEDOWN 'common.OSKEY_PAGEDOWN'
---@field OSKEY_PAGEDOWN	oskeytype	_ConvertOsKeyType($22)
---
---OSKEY_END 'common.OSKEY_END'
---@field OSKEY_END	oskeytype	_ConvertOsKeyType($23)
---
---OSKEY_HOME 'common.OSKEY_HOME'
---@field OSKEY_HOME	oskeytype	_ConvertOsKeyType($24)
---
---OSKEY_LEFT 'common.OSKEY_LEFT'
---@field OSKEY_LEFT	oskeytype	_ConvertOsKeyType($25)
---
---OSKEY_UP 'common.OSKEY_UP'
---@field OSKEY_UP	oskeytype	_ConvertOsKeyType($26)
---
---OSKEY_RIGHT 'common.OSKEY_RIGHT'
---@field OSKEY_RIGHT	oskeytype	_ConvertOsKeyType($27)
---
---OSKEY_DOWN 'common.OSKEY_DOWN'
---@field OSKEY_DOWN	oskeytype	_ConvertOsKeyType($28)
---
---OSKEY_SELECT 'common.OSKEY_SELECT'
---@field OSKEY_SELECT	oskeytype	_ConvertOsKeyType($29)
---
---OSKEY_PRINT 'common.OSKEY_PRINT'
---@field OSKEY_PRINT	oskeytype	_ConvertOsKeyType($2A)
---
---OSKEY_EXECUTE 'common.OSKEY_EXECUTE'
---@field OSKEY_EXECUTE	oskeytype	_ConvertOsKeyType($2B)
---
---OSKEY_PRINTSCREEN 'common.OSKEY_PRINTSCREEN'
---@field OSKEY_PRINTSCREEN	oskeytype	_ConvertOsKeyType($2C)
---
---OSKEY_INSERT 'common.OSKEY_INSERT'
---@field OSKEY_INSERT	oskeytype	_ConvertOsKeyType($2D)
---
---OSKEY_DELETE 'common.OSKEY_DELETE'
---@field OSKEY_DELETE	oskeytype	_ConvertOsKeyType($2E)
---
---OSKEY_HELP 'common.OSKEY_HELP'
---@field OSKEY_HELP	oskeytype	_ConvertOsKeyType($2F)
---
---OSKEY_0 'common.OSKEY_0'
---@field OSKEY_0	oskeytype	_ConvertOsKeyType($30)
---
---OSKEY_1 'common.OSKEY_1'
---@field OSKEY_1	oskeytype	_ConvertOsKeyType($31)
---
---OSKEY_2 'common.OSKEY_2'
---@field OSKEY_2	oskeytype	_ConvertOsKeyType($32)
---
---OSKEY_3 'common.OSKEY_3'
---@field OSKEY_3	oskeytype	_ConvertOsKeyType($33)
---
---OSKEY_4 'common.OSKEY_4'
---@field OSKEY_4	oskeytype	_ConvertOsKeyType($34)
---
---OSKEY_5 'common.OSKEY_5'
---@field OSKEY_5	oskeytype	_ConvertOsKeyType($35)
---
---OSKEY_6 'common.OSKEY_6'
---@field OSKEY_6	oskeytype	_ConvertOsKeyType($36)
---
---OSKEY_7 'common.OSKEY_7'
---@field OSKEY_7	oskeytype	_ConvertOsKeyType($37)
---
---OSKEY_8 'common.OSKEY_8'
---@field OSKEY_8	oskeytype	_ConvertOsKeyType($38)
---
---OSKEY_9 'common.OSKEY_9'
---@field OSKEY_9	oskeytype	_ConvertOsKeyType($39)
---
---OSKEY_A 'common.OSKEY_A'
---@field OSKEY_A	oskeytype	_ConvertOsKeyType($41)
---
---OSKEY_B 'common.OSKEY_B'
---@field OSKEY_B	oskeytype	_ConvertOsKeyType($42)
---
---OSKEY_C 'common.OSKEY_C'
---@field OSKEY_C	oskeytype	_ConvertOsKeyType($43)
---
---OSKEY_D 'common.OSKEY_D'
---@field OSKEY_D	oskeytype	_ConvertOsKeyType($44)
---
---OSKEY_E 'common.OSKEY_E'
---@field OSKEY_E	oskeytype	_ConvertOsKeyType($45)
---
---OSKEY_F 'common.OSKEY_F'
---@field OSKEY_F	oskeytype	_ConvertOsKeyType($46)
---
---OSKEY_G 'common.OSKEY_G'
---@field OSKEY_G	oskeytype	_ConvertOsKeyType($47)
---
---OSKEY_H 'common.OSKEY_H'
---@field OSKEY_H	oskeytype	_ConvertOsKeyType($48)
---
---OSKEY_I 'common.OSKEY_I'
---@field OSKEY_I	oskeytype	_ConvertOsKeyType($49)
---
---OSKEY_J 'common.OSKEY_J'
---@field OSKEY_J	oskeytype	_ConvertOsKeyType($4A)
---
---OSKEY_K 'common.OSKEY_K'
---@field OSKEY_K	oskeytype	_ConvertOsKeyType($4B)
---
---OSKEY_L 'common.OSKEY_L'
---@field OSKEY_L	oskeytype	_ConvertOsKeyType($4C)
---
---OSKEY_M 'common.OSKEY_M'
---@field OSKEY_M	oskeytype	_ConvertOsKeyType($4D)
---
---OSKEY_N 'common.OSKEY_N'
---@field OSKEY_N	oskeytype	_ConvertOsKeyType($4E)
---
---OSKEY_O 'common.OSKEY_O'
---@field OSKEY_O	oskeytype	_ConvertOsKeyType($4F)
---
---OSKEY_P 'common.OSKEY_P'
---@field OSKEY_P	oskeytype	_ConvertOsKeyType($50)
---
---OSKEY_Q 'common.OSKEY_Q'
---@field OSKEY_Q	oskeytype	_ConvertOsKeyType($51)
---
---OSKEY_R 'common.OSKEY_R'
---@field OSKEY_R	oskeytype	_ConvertOsKeyType($52)
---
---OSKEY_S 'common.OSKEY_S'
---@field OSKEY_S	oskeytype	_ConvertOsKeyType($53)
---
---OSKEY_T 'common.OSKEY_T'
---@field OSKEY_T	oskeytype	_ConvertOsKeyType($54)
---
---OSKEY_U 'common.OSKEY_U'
---@field OSKEY_U	oskeytype	_ConvertOsKeyType($55)
---
---OSKEY_V 'common.OSKEY_V'
---@field OSKEY_V	oskeytype	_ConvertOsKeyType($56)
---
---OSKEY_W 'common.OSKEY_W'
---@field OSKEY_W	oskeytype	_ConvertOsKeyType($57)
---
---OSKEY_X 'common.OSKEY_X'
---@field OSKEY_X	oskeytype	_ConvertOsKeyType($58)
---
---OSKEY_Y 'common.OSKEY_Y'
---@field OSKEY_Y	oskeytype	_ConvertOsKeyType($59)
---
---OSKEY_Z 'common.OSKEY_Z'
---@field OSKEY_Z	oskeytype	_ConvertOsKeyType($5A)
---
---OSKEY_LMETA 'common.OSKEY_LMETA'
---@field OSKEY_LMETA	oskeytype	_ConvertOsKeyType($5B)
---
---OSKEY_RMETA 'common.OSKEY_RMETA'
---@field OSKEY_RMETA	oskeytype	_ConvertOsKeyType($5C)
---
---OSKEY_APPS 'common.OSKEY_APPS'
---@field OSKEY_APPS	oskeytype	_ConvertOsKeyType($5D)
---
---OSKEY_SLEEP 'common.OSKEY_SLEEP'
---@field OSKEY_SLEEP	oskeytype	_ConvertOsKeyType($5F)
---
---OSKEY_NUMPAD0 'common.OSKEY_NUMPAD0'
---@field OSKEY_NUMPAD0	oskeytype	_ConvertOsKeyType($60)
---
---OSKEY_NUMPAD1 'common.OSKEY_NUMPAD1'
---@field OSKEY_NUMPAD1	oskeytype	_ConvertOsKeyType($61)
---
---OSKEY_NUMPAD2 'common.OSKEY_NUMPAD2'
---@field OSKEY_NUMPAD2	oskeytype	_ConvertOsKeyType($62)
---
---OSKEY_NUMPAD3 'common.OSKEY_NUMPAD3'
---@field OSKEY_NUMPAD3	oskeytype	_ConvertOsKeyType($63)
---
---OSKEY_NUMPAD4 'common.OSKEY_NUMPAD4'
---@field OSKEY_NUMPAD4	oskeytype	_ConvertOsKeyType($64)
---
---OSKEY_NUMPAD5 'common.OSKEY_NUMPAD5'
---@field OSKEY_NUMPAD5	oskeytype	_ConvertOsKeyType($65)
---
---OSKEY_NUMPAD6 'common.OSKEY_NUMPAD6'
---@field OSKEY_NUMPAD6	oskeytype	_ConvertOsKeyType($66)
---
---OSKEY_NUMPAD7 'common.OSKEY_NUMPAD7'
---@field OSKEY_NUMPAD7	oskeytype	_ConvertOsKeyType($67)
---
---OSKEY_NUMPAD8 'common.OSKEY_NUMPAD8'
---@field OSKEY_NUMPAD8	oskeytype	_ConvertOsKeyType($68)
---
---OSKEY_NUMPAD9 'common.OSKEY_NUMPAD9'
---@field OSKEY_NUMPAD9	oskeytype	_ConvertOsKeyType($69)
---
---OSKEY_MULTIPLY 'common.OSKEY_MULTIPLY'
---@field OSKEY_MULTIPLY	oskeytype	_ConvertOsKeyType($6A)
---
---OSKEY_ADD 'common.OSKEY_ADD'
---@field OSKEY_ADD	oskeytype	_ConvertOsKeyType($6B)
---
---OSKEY_SEPARATOR 'common.OSKEY_SEPARATOR'
---@field OSKEY_SEPARATOR	oskeytype	_ConvertOsKeyType($6C)
---
---OSKEY_SUBTRACT 'common.OSKEY_SUBTRACT'
---@field OSKEY_SUBTRACT	oskeytype	_ConvertOsKeyType($6D)
---
---OSKEY_DECIMAL 'common.OSKEY_DECIMAL'
---@field OSKEY_DECIMAL	oskeytype	_ConvertOsKeyType($6E)
---
---OSKEY_DIVIDE 'common.OSKEY_DIVIDE'
---@field OSKEY_DIVIDE	oskeytype	_ConvertOsKeyType($6F)
---
---OSKEY_F1 'common.OSKEY_F1'
---@field OSKEY_F1	oskeytype	_ConvertOsKeyType($70)
---
---OSKEY_F2 'common.OSKEY_F2'
---@field OSKEY_F2	oskeytype	_ConvertOsKeyType($71)
---
---OSKEY_F3 'common.OSKEY_F3'
---@field OSKEY_F3	oskeytype	_ConvertOsKeyType($72)
---
---OSKEY_F4 'common.OSKEY_F4'
---@field OSKEY_F4	oskeytype	_ConvertOsKeyType($73)
---
---OSKEY_F5 'common.OSKEY_F5'
---@field OSKEY_F5	oskeytype	_ConvertOsKeyType($74)
---
---OSKEY_F6 'common.OSKEY_F6'
---@field OSKEY_F6	oskeytype	_ConvertOsKeyType($75)
---
---OSKEY_F7 'common.OSKEY_F7'
---@field OSKEY_F7	oskeytype	_ConvertOsKeyType($76)
---
---OSKEY_F8 'common.OSKEY_F8'
---@field OSKEY_F8	oskeytype	_ConvertOsKeyType($77)
---
---OSKEY_F9 'common.OSKEY_F9'
---@field OSKEY_F9	oskeytype	_ConvertOsKeyType($78)
---
---OSKEY_F10 'common.OSKEY_F10'
---@field OSKEY_F10	oskeytype	_ConvertOsKeyType($79)
---
---OSKEY_F11 'common.OSKEY_F11'
---@field OSKEY_F11	oskeytype	_ConvertOsKeyType($7A)
---
---OSKEY_F12 'common.OSKEY_F12'
---@field OSKEY_F12	oskeytype	_ConvertOsKeyType($7B)
---
---OSKEY_F13 'common.OSKEY_F13'
---@field OSKEY_F13	oskeytype	_ConvertOsKeyType($7C)
---
---OSKEY_F14 'common.OSKEY_F14'
---@field OSKEY_F14	oskeytype	_ConvertOsKeyType($7D)
---
---OSKEY_F15 'common.OSKEY_F15'
---@field OSKEY_F15	oskeytype	_ConvertOsKeyType($7E)
---
---OSKEY_F16 'common.OSKEY_F16'
---@field OSKEY_F16	oskeytype	_ConvertOsKeyType($7F)
---
---OSKEY_F17 'common.OSKEY_F17'
---@field OSKEY_F17	oskeytype	_ConvertOsKeyType($80)
---
---OSKEY_F18 'common.OSKEY_F18'
---@field OSKEY_F18	oskeytype	_ConvertOsKeyType($81)
---
---OSKEY_F19 'common.OSKEY_F19'
---@field OSKEY_F19	oskeytype	_ConvertOsKeyType($82)
---
---OSKEY_F20 'common.OSKEY_F20'
---@field OSKEY_F20	oskeytype	_ConvertOsKeyType($83)
---
---OSKEY_F21 'common.OSKEY_F21'
---@field OSKEY_F21	oskeytype	_ConvertOsKeyType($84)
---
---OSKEY_F22 'common.OSKEY_F22'
---@field OSKEY_F22	oskeytype	_ConvertOsKeyType($85)
---
---OSKEY_F23 'common.OSKEY_F23'
---@field OSKEY_F23	oskeytype	_ConvertOsKeyType($86)
---
---OSKEY_F24 'common.OSKEY_F24'
---@field OSKEY_F24	oskeytype	_ConvertOsKeyType($87)
---
---OSKEY_NUMLOCK 'common.OSKEY_NUMLOCK'
---@field OSKEY_NUMLOCK	oskeytype	_ConvertOsKeyType($90)
---
---OSKEY_SCROLLLOCK 'common.OSKEY_SCROLLLOCK'
---@field OSKEY_SCROLLLOCK	oskeytype	_ConvertOsKeyType($91)
---
---OSKEY_OEM_NEC_EQUAL 'common.OSKEY_OEM_NEC_EQUAL'
---@field OSKEY_OEM_NEC_EQUAL	oskeytype	_ConvertOsKeyType($92)
---
---OSKEY_OEM_FJ_JISHO 'common.OSKEY_OEM_FJ_JISHO'
---@field OSKEY_OEM_FJ_JISHO	oskeytype	_ConvertOsKeyType($92)
---
---OSKEY_OEM_FJ_MASSHOU 'common.OSKEY_OEM_FJ_MASSHOU'
---@field OSKEY_OEM_FJ_MASSHOU	oskeytype	_ConvertOsKeyType($93)
---
---OSKEY_OEM_FJ_TOUROKU 'common.OSKEY_OEM_FJ_TOUROKU'
---@field OSKEY_OEM_FJ_TOUROKU	oskeytype	_ConvertOsKeyType($94)
---
---OSKEY_OEM_FJ_LOYA 'common.OSKEY_OEM_FJ_LOYA'
---@field OSKEY_OEM_FJ_LOYA	oskeytype	_ConvertOsKeyType($95)
---
---OSKEY_OEM_FJ_ROYA 'common.OSKEY_OEM_FJ_ROYA'
---@field OSKEY_OEM_FJ_ROYA	oskeytype	_ConvertOsKeyType($96)
---
---OSKEY_LSHIFT 'common.OSKEY_LSHIFT'
---@field OSKEY_LSHIFT	oskeytype	_ConvertOsKeyType($A0)
---
---OSKEY_RSHIFT 'common.OSKEY_RSHIFT'
---@field OSKEY_RSHIFT	oskeytype	_ConvertOsKeyType($A1)
---
---OSKEY_LCONTROL 'common.OSKEY_LCONTROL'
---@field OSKEY_LCONTROL	oskeytype	_ConvertOsKeyType($A2)
---
---OSKEY_RCONTROL 'common.OSKEY_RCONTROL'
---@field OSKEY_RCONTROL	oskeytype	_ConvertOsKeyType($A3)
---
---OSKEY_LALT 'common.OSKEY_LALT'
---@field OSKEY_LALT	oskeytype	_ConvertOsKeyType($A4)
---
---OSKEY_RALT 'common.OSKEY_RALT'
---@field OSKEY_RALT	oskeytype	_ConvertOsKeyType($A5)
---
---OSKEY_BROWSER_BACK 'common.OSKEY_BROWSER_BACK'
---@field OSKEY_BROWSER_BACK	oskeytype	_ConvertOsKeyType($A6)
---
---OSKEY_BROWSER_FORWARD 'common.OSKEY_BROWSER_FORWARD'
---@field OSKEY_BROWSER_FORWARD	oskeytype	_ConvertOsKeyType($A7)
---
---OSKEY_BROWSER_REFRESH 'common.OSKEY_BROWSER_REFRESH'
---@field OSKEY_BROWSER_REFRESH	oskeytype	_ConvertOsKeyType($A8)
---
---OSKEY_BROWSER_STOP 'common.OSKEY_BROWSER_STOP'
---@field OSKEY_BROWSER_STOP	oskeytype	_ConvertOsKeyType($A9)
---
---OSKEY_BROWSER_SEARCH 'common.OSKEY_BROWSER_SEARCH'
---@field OSKEY_BROWSER_SEARCH	oskeytype	_ConvertOsKeyType($AA)
---
---OSKEY_BROWSER_FAVORITES 'common.OSKEY_BROWSER_FAVORITES'
---@field OSKEY_BROWSER_FAVORITES	oskeytype	_ConvertOsKeyType($AB)
---
---OSKEY_BROWSER_HOME 'common.OSKEY_BROWSER_HOME'
---@field OSKEY_BROWSER_HOME	oskeytype	_ConvertOsKeyType($AC)
---
---OSKEY_VOLUME_MUTE 'common.OSKEY_VOLUME_MUTE'
---@field OSKEY_VOLUME_MUTE	oskeytype	_ConvertOsKeyType($AD)
---
---OSKEY_VOLUME_DOWN 'common.OSKEY_VOLUME_DOWN'
---@field OSKEY_VOLUME_DOWN	oskeytype	_ConvertOsKeyType($AE)
---
---OSKEY_VOLUME_UP 'common.OSKEY_VOLUME_UP'
---@field OSKEY_VOLUME_UP	oskeytype	_ConvertOsKeyType($AF)
---
---OSKEY_MEDIA_NEXT_TRACK 'common.OSKEY_MEDIA_NEXT_TRACK'
---@field OSKEY_MEDIA_NEXT_TRACK	oskeytype	_ConvertOsKeyType($B0)
---
---OSKEY_MEDIA_PREV_TRACK 'common.OSKEY_MEDIA_PREV_TRACK'
---@field OSKEY_MEDIA_PREV_TRACK	oskeytype	_ConvertOsKeyType($B1)
---
---OSKEY_MEDIA_STOP 'common.OSKEY_MEDIA_STOP'
---@field OSKEY_MEDIA_STOP	oskeytype	_ConvertOsKeyType($B2)
---
---OSKEY_MEDIA_PLAY_PAUSE 'common.OSKEY_MEDIA_PLAY_PAUSE'
---@field OSKEY_MEDIA_PLAY_PAUSE	oskeytype	_ConvertOsKeyType($B3)
---
---OSKEY_LAUNCH_MAIL 'common.OSKEY_LAUNCH_MAIL'
---@field OSKEY_LAUNCH_MAIL	oskeytype	_ConvertOsKeyType($B4)
---
---OSKEY_LAUNCH_MEDIA_SELECT 'common.OSKEY_LAUNCH_MEDIA_SELECT'
---@field OSKEY_LAUNCH_MEDIA_SELECT	oskeytype	_ConvertOsKeyType($B5)
---
---OSKEY_LAUNCH_APP1 'common.OSKEY_LAUNCH_APP1'
---@field OSKEY_LAUNCH_APP1	oskeytype	_ConvertOsKeyType($B6)
---
---OSKEY_LAUNCH_APP2 'common.OSKEY_LAUNCH_APP2'
---@field OSKEY_LAUNCH_APP2	oskeytype	_ConvertOsKeyType($B7)
---
---OSKEY_OEM_1 'common.OSKEY_OEM_1'
---@field OSKEY_OEM_1	oskeytype	_ConvertOsKeyType($BA)
---
---OSKEY_OEM_PLUS 'common.OSKEY_OEM_PLUS'
---@field OSKEY_OEM_PLUS	oskeytype	_ConvertOsKeyType($BB)
---
---OSKEY_OEM_COMMA 'common.OSKEY_OEM_COMMA'
---@field OSKEY_OEM_COMMA	oskeytype	_ConvertOsKeyType($BC)
---
---OSKEY_OEM_MINUS 'common.OSKEY_OEM_MINUS'
---@field OSKEY_OEM_MINUS	oskeytype	_ConvertOsKeyType($BD)
---
---OSKEY_OEM_PERIOD 'common.OSKEY_OEM_PERIOD'
---@field OSKEY_OEM_PERIOD	oskeytype	_ConvertOsKeyType($BE)
---
---OSKEY_OEM_2 'common.OSKEY_OEM_2'
---@field OSKEY_OEM_2	oskeytype	_ConvertOsKeyType($BF)
---
---OSKEY_OEM_3 'common.OSKEY_OEM_3'
---@field OSKEY_OEM_3	oskeytype	_ConvertOsKeyType($C0)
---
---OSKEY_OEM_4 'common.OSKEY_OEM_4'
---@field OSKEY_OEM_4	oskeytype	_ConvertOsKeyType($DB)
---
---OSKEY_OEM_5 'common.OSKEY_OEM_5'
---@field OSKEY_OEM_5	oskeytype	_ConvertOsKeyType($DC)
---
---OSKEY_OEM_6 'common.OSKEY_OEM_6'
---@field OSKEY_OEM_6	oskeytype	_ConvertOsKeyType($DD)
---
---OSKEY_OEM_7 'common.OSKEY_OEM_7'
---@field OSKEY_OEM_7	oskeytype	_ConvertOsKeyType($DE)
---
---OSKEY_OEM_8 'common.OSKEY_OEM_8'
---@field OSKEY_OEM_8	oskeytype	_ConvertOsKeyType($DF)
---
---OSKEY_OEM_AX 'common.OSKEY_OEM_AX'
---@field OSKEY_OEM_AX	oskeytype	_ConvertOsKeyType($E1)
---
---OSKEY_OEM_102 'common.OSKEY_OEM_102'
---@field OSKEY_OEM_102	oskeytype	_ConvertOsKeyType($E2)
---
---OSKEY_ICO_HELP 'common.OSKEY_ICO_HELP'
---@field OSKEY_ICO_HELP	oskeytype	_ConvertOsKeyType($E3)
---
---OSKEY_ICO_00 'common.OSKEY_ICO_00'
---@field OSKEY_ICO_00	oskeytype	_ConvertOsKeyType($E4)
---
---OSKEY_PROCESSKEY 'common.OSKEY_PROCESSKEY'
---@field OSKEY_PROCESSKEY	oskeytype	_ConvertOsKeyType($E5)
---
---OSKEY_ICO_CLEAR 'common.OSKEY_ICO_CLEAR'
---@field OSKEY_ICO_CLEAR	oskeytype	_ConvertOsKeyType($E6)
---
---OSKEY_PACKET 'common.OSKEY_PACKET'
---@field OSKEY_PACKET	oskeytype	_ConvertOsKeyType($E7)
---
---OSKEY_OEM_RESET 'common.OSKEY_OEM_RESET'
---@field OSKEY_OEM_RESET	oskeytype	_ConvertOsKeyType($E9)
---
---OSKEY_OEM_JUMP 'common.OSKEY_OEM_JUMP'
---@field OSKEY_OEM_JUMP	oskeytype	_ConvertOsKeyType($EA)
---
---OSKEY_OEM_PA1 'common.OSKEY_OEM_PA1'
---@field OSKEY_OEM_PA1	oskeytype	_ConvertOsKeyType($EB)
---
---OSKEY_OEM_PA2 'common.OSKEY_OEM_PA2'
---@field OSKEY_OEM_PA2	oskeytype	_ConvertOsKeyType($EC)
---
---OSKEY_OEM_PA3 'common.OSKEY_OEM_PA3'
---@field OSKEY_OEM_PA3	oskeytype	_ConvertOsKeyType($ED)
---
---OSKEY_OEM_WSCTRL 'common.OSKEY_OEM_WSCTRL'
---@field OSKEY_OEM_WSCTRL	oskeytype	_ConvertOsKeyType($EE)
---
---OSKEY_OEM_CUSEL 'common.OSKEY_OEM_CUSEL'
---@field OSKEY_OEM_CUSEL	oskeytype	_ConvertOsKeyType($EF)
---
---OSKEY_OEM_ATTN 'common.OSKEY_OEM_ATTN'
---@field OSKEY_OEM_ATTN	oskeytype	_ConvertOsKeyType($F0)
---
---OSKEY_OEM_FINISH 'common.OSKEY_OEM_FINISH'
---@field OSKEY_OEM_FINISH	oskeytype	_ConvertOsKeyType($F1)
---
---OSKEY_OEM_COPY 'common.OSKEY_OEM_COPY'
---@field OSKEY_OEM_COPY	oskeytype	_ConvertOsKeyType($F2)
---
---OSKEY_OEM_AUTO 'common.OSKEY_OEM_AUTO'
---@field OSKEY_OEM_AUTO	oskeytype	_ConvertOsKeyType($F3)
---
---OSKEY_OEM_ENLW 'common.OSKEY_OEM_ENLW'
---@field OSKEY_OEM_ENLW	oskeytype	_ConvertOsKeyType($F4)
---
---OSKEY_OEM_BACKTAB 'common.OSKEY_OEM_BACKTAB'
---@field OSKEY_OEM_BACKTAB	oskeytype	_ConvertOsKeyType($F5)
---
---OSKEY_ATTN 'common.OSKEY_ATTN'
---@field OSKEY_ATTN	oskeytype	_ConvertOsKeyType($F6)
---
---OSKEY_CRSEL 'common.OSKEY_CRSEL'
---@field OSKEY_CRSEL	oskeytype	_ConvertOsKeyType($F7)
---
---OSKEY_EXSEL 'common.OSKEY_EXSEL'
---@field OSKEY_EXSEL	oskeytype	_ConvertOsKeyType($F8)
---
---OSKEY_EREOF 'common.OSKEY_EREOF'
---@field OSKEY_EREOF	oskeytype	_ConvertOsKeyType($F9)
---
---OSKEY_PLAY 'common.OSKEY_PLAY'
---@field OSKEY_PLAY	oskeytype	_ConvertOsKeyType($FA)
---
---OSKEY_ZOOM 'common.OSKEY_ZOOM'
---@field OSKEY_ZOOM	oskeytype	_ConvertOsKeyType($FB)
---
---OSKEY_NONAME 'common.OSKEY_NONAME'
---@field OSKEY_NONAME	oskeytype	_ConvertOsKeyType($FC)
---
---OSKEY_PA1 'common.OSKEY_PA1'
---@field OSKEY_PA1	oskeytype	_ConvertOsKeyType($FD)
---
---OSKEY_OEM_CLEAR 'common.OSKEY_OEM_CLEAR'
---@field OSKEY_OEM_CLEAR	oskeytype	_ConvertOsKeyType($FE)
---
---Ability 'common.ABILITY_IF_BUTTON_POSITION_NORMAL_X'
---@field ABILITY_IF_BUTTON_POSITION_NORMAL_X	abilityintegerfield	_ConvertAbilityIntegerField('abpx')
---
---ABILITY_IF_BUTTON_POSITION_NORMAL_Y 'common.ABILITY_IF_BUTTON_POSITION_NORMAL_Y'
---@field ABILITY_IF_BUTTON_POSITION_NORMAL_Y	abilityintegerfield	_ConvertAbilityIntegerField('abpy')
---
---ABILITY_IF_BUTTON_POSITION_ACTIVATED_X 'common.ABILITY_IF_BUTTON_POSITION_ACTIVATED_X'
---@field ABILITY_IF_BUTTON_POSITION_ACTIVATED_X	abilityintegerfield	_ConvertAbilityIntegerField('aubx')
---
---ABILITY_IF_BUTTON_POSITION_ACTIVATED_Y 'common.ABILITY_IF_BUTTON_POSITION_ACTIVATED_Y'
---@field ABILITY_IF_BUTTON_POSITION_ACTIVATED_Y	abilityintegerfield	_ConvertAbilityIntegerField('auby')
---
---ABILITY_IF_BUTTON_POSITION_RESEARCH_X 'common.ABILITY_IF_BUTTON_POSITION_RESEARCH_X'
---@field ABILITY_IF_BUTTON_POSITION_RESEARCH_X	abilityintegerfield	_ConvertAbilityIntegerField('arpx')
---
---ABILITY_IF_BUTTON_POSITION_RESEARCH_Y 'common.ABILITY_IF_BUTTON_POSITION_RESEARCH_Y'
---@field ABILITY_IF_BUTTON_POSITION_RESEARCH_Y	abilityintegerfield	_ConvertAbilityIntegerField('arpy')
---
---ABILITY_IF_MISSILE_SPEED 'common.ABILITY_IF_MISSILE_SPEED'
---@field ABILITY_IF_MISSILE_SPEED	abilityintegerfield	_ConvertAbilityIntegerField('amsp')
---
---ABILITY_IF_TARGET_ATTACHMENTS 'common.ABILITY_IF_TARGET_ATTACHMENTS'
---@field ABILITY_IF_TARGET_ATTACHMENTS	abilityintegerfield	_ConvertAbilityIntegerField('atac')
---
---ABILITY_IF_CASTER_ATTACHMENTS 'common.ABILITY_IF_CASTER_ATTACHMENTS'
---@field ABILITY_IF_CASTER_ATTACHMENTS	abilityintegerfield	_ConvertAbilityIntegerField('acac')
---
---ABILITY_IF_PRIORITY 'common.ABILITY_IF_PRIORITY'
---@field ABILITY_IF_PRIORITY	abilityintegerfield	_ConvertAbilityIntegerField('apri')
---
---ABILITY_IF_LEVELS 'common.ABILITY_IF_LEVELS'
---@field ABILITY_IF_LEVELS	abilityintegerfield	_ConvertAbilityIntegerField('alev')
---
---ABILITY_IF_REQUIRED_LEVEL 'common.ABILITY_IF_REQUIRED_LEVEL'
---@field ABILITY_IF_REQUIRED_LEVEL	abilityintegerfield	_ConvertAbilityIntegerField('arlv')
---
---ABILITY_IF_LEVEL_SKIP_REQUIREMENT 'common.ABILITY_IF_LEVEL_SKIP_REQUIREMENT'
---@field ABILITY_IF_LEVEL_SKIP_REQUIREMENT	abilityintegerfield	_ConvertAbilityIntegerField('alsk')
---
---ABILITY_BF_HERO_ABILITY 'common.ABILITY_BF_HERO_ABILITY'
---@field ABILITY_BF_HERO_ABILITY	abilitybooleanfield	_ConvertAbilityBooleanField('aher')
---
---ABILITY_BF_ITEM_ABILITY 'common.ABILITY_BF_ITEM_ABILITY'
---@field ABILITY_BF_ITEM_ABILITY	abilitybooleanfield	_ConvertAbilityBooleanField('aite')
---
---ABILITY_BF_CHECK_DEPENDENCIES 'common.ABILITY_BF_CHECK_DEPENDENCIES'
---@field ABILITY_BF_CHECK_DEPENDENCIES	abilitybooleanfield	_ConvertAbilityBooleanField('achd')
---
---ABILITY_RF_ARF_MISSILE_ARC 'common.ABILITY_RF_ARF_MISSILE_ARC'
---@field ABILITY_RF_ARF_MISSILE_ARC	abilityrealfield	_ConvertAbilityRealField('amac')
---
---ABILITY_SF_NAME 'common.ABILITY_SF_NAME'
---@field ABILITY_SF_NAME	abilitystringfield	_ConvertAbilityStringField('anam')
---
---ABILITY_SF_ICON_ACTIVATED 'common.ABILITY_SF_ICON_ACTIVATED'
---@field ABILITY_SF_ICON_ACTIVATED	abilitystringfield	_ConvertAbilityStringField('auar')
---
---ABILITY_SF_ICON_RESEARCH 'common.ABILITY_SF_ICON_RESEARCH'
---@field ABILITY_SF_ICON_RESEARCH	abilitystringfield	_ConvertAbilityStringField('arar')
---
---ABILITY_SF_EFFECT_SOUND 'common.ABILITY_SF_EFFECT_SOUND'
---@field ABILITY_SF_EFFECT_SOUND	abilitystringfield	_ConvertAbilityStringField('aefs')
---
---ABILITY_SF_EFFECT_SOUND_LOOPING 'common.ABILITY_SF_EFFECT_SOUND_LOOPING'
---@field ABILITY_SF_EFFECT_SOUND_LOOPING	abilitystringfield	_ConvertAbilityStringField('aefl')
---
---ABILITY_ILF_MANA_COST 'common.ABILITY_ILF_MANA_COST'
---@field ABILITY_ILF_MANA_COST	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('amcs')
---
---ABILITY_ILF_NUMBER_OF_WAVES 'common.ABILITY_ILF_NUMBER_OF_WAVES'
---@field ABILITY_ILF_NUMBER_OF_WAVES	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Hbz1')
---
---ABILITY_ILF_NUMBER_OF_SHARDS 'common.ABILITY_ILF_NUMBER_OF_SHARDS'
---@field ABILITY_ILF_NUMBER_OF_SHARDS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Hbz3')
---
---ABILITY_ILF_NUMBER_OF_UNITS_TELEPORTED 'common.ABILITY_ILF_NUMBER_OF_UNITS_TELEPORTED'
---@field ABILITY_ILF_NUMBER_OF_UNITS_TELEPORTED	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Hmt1')
---
---ABILITY_ILF_SUMMONED_UNIT_COUNT_HWE2 'common.ABILITY_ILF_SUMMONED_UNIT_COUNT_HWE2'
---@field ABILITY_ILF_SUMMONED_UNIT_COUNT_HWE2	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Hwe2')
---
---ABILITY_ILF_NUMBER_OF_IMAGES 'common.ABILITY_ILF_NUMBER_OF_IMAGES'
---@field ABILITY_ILF_NUMBER_OF_IMAGES	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Omi1')
---
---ABILITY_ILF_NUMBER_OF_CORPSES_RAISED_UAN1 'common.ABILITY_ILF_NUMBER_OF_CORPSES_RAISED_UAN1'
---@field ABILITY_ILF_NUMBER_OF_CORPSES_RAISED_UAN1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Uan1')
---
---ABILITY_ILF_MORPHING_FLAGS 'common.ABILITY_ILF_MORPHING_FLAGS'
---@field ABILITY_ILF_MORPHING_FLAGS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Eme2')
---
---ABILITY_ILF_STRENGTH_BONUS_NRG5 'common.ABILITY_ILF_STRENGTH_BONUS_NRG5'
---@field ABILITY_ILF_STRENGTH_BONUS_NRG5	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nrg5')
---
---ABILITY_ILF_DEFENSE_BONUS_NRG6 'common.ABILITY_ILF_DEFENSE_BONUS_NRG6'
---@field ABILITY_ILF_DEFENSE_BONUS_NRG6	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nrg6')
---
---ABILITY_ILF_NUMBER_OF_TARGETS_HIT 'common.ABILITY_ILF_NUMBER_OF_TARGETS_HIT'
---@field ABILITY_ILF_NUMBER_OF_TARGETS_HIT	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ocl2')
---
---ABILITY_ILF_DETECTION_TYPE_OFS1 'common.ABILITY_ILF_DETECTION_TYPE_OFS1'
---@field ABILITY_ILF_DETECTION_TYPE_OFS1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ofs1')
---
---ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_OSF2 'common.ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_OSF2'
---@field ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_OSF2	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Osf2')
---
---ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_EFN1 'common.ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_EFN1'
---@field ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_EFN1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Efn1')
---
---ABILITY_ILF_NUMBER_OF_CORPSES_RAISED_HRE1 'common.ABILITY_ILF_NUMBER_OF_CORPSES_RAISED_HRE1'
---@field ABILITY_ILF_NUMBER_OF_CORPSES_RAISED_HRE1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Hre1')
---
---ABILITY_ILF_STACK_FLAGS 'common.ABILITY_ILF_STACK_FLAGS'
---@field ABILITY_ILF_STACK_FLAGS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Hca4')
---
---ABILITY_ILF_MINIMUM_NUMBER_OF_UNITS 'common.ABILITY_ILF_MINIMUM_NUMBER_OF_UNITS'
---@field ABILITY_ILF_MINIMUM_NUMBER_OF_UNITS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ndp2')
---
---ABILITY_ILF_MAXIMUM_NUMBER_OF_UNITS_NDP3 'common.ABILITY_ILF_MAXIMUM_NUMBER_OF_UNITS_NDP3'
---@field ABILITY_ILF_MAXIMUM_NUMBER_OF_UNITS_NDP3	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ndp3')
---
---ABILITY_ILF_NUMBER_OF_UNITS_CREATED_NRC2 'common.ABILITY_ILF_NUMBER_OF_UNITS_CREATED_NRC2'
---@field ABILITY_ILF_NUMBER_OF_UNITS_CREATED_NRC2	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nrc2')
---
---ABILITY_ILF_SHIELD_LIFE 'common.ABILITY_ILF_SHIELD_LIFE'
---@field ABILITY_ILF_SHIELD_LIFE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ams3')
---
---ABILITY_ILF_MANA_LOSS_AMS4 'common.ABILITY_ILF_MANA_LOSS_AMS4'
---@field ABILITY_ILF_MANA_LOSS_AMS4	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ams4')
---
---ABILITY_ILF_GOLD_PER_INTERVAL_BGM1 'common.ABILITY_ILF_GOLD_PER_INTERVAL_BGM1'
---@field ABILITY_ILF_GOLD_PER_INTERVAL_BGM1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Bgm1')
---
---ABILITY_ILF_MAX_NUMBER_OF_MINERS 'common.ABILITY_ILF_MAX_NUMBER_OF_MINERS'
---@field ABILITY_ILF_MAX_NUMBER_OF_MINERS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Bgm3')
---
---ABILITY_ILF_CARGO_CAPACITY 'common.ABILITY_ILF_CARGO_CAPACITY'
---@field ABILITY_ILF_CARGO_CAPACITY	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Car1')
---
---ABILITY_ILF_MAXIMUM_CREEP_LEVEL_DEV3 'common.ABILITY_ILF_MAXIMUM_CREEP_LEVEL_DEV3'
---@field ABILITY_ILF_MAXIMUM_CREEP_LEVEL_DEV3	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Dev3')
---
---ABILITY_ILF_MAX_CREEP_LEVEL_DEV1 'common.ABILITY_ILF_MAX_CREEP_LEVEL_DEV1'
---@field ABILITY_ILF_MAX_CREEP_LEVEL_DEV1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Dev1')
---
---ABILITY_ILF_GOLD_PER_INTERVAL_EGM1 'common.ABILITY_ILF_GOLD_PER_INTERVAL_EGM1'
---@field ABILITY_ILF_GOLD_PER_INTERVAL_EGM1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Egm1')
---
---ABILITY_ILF_DEFENSE_REDUCTION 'common.ABILITY_ILF_DEFENSE_REDUCTION'
---@field ABILITY_ILF_DEFENSE_REDUCTION	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Fae1')
---
---ABILITY_ILF_DETECTION_TYPE_FLA1 'common.ABILITY_ILF_DETECTION_TYPE_FLA1'
---@field ABILITY_ILF_DETECTION_TYPE_FLA1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Fla1')
---
---ABILITY_ILF_FLARE_COUNT 'common.ABILITY_ILF_FLARE_COUNT'
---@field ABILITY_ILF_FLARE_COUNT	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Fla3')
---
---ABILITY_ILF_MAX_GOLD 'common.ABILITY_ILF_MAX_GOLD'
---@field ABILITY_ILF_MAX_GOLD	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Gld1')
---
---ABILITY_ILF_MINING_CAPACITY 'common.ABILITY_ILF_MINING_CAPACITY'
---@field ABILITY_ILF_MINING_CAPACITY	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Gld3')
---
---ABILITY_ILF_MAXIMUM_NUMBER_OF_CORPSES_GYD1 'common.ABILITY_ILF_MAXIMUM_NUMBER_OF_CORPSES_GYD1'
---@field ABILITY_ILF_MAXIMUM_NUMBER_OF_CORPSES_GYD1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Gyd1')
---
---ABILITY_ILF_DAMAGE_TO_TREE 'common.ABILITY_ILF_DAMAGE_TO_TREE'
---@field ABILITY_ILF_DAMAGE_TO_TREE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Har1')
---
---ABILITY_ILF_LUMBER_CAPACITY 'common.ABILITY_ILF_LUMBER_CAPACITY'
---@field ABILITY_ILF_LUMBER_CAPACITY	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Har2')
---
---ABILITY_ILF_GOLD_CAPACITY 'common.ABILITY_ILF_GOLD_CAPACITY'
---@field ABILITY_ILF_GOLD_CAPACITY	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Har3')
---
---ABILITY_ILF_DEFENSE_INCREASE_INF2 'common.ABILITY_ILF_DEFENSE_INCREASE_INF2'
---@field ABILITY_ILF_DEFENSE_INCREASE_INF2	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Inf2')
---
---ABILITY_ILF_INTERACTION_TYPE 'common.ABILITY_ILF_INTERACTION_TYPE'
---@field ABILITY_ILF_INTERACTION_TYPE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Neu2')
---
---ABILITY_ILF_GOLD_COST_NDT1 'common.ABILITY_ILF_GOLD_COST_NDT1'
---@field ABILITY_ILF_GOLD_COST_NDT1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ndt1')
---
---ABILITY_ILF_LUMBER_COST_NDT2 'common.ABILITY_ILF_LUMBER_COST_NDT2'
---@field ABILITY_ILF_LUMBER_COST_NDT2	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ndt2')
---
---ABILITY_ILF_DETECTION_TYPE_NDT3 'common.ABILITY_ILF_DETECTION_TYPE_NDT3'
---@field ABILITY_ILF_DETECTION_TYPE_NDT3	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ndt3')
---
---ABILITY_ILF_STACKING_TYPE_POI4 'common.ABILITY_ILF_STACKING_TYPE_POI4'
---@field ABILITY_ILF_STACKING_TYPE_POI4	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Poi4')
---
---ABILITY_ILF_STACKING_TYPE_POA5 'common.ABILITY_ILF_STACKING_TYPE_POA5'
---@field ABILITY_ILF_STACKING_TYPE_POA5	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Poa5')
---
---ABILITY_ILF_MAXIMUM_CREEP_LEVEL_PLY1 'common.ABILITY_ILF_MAXIMUM_CREEP_LEVEL_PLY1'
---@field ABILITY_ILF_MAXIMUM_CREEP_LEVEL_PLY1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ply1')
---
---ABILITY_ILF_MAXIMUM_CREEP_LEVEL_POS1 'common.ABILITY_ILF_MAXIMUM_CREEP_LEVEL_POS1'
---@field ABILITY_ILF_MAXIMUM_CREEP_LEVEL_POS1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Pos1')
---
---ABILITY_ILF_MOVEMENT_UPDATE_FREQUENCY_PRG1 'common.ABILITY_ILF_MOVEMENT_UPDATE_FREQUENCY_PRG1'
---@field ABILITY_ILF_MOVEMENT_UPDATE_FREQUENCY_PRG1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Prg1')
---
---ABILITY_ILF_ATTACK_UPDATE_FREQUENCY_PRG2 'common.ABILITY_ILF_ATTACK_UPDATE_FREQUENCY_PRG2'
---@field ABILITY_ILF_ATTACK_UPDATE_FREQUENCY_PRG2	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Prg2')
---
---ABILITY_ILF_MANA_LOSS_PRG6 'common.ABILITY_ILF_MANA_LOSS_PRG6'
---@field ABILITY_ILF_MANA_LOSS_PRG6	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Prg6')
---
---ABILITY_ILF_UNITS_SUMMONED_TYPE_ONE 'common.ABILITY_ILF_UNITS_SUMMONED_TYPE_ONE'
---@field ABILITY_ILF_UNITS_SUMMONED_TYPE_ONE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Rai1')
---
---ABILITY_ILF_UNITS_SUMMONED_TYPE_TWO 'common.ABILITY_ILF_UNITS_SUMMONED_TYPE_TWO'
---@field ABILITY_ILF_UNITS_SUMMONED_TYPE_TWO	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Rai2')
---
---ABILITY_ILF_MAX_UNITS_SUMMONED 'common.ABILITY_ILF_MAX_UNITS_SUMMONED'
---@field ABILITY_ILF_MAX_UNITS_SUMMONED	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ucb5')
---
---ABILITY_ILF_ALLOW_WHEN_FULL_REJ3 'common.ABILITY_ILF_ALLOW_WHEN_FULL_REJ3'
---@field ABILITY_ILF_ALLOW_WHEN_FULL_REJ3	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Rej3')
---
---ABILITY_ILF_MAXIMUM_UNITS_CHARGED_TO_CASTER 'common.ABILITY_ILF_MAXIMUM_UNITS_CHARGED_TO_CASTER'
---@field ABILITY_ILF_MAXIMUM_UNITS_CHARGED_TO_CASTER	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Rpb5')
---
---ABILITY_ILF_MAXIMUM_UNITS_AFFECTED 'common.ABILITY_ILF_MAXIMUM_UNITS_AFFECTED'
---@field ABILITY_ILF_MAXIMUM_UNITS_AFFECTED	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Rpb6')
---
---ABILITY_ILF_DEFENSE_INCREASE_ROA2 'common.ABILITY_ILF_DEFENSE_INCREASE_ROA2'
---@field ABILITY_ILF_DEFENSE_INCREASE_ROA2	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Roa2')
---
---ABILITY_ILF_MAX_UNITS_ROA7 'common.ABILITY_ILF_MAX_UNITS_ROA7'
---@field ABILITY_ILF_MAX_UNITS_ROA7	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Roa7')
---
---ABILITY_ILF_ROOTED_WEAPONS 'common.ABILITY_ILF_ROOTED_WEAPONS'
---@field ABILITY_ILF_ROOTED_WEAPONS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Roo1')
---
---ABILITY_ILF_UPROOTED_WEAPONS 'common.ABILITY_ILF_UPROOTED_WEAPONS'
---@field ABILITY_ILF_UPROOTED_WEAPONS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Roo2')
---
---ABILITY_ILF_UPROOTED_DEFENSE_TYPE 'common.ABILITY_ILF_UPROOTED_DEFENSE_TYPE'
---@field ABILITY_ILF_UPROOTED_DEFENSE_TYPE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Roo4')
---
---ABILITY_ILF_ACCUMULATION_STEP 'common.ABILITY_ILF_ACCUMULATION_STEP'
---@field ABILITY_ILF_ACCUMULATION_STEP	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Sal2')
---
---ABILITY_ILF_NUMBER_OF_OWLS 'common.ABILITY_ILF_NUMBER_OF_OWLS'
---@field ABILITY_ILF_NUMBER_OF_OWLS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Esn4')
---
---ABILITY_ILF_STACKING_TYPE_SPO4 'common.ABILITY_ILF_STACKING_TYPE_SPO4'
---@field ABILITY_ILF_STACKING_TYPE_SPO4	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Spo4')
---
---ABILITY_ILF_NUMBER_OF_UNITS 'common.ABILITY_ILF_NUMBER_OF_UNITS'
---@field ABILITY_ILF_NUMBER_OF_UNITS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Sod1')
---
---ABILITY_ILF_SPIDER_CAPACITY 'common.ABILITY_ILF_SPIDER_CAPACITY'
---@field ABILITY_ILF_SPIDER_CAPACITY	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Spa1')
---
---ABILITY_ILF_INTERVALS_BEFORE_CHANGING_TREES 'common.ABILITY_ILF_INTERVALS_BEFORE_CHANGING_TREES'
---@field ABILITY_ILF_INTERVALS_BEFORE_CHANGING_TREES	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Wha2')
---
---ABILITY_ILF_AGILITY_BONUS 'common.ABILITY_ILF_AGILITY_BONUS'
---@field ABILITY_ILF_AGILITY_BONUS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Iagi')
---
---ABILITY_ILF_INTELLIGENCE_BONUS 'common.ABILITY_ILF_INTELLIGENCE_BONUS'
---@field ABILITY_ILF_INTELLIGENCE_BONUS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Iint')
---
---ABILITY_ILF_STRENGTH_BONUS_ISTR 'common.ABILITY_ILF_STRENGTH_BONUS_ISTR'
---@field ABILITY_ILF_STRENGTH_BONUS_ISTR	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Istr')
---
---ABILITY_ILF_ATTACK_BONUS 'common.ABILITY_ILF_ATTACK_BONUS'
---@field ABILITY_ILF_ATTACK_BONUS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Iatt')
---
---ABILITY_ILF_DEFENSE_BONUS_IDEF 'common.ABILITY_ILF_DEFENSE_BONUS_IDEF'
---@field ABILITY_ILF_DEFENSE_BONUS_IDEF	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Idef')
---
---ABILITY_ILF_SUMMON_1_AMOUNT 'common.ABILITY_ILF_SUMMON_1_AMOUNT'
---@field ABILITY_ILF_SUMMON_1_AMOUNT	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Isn1')
---
---ABILITY_ILF_SUMMON_2_AMOUNT 'common.ABILITY_ILF_SUMMON_2_AMOUNT'
---@field ABILITY_ILF_SUMMON_2_AMOUNT	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Isn2')
---
---ABILITY_ILF_EXPERIENCE_GAINED 'common.ABILITY_ILF_EXPERIENCE_GAINED'
---@field ABILITY_ILF_EXPERIENCE_GAINED	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ixpg')
---
---ABILITY_ILF_HIT_POINTS_GAINED_IHPG 'common.ABILITY_ILF_HIT_POINTS_GAINED_IHPG'
---@field ABILITY_ILF_HIT_POINTS_GAINED_IHPG	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ihpg')
---
---ABILITY_ILF_MANA_POINTS_GAINED_IMPG 'common.ABILITY_ILF_MANA_POINTS_GAINED_IMPG'
---@field ABILITY_ILF_MANA_POINTS_GAINED_IMPG	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Impg')
---
---ABILITY_ILF_HIT_POINTS_GAINED_IHP2 'common.ABILITY_ILF_HIT_POINTS_GAINED_IHP2'
---@field ABILITY_ILF_HIT_POINTS_GAINED_IHP2	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ihp2')
---
---ABILITY_ILF_MANA_POINTS_GAINED_IMP2 'common.ABILITY_ILF_MANA_POINTS_GAINED_IMP2'
---@field ABILITY_ILF_MANA_POINTS_GAINED_IMP2	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Imp2')
---
---ABILITY_ILF_DAMAGE_BONUS_DICE 'common.ABILITY_ILF_DAMAGE_BONUS_DICE'
---@field ABILITY_ILF_DAMAGE_BONUS_DICE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Idic')
---
---ABILITY_ILF_ARMOR_PENALTY_IARP 'common.ABILITY_ILF_ARMOR_PENALTY_IARP'
---@field ABILITY_ILF_ARMOR_PENALTY_IARP	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Iarp')
---
---ABILITY_ILF_ENABLED_ATTACK_INDEX_IOB5 'common.ABILITY_ILF_ENABLED_ATTACK_INDEX_IOB5'
---@field ABILITY_ILF_ENABLED_ATTACK_INDEX_IOB5	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Iob5')
---
---ABILITY_ILF_LEVELS_GAINED 'common.ABILITY_ILF_LEVELS_GAINED'
---@field ABILITY_ILF_LEVELS_GAINED	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ilev')
---
---ABILITY_ILF_MAX_LIFE_GAINED 'common.ABILITY_ILF_MAX_LIFE_GAINED'
---@field ABILITY_ILF_MAX_LIFE_GAINED	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ilif')
---
---ABILITY_ILF_MAX_MANA_GAINED 'common.ABILITY_ILF_MAX_MANA_GAINED'
---@field ABILITY_ILF_MAX_MANA_GAINED	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Iman')
---
---ABILITY_ILF_GOLD_GIVEN 'common.ABILITY_ILF_GOLD_GIVEN'
---@field ABILITY_ILF_GOLD_GIVEN	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Igol')
---
---ABILITY_ILF_LUMBER_GIVEN 'common.ABILITY_ILF_LUMBER_GIVEN'
---@field ABILITY_ILF_LUMBER_GIVEN	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ilum')
---
---ABILITY_ILF_DETECTION_TYPE_IFA1 'common.ABILITY_ILF_DETECTION_TYPE_IFA1'
---@field ABILITY_ILF_DETECTION_TYPE_IFA1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ifa1')
---
---ABILITY_ILF_MAXIMUM_CREEP_LEVEL_ICRE 'common.ABILITY_ILF_MAXIMUM_CREEP_LEVEL_ICRE'
---@field ABILITY_ILF_MAXIMUM_CREEP_LEVEL_ICRE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Icre')
---
---ABILITY_ILF_MOVEMENT_SPEED_BONUS 'common.ABILITY_ILF_MOVEMENT_SPEED_BONUS'
---@field ABILITY_ILF_MOVEMENT_SPEED_BONUS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Imvb')
---
---ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND 'common.ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND'
---@field ABILITY_ILF_HIT_POINTS_REGENERATED_PER_SECOND	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ihpr')
---
---ABILITY_ILF_SIGHT_RANGE_BONUS 'common.ABILITY_ILF_SIGHT_RANGE_BONUS'
---@field ABILITY_ILF_SIGHT_RANGE_BONUS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Isib')
---
---ABILITY_ILF_DAMAGE_PER_DURATION 'common.ABILITY_ILF_DAMAGE_PER_DURATION'
---@field ABILITY_ILF_DAMAGE_PER_DURATION	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Icfd')
---
---ABILITY_ILF_MANA_USED_PER_SECOND 'common.ABILITY_ILF_MANA_USED_PER_SECOND'
---@field ABILITY_ILF_MANA_USED_PER_SECOND	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Icfm')
---
---ABILITY_ILF_EXTRA_MANA_REQUIRED 'common.ABILITY_ILF_EXTRA_MANA_REQUIRED'
---@field ABILITY_ILF_EXTRA_MANA_REQUIRED	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Icfx')
---
---ABILITY_ILF_DETECTION_RADIUS_IDET 'common.ABILITY_ILF_DETECTION_RADIUS_IDET'
---@field ABILITY_ILF_DETECTION_RADIUS_IDET	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Idet')
---
---ABILITY_ILF_MANA_LOSS_PER_UNIT_IDIM 'common.ABILITY_ILF_MANA_LOSS_PER_UNIT_IDIM'
---@field ABILITY_ILF_MANA_LOSS_PER_UNIT_IDIM	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Idim')
---
---ABILITY_ILF_DAMAGE_TO_SUMMONED_UNITS_IDID 'common.ABILITY_ILF_DAMAGE_TO_SUMMONED_UNITS_IDID'
---@field ABILITY_ILF_DAMAGE_TO_SUMMONED_UNITS_IDID	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Idid')
---
---ABILITY_ILF_MAXIMUM_NUMBER_OF_UNITS_IREC 'common.ABILITY_ILF_MAXIMUM_NUMBER_OF_UNITS_IREC'
---@field ABILITY_ILF_MAXIMUM_NUMBER_OF_UNITS_IREC	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Irec')
---
---ABILITY_ILF_DELAY_AFTER_DEATH_SECONDS 'common.ABILITY_ILF_DELAY_AFTER_DEATH_SECONDS'
---@field ABILITY_ILF_DELAY_AFTER_DEATH_SECONDS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ircd')
---
---ABILITY_ILF_RESTORED_LIFE 'common.ABILITY_ILF_RESTORED_LIFE'
---@field ABILITY_ILF_RESTORED_LIFE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('irc2')
---
---ABILITY_ILF_RESTORED_MANA__1_FOR_CURRENT 'common.ABILITY_ILF_RESTORED_MANA__1_FOR_CURRENT'
---@field ABILITY_ILF_RESTORED_MANA__1_FOR_CURRENT	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('irc3')
---
---ABILITY_ILF_HIT_POINTS_RESTORED 'common.ABILITY_ILF_HIT_POINTS_RESTORED'
---@field ABILITY_ILF_HIT_POINTS_RESTORED	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ihps')
---
---ABILITY_ILF_MANA_POINTS_RESTORED 'common.ABILITY_ILF_MANA_POINTS_RESTORED'
---@field ABILITY_ILF_MANA_POINTS_RESTORED	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Imps')
---
---ABILITY_ILF_MAXIMUM_NUMBER_OF_UNITS_ITPM 'common.ABILITY_ILF_MAXIMUM_NUMBER_OF_UNITS_ITPM'
---@field ABILITY_ILF_MAXIMUM_NUMBER_OF_UNITS_ITPM	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Itpm')
---
---ABILITY_ILF_NUMBER_OF_CORPSES_RAISED_CAD1 'common.ABILITY_ILF_NUMBER_OF_CORPSES_RAISED_CAD1'
---@field ABILITY_ILF_NUMBER_OF_CORPSES_RAISED_CAD1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Cad1')
---
---ABILITY_ILF_TERRAIN_DEFORMATION_DURATION_MS 'common.ABILITY_ILF_TERRAIN_DEFORMATION_DURATION_MS'
---@field ABILITY_ILF_TERRAIN_DEFORMATION_DURATION_MS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Wrs3')
---
---ABILITY_ILF_MAXIMUM_UNITS 'common.ABILITY_ILF_MAXIMUM_UNITS'
---@field ABILITY_ILF_MAXIMUM_UNITS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Uds1')
---
---ABILITY_ILF_DETECTION_TYPE_DET1 'common.ABILITY_ILF_DETECTION_TYPE_DET1'
---@field ABILITY_ILF_DETECTION_TYPE_DET1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Det1')
---
---ABILITY_ILF_GOLD_COST_PER_STRUCTURE 'common.ABILITY_ILF_GOLD_COST_PER_STRUCTURE'
---@field ABILITY_ILF_GOLD_COST_PER_STRUCTURE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nsp1')
---
---ABILITY_ILF_LUMBER_COST_PER_USE 'common.ABILITY_ILF_LUMBER_COST_PER_USE'
---@field ABILITY_ILF_LUMBER_COST_PER_USE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nsp2')
---
---ABILITY_ILF_DETECTION_TYPE_NSP3 'common.ABILITY_ILF_DETECTION_TYPE_NSP3'
---@field ABILITY_ILF_DETECTION_TYPE_NSP3	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nsp3')
---
---ABILITY_ILF_NUMBER_OF_SWARM_UNITS 'common.ABILITY_ILF_NUMBER_OF_SWARM_UNITS'
---@field ABILITY_ILF_NUMBER_OF_SWARM_UNITS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Uls1')
---
---ABILITY_ILF_MAX_SWARM_UNITS_PER_TARGET 'common.ABILITY_ILF_MAX_SWARM_UNITS_PER_TARGET'
---@field ABILITY_ILF_MAX_SWARM_UNITS_PER_TARGET	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Uls3')
---
---ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_NBA2 'common.ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_NBA2'
---@field ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_NBA2	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nba2')
---
---ABILITY_ILF_MAXIMUM_CREEP_LEVEL_NCH1 'common.ABILITY_ILF_MAXIMUM_CREEP_LEVEL_NCH1'
---@field ABILITY_ILF_MAXIMUM_CREEP_LEVEL_NCH1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nch1')
---
---ABILITY_ILF_ATTACKS_PREVENTED 'common.ABILITY_ILF_ATTACKS_PREVENTED'
---@field ABILITY_ILF_ATTACKS_PREVENTED	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nsi1')
---
---ABILITY_ILF_MAXIMUM_NUMBER_OF_TARGETS_EFK3 'common.ABILITY_ILF_MAXIMUM_NUMBER_OF_TARGETS_EFK3'
---@field ABILITY_ILF_MAXIMUM_NUMBER_OF_TARGETS_EFK3	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Efk3')
---
---ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_ESV1 'common.ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_ESV1'
---@field ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_ESV1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Esv1')
---
---ABILITY_ILF_MAXIMUM_NUMBER_OF_CORPSES_EXH1 'common.ABILITY_ILF_MAXIMUM_NUMBER_OF_CORPSES_EXH1'
---@field ABILITY_ILF_MAXIMUM_NUMBER_OF_CORPSES_EXH1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('exh1')
---
---ABILITY_ILF_ITEM_CAPACITY 'common.ABILITY_ILF_ITEM_CAPACITY'
---@field ABILITY_ILF_ITEM_CAPACITY	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('inv1')
---
---ABILITY_ILF_MAXIMUM_NUMBER_OF_TARGETS_SPL2 'common.ABILITY_ILF_MAXIMUM_NUMBER_OF_TARGETS_SPL2'
---@field ABILITY_ILF_MAXIMUM_NUMBER_OF_TARGETS_SPL2	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('spl2')
---
---ABILITY_ILF_ALLOW_WHEN_FULL_IRL3 'common.ABILITY_ILF_ALLOW_WHEN_FULL_IRL3'
---@field ABILITY_ILF_ALLOW_WHEN_FULL_IRL3	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('irl3')
---
---ABILITY_ILF_MAXIMUM_DISPELLED_UNITS 'common.ABILITY_ILF_MAXIMUM_DISPELLED_UNITS'
---@field ABILITY_ILF_MAXIMUM_DISPELLED_UNITS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('idc3')
---
---ABILITY_ILF_NUMBER_OF_LURES 'common.ABILITY_ILF_NUMBER_OF_LURES'
---@field ABILITY_ILF_NUMBER_OF_LURES	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('imo1')
---
---ABILITY_ILF_NEW_TIME_OF_DAY_HOUR 'common.ABILITY_ILF_NEW_TIME_OF_DAY_HOUR'
---@field ABILITY_ILF_NEW_TIME_OF_DAY_HOUR	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('ict1')
---
---ABILITY_ILF_NEW_TIME_OF_DAY_MINUTE 'common.ABILITY_ILF_NEW_TIME_OF_DAY_MINUTE'
---@field ABILITY_ILF_NEW_TIME_OF_DAY_MINUTE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('ict2')
---
---ABILITY_ILF_NUMBER_OF_UNITS_CREATED_MEC1 'common.ABILITY_ILF_NUMBER_OF_UNITS_CREATED_MEC1'
---@field ABILITY_ILF_NUMBER_OF_UNITS_CREATED_MEC1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('mec1')
---
---ABILITY_ILF_MINIMUM_SPELLS 'common.ABILITY_ILF_MINIMUM_SPELLS'
---@field ABILITY_ILF_MINIMUM_SPELLS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('spb3')
---
---ABILITY_ILF_MAXIMUM_SPELLS 'common.ABILITY_ILF_MAXIMUM_SPELLS'
---@field ABILITY_ILF_MAXIMUM_SPELLS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('spb4')
---
---ABILITY_ILF_DISABLED_ATTACK_INDEX 'common.ABILITY_ILF_DISABLED_ATTACK_INDEX'
---@field ABILITY_ILF_DISABLED_ATTACK_INDEX	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('gra3')
---
---ABILITY_ILF_ENABLED_ATTACK_INDEX_GRA4 'common.ABILITY_ILF_ENABLED_ATTACK_INDEX_GRA4'
---@field ABILITY_ILF_ENABLED_ATTACK_INDEX_GRA4	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('gra4')
---
---ABILITY_ILF_MAXIMUM_ATTACKS 'common.ABILITY_ILF_MAXIMUM_ATTACKS'
---@field ABILITY_ILF_MAXIMUM_ATTACKS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('gra5')
---
---ABILITY_ILF_BUILDING_TYPES_ALLOWED_NPR1 'common.ABILITY_ILF_BUILDING_TYPES_ALLOWED_NPR1'
---@field ABILITY_ILF_BUILDING_TYPES_ALLOWED_NPR1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Npr1')
---
---ABILITY_ILF_BUILDING_TYPES_ALLOWED_NSA1 'common.ABILITY_ILF_BUILDING_TYPES_ALLOWED_NSA1'
---@field ABILITY_ILF_BUILDING_TYPES_ALLOWED_NSA1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nsa1')
---
---ABILITY_ILF_ATTACK_MODIFICATION 'common.ABILITY_ILF_ATTACK_MODIFICATION'
---@field ABILITY_ILF_ATTACK_MODIFICATION	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Iaa1')
---
---ABILITY_ILF_SUMMONED_UNIT_COUNT_NPA5 'common.ABILITY_ILF_SUMMONED_UNIT_COUNT_NPA5'
---@field ABILITY_ILF_SUMMONED_UNIT_COUNT_NPA5	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Npa5')
---
---ABILITY_ILF_UPGRADE_LEVELS 'common.ABILITY_ILF_UPGRADE_LEVELS'
---@field ABILITY_ILF_UPGRADE_LEVELS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Igl1')
---
---ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_NDO2 'common.ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_NDO2'
---@field ABILITY_ILF_NUMBER_OF_SUMMONED_UNITS_NDO2	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ndo2')
---
---ABILITY_ILF_BEASTS_PER_SECOND 'common.ABILITY_ILF_BEASTS_PER_SECOND'
---@field ABILITY_ILF_BEASTS_PER_SECOND	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nst1')
---
---ABILITY_ILF_TARGET_TYPE 'common.ABILITY_ILF_TARGET_TYPE'
---@field ABILITY_ILF_TARGET_TYPE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ncl2')
---
---ABILITY_ILF_OPTIONS 'common.ABILITY_ILF_OPTIONS'
---@field ABILITY_ILF_OPTIONS	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ncl3')
---
---ABILITY_ILF_ARMOR_PENALTY_NAB3 'common.ABILITY_ILF_ARMOR_PENALTY_NAB3'
---@field ABILITY_ILF_ARMOR_PENALTY_NAB3	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nab3')
---
---ABILITY_ILF_WAVE_COUNT_NHS6 'common.ABILITY_ILF_WAVE_COUNT_NHS6'
---@field ABILITY_ILF_WAVE_COUNT_NHS6	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nhs6')
---
---ABILITY_ILF_MAX_CREEP_LEVEL_NTM3 'common.ABILITY_ILF_MAX_CREEP_LEVEL_NTM3'
---@field ABILITY_ILF_MAX_CREEP_LEVEL_NTM3	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ntm3')
---
---ABILITY_ILF_MISSILE_COUNT 'common.ABILITY_ILF_MISSILE_COUNT'
---@field ABILITY_ILF_MISSILE_COUNT	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ncs3')
---
---ABILITY_ILF_SPLIT_ATTACK_COUNT 'common.ABILITY_ILF_SPLIT_ATTACK_COUNT'
---@field ABILITY_ILF_SPLIT_ATTACK_COUNT	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nlm3')
---
---ABILITY_ILF_GENERATION_COUNT 'common.ABILITY_ILF_GENERATION_COUNT'
---@field ABILITY_ILF_GENERATION_COUNT	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nlm6')
---
---ABILITY_ILF_ROCK_RING_COUNT 'common.ABILITY_ILF_ROCK_RING_COUNT'
---@field ABILITY_ILF_ROCK_RING_COUNT	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nvc1')
---
---ABILITY_ILF_WAVE_COUNT_NVC2 'common.ABILITY_ILF_WAVE_COUNT_NVC2'
---@field ABILITY_ILF_WAVE_COUNT_NVC2	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nvc2')
---
---ABILITY_ILF_PREFER_HOSTILES_TAU1 'common.ABILITY_ILF_PREFER_HOSTILES_TAU1'
---@field ABILITY_ILF_PREFER_HOSTILES_TAU1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Tau1')
---
---ABILITY_ILF_PREFER_FRIENDLIES_TAU2 'common.ABILITY_ILF_PREFER_FRIENDLIES_TAU2'
---@field ABILITY_ILF_PREFER_FRIENDLIES_TAU2	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Tau2')
---
---ABILITY_ILF_MAX_UNITS_TAU3 'common.ABILITY_ILF_MAX_UNITS_TAU3'
---@field ABILITY_ILF_MAX_UNITS_TAU3	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Tau3')
---
---ABILITY_ILF_NUMBER_OF_PULSES 'common.ABILITY_ILF_NUMBER_OF_PULSES'
---@field ABILITY_ILF_NUMBER_OF_PULSES	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Tau4')
---
---ABILITY_ILF_SUMMONED_UNIT_TYPE_HWE1 'common.ABILITY_ILF_SUMMONED_UNIT_TYPE_HWE1'
---@field ABILITY_ILF_SUMMONED_UNIT_TYPE_HWE1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Hwe1')
---
---ABILITY_ILF_SUMMONED_UNIT_UIN4 'common.ABILITY_ILF_SUMMONED_UNIT_UIN4'
---@field ABILITY_ILF_SUMMONED_UNIT_UIN4	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Uin4')
---
---ABILITY_ILF_SUMMONED_UNIT_OSF1 'common.ABILITY_ILF_SUMMONED_UNIT_OSF1'
---@field ABILITY_ILF_SUMMONED_UNIT_OSF1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Osf1')
---
---ABILITY_ILF_SUMMONED_UNIT_TYPE_EFNU 'common.ABILITY_ILF_SUMMONED_UNIT_TYPE_EFNU'
---@field ABILITY_ILF_SUMMONED_UNIT_TYPE_EFNU	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Efnu')
---
---ABILITY_ILF_SUMMONED_UNIT_TYPE_NBAU 'common.ABILITY_ILF_SUMMONED_UNIT_TYPE_NBAU'
---@field ABILITY_ILF_SUMMONED_UNIT_TYPE_NBAU	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nbau')
---
---ABILITY_ILF_SUMMONED_UNIT_TYPE_NTOU 'common.ABILITY_ILF_SUMMONED_UNIT_TYPE_NTOU'
---@field ABILITY_ILF_SUMMONED_UNIT_TYPE_NTOU	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ntou')
---
---ABILITY_ILF_SUMMONED_UNIT_TYPE_ESVU 'common.ABILITY_ILF_SUMMONED_UNIT_TYPE_ESVU'
---@field ABILITY_ILF_SUMMONED_UNIT_TYPE_ESVU	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Esvu')
---
---ABILITY_ILF_SUMMONED_UNIT_TYPES 'common.ABILITY_ILF_SUMMONED_UNIT_TYPES'
---@field ABILITY_ILF_SUMMONED_UNIT_TYPES	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nef1')
---
---ABILITY_ILF_SUMMONED_UNIT_TYPE_NDOU 'common.ABILITY_ILF_SUMMONED_UNIT_TYPE_NDOU'
---@field ABILITY_ILF_SUMMONED_UNIT_TYPE_NDOU	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ndou')
---
---ABILITY_ILF_ALTERNATE_FORM_UNIT_EMEU 'common.ABILITY_ILF_ALTERNATE_FORM_UNIT_EMEU'
---@field ABILITY_ILF_ALTERNATE_FORM_UNIT_EMEU	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Emeu')
---
---ABILITY_ILF_PLAGUE_WARD_UNIT_TYPE 'common.ABILITY_ILF_PLAGUE_WARD_UNIT_TYPE'
---@field ABILITY_ILF_PLAGUE_WARD_UNIT_TYPE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Aplu')
---
---ABILITY_ILF_ALLOWED_UNIT_TYPE_BTL1 'common.ABILITY_ILF_ALLOWED_UNIT_TYPE_BTL1'
---@field ABILITY_ILF_ALLOWED_UNIT_TYPE_BTL1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Btl1')
---
---ABILITY_ILF_NEW_UNIT_TYPE 'common.ABILITY_ILF_NEW_UNIT_TYPE'
---@field ABILITY_ILF_NEW_UNIT_TYPE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Cha1')
---
---ABILITY_ILF_RESULTING_UNIT_TYPE_ENT1 'common.ABILITY_ILF_RESULTING_UNIT_TYPE_ENT1'
---@field ABILITY_ILF_RESULTING_UNIT_TYPE_ENT1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('ent1')
---
---ABILITY_ILF_CORPSE_UNIT_TYPE 'common.ABILITY_ILF_CORPSE_UNIT_TYPE'
---@field ABILITY_ILF_CORPSE_UNIT_TYPE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Gydu')
---
---ABILITY_ILF_ALLOWED_UNIT_TYPE_LOA1 'common.ABILITY_ILF_ALLOWED_UNIT_TYPE_LOA1'
---@field ABILITY_ILF_ALLOWED_UNIT_TYPE_LOA1	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Loa1')
---
---ABILITY_ILF_UNIT_TYPE_FOR_LIMIT_CHECK 'common.ABILITY_ILF_UNIT_TYPE_FOR_LIMIT_CHECK'
---@field ABILITY_ILF_UNIT_TYPE_FOR_LIMIT_CHECK	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Raiu')
---
---ABILITY_ILF_WARD_UNIT_TYPE_STAU 'common.ABILITY_ILF_WARD_UNIT_TYPE_STAU'
---@field ABILITY_ILF_WARD_UNIT_TYPE_STAU	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Stau')
---
---ABILITY_ILF_EFFECT_ABILITY 'common.ABILITY_ILF_EFFECT_ABILITY'
---@field ABILITY_ILF_EFFECT_ABILITY	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Iobu')
---
---ABILITY_ILF_CONVERSION_UNIT 'common.ABILITY_ILF_CONVERSION_UNIT'
---@field ABILITY_ILF_CONVERSION_UNIT	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ndc2')
---
---ABILITY_ILF_UNIT_TO_PRESERVE 'common.ABILITY_ILF_UNIT_TO_PRESERVE'
---@field ABILITY_ILF_UNIT_TO_PRESERVE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nsl1')
---
---ABILITY_ILF_UNIT_TYPE_ALLOWED 'common.ABILITY_ILF_UNIT_TYPE_ALLOWED'
---@field ABILITY_ILF_UNIT_TYPE_ALLOWED	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Chl1')
---
---ABILITY_ILF_SWARM_UNIT_TYPE 'common.ABILITY_ILF_SWARM_UNIT_TYPE'
---@field ABILITY_ILF_SWARM_UNIT_TYPE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Ulsu')
---
---ABILITY_ILF_RESULTING_UNIT_TYPE_COAU 'common.ABILITY_ILF_RESULTING_UNIT_TYPE_COAU'
---@field ABILITY_ILF_RESULTING_UNIT_TYPE_COAU	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('coau')
---
---ABILITY_ILF_UNIT_TYPE_EXHU 'common.ABILITY_ILF_UNIT_TYPE_EXHU'
---@field ABILITY_ILF_UNIT_TYPE_EXHU	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('exhu')
---
---ABILITY_ILF_WARD_UNIT_TYPE_HWDU 'common.ABILITY_ILF_WARD_UNIT_TYPE_HWDU'
---@field ABILITY_ILF_WARD_UNIT_TYPE_HWDU	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('hwdu')
---
---ABILITY_ILF_LURE_UNIT_TYPE 'common.ABILITY_ILF_LURE_UNIT_TYPE'
---@field ABILITY_ILF_LURE_UNIT_TYPE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('imou')
---
---ABILITY_ILF_UNIT_TYPE_IPMU 'common.ABILITY_ILF_UNIT_TYPE_IPMU'
---@field ABILITY_ILF_UNIT_TYPE_IPMU	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('ipmu')
---
---ABILITY_ILF_FACTORY_UNIT_ID 'common.ABILITY_ILF_FACTORY_UNIT_ID'
---@field ABILITY_ILF_FACTORY_UNIT_ID	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nsyu')
---
---ABILITY_ILF_SPAWN_UNIT_ID_NFYU 'common.ABILITY_ILF_SPAWN_UNIT_ID_NFYU'
---@field ABILITY_ILF_SPAWN_UNIT_ID_NFYU	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nfyu')
---
---ABILITY_ILF_DESTRUCTIBLE_ID 'common.ABILITY_ILF_DESTRUCTIBLE_ID'
---@field ABILITY_ILF_DESTRUCTIBLE_ID	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Nvcu')
---
---ABILITY_ILF_UPGRADE_TYPE 'common.ABILITY_ILF_UPGRADE_TYPE'
---@field ABILITY_ILF_UPGRADE_TYPE	abilityintegerlevelfield	_ConvertAbilityIntegerLevelField('Iglu')
---
---ABILITY_RLF_CASTING_TIME 'common.ABILITY_RLF_CASTING_TIME'
---@field ABILITY_RLF_CASTING_TIME	abilityreallevelfield	_ConvertAbilityRealLevelField('acas')
---
---ABILITY_RLF_DURATION_NORMAL 'common.ABILITY_RLF_DURATION_NORMAL'
---@field ABILITY_RLF_DURATION_NORMAL	abilityreallevelfield	_ConvertAbilityRealLevelField('adur')
---
---ABILITY_RLF_DURATION_HERO 'common.ABILITY_RLF_DURATION_HERO'
---@field ABILITY_RLF_DURATION_HERO	abilityreallevelfield	_ConvertAbilityRealLevelField('ahdu')
---
---ABILITY_RLF_COOLDOWN 'common.ABILITY_RLF_COOLDOWN'
---@field ABILITY_RLF_COOLDOWN	abilityreallevelfield	_ConvertAbilityRealLevelField('acdn')
---
---ABILITY_RLF_AREA_OF_EFFECT 'common.ABILITY_RLF_AREA_OF_EFFECT'
---@field ABILITY_RLF_AREA_OF_EFFECT	abilityreallevelfield	_ConvertAbilityRealLevelField('aare')
---
---ABILITY_RLF_CAST_RANGE 'common.ABILITY_RLF_CAST_RANGE'
---@field ABILITY_RLF_CAST_RANGE	abilityreallevelfield	_ConvertAbilityRealLevelField('aran')
---
---ABILITY_RLF_DAMAGE_HBZ2 'common.ABILITY_RLF_DAMAGE_HBZ2'
---@field ABILITY_RLF_DAMAGE_HBZ2	abilityreallevelfield	_ConvertAbilityRealLevelField('Hbz2')
---
---ABILITY_RLF_BUILDING_REDUCTION_HBZ4 'common.ABILITY_RLF_BUILDING_REDUCTION_HBZ4'
---@field ABILITY_RLF_BUILDING_REDUCTION_HBZ4	abilityreallevelfield	_ConvertAbilityRealLevelField('Hbz4')
---
---ABILITY_RLF_DAMAGE_PER_SECOND_HBZ5 'common.ABILITY_RLF_DAMAGE_PER_SECOND_HBZ5'
---@field ABILITY_RLF_DAMAGE_PER_SECOND_HBZ5	abilityreallevelfield	_ConvertAbilityRealLevelField('Hbz5')
---
---ABILITY_RLF_MAXIMUM_DAMAGE_PER_WAVE 'common.ABILITY_RLF_MAXIMUM_DAMAGE_PER_WAVE'
---@field ABILITY_RLF_MAXIMUM_DAMAGE_PER_WAVE	abilityreallevelfield	_ConvertAbilityRealLevelField('Hbz6')
---
---ABILITY_RLF_MANA_REGENERATION_INCREASE 'common.ABILITY_RLF_MANA_REGENERATION_INCREASE'
---@field ABILITY_RLF_MANA_REGENERATION_INCREASE	abilityreallevelfield	_ConvertAbilityRealLevelField('Hab1')
---
---ABILITY_RLF_CASTING_DELAY 'common.ABILITY_RLF_CASTING_DELAY'
---@field ABILITY_RLF_CASTING_DELAY	abilityreallevelfield	_ConvertAbilityRealLevelField('Hmt2')
---
---ABILITY_RLF_DAMAGE_PER_SECOND_OWW1 'common.ABILITY_RLF_DAMAGE_PER_SECOND_OWW1'
---@field ABILITY_RLF_DAMAGE_PER_SECOND_OWW1	abilityreallevelfield	_ConvertAbilityRealLevelField('Oww1')
---
---ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_OWW2 'common.ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_OWW2'
---@field ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_OWW2	abilityreallevelfield	_ConvertAbilityRealLevelField('Oww2')
---
---ABILITY_RLF_CHANCE_TO_CRITICAL_STRIKE 'common.ABILITY_RLF_CHANCE_TO_CRITICAL_STRIKE'
---@field ABILITY_RLF_CHANCE_TO_CRITICAL_STRIKE	abilityreallevelfield	_ConvertAbilityRealLevelField('Ocr1')
---
---ABILITY_RLF_DAMAGE_MULTIPLIER_OCR2 'common.ABILITY_RLF_DAMAGE_MULTIPLIER_OCR2'
---@field ABILITY_RLF_DAMAGE_MULTIPLIER_OCR2	abilityreallevelfield	_ConvertAbilityRealLevelField('Ocr2')
---
---ABILITY_RLF_DAMAGE_BONUS_OCR3 'common.ABILITY_RLF_DAMAGE_BONUS_OCR3'
---@field ABILITY_RLF_DAMAGE_BONUS_OCR3	abilityreallevelfield	_ConvertAbilityRealLevelField('Ocr3')
---
---ABILITY_RLF_CHANCE_TO_EVADE_OCR4 'common.ABILITY_RLF_CHANCE_TO_EVADE_OCR4'
---@field ABILITY_RLF_CHANCE_TO_EVADE_OCR4	abilityreallevelfield	_ConvertAbilityRealLevelField('Ocr4')
---
---ABILITY_RLF_DAMAGE_DEALT_PERCENT_OMI2 'common.ABILITY_RLF_DAMAGE_DEALT_PERCENT_OMI2'
---@field ABILITY_RLF_DAMAGE_DEALT_PERCENT_OMI2	abilityreallevelfield	_ConvertAbilityRealLevelField('Omi2')
---
---ABILITY_RLF_DAMAGE_TAKEN_PERCENT_OMI3 'common.ABILITY_RLF_DAMAGE_TAKEN_PERCENT_OMI3'
---@field ABILITY_RLF_DAMAGE_TAKEN_PERCENT_OMI3	abilityreallevelfield	_ConvertAbilityRealLevelField('Omi3')
---
---ABILITY_RLF_ANIMATION_DELAY 'common.ABILITY_RLF_ANIMATION_DELAY'
---@field ABILITY_RLF_ANIMATION_DELAY	abilityreallevelfield	_ConvertAbilityRealLevelField('Omi4')
---
---ABILITY_RLF_TRANSITION_TIME 'common.ABILITY_RLF_TRANSITION_TIME'
---@field ABILITY_RLF_TRANSITION_TIME	abilityreallevelfield	_ConvertAbilityRealLevelField('Owk1')
---
---ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_OWK2 'common.ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_OWK2'
---@field ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_OWK2	abilityreallevelfield	_ConvertAbilityRealLevelField('Owk2')
---
---ABILITY_RLF_BACKSTAB_DAMAGE 'common.ABILITY_RLF_BACKSTAB_DAMAGE'
---@field ABILITY_RLF_BACKSTAB_DAMAGE	abilityreallevelfield	_ConvertAbilityRealLevelField('Owk3')
---
---ABILITY_RLF_AMOUNT_HEALED_DAMAGED_UDC1 'common.ABILITY_RLF_AMOUNT_HEALED_DAMAGED_UDC1'
---@field ABILITY_RLF_AMOUNT_HEALED_DAMAGED_UDC1	abilityreallevelfield	_ConvertAbilityRealLevelField('Udc1')
---
---ABILITY_RLF_LIFE_CONVERTED_TO_MANA 'common.ABILITY_RLF_LIFE_CONVERTED_TO_MANA'
---@field ABILITY_RLF_LIFE_CONVERTED_TO_MANA	abilityreallevelfield	_ConvertAbilityRealLevelField('Udp1')
---
---ABILITY_RLF_LIFE_CONVERTED_TO_LIFE 'common.ABILITY_RLF_LIFE_CONVERTED_TO_LIFE'
---@field ABILITY_RLF_LIFE_CONVERTED_TO_LIFE	abilityreallevelfield	_ConvertAbilityRealLevelField('Udp2')
---
---ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_UAU1 'common.ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_UAU1'
---@field ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_UAU1	abilityreallevelfield	_ConvertAbilityRealLevelField('Uau1')
---
---ABILITY_RLF_LIFE_REGENERATION_INCREASE_PERCENT 'common.ABILITY_RLF_LIFE_REGENERATION_INCREASE_PERCENT'
---@field ABILITY_RLF_LIFE_REGENERATION_INCREASE_PERCENT	abilityreallevelfield	_ConvertAbilityRealLevelField('Uau2')
---
---ABILITY_RLF_CHANCE_TO_EVADE_EEV1 'common.ABILITY_RLF_CHANCE_TO_EVADE_EEV1'
---@field ABILITY_RLF_CHANCE_TO_EVADE_EEV1	abilityreallevelfield	_ConvertAbilityRealLevelField('Eev1')
---
---ABILITY_RLF_DAMAGE_PER_INTERVAL 'common.ABILITY_RLF_DAMAGE_PER_INTERVAL'
---@field ABILITY_RLF_DAMAGE_PER_INTERVAL	abilityreallevelfield	_ConvertAbilityRealLevelField('Eim1')
---
---ABILITY_RLF_MANA_DRAINED_PER_SECOND_EIM2 'common.ABILITY_RLF_MANA_DRAINED_PER_SECOND_EIM2'
---@field ABILITY_RLF_MANA_DRAINED_PER_SECOND_EIM2	abilityreallevelfield	_ConvertAbilityRealLevelField('Eim2')
---
---ABILITY_RLF_BUFFER_MANA_REQUIRED 'common.ABILITY_RLF_BUFFER_MANA_REQUIRED'
---@field ABILITY_RLF_BUFFER_MANA_REQUIRED	abilityreallevelfield	_ConvertAbilityRealLevelField('Eim3')
---
---ABILITY_RLF_MAX_MANA_DRAINED 'common.ABILITY_RLF_MAX_MANA_DRAINED'
---@field ABILITY_RLF_MAX_MANA_DRAINED	abilityreallevelfield	_ConvertAbilityRealLevelField('Emb1')
---
---ABILITY_RLF_BOLT_DELAY 'common.ABILITY_RLF_BOLT_DELAY'
---@field ABILITY_RLF_BOLT_DELAY	abilityreallevelfield	_ConvertAbilityRealLevelField('Emb2')
---
---ABILITY_RLF_BOLT_LIFETIME 'common.ABILITY_RLF_BOLT_LIFETIME'
---@field ABILITY_RLF_BOLT_LIFETIME	abilityreallevelfield	_ConvertAbilityRealLevelField('Emb3')
---
---ABILITY_RLF_ALTITUDE_ADJUSTMENT_DURATION 'common.ABILITY_RLF_ALTITUDE_ADJUSTMENT_DURATION'
---@field ABILITY_RLF_ALTITUDE_ADJUSTMENT_DURATION	abilityreallevelfield	_ConvertAbilityRealLevelField('Eme3')
---
---ABILITY_RLF_LANDING_DELAY_TIME 'common.ABILITY_RLF_LANDING_DELAY_TIME'
---@field ABILITY_RLF_LANDING_DELAY_TIME	abilityreallevelfield	_ConvertAbilityRealLevelField('Eme4')
---
---ABILITY_RLF_ALTERNATE_FORM_HIT_POINT_BONUS 'common.ABILITY_RLF_ALTERNATE_FORM_HIT_POINT_BONUS'
---@field ABILITY_RLF_ALTERNATE_FORM_HIT_POINT_BONUS	abilityreallevelfield	_ConvertAbilityRealLevelField('Eme5')
---
---ABILITY_RLF_MOVE_SPEED_BONUS_INFO_PANEL_ONLY 'common.ABILITY_RLF_MOVE_SPEED_BONUS_INFO_PANEL_ONLY'
---@field ABILITY_RLF_MOVE_SPEED_BONUS_INFO_PANEL_ONLY	abilityreallevelfield	_ConvertAbilityRealLevelField('Ncr5')
---
---ABILITY_RLF_ATTACK_SPEED_BONUS_INFO_PANEL_ONLY 'common.ABILITY_RLF_ATTACK_SPEED_BONUS_INFO_PANEL_ONLY'
---@field ABILITY_RLF_ATTACK_SPEED_BONUS_INFO_PANEL_ONLY	abilityreallevelfield	_ConvertAbilityRealLevelField('Ncr6')
---
---ABILITY_RLF_LIFE_REGENERATION_RATE_PER_SECOND 'common.ABILITY_RLF_LIFE_REGENERATION_RATE_PER_SECOND'
---@field ABILITY_RLF_LIFE_REGENERATION_RATE_PER_SECOND	abilityreallevelfield	_ConvertAbilityRealLevelField('ave5')
---
---ABILITY_RLF_STUN_DURATION_USL1 'common.ABILITY_RLF_STUN_DURATION_USL1'
---@field ABILITY_RLF_STUN_DURATION_USL1	abilityreallevelfield	_ConvertAbilityRealLevelField('Usl1')
---
---ABILITY_RLF_ATTACK_DAMAGE_STOLEN_PERCENT 'common.ABILITY_RLF_ATTACK_DAMAGE_STOLEN_PERCENT'
---@field ABILITY_RLF_ATTACK_DAMAGE_STOLEN_PERCENT	abilityreallevelfield	_ConvertAbilityRealLevelField('Uav1')
---
---ABILITY_RLF_DAMAGE_UCS1 'common.ABILITY_RLF_DAMAGE_UCS1'
---@field ABILITY_RLF_DAMAGE_UCS1	abilityreallevelfield	_ConvertAbilityRealLevelField('Ucs1')
---
---ABILITY_RLF_MAX_DAMAGE_UCS2 'common.ABILITY_RLF_MAX_DAMAGE_UCS2'
---@field ABILITY_RLF_MAX_DAMAGE_UCS2	abilityreallevelfield	_ConvertAbilityRealLevelField('Ucs2')
---
---ABILITY_RLF_DISTANCE_UCS3 'common.ABILITY_RLF_DISTANCE_UCS3'
---@field ABILITY_RLF_DISTANCE_UCS3	abilityreallevelfield	_ConvertAbilityRealLevelField('Ucs3')
---
---ABILITY_RLF_FINAL_AREA_UCS4 'common.ABILITY_RLF_FINAL_AREA_UCS4'
---@field ABILITY_RLF_FINAL_AREA_UCS4	abilityreallevelfield	_ConvertAbilityRealLevelField('Ucs4')
---
---ABILITY_RLF_DAMAGE_UIN1 'common.ABILITY_RLF_DAMAGE_UIN1'
---@field ABILITY_RLF_DAMAGE_UIN1	abilityreallevelfield	_ConvertAbilityRealLevelField('Uin1')
---
---ABILITY_RLF_DURATION 'common.ABILITY_RLF_DURATION'
---@field ABILITY_RLF_DURATION	abilityreallevelfield	_ConvertAbilityRealLevelField('Uin2')
---
---ABILITY_RLF_IMPACT_DELAY 'common.ABILITY_RLF_IMPACT_DELAY'
---@field ABILITY_RLF_IMPACT_DELAY	abilityreallevelfield	_ConvertAbilityRealLevelField('Uin3')
---
---ABILITY_RLF_DAMAGE_PER_TARGET_OCL1 'common.ABILITY_RLF_DAMAGE_PER_TARGET_OCL1'
---@field ABILITY_RLF_DAMAGE_PER_TARGET_OCL1	abilityreallevelfield	_ConvertAbilityRealLevelField('Ocl1')
---
---ABILITY_RLF_DAMAGE_REDUCTION_PER_TARGET 'common.ABILITY_RLF_DAMAGE_REDUCTION_PER_TARGET'
---@field ABILITY_RLF_DAMAGE_REDUCTION_PER_TARGET	abilityreallevelfield	_ConvertAbilityRealLevelField('Ocl3')
---
---ABILITY_RLF_EFFECT_DELAY_OEQ1 'common.ABILITY_RLF_EFFECT_DELAY_OEQ1'
---@field ABILITY_RLF_EFFECT_DELAY_OEQ1	abilityreallevelfield	_ConvertAbilityRealLevelField('Oeq1')
---
---ABILITY_RLF_DAMAGE_PER_SECOND_TO_BUILDINGS 'common.ABILITY_RLF_DAMAGE_PER_SECOND_TO_BUILDINGS'
---@field ABILITY_RLF_DAMAGE_PER_SECOND_TO_BUILDINGS	abilityreallevelfield	_ConvertAbilityRealLevelField('Oeq2')
---
---ABILITY_RLF_UNITS_SLOWED_PERCENT 'common.ABILITY_RLF_UNITS_SLOWED_PERCENT'
---@field ABILITY_RLF_UNITS_SLOWED_PERCENT	abilityreallevelfield	_ConvertAbilityRealLevelField('Oeq3')
---
---ABILITY_RLF_FINAL_AREA_OEQ4 'common.ABILITY_RLF_FINAL_AREA_OEQ4'
---@field ABILITY_RLF_FINAL_AREA_OEQ4	abilityreallevelfield	_ConvertAbilityRealLevelField('Oeq4')
---
---ABILITY_RLF_DAMAGE_PER_SECOND_EER1 'common.ABILITY_RLF_DAMAGE_PER_SECOND_EER1'
---@field ABILITY_RLF_DAMAGE_PER_SECOND_EER1	abilityreallevelfield	_ConvertAbilityRealLevelField('Eer1')
---
---ABILITY_RLF_DAMAGE_DEALT_TO_ATTACKERS 'common.ABILITY_RLF_DAMAGE_DEALT_TO_ATTACKERS'
---@field ABILITY_RLF_DAMAGE_DEALT_TO_ATTACKERS	abilityreallevelfield	_ConvertAbilityRealLevelField('Eah1')
---
---ABILITY_RLF_LIFE_HEALED 'common.ABILITY_RLF_LIFE_HEALED'
---@field ABILITY_RLF_LIFE_HEALED	abilityreallevelfield	_ConvertAbilityRealLevelField('Etq1')
---
---ABILITY_RLF_HEAL_INTERVAL 'common.ABILITY_RLF_HEAL_INTERVAL'
---@field ABILITY_RLF_HEAL_INTERVAL	abilityreallevelfield	_ConvertAbilityRealLevelField('Etq2')
---
---ABILITY_RLF_BUILDING_REDUCTION_ETQ3 'common.ABILITY_RLF_BUILDING_REDUCTION_ETQ3'
---@field ABILITY_RLF_BUILDING_REDUCTION_ETQ3	abilityreallevelfield	_ConvertAbilityRealLevelField('Etq3')
---
---ABILITY_RLF_INITIAL_IMMUNITY_DURATION 'common.ABILITY_RLF_INITIAL_IMMUNITY_DURATION'
---@field ABILITY_RLF_INITIAL_IMMUNITY_DURATION	abilityreallevelfield	_ConvertAbilityRealLevelField('Etq4')
---
---ABILITY_RLF_MAX_LIFE_DRAINED_PER_SECOND_PERCENT 'common.ABILITY_RLF_MAX_LIFE_DRAINED_PER_SECOND_PERCENT'
---@field ABILITY_RLF_MAX_LIFE_DRAINED_PER_SECOND_PERCENT	abilityreallevelfield	_ConvertAbilityRealLevelField('Udd1')
---
---ABILITY_RLF_BUILDING_REDUCTION_UDD2 'common.ABILITY_RLF_BUILDING_REDUCTION_UDD2'
---@field ABILITY_RLF_BUILDING_REDUCTION_UDD2	abilityreallevelfield	_ConvertAbilityRealLevelField('Udd2')
---
---ABILITY_RLF_ARMOR_DURATION 'common.ABILITY_RLF_ARMOR_DURATION'
---@field ABILITY_RLF_ARMOR_DURATION	abilityreallevelfield	_ConvertAbilityRealLevelField('Ufa1')
---
---ABILITY_RLF_ARMOR_BONUS_UFA2 'common.ABILITY_RLF_ARMOR_BONUS_UFA2'
---@field ABILITY_RLF_ARMOR_BONUS_UFA2	abilityreallevelfield	_ConvertAbilityRealLevelField('Ufa2')
---
---ABILITY_RLF_AREA_OF_EFFECT_DAMAGE 'common.ABILITY_RLF_AREA_OF_EFFECT_DAMAGE'
---@field ABILITY_RLF_AREA_OF_EFFECT_DAMAGE	abilityreallevelfield	_ConvertAbilityRealLevelField('Ufn1')
---
---ABILITY_RLF_SPECIFIC_TARGET_DAMAGE_UFN2 'common.ABILITY_RLF_SPECIFIC_TARGET_DAMAGE_UFN2'
---@field ABILITY_RLF_SPECIFIC_TARGET_DAMAGE_UFN2	abilityreallevelfield	_ConvertAbilityRealLevelField('Ufn2')
---
---ABILITY_RLF_DAMAGE_BONUS_HFA1 'common.ABILITY_RLF_DAMAGE_BONUS_HFA1'
---@field ABILITY_RLF_DAMAGE_BONUS_HFA1	abilityreallevelfield	_ConvertAbilityRealLevelField('Hfa1')
---
---ABILITY_RLF_DAMAGE_DEALT_ESF1 'common.ABILITY_RLF_DAMAGE_DEALT_ESF1'
---@field ABILITY_RLF_DAMAGE_DEALT_ESF1	abilityreallevelfield	_ConvertAbilityRealLevelField('Esf1')
---
---ABILITY_RLF_DAMAGE_INTERVAL_ESF2 'common.ABILITY_RLF_DAMAGE_INTERVAL_ESF2'
---@field ABILITY_RLF_DAMAGE_INTERVAL_ESF2	abilityreallevelfield	_ConvertAbilityRealLevelField('Esf2')
---
---ABILITY_RLF_BUILDING_REDUCTION_ESF3 'common.ABILITY_RLF_BUILDING_REDUCTION_ESF3'
---@field ABILITY_RLF_BUILDING_REDUCTION_ESF3	abilityreallevelfield	_ConvertAbilityRealLevelField('Esf3')
---
---ABILITY_RLF_DAMAGE_BONUS_PERCENT 'common.ABILITY_RLF_DAMAGE_BONUS_PERCENT'
---@field ABILITY_RLF_DAMAGE_BONUS_PERCENT	abilityreallevelfield	_ConvertAbilityRealLevelField('Ear1')
---
---ABILITY_RLF_DEFENSE_BONUS_HAV1 'common.ABILITY_RLF_DEFENSE_BONUS_HAV1'
---@field ABILITY_RLF_DEFENSE_BONUS_HAV1	abilityreallevelfield	_ConvertAbilityRealLevelField('Hav1')
---
---ABILITY_RLF_HIT_POINT_BONUS 'common.ABILITY_RLF_HIT_POINT_BONUS'
---@field ABILITY_RLF_HIT_POINT_BONUS	abilityreallevelfield	_ConvertAbilityRealLevelField('Hav2')
---
---ABILITY_RLF_DAMAGE_BONUS_HAV3 'common.ABILITY_RLF_DAMAGE_BONUS_HAV3'
---@field ABILITY_RLF_DAMAGE_BONUS_HAV3	abilityreallevelfield	_ConvertAbilityRealLevelField('Hav3')
---
---ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_HAV4 'common.ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_HAV4'
---@field ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_HAV4	abilityreallevelfield	_ConvertAbilityRealLevelField('Hav4')
---
---ABILITY_RLF_CHANCE_TO_BASH 'common.ABILITY_RLF_CHANCE_TO_BASH'
---@field ABILITY_RLF_CHANCE_TO_BASH	abilityreallevelfield	_ConvertAbilityRealLevelField('Hbh1')
---
---ABILITY_RLF_DAMAGE_MULTIPLIER_HBH2 'common.ABILITY_RLF_DAMAGE_MULTIPLIER_HBH2'
---@field ABILITY_RLF_DAMAGE_MULTIPLIER_HBH2	abilityreallevelfield	_ConvertAbilityRealLevelField('Hbh2')
---
---ABILITY_RLF_DAMAGE_BONUS_HBH3 'common.ABILITY_RLF_DAMAGE_BONUS_HBH3'
---@field ABILITY_RLF_DAMAGE_BONUS_HBH3	abilityreallevelfield	_ConvertAbilityRealLevelField('Hbh3')
---
---ABILITY_RLF_CHANCE_TO_MISS_HBH4 'common.ABILITY_RLF_CHANCE_TO_MISS_HBH4'
---@field ABILITY_RLF_CHANCE_TO_MISS_HBH4	abilityreallevelfield	_ConvertAbilityRealLevelField('Hbh4')
---
---ABILITY_RLF_DAMAGE_HTB1 'common.ABILITY_RLF_DAMAGE_HTB1'
---@field ABILITY_RLF_DAMAGE_HTB1	abilityreallevelfield	_ConvertAbilityRealLevelField('Htb1')
---
---ABILITY_RLF_AOE_DAMAGE 'common.ABILITY_RLF_AOE_DAMAGE'
---@field ABILITY_RLF_AOE_DAMAGE	abilityreallevelfield	_ConvertAbilityRealLevelField('Htc1')
---
---ABILITY_RLF_SPECIFIC_TARGET_DAMAGE_HTC2 'common.ABILITY_RLF_SPECIFIC_TARGET_DAMAGE_HTC2'
---@field ABILITY_RLF_SPECIFIC_TARGET_DAMAGE_HTC2	abilityreallevelfield	_ConvertAbilityRealLevelField('Htc2')
---
---ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_HTC3 'common.ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_HTC3'
---@field ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_HTC3	abilityreallevelfield	_ConvertAbilityRealLevelField('Htc3')
---
---ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_HTC4 'common.ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_HTC4'
---@field ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_HTC4	abilityreallevelfield	_ConvertAbilityRealLevelField('Htc4')
---
---ABILITY_RLF_ARMOR_BONUS_HAD1 'common.ABILITY_RLF_ARMOR_BONUS_HAD1'
---@field ABILITY_RLF_ARMOR_BONUS_HAD1	abilityreallevelfield	_ConvertAbilityRealLevelField('Had1')
---
---ABILITY_RLF_AMOUNT_HEALED_DAMAGED_HHB1 'common.ABILITY_RLF_AMOUNT_HEALED_DAMAGED_HHB1'
---@field ABILITY_RLF_AMOUNT_HEALED_DAMAGED_HHB1	abilityreallevelfield	_ConvertAbilityRealLevelField('Hhb1')
---
---ABILITY_RLF_EXTRA_DAMAGE_HCA1 'common.ABILITY_RLF_EXTRA_DAMAGE_HCA1'
---@field ABILITY_RLF_EXTRA_DAMAGE_HCA1	abilityreallevelfield	_ConvertAbilityRealLevelField('Hca1')
---
---ABILITY_RLF_MOVEMENT_SPEED_FACTOR_HCA2 'common.ABILITY_RLF_MOVEMENT_SPEED_FACTOR_HCA2'
---@field ABILITY_RLF_MOVEMENT_SPEED_FACTOR_HCA2	abilityreallevelfield	_ConvertAbilityRealLevelField('Hca2')
---
---ABILITY_RLF_ATTACK_SPEED_FACTOR_HCA3 'common.ABILITY_RLF_ATTACK_SPEED_FACTOR_HCA3'
---@field ABILITY_RLF_ATTACK_SPEED_FACTOR_HCA3	abilityreallevelfield	_ConvertAbilityRealLevelField('Hca3')
---
---ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_OAE1 'common.ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_OAE1'
---@field ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_OAE1	abilityreallevelfield	_ConvertAbilityRealLevelField('Oae1')
---
---ABILITY_RLF_ATTACK_SPEED_INCREASE_PERCENT_OAE2 'common.ABILITY_RLF_ATTACK_SPEED_INCREASE_PERCENT_OAE2'
---@field ABILITY_RLF_ATTACK_SPEED_INCREASE_PERCENT_OAE2	abilityreallevelfield	_ConvertAbilityRealLevelField('Oae2')
---
---ABILITY_RLF_REINCARNATION_DELAY 'common.ABILITY_RLF_REINCARNATION_DELAY'
---@field ABILITY_RLF_REINCARNATION_DELAY	abilityreallevelfield	_ConvertAbilityRealLevelField('Ore1')
---
---ABILITY_RLF_DAMAGE_OSH1 'common.ABILITY_RLF_DAMAGE_OSH1'
---@field ABILITY_RLF_DAMAGE_OSH1	abilityreallevelfield	_ConvertAbilityRealLevelField('Osh1')
---
---ABILITY_RLF_MAXIMUM_DAMAGE_OSH2 'common.ABILITY_RLF_MAXIMUM_DAMAGE_OSH2'
---@field ABILITY_RLF_MAXIMUM_DAMAGE_OSH2	abilityreallevelfield	_ConvertAbilityRealLevelField('Osh2')
---
---ABILITY_RLF_DISTANCE_OSH3 'common.ABILITY_RLF_DISTANCE_OSH3'
---@field ABILITY_RLF_DISTANCE_OSH3	abilityreallevelfield	_ConvertAbilityRealLevelField('Osh3')
---
---ABILITY_RLF_FINAL_AREA_OSH4 'common.ABILITY_RLF_FINAL_AREA_OSH4'
---@field ABILITY_RLF_FINAL_AREA_OSH4	abilityreallevelfield	_ConvertAbilityRealLevelField('Osh4')
---
---ABILITY_RLF_GRAPHIC_DELAY_NFD1 'common.ABILITY_RLF_GRAPHIC_DELAY_NFD1'
---@field ABILITY_RLF_GRAPHIC_DELAY_NFD1	abilityreallevelfield	_ConvertAbilityRealLevelField('Nfd1')
---
---ABILITY_RLF_GRAPHIC_DURATION_NFD2 'common.ABILITY_RLF_GRAPHIC_DURATION_NFD2'
---@field ABILITY_RLF_GRAPHIC_DURATION_NFD2	abilityreallevelfield	_ConvertAbilityRealLevelField('Nfd2')
---
---ABILITY_RLF_DAMAGE_NFD3 'common.ABILITY_RLF_DAMAGE_NFD3'
---@field ABILITY_RLF_DAMAGE_NFD3	abilityreallevelfield	_ConvertAbilityRealLevelField('Nfd3')
---
---ABILITY_RLF_SUMMONED_UNIT_DAMAGE_AMS1 'common.ABILITY_RLF_SUMMONED_UNIT_DAMAGE_AMS1'
---@field ABILITY_RLF_SUMMONED_UNIT_DAMAGE_AMS1	abilityreallevelfield	_ConvertAbilityRealLevelField('Ams1')
---
---ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_AMS2 'common.ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_AMS2'
---@field ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_AMS2	abilityreallevelfield	_ConvertAbilityRealLevelField('Ams2')
---
---ABILITY_RLF_AURA_DURATION 'common.ABILITY_RLF_AURA_DURATION'
---@field ABILITY_RLF_AURA_DURATION	abilityreallevelfield	_ConvertAbilityRealLevelField('Apl1')
---
---ABILITY_RLF_DAMAGE_PER_SECOND_APL2 'common.ABILITY_RLF_DAMAGE_PER_SECOND_APL2'
---@field ABILITY_RLF_DAMAGE_PER_SECOND_APL2	abilityreallevelfield	_ConvertAbilityRealLevelField('Apl2')
---
---ABILITY_RLF_DURATION_OF_PLAGUE_WARD 'common.ABILITY_RLF_DURATION_OF_PLAGUE_WARD'
---@field ABILITY_RLF_DURATION_OF_PLAGUE_WARD	abilityreallevelfield	_ConvertAbilityRealLevelField('Apl3')
---
---ABILITY_RLF_AMOUNT_OF_HIT_POINTS_REGENERATED 'common.ABILITY_RLF_AMOUNT_OF_HIT_POINTS_REGENERATED'
---@field ABILITY_RLF_AMOUNT_OF_HIT_POINTS_REGENERATED	abilityreallevelfield	_ConvertAbilityRealLevelField('Oar1')
---
---ABILITY_RLF_ATTACK_DAMAGE_INCREASE_AKB1 'common.ABILITY_RLF_ATTACK_DAMAGE_INCREASE_AKB1'
---@field ABILITY_RLF_ATTACK_DAMAGE_INCREASE_AKB1	abilityreallevelfield	_ConvertAbilityRealLevelField('Akb1')
---
---ABILITY_RLF_MANA_LOSS_ADM1 'common.ABILITY_RLF_MANA_LOSS_ADM1'
---@field ABILITY_RLF_MANA_LOSS_ADM1	abilityreallevelfield	_ConvertAbilityRealLevelField('Adm1')
---
---ABILITY_RLF_SUMMONED_UNIT_DAMAGE_ADM2 'common.ABILITY_RLF_SUMMONED_UNIT_DAMAGE_ADM2'
---@field ABILITY_RLF_SUMMONED_UNIT_DAMAGE_ADM2	abilityreallevelfield	_ConvertAbilityRealLevelField('Adm2')
---
---ABILITY_RLF_EXPANSION_AMOUNT 'common.ABILITY_RLF_EXPANSION_AMOUNT'
---@field ABILITY_RLF_EXPANSION_AMOUNT	abilityreallevelfield	_ConvertAbilityRealLevelField('Bli1')
---
---ABILITY_RLF_INTERVAL_DURATION_BGM2 'common.ABILITY_RLF_INTERVAL_DURATION_BGM2'
---@field ABILITY_RLF_INTERVAL_DURATION_BGM2	abilityreallevelfield	_ConvertAbilityRealLevelField('Bgm2')
---
---ABILITY_RLF_RADIUS_OF_MINING_RING 'common.ABILITY_RLF_RADIUS_OF_MINING_RING'
---@field ABILITY_RLF_RADIUS_OF_MINING_RING	abilityreallevelfield	_ConvertAbilityRealLevelField('Bgm4')
---
---ABILITY_RLF_ATTACK_SPEED_INCREASE_PERCENT_BLO1 'common.ABILITY_RLF_ATTACK_SPEED_INCREASE_PERCENT_BLO1'
---@field ABILITY_RLF_ATTACK_SPEED_INCREASE_PERCENT_BLO1	abilityreallevelfield	_ConvertAbilityRealLevelField('Blo1')
---
---ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_BLO2 'common.ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_BLO2'
---@field ABILITY_RLF_MOVEMENT_SPEED_INCREASE_PERCENT_BLO2	abilityreallevelfield	_ConvertAbilityRealLevelField('Blo2')
---
---ABILITY_RLF_SCALING_FACTOR 'common.ABILITY_RLF_SCALING_FACTOR'
---@field ABILITY_RLF_SCALING_FACTOR	abilityreallevelfield	_ConvertAbilityRealLevelField('Blo3')
---
---ABILITY_RLF_HIT_POINTS_PER_SECOND_CAN1 'common.ABILITY_RLF_HIT_POINTS_PER_SECOND_CAN1'
---@field ABILITY_RLF_HIT_POINTS_PER_SECOND_CAN1	abilityreallevelfield	_ConvertAbilityRealLevelField('Can1')
---
---ABILITY_RLF_MAX_HIT_POINTS 'common.ABILITY_RLF_MAX_HIT_POINTS'
---@field ABILITY_RLF_MAX_HIT_POINTS	abilityreallevelfield	_ConvertAbilityRealLevelField('Can2')
---
---ABILITY_RLF_DAMAGE_PER_SECOND_DEV2 'common.ABILITY_RLF_DAMAGE_PER_SECOND_DEV2'
---@field ABILITY_RLF_DAMAGE_PER_SECOND_DEV2	abilityreallevelfield	_ConvertAbilityRealLevelField('Dev2')
---
---ABILITY_RLF_MOVEMENT_UPDATE_FREQUENCY_CHD1 'common.ABILITY_RLF_MOVEMENT_UPDATE_FREQUENCY_CHD1'
---@field ABILITY_RLF_MOVEMENT_UPDATE_FREQUENCY_CHD1	abilityreallevelfield	_ConvertAbilityRealLevelField('Chd1')
---
---ABILITY_RLF_ATTACK_UPDATE_FREQUENCY_CHD2 'common.ABILITY_RLF_ATTACK_UPDATE_FREQUENCY_CHD2'
---@field ABILITY_RLF_ATTACK_UPDATE_FREQUENCY_CHD2	abilityreallevelfield	_ConvertAbilityRealLevelField('Chd2')
---
---ABILITY_RLF_SUMMONED_UNIT_DAMAGE_CHD3 'common.ABILITY_RLF_SUMMONED_UNIT_DAMAGE_CHD3'
---@field ABILITY_RLF_SUMMONED_UNIT_DAMAGE_CHD3	abilityreallevelfield	_ConvertAbilityRealLevelField('Chd3')
---
---ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_CRI1 'common.ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_CRI1'
---@field ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_CRI1	abilityreallevelfield	_ConvertAbilityRealLevelField('Cri1')
---
---ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_CRI2 'common.ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_CRI2'
---@field ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_CRI2	abilityreallevelfield	_ConvertAbilityRealLevelField('Cri2')
---
---ABILITY_RLF_DAMAGE_REDUCTION_CRI3 'common.ABILITY_RLF_DAMAGE_REDUCTION_CRI3'
---@field ABILITY_RLF_DAMAGE_REDUCTION_CRI3	abilityreallevelfield	_ConvertAbilityRealLevelField('Cri3')
---
---ABILITY_RLF_CHANCE_TO_MISS_CRS 'common.ABILITY_RLF_CHANCE_TO_MISS_CRS'
---@field ABILITY_RLF_CHANCE_TO_MISS_CRS	abilityreallevelfield	_ConvertAbilityRealLevelField('Crs1')
---
---ABILITY_RLF_FULL_DAMAGE_RADIUS_DDA1 'common.ABILITY_RLF_FULL_DAMAGE_RADIUS_DDA1'
---@field ABILITY_RLF_FULL_DAMAGE_RADIUS_DDA1	abilityreallevelfield	_ConvertAbilityRealLevelField('Dda1')
---
---ABILITY_RLF_FULL_DAMAGE_AMOUNT_DDA2 'common.ABILITY_RLF_FULL_DAMAGE_AMOUNT_DDA2'
---@field ABILITY_RLF_FULL_DAMAGE_AMOUNT_DDA2	abilityreallevelfield	_ConvertAbilityRealLevelField('Dda2')
---
---ABILITY_RLF_PARTIAL_DAMAGE_RADIUS 'common.ABILITY_RLF_PARTIAL_DAMAGE_RADIUS'
---@field ABILITY_RLF_PARTIAL_DAMAGE_RADIUS	abilityreallevelfield	_ConvertAbilityRealLevelField('Dda3')
---
---ABILITY_RLF_PARTIAL_DAMAGE_AMOUNT 'common.ABILITY_RLF_PARTIAL_DAMAGE_AMOUNT'
---@field ABILITY_RLF_PARTIAL_DAMAGE_AMOUNT	abilityreallevelfield	_ConvertAbilityRealLevelField('Dda4')
---
---ABILITY_RLF_BUILDING_DAMAGE_FACTOR_SDS1 'common.ABILITY_RLF_BUILDING_DAMAGE_FACTOR_SDS1'
---@field ABILITY_RLF_BUILDING_DAMAGE_FACTOR_SDS1	abilityreallevelfield	_ConvertAbilityRealLevelField('Sds1')
---
---ABILITY_RLF_MAX_DAMAGE_UCO5 'common.ABILITY_RLF_MAX_DAMAGE_UCO5'
---@field ABILITY_RLF_MAX_DAMAGE_UCO5	abilityreallevelfield	_ConvertAbilityRealLevelField('Uco5')
---
---ABILITY_RLF_MOVE_SPEED_BONUS_UCO6 'common.ABILITY_RLF_MOVE_SPEED_BONUS_UCO6'
---@field ABILITY_RLF_MOVE_SPEED_BONUS_UCO6	abilityreallevelfield	_ConvertAbilityRealLevelField('Uco6')
---
---ABILITY_RLF_DAMAGE_TAKEN_PERCENT_DEF1 'common.ABILITY_RLF_DAMAGE_TAKEN_PERCENT_DEF1'
---@field ABILITY_RLF_DAMAGE_TAKEN_PERCENT_DEF1	abilityreallevelfield	_ConvertAbilityRealLevelField('Def1')
---
---ABILITY_RLF_DAMAGE_DEALT_PERCENT_DEF2 'common.ABILITY_RLF_DAMAGE_DEALT_PERCENT_DEF2'
---@field ABILITY_RLF_DAMAGE_DEALT_PERCENT_DEF2	abilityreallevelfield	_ConvertAbilityRealLevelField('Def2')
---
---ABILITY_RLF_MOVEMENT_SPEED_FACTOR_DEF3 'common.ABILITY_RLF_MOVEMENT_SPEED_FACTOR_DEF3'
---@field ABILITY_RLF_MOVEMENT_SPEED_FACTOR_DEF3	abilityreallevelfield	_ConvertAbilityRealLevelField('Def3')
---
---ABILITY_RLF_ATTACK_SPEED_FACTOR_DEF4 'common.ABILITY_RLF_ATTACK_SPEED_FACTOR_DEF4'
---@field ABILITY_RLF_ATTACK_SPEED_FACTOR_DEF4	abilityreallevelfield	_ConvertAbilityRealLevelField('Def4')
---
---ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_DEF5 'common.ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_DEF5'
---@field ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_DEF5	abilityreallevelfield	_ConvertAbilityRealLevelField('Def5')
---
---ABILITY_RLF_CHANCE_TO_DEFLECT 'common.ABILITY_RLF_CHANCE_TO_DEFLECT'
---@field ABILITY_RLF_CHANCE_TO_DEFLECT	abilityreallevelfield	_ConvertAbilityRealLevelField('Def6')
---
---ABILITY_RLF_DEFLECT_DAMAGE_TAKEN_PIERCING 'common.ABILITY_RLF_DEFLECT_DAMAGE_TAKEN_PIERCING'
---@field ABILITY_RLF_DEFLECT_DAMAGE_TAKEN_PIERCING	abilityreallevelfield	_ConvertAbilityRealLevelField('Def7')
---
---ABILITY_RLF_DEFLECT_DAMAGE_TAKEN_SPELLS 'common.ABILITY_RLF_DEFLECT_DAMAGE_TAKEN_SPELLS'
---@field ABILITY_RLF_DEFLECT_DAMAGE_TAKEN_SPELLS	abilityreallevelfield	_ConvertAbilityRealLevelField('Def8')
---
---ABILITY_RLF_RIP_DELAY 'common.ABILITY_RLF_RIP_DELAY'
---@field ABILITY_RLF_RIP_DELAY	abilityreallevelfield	_ConvertAbilityRealLevelField('Eat1')
---
---ABILITY_RLF_EAT_DELAY 'common.ABILITY_RLF_EAT_DELAY'
---@field ABILITY_RLF_EAT_DELAY	abilityreallevelfield	_ConvertAbilityRealLevelField('Eat2')
---
---ABILITY_RLF_HIT_POINTS_GAINED_EAT3 'common.ABILITY_RLF_HIT_POINTS_GAINED_EAT3'
---@field ABILITY_RLF_HIT_POINTS_GAINED_EAT3	abilityreallevelfield	_ConvertAbilityRealLevelField('Eat3')
---
---ABILITY_RLF_AIR_UNIT_LOWER_DURATION 'common.ABILITY_RLF_AIR_UNIT_LOWER_DURATION'
---@field ABILITY_RLF_AIR_UNIT_LOWER_DURATION	abilityreallevelfield	_ConvertAbilityRealLevelField('Ens1')
---
---ABILITY_RLF_AIR_UNIT_HEIGHT 'common.ABILITY_RLF_AIR_UNIT_HEIGHT'
---@field ABILITY_RLF_AIR_UNIT_HEIGHT	abilityreallevelfield	_ConvertAbilityRealLevelField('Ens2')
---
---ABILITY_RLF_MELEE_ATTACK_RANGE 'common.ABILITY_RLF_MELEE_ATTACK_RANGE'
---@field ABILITY_RLF_MELEE_ATTACK_RANGE	abilityreallevelfield	_ConvertAbilityRealLevelField('Ens3')
---
---ABILITY_RLF_INTERVAL_DURATION_EGM2 'common.ABILITY_RLF_INTERVAL_DURATION_EGM2'
---@field ABILITY_RLF_INTERVAL_DURATION_EGM2	abilityreallevelfield	_ConvertAbilityRealLevelField('Egm2')
---
---ABILITY_RLF_EFFECT_DELAY_FLA2 'common.ABILITY_RLF_EFFECT_DELAY_FLA2'
---@field ABILITY_RLF_EFFECT_DELAY_FLA2	abilityreallevelfield	_ConvertAbilityRealLevelField('Fla2')
---
---ABILITY_RLF_MINING_DURATION 'common.ABILITY_RLF_MINING_DURATION'
---@field ABILITY_RLF_MINING_DURATION	abilityreallevelfield	_ConvertAbilityRealLevelField('Gld2')
---
---ABILITY_RLF_RADIUS_OF_GRAVESTONES 'common.ABILITY_RLF_RADIUS_OF_GRAVESTONES'
---@field ABILITY_RLF_RADIUS_OF_GRAVESTONES	abilityreallevelfield	_ConvertAbilityRealLevelField('Gyd2')
---
---ABILITY_RLF_RADIUS_OF_CORPSES 'common.ABILITY_RLF_RADIUS_OF_CORPSES'
---@field ABILITY_RLF_RADIUS_OF_CORPSES	abilityreallevelfield	_ConvertAbilityRealLevelField('Gyd3')
---
---ABILITY_RLF_HIT_POINTS_GAINED_HEA1 'common.ABILITY_RLF_HIT_POINTS_GAINED_HEA1'
---@field ABILITY_RLF_HIT_POINTS_GAINED_HEA1	abilityreallevelfield	_ConvertAbilityRealLevelField('Hea1')
---
---ABILITY_RLF_DAMAGE_INCREASE_PERCENT_INF1 'common.ABILITY_RLF_DAMAGE_INCREASE_PERCENT_INF1'
---@field ABILITY_RLF_DAMAGE_INCREASE_PERCENT_INF1	abilityreallevelfield	_ConvertAbilityRealLevelField('Inf1')
---
---ABILITY_RLF_AUTOCAST_RANGE 'common.ABILITY_RLF_AUTOCAST_RANGE'
---@field ABILITY_RLF_AUTOCAST_RANGE	abilityreallevelfield	_ConvertAbilityRealLevelField('Inf3')
---
---ABILITY_RLF_LIFE_REGEN_RATE 'common.ABILITY_RLF_LIFE_REGEN_RATE'
---@field ABILITY_RLF_LIFE_REGEN_RATE	abilityreallevelfield	_ConvertAbilityRealLevelField('Inf4')
---
---ABILITY_RLF_GRAPHIC_DELAY_LIT1 'common.ABILITY_RLF_GRAPHIC_DELAY_LIT1'
---@field ABILITY_RLF_GRAPHIC_DELAY_LIT1	abilityreallevelfield	_ConvertAbilityRealLevelField('Lit1')
---
---ABILITY_RLF_GRAPHIC_DURATION_LIT2 'common.ABILITY_RLF_GRAPHIC_DURATION_LIT2'
---@field ABILITY_RLF_GRAPHIC_DURATION_LIT2	abilityreallevelfield	_ConvertAbilityRealLevelField('Lit2')
---
---ABILITY_RLF_DAMAGE_PER_SECOND_LSH1 'common.ABILITY_RLF_DAMAGE_PER_SECOND_LSH1'
---@field ABILITY_RLF_DAMAGE_PER_SECOND_LSH1	abilityreallevelfield	_ConvertAbilityRealLevelField('Lsh1')
---
---ABILITY_RLF_MANA_GAINED 'common.ABILITY_RLF_MANA_GAINED'
---@field ABILITY_RLF_MANA_GAINED	abilityreallevelfield	_ConvertAbilityRealLevelField('Mbt1')
---
---ABILITY_RLF_HIT_POINTS_GAINED_MBT2 'common.ABILITY_RLF_HIT_POINTS_GAINED_MBT2'
---@field ABILITY_RLF_HIT_POINTS_GAINED_MBT2	abilityreallevelfield	_ConvertAbilityRealLevelField('Mbt2')
---
---ABILITY_RLF_AUTOCAST_REQUIREMENT 'common.ABILITY_RLF_AUTOCAST_REQUIREMENT'
---@field ABILITY_RLF_AUTOCAST_REQUIREMENT	abilityreallevelfield	_ConvertAbilityRealLevelField('Mbt3')
---
---ABILITY_RLF_WATER_HEIGHT 'common.ABILITY_RLF_WATER_HEIGHT'
---@field ABILITY_RLF_WATER_HEIGHT	abilityreallevelfield	_ConvertAbilityRealLevelField('Mbt4')
---
---ABILITY_RLF_ACTIVATION_DELAY_MIN1 'common.ABILITY_RLF_ACTIVATION_DELAY_MIN1'
---@field ABILITY_RLF_ACTIVATION_DELAY_MIN1	abilityreallevelfield	_ConvertAbilityRealLevelField('Min1')
---
---ABILITY_RLF_INVISIBILITY_TRANSITION_TIME 'common.ABILITY_RLF_INVISIBILITY_TRANSITION_TIME'
---@field ABILITY_RLF_INVISIBILITY_TRANSITION_TIME	abilityreallevelfield	_ConvertAbilityRealLevelField('Min2')
---
---ABILITY_RLF_ACTIVATION_RADIUS 'common.ABILITY_RLF_ACTIVATION_RADIUS'
---@field ABILITY_RLF_ACTIVATION_RADIUS	abilityreallevelfield	_ConvertAbilityRealLevelField('Neu1')
---
---ABILITY_RLF_AMOUNT_REGENERATED 'common.ABILITY_RLF_AMOUNT_REGENERATED'
---@field ABILITY_RLF_AMOUNT_REGENERATED	abilityreallevelfield	_ConvertAbilityRealLevelField('Arm1')
---
---ABILITY_RLF_DAMAGE_PER_SECOND_POI1 'common.ABILITY_RLF_DAMAGE_PER_SECOND_POI1'
---@field ABILITY_RLF_DAMAGE_PER_SECOND_POI1	abilityreallevelfield	_ConvertAbilityRealLevelField('Poi1')
---
---ABILITY_RLF_ATTACK_SPEED_FACTOR_POI2 'common.ABILITY_RLF_ATTACK_SPEED_FACTOR_POI2'
---@field ABILITY_RLF_ATTACK_SPEED_FACTOR_POI2	abilityreallevelfield	_ConvertAbilityRealLevelField('Poi2')
---
---ABILITY_RLF_MOVEMENT_SPEED_FACTOR_POI3 'common.ABILITY_RLF_MOVEMENT_SPEED_FACTOR_POI3'
---@field ABILITY_RLF_MOVEMENT_SPEED_FACTOR_POI3	abilityreallevelfield	_ConvertAbilityRealLevelField('Poi3')
---
---ABILITY_RLF_EXTRA_DAMAGE_POA1 'common.ABILITY_RLF_EXTRA_DAMAGE_POA1'
---@field ABILITY_RLF_EXTRA_DAMAGE_POA1	abilityreallevelfield	_ConvertAbilityRealLevelField('Poa1')
---
---ABILITY_RLF_DAMAGE_PER_SECOND_POA2 'common.ABILITY_RLF_DAMAGE_PER_SECOND_POA2'
---@field ABILITY_RLF_DAMAGE_PER_SECOND_POA2	abilityreallevelfield	_ConvertAbilityRealLevelField('Poa2')
---
---ABILITY_RLF_ATTACK_SPEED_FACTOR_POA3 'common.ABILITY_RLF_ATTACK_SPEED_FACTOR_POA3'
---@field ABILITY_RLF_ATTACK_SPEED_FACTOR_POA3	abilityreallevelfield	_ConvertAbilityRealLevelField('Poa3')
---
---ABILITY_RLF_MOVEMENT_SPEED_FACTOR_POA4 'common.ABILITY_RLF_MOVEMENT_SPEED_FACTOR_POA4'
---@field ABILITY_RLF_MOVEMENT_SPEED_FACTOR_POA4	abilityreallevelfield	_ConvertAbilityRealLevelField('Poa4')
---
---ABILITY_RLF_DAMAGE_AMPLIFICATION 'common.ABILITY_RLF_DAMAGE_AMPLIFICATION'
---@field ABILITY_RLF_DAMAGE_AMPLIFICATION	abilityreallevelfield	_ConvertAbilityRealLevelField('Pos2')
---
---ABILITY_RLF_CHANCE_TO_STOMP_PERCENT 'common.ABILITY_RLF_CHANCE_TO_STOMP_PERCENT'
---@field ABILITY_RLF_CHANCE_TO_STOMP_PERCENT	abilityreallevelfield	_ConvertAbilityRealLevelField('War1')
---
---ABILITY_RLF_DAMAGE_DEALT_WAR2 'common.ABILITY_RLF_DAMAGE_DEALT_WAR2'
---@field ABILITY_RLF_DAMAGE_DEALT_WAR2	abilityreallevelfield	_ConvertAbilityRealLevelField('War2')
---
---ABILITY_RLF_FULL_DAMAGE_RADIUS_WAR3 'common.ABILITY_RLF_FULL_DAMAGE_RADIUS_WAR3'
---@field ABILITY_RLF_FULL_DAMAGE_RADIUS_WAR3	abilityreallevelfield	_ConvertAbilityRealLevelField('War3')
---
---ABILITY_RLF_HALF_DAMAGE_RADIUS_WAR4 'common.ABILITY_RLF_HALF_DAMAGE_RADIUS_WAR4'
---@field ABILITY_RLF_HALF_DAMAGE_RADIUS_WAR4	abilityreallevelfield	_ConvertAbilityRealLevelField('War4')
---
---ABILITY_RLF_SUMMONED_UNIT_DAMAGE_PRG3 'common.ABILITY_RLF_SUMMONED_UNIT_DAMAGE_PRG3'
---@field ABILITY_RLF_SUMMONED_UNIT_DAMAGE_PRG3	abilityreallevelfield	_ConvertAbilityRealLevelField('Prg3')
---
---ABILITY_RLF_UNIT_PAUSE_DURATION 'common.ABILITY_RLF_UNIT_PAUSE_DURATION'
---@field ABILITY_RLF_UNIT_PAUSE_DURATION	abilityreallevelfield	_ConvertAbilityRealLevelField('Prg4')
---
---ABILITY_RLF_HERO_PAUSE_DURATION 'common.ABILITY_RLF_HERO_PAUSE_DURATION'
---@field ABILITY_RLF_HERO_PAUSE_DURATION	abilityreallevelfield	_ConvertAbilityRealLevelField('Prg5')
---
---ABILITY_RLF_HIT_POINTS_GAINED_REJ1 'common.ABILITY_RLF_HIT_POINTS_GAINED_REJ1'
---@field ABILITY_RLF_HIT_POINTS_GAINED_REJ1	abilityreallevelfield	_ConvertAbilityRealLevelField('Rej1')
---
---ABILITY_RLF_MANA_POINTS_GAINED_REJ2 'common.ABILITY_RLF_MANA_POINTS_GAINED_REJ2'
---@field ABILITY_RLF_MANA_POINTS_GAINED_REJ2	abilityreallevelfield	_ConvertAbilityRealLevelField('Rej2')
---
---ABILITY_RLF_MINIMUM_LIFE_REQUIRED 'common.ABILITY_RLF_MINIMUM_LIFE_REQUIRED'
---@field ABILITY_RLF_MINIMUM_LIFE_REQUIRED	abilityreallevelfield	_ConvertAbilityRealLevelField('Rpb3')
---
---ABILITY_RLF_MINIMUM_MANA_REQUIRED 'common.ABILITY_RLF_MINIMUM_MANA_REQUIRED'
---@field ABILITY_RLF_MINIMUM_MANA_REQUIRED	abilityreallevelfield	_ConvertAbilityRealLevelField('Rpb4')
---
---ABILITY_RLF_REPAIR_COST_RATIO 'common.ABILITY_RLF_REPAIR_COST_RATIO'
---@field ABILITY_RLF_REPAIR_COST_RATIO	abilityreallevelfield	_ConvertAbilityRealLevelField('Rep1')
---
---ABILITY_RLF_REPAIR_TIME_RATIO 'common.ABILITY_RLF_REPAIR_TIME_RATIO'
---@field ABILITY_RLF_REPAIR_TIME_RATIO	abilityreallevelfield	_ConvertAbilityRealLevelField('Rep2')
---
---ABILITY_RLF_POWERBUILD_COST 'common.ABILITY_RLF_POWERBUILD_COST'
---@field ABILITY_RLF_POWERBUILD_COST	abilityreallevelfield	_ConvertAbilityRealLevelField('Rep3')
---
---ABILITY_RLF_POWERBUILD_RATE 'common.ABILITY_RLF_POWERBUILD_RATE'
---@field ABILITY_RLF_POWERBUILD_RATE	abilityreallevelfield	_ConvertAbilityRealLevelField('Rep4')
---
---ABILITY_RLF_NAVAL_RANGE_BONUS 'common.ABILITY_RLF_NAVAL_RANGE_BONUS'
---@field ABILITY_RLF_NAVAL_RANGE_BONUS	abilityreallevelfield	_ConvertAbilityRealLevelField('Rep5')
---
---ABILITY_RLF_DAMAGE_INCREASE_PERCENT_ROA1 'common.ABILITY_RLF_DAMAGE_INCREASE_PERCENT_ROA1'
---@field ABILITY_RLF_DAMAGE_INCREASE_PERCENT_ROA1	abilityreallevelfield	_ConvertAbilityRealLevelField('Roa1')
---
---ABILITY_RLF_LIFE_REGENERATION_RATE 'common.ABILITY_RLF_LIFE_REGENERATION_RATE'
---@field ABILITY_RLF_LIFE_REGENERATION_RATE	abilityreallevelfield	_ConvertAbilityRealLevelField('Roa3')
---
---ABILITY_RLF_MANA_REGEN 'common.ABILITY_RLF_MANA_REGEN'
---@field ABILITY_RLF_MANA_REGEN	abilityreallevelfield	_ConvertAbilityRealLevelField('Roa4')
---
---ABILITY_RLF_DAMAGE_INCREASE 'common.ABILITY_RLF_DAMAGE_INCREASE'
---@field ABILITY_RLF_DAMAGE_INCREASE	abilityreallevelfield	_ConvertAbilityRealLevelField('Nbr1')
---
---ABILITY_RLF_SALVAGE_COST_RATIO 'common.ABILITY_RLF_SALVAGE_COST_RATIO'
---@field ABILITY_RLF_SALVAGE_COST_RATIO	abilityreallevelfield	_ConvertAbilityRealLevelField('Sal1')
---
---ABILITY_RLF_IN_FLIGHT_SIGHT_RADIUS 'common.ABILITY_RLF_IN_FLIGHT_SIGHT_RADIUS'
---@field ABILITY_RLF_IN_FLIGHT_SIGHT_RADIUS	abilityreallevelfield	_ConvertAbilityRealLevelField('Esn1')
---
---ABILITY_RLF_HOVERING_SIGHT_RADIUS 'common.ABILITY_RLF_HOVERING_SIGHT_RADIUS'
---@field ABILITY_RLF_HOVERING_SIGHT_RADIUS	abilityreallevelfield	_ConvertAbilityRealLevelField('Esn2')
---
---ABILITY_RLF_HOVERING_HEIGHT 'common.ABILITY_RLF_HOVERING_HEIGHT'
---@field ABILITY_RLF_HOVERING_HEIGHT	abilityreallevelfield	_ConvertAbilityRealLevelField('Esn3')
---
---ABILITY_RLF_DURATION_OF_OWLS 'common.ABILITY_RLF_DURATION_OF_OWLS'
---@field ABILITY_RLF_DURATION_OF_OWLS	abilityreallevelfield	_ConvertAbilityRealLevelField('Esn5')
---
---ABILITY_RLF_FADE_DURATION 'common.ABILITY_RLF_FADE_DURATION'
---@field ABILITY_RLF_FADE_DURATION	abilityreallevelfield	_ConvertAbilityRealLevelField('Shm1')
---
---ABILITY_RLF_DAY_NIGHT_DURATION 'common.ABILITY_RLF_DAY_NIGHT_DURATION'
---@field ABILITY_RLF_DAY_NIGHT_DURATION	abilityreallevelfield	_ConvertAbilityRealLevelField('Shm2')
---
---ABILITY_RLF_ACTION_DURATION 'common.ABILITY_RLF_ACTION_DURATION'
---@field ABILITY_RLF_ACTION_DURATION	abilityreallevelfield	_ConvertAbilityRealLevelField('Shm3')
---
---ABILITY_RLF_MOVEMENT_SPEED_FACTOR_SLO1 'common.ABILITY_RLF_MOVEMENT_SPEED_FACTOR_SLO1'
---@field ABILITY_RLF_MOVEMENT_SPEED_FACTOR_SLO1	abilityreallevelfield	_ConvertAbilityRealLevelField('Slo1')
---
---ABILITY_RLF_ATTACK_SPEED_FACTOR_SLO2 'common.ABILITY_RLF_ATTACK_SPEED_FACTOR_SLO2'
---@field ABILITY_RLF_ATTACK_SPEED_FACTOR_SLO2	abilityreallevelfield	_ConvertAbilityRealLevelField('Slo2')
---
---ABILITY_RLF_DAMAGE_PER_SECOND_SPO1 'common.ABILITY_RLF_DAMAGE_PER_SECOND_SPO1'
---@field ABILITY_RLF_DAMAGE_PER_SECOND_SPO1	abilityreallevelfield	_ConvertAbilityRealLevelField('Spo1')
---
---ABILITY_RLF_MOVEMENT_SPEED_FACTOR_SPO2 'common.ABILITY_RLF_MOVEMENT_SPEED_FACTOR_SPO2'
---@field ABILITY_RLF_MOVEMENT_SPEED_FACTOR_SPO2	abilityreallevelfield	_ConvertAbilityRealLevelField('Spo2')
---
---ABILITY_RLF_ATTACK_SPEED_FACTOR_SPO3 'common.ABILITY_RLF_ATTACK_SPEED_FACTOR_SPO3'
---@field ABILITY_RLF_ATTACK_SPEED_FACTOR_SPO3	abilityreallevelfield	_ConvertAbilityRealLevelField('Spo3')
---
---ABILITY_RLF_ACTIVATION_DELAY_STA1 'common.ABILITY_RLF_ACTIVATION_DELAY_STA1'
---@field ABILITY_RLF_ACTIVATION_DELAY_STA1	abilityreallevelfield	_ConvertAbilityRealLevelField('Sta1')
---
---ABILITY_RLF_DETECTION_RADIUS_STA2 'common.ABILITY_RLF_DETECTION_RADIUS_STA2'
---@field ABILITY_RLF_DETECTION_RADIUS_STA2	abilityreallevelfield	_ConvertAbilityRealLevelField('Sta2')
---
---ABILITY_RLF_DETONATION_RADIUS 'common.ABILITY_RLF_DETONATION_RADIUS'
---@field ABILITY_RLF_DETONATION_RADIUS	abilityreallevelfield	_ConvertAbilityRealLevelField('Sta3')
---
---ABILITY_RLF_STUN_DURATION_STA4 'common.ABILITY_RLF_STUN_DURATION_STA4'
---@field ABILITY_RLF_STUN_DURATION_STA4	abilityreallevelfield	_ConvertAbilityRealLevelField('Sta4')
---
---ABILITY_RLF_ATTACK_SPEED_BONUS_PERCENT 'common.ABILITY_RLF_ATTACK_SPEED_BONUS_PERCENT'
---@field ABILITY_RLF_ATTACK_SPEED_BONUS_PERCENT	abilityreallevelfield	_ConvertAbilityRealLevelField('Uhf1')
---
---ABILITY_RLF_DAMAGE_PER_SECOND_UHF2 'common.ABILITY_RLF_DAMAGE_PER_SECOND_UHF2'
---@field ABILITY_RLF_DAMAGE_PER_SECOND_UHF2	abilityreallevelfield	_ConvertAbilityRealLevelField('Uhf2')
---
---ABILITY_RLF_LUMBER_PER_INTERVAL 'common.ABILITY_RLF_LUMBER_PER_INTERVAL'
---@field ABILITY_RLF_LUMBER_PER_INTERVAL	abilityreallevelfield	_ConvertAbilityRealLevelField('Wha1')
---
---ABILITY_RLF_ART_ATTACHMENT_HEIGHT 'common.ABILITY_RLF_ART_ATTACHMENT_HEIGHT'
---@field ABILITY_RLF_ART_ATTACHMENT_HEIGHT	abilityreallevelfield	_ConvertAbilityRealLevelField('Wha3')
---
---ABILITY_RLF_TELEPORT_AREA_WIDTH 'common.ABILITY_RLF_TELEPORT_AREA_WIDTH'
---@field ABILITY_RLF_TELEPORT_AREA_WIDTH	abilityreallevelfield	_ConvertAbilityRealLevelField('Wrp1')
---
---ABILITY_RLF_TELEPORT_AREA_HEIGHT 'common.ABILITY_RLF_TELEPORT_AREA_HEIGHT'
---@field ABILITY_RLF_TELEPORT_AREA_HEIGHT	abilityreallevelfield	_ConvertAbilityRealLevelField('Wrp2')
---
---ABILITY_RLF_LIFE_STOLEN_PER_ATTACK 'common.ABILITY_RLF_LIFE_STOLEN_PER_ATTACK'
---@field ABILITY_RLF_LIFE_STOLEN_PER_ATTACK	abilityreallevelfield	_ConvertAbilityRealLevelField('Ivam')
---
---ABILITY_RLF_DAMAGE_BONUS_IDAM 'common.ABILITY_RLF_DAMAGE_BONUS_IDAM'
---@field ABILITY_RLF_DAMAGE_BONUS_IDAM	abilityreallevelfield	_ConvertAbilityRealLevelField('Idam')
---
---ABILITY_RLF_CHANCE_TO_HIT_UNITS_PERCENT 'common.ABILITY_RLF_CHANCE_TO_HIT_UNITS_PERCENT'
---@field ABILITY_RLF_CHANCE_TO_HIT_UNITS_PERCENT	abilityreallevelfield	_ConvertAbilityRealLevelField('Iob2')
---
---ABILITY_RLF_CHANCE_TO_HIT_HEROS_PERCENT 'common.ABILITY_RLF_CHANCE_TO_HIT_HEROS_PERCENT'
---@field ABILITY_RLF_CHANCE_TO_HIT_HEROS_PERCENT	abilityreallevelfield	_ConvertAbilityRealLevelField('Iob3')
---
---ABILITY_RLF_CHANCE_TO_HIT_SUMMONS_PERCENT 'common.ABILITY_RLF_CHANCE_TO_HIT_SUMMONS_PERCENT'
---@field ABILITY_RLF_CHANCE_TO_HIT_SUMMONS_PERCENT	abilityreallevelfield	_ConvertAbilityRealLevelField('Iob4')
---
---ABILITY_RLF_DELAY_FOR_TARGET_EFFECT 'common.ABILITY_RLF_DELAY_FOR_TARGET_EFFECT'
---@field ABILITY_RLF_DELAY_FOR_TARGET_EFFECT	abilityreallevelfield	_ConvertAbilityRealLevelField('Idel')
---
---ABILITY_RLF_DAMAGE_DEALT_PERCENT_OF_NORMAL 'common.ABILITY_RLF_DAMAGE_DEALT_PERCENT_OF_NORMAL'
---@field ABILITY_RLF_DAMAGE_DEALT_PERCENT_OF_NORMAL	abilityreallevelfield	_ConvertAbilityRealLevelField('Iild')
---
---ABILITY_RLF_DAMAGE_RECEIVED_MULTIPLIER 'common.ABILITY_RLF_DAMAGE_RECEIVED_MULTIPLIER'
---@field ABILITY_RLF_DAMAGE_RECEIVED_MULTIPLIER	abilityreallevelfield	_ConvertAbilityRealLevelField('Iilw')
---
---ABILITY_RLF_MANA_REGENERATION_BONUS_AS_FRACTION_OF_NORMAL 'common.ABILITY_RLF_MANA_REGENERATION_BONUS_AS_FRACTION_OF_NORMAL'
---@field ABILITY_RLF_MANA_REGENERATION_BONUS_AS_FRACTION_OF_NORMAL	abilityreallevelfield	_ConvertAbilityRealLevelField('Imrp')
---
---ABILITY_RLF_MOVEMENT_SPEED_INCREASE_ISPI 'common.ABILITY_RLF_MOVEMENT_SPEED_INCREASE_ISPI'
---@field ABILITY_RLF_MOVEMENT_SPEED_INCREASE_ISPI	abilityreallevelfield	_ConvertAbilityRealLevelField('Ispi')
---
---ABILITY_RLF_DAMAGE_PER_SECOND_IDPS 'common.ABILITY_RLF_DAMAGE_PER_SECOND_IDPS'
---@field ABILITY_RLF_DAMAGE_PER_SECOND_IDPS	abilityreallevelfield	_ConvertAbilityRealLevelField('Idps')
---
---ABILITY_RLF_ATTACK_DAMAGE_INCREASE_CAC1 'common.ABILITY_RLF_ATTACK_DAMAGE_INCREASE_CAC1'
---@field ABILITY_RLF_ATTACK_DAMAGE_INCREASE_CAC1	abilityreallevelfield	_ConvertAbilityRealLevelField('Cac1')
---
---ABILITY_RLF_DAMAGE_PER_SECOND_COR1 'common.ABILITY_RLF_DAMAGE_PER_SECOND_COR1'
---@field ABILITY_RLF_DAMAGE_PER_SECOND_COR1	abilityreallevelfield	_ConvertAbilityRealLevelField('Cor1')
---
---ABILITY_RLF_ATTACK_SPEED_INCREASE_ISX1 'common.ABILITY_RLF_ATTACK_SPEED_INCREASE_ISX1'
---@field ABILITY_RLF_ATTACK_SPEED_INCREASE_ISX1	abilityreallevelfield	_ConvertAbilityRealLevelField('Isx1')
---
---ABILITY_RLF_DAMAGE_WRS1 'common.ABILITY_RLF_DAMAGE_WRS1'
---@field ABILITY_RLF_DAMAGE_WRS1	abilityreallevelfield	_ConvertAbilityRealLevelField('Wrs1')
---
---ABILITY_RLF_TERRAIN_DEFORMATION_AMPLITUDE 'common.ABILITY_RLF_TERRAIN_DEFORMATION_AMPLITUDE'
---@field ABILITY_RLF_TERRAIN_DEFORMATION_AMPLITUDE	abilityreallevelfield	_ConvertAbilityRealLevelField('Wrs2')
---
---ABILITY_RLF_DAMAGE_CTC1 'common.ABILITY_RLF_DAMAGE_CTC1'
---@field ABILITY_RLF_DAMAGE_CTC1	abilityreallevelfield	_ConvertAbilityRealLevelField('Ctc1')
---
---ABILITY_RLF_EXTRA_DAMAGE_TO_TARGET 'common.ABILITY_RLF_EXTRA_DAMAGE_TO_TARGET'
---@field ABILITY_RLF_EXTRA_DAMAGE_TO_TARGET	abilityreallevelfield	_ConvertAbilityRealLevelField('Ctc2')
---
---ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_CTC3 'common.ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_CTC3'
---@field ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_CTC3	abilityreallevelfield	_ConvertAbilityRealLevelField('Ctc3')
---
---ABILITY_RLF_ATTACK_SPEED_REDUCTION_CTC4 'common.ABILITY_RLF_ATTACK_SPEED_REDUCTION_CTC4'
---@field ABILITY_RLF_ATTACK_SPEED_REDUCTION_CTC4	abilityreallevelfield	_ConvertAbilityRealLevelField('Ctc4')
---
---ABILITY_RLF_DAMAGE_CTB1 'common.ABILITY_RLF_DAMAGE_CTB1'
---@field ABILITY_RLF_DAMAGE_CTB1	abilityreallevelfield	_ConvertAbilityRealLevelField('Ctb1')
---
---ABILITY_RLF_CASTING_DELAY_SECONDS 'common.ABILITY_RLF_CASTING_DELAY_SECONDS'
---@field ABILITY_RLF_CASTING_DELAY_SECONDS	abilityreallevelfield	_ConvertAbilityRealLevelField('Uds2')
---
---ABILITY_RLF_MANA_LOSS_PER_UNIT_DTN1 'common.ABILITY_RLF_MANA_LOSS_PER_UNIT_DTN1'
---@field ABILITY_RLF_MANA_LOSS_PER_UNIT_DTN1	abilityreallevelfield	_ConvertAbilityRealLevelField('Dtn1')
---
---ABILITY_RLF_DAMAGE_TO_SUMMONED_UNITS_DTN2 'common.ABILITY_RLF_DAMAGE_TO_SUMMONED_UNITS_DTN2'
---@field ABILITY_RLF_DAMAGE_TO_SUMMONED_UNITS_DTN2	abilityreallevelfield	_ConvertAbilityRealLevelField('Dtn2')
---
---ABILITY_RLF_TRANSITION_TIME_SECONDS 'common.ABILITY_RLF_TRANSITION_TIME_SECONDS'
---@field ABILITY_RLF_TRANSITION_TIME_SECONDS	abilityreallevelfield	_ConvertAbilityRealLevelField('Ivs1')
---
---ABILITY_RLF_MANA_DRAINED_PER_SECOND_NMR1 'common.ABILITY_RLF_MANA_DRAINED_PER_SECOND_NMR1'
---@field ABILITY_RLF_MANA_DRAINED_PER_SECOND_NMR1	abilityreallevelfield	_ConvertAbilityRealLevelField('Nmr1')
---
---ABILITY_RLF_CHANCE_TO_REDUCE_DAMAGE_PERCENT 'common.ABILITY_RLF_CHANCE_TO_REDUCE_DAMAGE_PERCENT'
---@field ABILITY_RLF_CHANCE_TO_REDUCE_DAMAGE_PERCENT	abilityreallevelfield	_ConvertAbilityRealLevelField('Ssk1')
---
---ABILITY_RLF_MINIMUM_DAMAGE 'common.ABILITY_RLF_MINIMUM_DAMAGE'
---@field ABILITY_RLF_MINIMUM_DAMAGE	abilityreallevelfield	_ConvertAbilityRealLevelField('Ssk2')
---
---ABILITY_RLF_IGNORED_DAMAGE 'common.ABILITY_RLF_IGNORED_DAMAGE'
---@field ABILITY_RLF_IGNORED_DAMAGE	abilityreallevelfield	_ConvertAbilityRealLevelField('Ssk3')
---
---ABILITY_RLF_FULL_DAMAGE_DEALT 'common.ABILITY_RLF_FULL_DAMAGE_DEALT'
---@field ABILITY_RLF_FULL_DAMAGE_DEALT	abilityreallevelfield	_ConvertAbilityRealLevelField('Hfs1')
---
---ABILITY_RLF_FULL_DAMAGE_INTERVAL 'common.ABILITY_RLF_FULL_DAMAGE_INTERVAL'
---@field ABILITY_RLF_FULL_DAMAGE_INTERVAL	abilityreallevelfield	_ConvertAbilityRealLevelField('Hfs2')
---
---ABILITY_RLF_HALF_DAMAGE_DEALT 'common.ABILITY_RLF_HALF_DAMAGE_DEALT'
---@field ABILITY_RLF_HALF_DAMAGE_DEALT	abilityreallevelfield	_ConvertAbilityRealLevelField('Hfs3')
---
---ABILITY_RLF_HALF_DAMAGE_INTERVAL 'common.ABILITY_RLF_HALF_DAMAGE_INTERVAL'
---@field ABILITY_RLF_HALF_DAMAGE_INTERVAL	abilityreallevelfield	_ConvertAbilityRealLevelField('Hfs4')
---
---ABILITY_RLF_BUILDING_REDUCTION_HFS5 'common.ABILITY_RLF_BUILDING_REDUCTION_HFS5'
---@field ABILITY_RLF_BUILDING_REDUCTION_HFS5	abilityreallevelfield	_ConvertAbilityRealLevelField('Hfs5')
---
---ABILITY_RLF_MAXIMUM_DAMAGE_HFS6 'common.ABILITY_RLF_MAXIMUM_DAMAGE_HFS6'
---@field ABILITY_RLF_MAXIMUM_DAMAGE_HFS6	abilityreallevelfield	_ConvertAbilityRealLevelField('Hfs6')
---
---ABILITY_RLF_MANA_PER_HIT_POINT 'common.ABILITY_RLF_MANA_PER_HIT_POINT'
---@field ABILITY_RLF_MANA_PER_HIT_POINT	abilityreallevelfield	_ConvertAbilityRealLevelField('Nms1')
---
---ABILITY_RLF_DAMAGE_ABSORBED_PERCENT 'common.ABILITY_RLF_DAMAGE_ABSORBED_PERCENT'
---@field ABILITY_RLF_DAMAGE_ABSORBED_PERCENT	abilityreallevelfield	_ConvertAbilityRealLevelField('Nms2')
---
---ABILITY_RLF_WAVE_DISTANCE 'common.ABILITY_RLF_WAVE_DISTANCE'
---@field ABILITY_RLF_WAVE_DISTANCE	abilityreallevelfield	_ConvertAbilityRealLevelField('Uim1')
---
---ABILITY_RLF_WAVE_TIME_SECONDS 'common.ABILITY_RLF_WAVE_TIME_SECONDS'
---@field ABILITY_RLF_WAVE_TIME_SECONDS	abilityreallevelfield	_ConvertAbilityRealLevelField('Uim2')
---
---ABILITY_RLF_DAMAGE_DEALT_UIM3 'common.ABILITY_RLF_DAMAGE_DEALT_UIM3'
---@field ABILITY_RLF_DAMAGE_DEALT_UIM3	abilityreallevelfield	_ConvertAbilityRealLevelField('Uim3')
---
---ABILITY_RLF_AIR_TIME_SECONDS_UIM4 'common.ABILITY_RLF_AIR_TIME_SECONDS_UIM4'
---@field ABILITY_RLF_AIR_TIME_SECONDS_UIM4	abilityreallevelfield	_ConvertAbilityRealLevelField('Uim4')
---
---ABILITY_RLF_UNIT_RELEASE_INTERVAL_SECONDS 'common.ABILITY_RLF_UNIT_RELEASE_INTERVAL_SECONDS'
---@field ABILITY_RLF_UNIT_RELEASE_INTERVAL_SECONDS	abilityreallevelfield	_ConvertAbilityRealLevelField('Uls2')
---
---ABILITY_RLF_DAMAGE_RETURN_FACTOR 'common.ABILITY_RLF_DAMAGE_RETURN_FACTOR'
---@field ABILITY_RLF_DAMAGE_RETURN_FACTOR	abilityreallevelfield	_ConvertAbilityRealLevelField('Uls4')
---
---ABILITY_RLF_DAMAGE_RETURN_THRESHOLD 'common.ABILITY_RLF_DAMAGE_RETURN_THRESHOLD'
---@field ABILITY_RLF_DAMAGE_RETURN_THRESHOLD	abilityreallevelfield	_ConvertAbilityRealLevelField('Uls5')
---
---ABILITY_RLF_RETURNED_DAMAGE_FACTOR 'common.ABILITY_RLF_RETURNED_DAMAGE_FACTOR'
---@field ABILITY_RLF_RETURNED_DAMAGE_FACTOR	abilityreallevelfield	_ConvertAbilityRealLevelField('Uts1')
---
---ABILITY_RLF_RECEIVED_DAMAGE_FACTOR 'common.ABILITY_RLF_RECEIVED_DAMAGE_FACTOR'
---@field ABILITY_RLF_RECEIVED_DAMAGE_FACTOR	abilityreallevelfield	_ConvertAbilityRealLevelField('Uts2')
---
---ABILITY_RLF_DEFENSE_BONUS_UTS3 'common.ABILITY_RLF_DEFENSE_BONUS_UTS3'
---@field ABILITY_RLF_DEFENSE_BONUS_UTS3	abilityreallevelfield	_ConvertAbilityRealLevelField('Uts3')
---
---ABILITY_RLF_DAMAGE_BONUS_NBA1 'common.ABILITY_RLF_DAMAGE_BONUS_NBA1'
---@field ABILITY_RLF_DAMAGE_BONUS_NBA1	abilityreallevelfield	_ConvertAbilityRealLevelField('Nba1')
---
---ABILITY_RLF_SUMMONED_UNIT_DURATION_SECONDS_NBA3 'common.ABILITY_RLF_SUMMONED_UNIT_DURATION_SECONDS_NBA3'
---@field ABILITY_RLF_SUMMONED_UNIT_DURATION_SECONDS_NBA3	abilityreallevelfield	_ConvertAbilityRealLevelField('Nba3')
---
---ABILITY_RLF_MANA_PER_SUMMONED_HITPOINT 'common.ABILITY_RLF_MANA_PER_SUMMONED_HITPOINT'
---@field ABILITY_RLF_MANA_PER_SUMMONED_HITPOINT	abilityreallevelfield	_ConvertAbilityRealLevelField('Cmg2')
---
---ABILITY_RLF_CHARGE_FOR_CURRENT_LIFE 'common.ABILITY_RLF_CHARGE_FOR_CURRENT_LIFE'
---@field ABILITY_RLF_CHARGE_FOR_CURRENT_LIFE	abilityreallevelfield	_ConvertAbilityRealLevelField('Cmg3')
---
---ABILITY_RLF_HIT_POINTS_DRAINED 'common.ABILITY_RLF_HIT_POINTS_DRAINED'
---@field ABILITY_RLF_HIT_POINTS_DRAINED	abilityreallevelfield	_ConvertAbilityRealLevelField('Ndr1')
---
---ABILITY_RLF_MANA_POINTS_DRAINED 'common.ABILITY_RLF_MANA_POINTS_DRAINED'
---@field ABILITY_RLF_MANA_POINTS_DRAINED	abilityreallevelfield	_ConvertAbilityRealLevelField('Ndr2')
---
---ABILITY_RLF_DRAIN_INTERVAL_SECONDS 'common.ABILITY_RLF_DRAIN_INTERVAL_SECONDS'
---@field ABILITY_RLF_DRAIN_INTERVAL_SECONDS	abilityreallevelfield	_ConvertAbilityRealLevelField('Ndr3')
---
---ABILITY_RLF_LIFE_TRANSFERRED_PER_SECOND 'common.ABILITY_RLF_LIFE_TRANSFERRED_PER_SECOND'
---@field ABILITY_RLF_LIFE_TRANSFERRED_PER_SECOND	abilityreallevelfield	_ConvertAbilityRealLevelField('Ndr4')
---
---ABILITY_RLF_MANA_TRANSFERRED_PER_SECOND 'common.ABILITY_RLF_MANA_TRANSFERRED_PER_SECOND'
---@field ABILITY_RLF_MANA_TRANSFERRED_PER_SECOND	abilityreallevelfield	_ConvertAbilityRealLevelField('Ndr5')
---
---ABILITY_RLF_BONUS_LIFE_FACTOR 'common.ABILITY_RLF_BONUS_LIFE_FACTOR'
---@field ABILITY_RLF_BONUS_LIFE_FACTOR	abilityreallevelfield	_ConvertAbilityRealLevelField('Ndr6')
---
---ABILITY_RLF_BONUS_LIFE_DECAY 'common.ABILITY_RLF_BONUS_LIFE_DECAY'
---@field ABILITY_RLF_BONUS_LIFE_DECAY	abilityreallevelfield	_ConvertAbilityRealLevelField('Ndr7')
---
---ABILITY_RLF_BONUS_MANA_FACTOR 'common.ABILITY_RLF_BONUS_MANA_FACTOR'
---@field ABILITY_RLF_BONUS_MANA_FACTOR	abilityreallevelfield	_ConvertAbilityRealLevelField('Ndr8')
---
---ABILITY_RLF_BONUS_MANA_DECAY 'common.ABILITY_RLF_BONUS_MANA_DECAY'
---@field ABILITY_RLF_BONUS_MANA_DECAY	abilityreallevelfield	_ConvertAbilityRealLevelField('Ndr9')
---
---ABILITY_RLF_CHANCE_TO_MISS_PERCENT 'common.ABILITY_RLF_CHANCE_TO_MISS_PERCENT'
---@field ABILITY_RLF_CHANCE_TO_MISS_PERCENT	abilityreallevelfield	_ConvertAbilityRealLevelField('Nsi2')
---
---ABILITY_RLF_MOVEMENT_SPEED_MODIFIER 'common.ABILITY_RLF_MOVEMENT_SPEED_MODIFIER'
---@field ABILITY_RLF_MOVEMENT_SPEED_MODIFIER	abilityreallevelfield	_ConvertAbilityRealLevelField('Nsi3')
---
---ABILITY_RLF_ATTACK_SPEED_MODIFIER 'common.ABILITY_RLF_ATTACK_SPEED_MODIFIER'
---@field ABILITY_RLF_ATTACK_SPEED_MODIFIER	abilityreallevelfield	_ConvertAbilityRealLevelField('Nsi4')
---
---ABILITY_RLF_DAMAGE_PER_SECOND_TDG1 'common.ABILITY_RLF_DAMAGE_PER_SECOND_TDG1'
---@field ABILITY_RLF_DAMAGE_PER_SECOND_TDG1	abilityreallevelfield	_ConvertAbilityRealLevelField('Tdg1')
---
---ABILITY_RLF_MEDIUM_DAMAGE_RADIUS_TDG2 'common.ABILITY_RLF_MEDIUM_DAMAGE_RADIUS_TDG2'
---@field ABILITY_RLF_MEDIUM_DAMAGE_RADIUS_TDG2	abilityreallevelfield	_ConvertAbilityRealLevelField('Tdg2')
---
---ABILITY_RLF_MEDIUM_DAMAGE_PER_SECOND 'common.ABILITY_RLF_MEDIUM_DAMAGE_PER_SECOND'
---@field ABILITY_RLF_MEDIUM_DAMAGE_PER_SECOND	abilityreallevelfield	_ConvertAbilityRealLevelField('Tdg3')
---
---ABILITY_RLF_SMALL_DAMAGE_RADIUS_TDG4 'common.ABILITY_RLF_SMALL_DAMAGE_RADIUS_TDG4'
---@field ABILITY_RLF_SMALL_DAMAGE_RADIUS_TDG4	abilityreallevelfield	_ConvertAbilityRealLevelField('Tdg4')
---
---ABILITY_RLF_SMALL_DAMAGE_PER_SECOND 'common.ABILITY_RLF_SMALL_DAMAGE_PER_SECOND'
---@field ABILITY_RLF_SMALL_DAMAGE_PER_SECOND	abilityreallevelfield	_ConvertAbilityRealLevelField('Tdg5')
---
---ABILITY_RLF_AIR_TIME_SECONDS_TSP1 'common.ABILITY_RLF_AIR_TIME_SECONDS_TSP1'
---@field ABILITY_RLF_AIR_TIME_SECONDS_TSP1	abilityreallevelfield	_ConvertAbilityRealLevelField('Tsp1')
---
---ABILITY_RLF_MINIMUM_HIT_INTERVAL_SECONDS 'common.ABILITY_RLF_MINIMUM_HIT_INTERVAL_SECONDS'
---@field ABILITY_RLF_MINIMUM_HIT_INTERVAL_SECONDS	abilityreallevelfield	_ConvertAbilityRealLevelField('Tsp2')
---
---ABILITY_RLF_DAMAGE_PER_SECOND_NBF5 'common.ABILITY_RLF_DAMAGE_PER_SECOND_NBF5'
---@field ABILITY_RLF_DAMAGE_PER_SECOND_NBF5	abilityreallevelfield	_ConvertAbilityRealLevelField('Nbf5')
---
---ABILITY_RLF_MAXIMUM_RANGE 'common.ABILITY_RLF_MAXIMUM_RANGE'
---@field ABILITY_RLF_MAXIMUM_RANGE	abilityreallevelfield	_ConvertAbilityRealLevelField('Ebl1')
---
---ABILITY_RLF_MINIMUM_RANGE 'common.ABILITY_RLF_MINIMUM_RANGE'
---@field ABILITY_RLF_MINIMUM_RANGE	abilityreallevelfield	_ConvertAbilityRealLevelField('Ebl2')
---
---ABILITY_RLF_DAMAGE_PER_TARGET_EFK1 'common.ABILITY_RLF_DAMAGE_PER_TARGET_EFK1'
---@field ABILITY_RLF_DAMAGE_PER_TARGET_EFK1	abilityreallevelfield	_ConvertAbilityRealLevelField('Efk1')
---
---ABILITY_RLF_MAXIMUM_TOTAL_DAMAGE 'common.ABILITY_RLF_MAXIMUM_TOTAL_DAMAGE'
---@field ABILITY_RLF_MAXIMUM_TOTAL_DAMAGE	abilityreallevelfield	_ConvertAbilityRealLevelField('Efk2')
---
---ABILITY_RLF_MAXIMUM_SPEED_ADJUSTMENT 'common.ABILITY_RLF_MAXIMUM_SPEED_ADJUSTMENT'
---@field ABILITY_RLF_MAXIMUM_SPEED_ADJUSTMENT	abilityreallevelfield	_ConvertAbilityRealLevelField('Efk4')
---
---ABILITY_RLF_DECAYING_DAMAGE 'common.ABILITY_RLF_DECAYING_DAMAGE'
---@field ABILITY_RLF_DECAYING_DAMAGE	abilityreallevelfield	_ConvertAbilityRealLevelField('Esh1')
---
---ABILITY_RLF_MOVEMENT_SPEED_FACTOR_ESH2 'common.ABILITY_RLF_MOVEMENT_SPEED_FACTOR_ESH2'
---@field ABILITY_RLF_MOVEMENT_SPEED_FACTOR_ESH2	abilityreallevelfield	_ConvertAbilityRealLevelField('Esh2')
---
---ABILITY_RLF_ATTACK_SPEED_FACTOR_ESH3 'common.ABILITY_RLF_ATTACK_SPEED_FACTOR_ESH3'
---@field ABILITY_RLF_ATTACK_SPEED_FACTOR_ESH3	abilityreallevelfield	_ConvertAbilityRealLevelField('Esh3')
---
---ABILITY_RLF_DECAY_POWER 'common.ABILITY_RLF_DECAY_POWER'
---@field ABILITY_RLF_DECAY_POWER	abilityreallevelfield	_ConvertAbilityRealLevelField('Esh4')
---
---ABILITY_RLF_INITIAL_DAMAGE_ESH5 'common.ABILITY_RLF_INITIAL_DAMAGE_ESH5'
---@field ABILITY_RLF_INITIAL_DAMAGE_ESH5	abilityreallevelfield	_ConvertAbilityRealLevelField('Esh5')
---
---ABILITY_RLF_MAXIMUM_LIFE_ABSORBED 'common.ABILITY_RLF_MAXIMUM_LIFE_ABSORBED'
---@field ABILITY_RLF_MAXIMUM_LIFE_ABSORBED	abilityreallevelfield	_ConvertAbilityRealLevelField('abs1')
---
---ABILITY_RLF_MAXIMUM_MANA_ABSORBED 'common.ABILITY_RLF_MAXIMUM_MANA_ABSORBED'
---@field ABILITY_RLF_MAXIMUM_MANA_ABSORBED	abilityreallevelfield	_ConvertAbilityRealLevelField('abs2')
---
---ABILITY_RLF_MOVEMENT_SPEED_INCREASE_BSK1 'common.ABILITY_RLF_MOVEMENT_SPEED_INCREASE_BSK1'
---@field ABILITY_RLF_MOVEMENT_SPEED_INCREASE_BSK1	abilityreallevelfield	_ConvertAbilityRealLevelField('bsk1')
---
---ABILITY_RLF_ATTACK_SPEED_INCREASE_BSK2 'common.ABILITY_RLF_ATTACK_SPEED_INCREASE_BSK2'
---@field ABILITY_RLF_ATTACK_SPEED_INCREASE_BSK2	abilityreallevelfield	_ConvertAbilityRealLevelField('bsk2')
---
---ABILITY_RLF_DAMAGE_TAKEN_INCREASE 'common.ABILITY_RLF_DAMAGE_TAKEN_INCREASE'
---@field ABILITY_RLF_DAMAGE_TAKEN_INCREASE	abilityreallevelfield	_ConvertAbilityRealLevelField('bsk3')
---
---ABILITY_RLF_LIFE_PER_UNIT 'common.ABILITY_RLF_LIFE_PER_UNIT'
---@field ABILITY_RLF_LIFE_PER_UNIT	abilityreallevelfield	_ConvertAbilityRealLevelField('dvm1')
---
---ABILITY_RLF_MANA_PER_UNIT 'common.ABILITY_RLF_MANA_PER_UNIT'
---@field ABILITY_RLF_MANA_PER_UNIT	abilityreallevelfield	_ConvertAbilityRealLevelField('dvm2')
---
---ABILITY_RLF_LIFE_PER_BUFF 'common.ABILITY_RLF_LIFE_PER_BUFF'
---@field ABILITY_RLF_LIFE_PER_BUFF	abilityreallevelfield	_ConvertAbilityRealLevelField('dvm3')
---
---ABILITY_RLF_MANA_PER_BUFF 'common.ABILITY_RLF_MANA_PER_BUFF'
---@field ABILITY_RLF_MANA_PER_BUFF	abilityreallevelfield	_ConvertAbilityRealLevelField('dvm4')
---
---ABILITY_RLF_SUMMONED_UNIT_DAMAGE_DVM5 'common.ABILITY_RLF_SUMMONED_UNIT_DAMAGE_DVM5'
---@field ABILITY_RLF_SUMMONED_UNIT_DAMAGE_DVM5	abilityreallevelfield	_ConvertAbilityRealLevelField('dvm5')
---
---ABILITY_RLF_DAMAGE_BONUS_FAK1 'common.ABILITY_RLF_DAMAGE_BONUS_FAK1'
---@field ABILITY_RLF_DAMAGE_BONUS_FAK1	abilityreallevelfield	_ConvertAbilityRealLevelField('fak1')
---
---ABILITY_RLF_MEDIUM_DAMAGE_FACTOR_FAK2 'common.ABILITY_RLF_MEDIUM_DAMAGE_FACTOR_FAK2'
---@field ABILITY_RLF_MEDIUM_DAMAGE_FACTOR_FAK2	abilityreallevelfield	_ConvertAbilityRealLevelField('fak2')
---
---ABILITY_RLF_SMALL_DAMAGE_FACTOR_FAK3 'common.ABILITY_RLF_SMALL_DAMAGE_FACTOR_FAK3'
---@field ABILITY_RLF_SMALL_DAMAGE_FACTOR_FAK3	abilityreallevelfield	_ConvertAbilityRealLevelField('fak3')
---
---ABILITY_RLF_FULL_DAMAGE_RADIUS_FAK4 'common.ABILITY_RLF_FULL_DAMAGE_RADIUS_FAK4'
---@field ABILITY_RLF_FULL_DAMAGE_RADIUS_FAK4	abilityreallevelfield	_ConvertAbilityRealLevelField('fak4')
---
---ABILITY_RLF_HALF_DAMAGE_RADIUS_FAK5 'common.ABILITY_RLF_HALF_DAMAGE_RADIUS_FAK5'
---@field ABILITY_RLF_HALF_DAMAGE_RADIUS_FAK5	abilityreallevelfield	_ConvertAbilityRealLevelField('fak5')
---
---ABILITY_RLF_EXTRA_DAMAGE_PER_SECOND 'common.ABILITY_RLF_EXTRA_DAMAGE_PER_SECOND'
---@field ABILITY_RLF_EXTRA_DAMAGE_PER_SECOND	abilityreallevelfield	_ConvertAbilityRealLevelField('liq1')
---
---ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_LIQ2 'common.ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_LIQ2'
---@field ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_LIQ2	abilityreallevelfield	_ConvertAbilityRealLevelField('liq2')
---
---ABILITY_RLF_ATTACK_SPEED_REDUCTION_LIQ3 'common.ABILITY_RLF_ATTACK_SPEED_REDUCTION_LIQ3'
---@field ABILITY_RLF_ATTACK_SPEED_REDUCTION_LIQ3	abilityreallevelfield	_ConvertAbilityRealLevelField('liq3')
---
---ABILITY_RLF_MAGIC_DAMAGE_FACTOR 'common.ABILITY_RLF_MAGIC_DAMAGE_FACTOR'
---@field ABILITY_RLF_MAGIC_DAMAGE_FACTOR	abilityreallevelfield	_ConvertAbilityRealLevelField('mim1')
---
---ABILITY_RLF_UNIT_DAMAGE_PER_MANA_POINT 'common.ABILITY_RLF_UNIT_DAMAGE_PER_MANA_POINT'
---@field ABILITY_RLF_UNIT_DAMAGE_PER_MANA_POINT	abilityreallevelfield	_ConvertAbilityRealLevelField('mfl1')
---
---ABILITY_RLF_HERO_DAMAGE_PER_MANA_POINT 'common.ABILITY_RLF_HERO_DAMAGE_PER_MANA_POINT'
---@field ABILITY_RLF_HERO_DAMAGE_PER_MANA_POINT	abilityreallevelfield	_ConvertAbilityRealLevelField('mfl2')
---
---ABILITY_RLF_UNIT_MAXIMUM_DAMAGE 'common.ABILITY_RLF_UNIT_MAXIMUM_DAMAGE'
---@field ABILITY_RLF_UNIT_MAXIMUM_DAMAGE	abilityreallevelfield	_ConvertAbilityRealLevelField('mfl3')
---
---ABILITY_RLF_HERO_MAXIMUM_DAMAGE 'common.ABILITY_RLF_HERO_MAXIMUM_DAMAGE'
---@field ABILITY_RLF_HERO_MAXIMUM_DAMAGE	abilityreallevelfield	_ConvertAbilityRealLevelField('mfl4')
---
---ABILITY_RLF_DAMAGE_COOLDOWN 'common.ABILITY_RLF_DAMAGE_COOLDOWN'
---@field ABILITY_RLF_DAMAGE_COOLDOWN	abilityreallevelfield	_ConvertAbilityRealLevelField('mfl5')
---
---ABILITY_RLF_DISTRIBUTED_DAMAGE_FACTOR_SPL1 'common.ABILITY_RLF_DISTRIBUTED_DAMAGE_FACTOR_SPL1'
---@field ABILITY_RLF_DISTRIBUTED_DAMAGE_FACTOR_SPL1	abilityreallevelfield	_ConvertAbilityRealLevelField('spl1')
---
---ABILITY_RLF_LIFE_REGENERATED 'common.ABILITY_RLF_LIFE_REGENERATED'
---@field ABILITY_RLF_LIFE_REGENERATED	abilityreallevelfield	_ConvertAbilityRealLevelField('irl1')
---
---ABILITY_RLF_MANA_REGENERATED 'common.ABILITY_RLF_MANA_REGENERATED'
---@field ABILITY_RLF_MANA_REGENERATED	abilityreallevelfield	_ConvertAbilityRealLevelField('irl2')
---
---ABILITY_RLF_MANA_LOSS_PER_UNIT_IDC1 'common.ABILITY_RLF_MANA_LOSS_PER_UNIT_IDC1'
---@field ABILITY_RLF_MANA_LOSS_PER_UNIT_IDC1	abilityreallevelfield	_ConvertAbilityRealLevelField('idc1')
---
---ABILITY_RLF_SUMMONED_UNIT_DAMAGE_IDC2 'common.ABILITY_RLF_SUMMONED_UNIT_DAMAGE_IDC2'
---@field ABILITY_RLF_SUMMONED_UNIT_DAMAGE_IDC2	abilityreallevelfield	_ConvertAbilityRealLevelField('idc2')
---
---ABILITY_RLF_ACTIVATION_DELAY_IMO2 'common.ABILITY_RLF_ACTIVATION_DELAY_IMO2'
---@field ABILITY_RLF_ACTIVATION_DELAY_IMO2	abilityreallevelfield	_ConvertAbilityRealLevelField('imo2')
---
---ABILITY_RLF_LURE_INTERVAL_SECONDS 'common.ABILITY_RLF_LURE_INTERVAL_SECONDS'
---@field ABILITY_RLF_LURE_INTERVAL_SECONDS	abilityreallevelfield	_ConvertAbilityRealLevelField('imo3')
---
---ABILITY_RLF_DAMAGE_BONUS_ISR1 'common.ABILITY_RLF_DAMAGE_BONUS_ISR1'
---@field ABILITY_RLF_DAMAGE_BONUS_ISR1	abilityreallevelfield	_ConvertAbilityRealLevelField('isr1')
---
---ABILITY_RLF_DAMAGE_REDUCTION_ISR2 'common.ABILITY_RLF_DAMAGE_REDUCTION_ISR2'
---@field ABILITY_RLF_DAMAGE_REDUCTION_ISR2	abilityreallevelfield	_ConvertAbilityRealLevelField('isr2')
---
---ABILITY_RLF_DAMAGE_BONUS_IPV1 'common.ABILITY_RLF_DAMAGE_BONUS_IPV1'
---@field ABILITY_RLF_DAMAGE_BONUS_IPV1	abilityreallevelfield	_ConvertAbilityRealLevelField('ipv1')
---
---ABILITY_RLF_LIFE_STEAL_AMOUNT 'common.ABILITY_RLF_LIFE_STEAL_AMOUNT'
---@field ABILITY_RLF_LIFE_STEAL_AMOUNT	abilityreallevelfield	_ConvertAbilityRealLevelField('ipv2')
---
---ABILITY_RLF_LIFE_RESTORED_FACTOR 'common.ABILITY_RLF_LIFE_RESTORED_FACTOR'
---@field ABILITY_RLF_LIFE_RESTORED_FACTOR	abilityreallevelfield	_ConvertAbilityRealLevelField('ast1')
---
---ABILITY_RLF_MANA_RESTORED_FACTOR 'common.ABILITY_RLF_MANA_RESTORED_FACTOR'
---@field ABILITY_RLF_MANA_RESTORED_FACTOR	abilityreallevelfield	_ConvertAbilityRealLevelField('ast2')
---
---ABILITY_RLF_ATTACH_DELAY 'common.ABILITY_RLF_ATTACH_DELAY'
---@field ABILITY_RLF_ATTACH_DELAY	abilityreallevelfield	_ConvertAbilityRealLevelField('gra1')
---
---ABILITY_RLF_REMOVE_DELAY 'common.ABILITY_RLF_REMOVE_DELAY'
---@field ABILITY_RLF_REMOVE_DELAY	abilityreallevelfield	_ConvertAbilityRealLevelField('gra2')
---
---ABILITY_RLF_HERO_REGENERATION_DELAY 'common.ABILITY_RLF_HERO_REGENERATION_DELAY'
---@field ABILITY_RLF_HERO_REGENERATION_DELAY	abilityreallevelfield	_ConvertAbilityRealLevelField('Nsa2')
---
---ABILITY_RLF_UNIT_REGENERATION_DELAY 'common.ABILITY_RLF_UNIT_REGENERATION_DELAY'
---@field ABILITY_RLF_UNIT_REGENERATION_DELAY	abilityreallevelfield	_ConvertAbilityRealLevelField('Nsa3')
---
---ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_NSA4 'common.ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_NSA4'
---@field ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_NSA4	abilityreallevelfield	_ConvertAbilityRealLevelField('Nsa4')
---
---ABILITY_RLF_HIT_POINTS_PER_SECOND_NSA5 'common.ABILITY_RLF_HIT_POINTS_PER_SECOND_NSA5'
---@field ABILITY_RLF_HIT_POINTS_PER_SECOND_NSA5	abilityreallevelfield	_ConvertAbilityRealLevelField('Nsa5')
---
---ABILITY_RLF_DAMAGE_TO_SUMMONED_UNITS_IXS1 'common.ABILITY_RLF_DAMAGE_TO_SUMMONED_UNITS_IXS1'
---@field ABILITY_RLF_DAMAGE_TO_SUMMONED_UNITS_IXS1	abilityreallevelfield	_ConvertAbilityRealLevelField('Ixs1')
---
---ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_IXS2 'common.ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_IXS2'
---@field ABILITY_RLF_MAGIC_DAMAGE_REDUCTION_IXS2	abilityreallevelfield	_ConvertAbilityRealLevelField('Ixs2')
---
---ABILITY_RLF_SUMMONED_UNIT_DURATION 'common.ABILITY_RLF_SUMMONED_UNIT_DURATION'
---@field ABILITY_RLF_SUMMONED_UNIT_DURATION	abilityreallevelfield	_ConvertAbilityRealLevelField('Npa6')
---
---ABILITY_RLF_SHIELD_COOLDOWN_TIME 'common.ABILITY_RLF_SHIELD_COOLDOWN_TIME'
---@field ABILITY_RLF_SHIELD_COOLDOWN_TIME	abilityreallevelfield	_ConvertAbilityRealLevelField('Nse1')
---
---ABILITY_RLF_DAMAGE_PER_SECOND_NDO1 'common.ABILITY_RLF_DAMAGE_PER_SECOND_NDO1'
---@field ABILITY_RLF_DAMAGE_PER_SECOND_NDO1	abilityreallevelfield	_ConvertAbilityRealLevelField('Ndo1')
---
---ABILITY_RLF_SUMMONED_UNIT_DURATION_SECONDS_NDO3 'common.ABILITY_RLF_SUMMONED_UNIT_DURATION_SECONDS_NDO3'
---@field ABILITY_RLF_SUMMONED_UNIT_DURATION_SECONDS_NDO3	abilityreallevelfield	_ConvertAbilityRealLevelField('Ndo3')
---
---ABILITY_RLF_MEDIUM_DAMAGE_RADIUS_FLK1 'common.ABILITY_RLF_MEDIUM_DAMAGE_RADIUS_FLK1'
---@field ABILITY_RLF_MEDIUM_DAMAGE_RADIUS_FLK1	abilityreallevelfield	_ConvertAbilityRealLevelField('flk1')
---
---ABILITY_RLF_SMALL_DAMAGE_RADIUS_FLK2 'common.ABILITY_RLF_SMALL_DAMAGE_RADIUS_FLK2'
---@field ABILITY_RLF_SMALL_DAMAGE_RADIUS_FLK2	abilityreallevelfield	_ConvertAbilityRealLevelField('flk2')
---
---ABILITY_RLF_FULL_DAMAGE_AMOUNT_FLK3 'common.ABILITY_RLF_FULL_DAMAGE_AMOUNT_FLK3'
---@field ABILITY_RLF_FULL_DAMAGE_AMOUNT_FLK3	abilityreallevelfield	_ConvertAbilityRealLevelField('flk3')
---
---ABILITY_RLF_MEDIUM_DAMAGE_AMOUNT 'common.ABILITY_RLF_MEDIUM_DAMAGE_AMOUNT'
---@field ABILITY_RLF_MEDIUM_DAMAGE_AMOUNT	abilityreallevelfield	_ConvertAbilityRealLevelField('flk4')
---
---ABILITY_RLF_SMALL_DAMAGE_AMOUNT 'common.ABILITY_RLF_SMALL_DAMAGE_AMOUNT'
---@field ABILITY_RLF_SMALL_DAMAGE_AMOUNT	abilityreallevelfield	_ConvertAbilityRealLevelField('flk5')
---
---ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_HBN1 'common.ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_HBN1'
---@field ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_HBN1	abilityreallevelfield	_ConvertAbilityRealLevelField('Hbn1')
---
---ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_HBN2 'common.ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_HBN2'
---@field ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_HBN2	abilityreallevelfield	_ConvertAbilityRealLevelField('Hbn2')
---
---ABILITY_RLF_MAX_MANA_DRAINED_UNITS 'common.ABILITY_RLF_MAX_MANA_DRAINED_UNITS'
---@field ABILITY_RLF_MAX_MANA_DRAINED_UNITS	abilityreallevelfield	_ConvertAbilityRealLevelField('fbk1')
---
---ABILITY_RLF_DAMAGE_RATIO_UNITS_PERCENT 'common.ABILITY_RLF_DAMAGE_RATIO_UNITS_PERCENT'
---@field ABILITY_RLF_DAMAGE_RATIO_UNITS_PERCENT	abilityreallevelfield	_ConvertAbilityRealLevelField('fbk2')
---
---ABILITY_RLF_MAX_MANA_DRAINED_HEROS 'common.ABILITY_RLF_MAX_MANA_DRAINED_HEROS'
---@field ABILITY_RLF_MAX_MANA_DRAINED_HEROS	abilityreallevelfield	_ConvertAbilityRealLevelField('fbk3')
---
---ABILITY_RLF_DAMAGE_RATIO_HEROS_PERCENT 'common.ABILITY_RLF_DAMAGE_RATIO_HEROS_PERCENT'
---@field ABILITY_RLF_DAMAGE_RATIO_HEROS_PERCENT	abilityreallevelfield	_ConvertAbilityRealLevelField('fbk4')
---
---ABILITY_RLF_SUMMONED_DAMAGE 'common.ABILITY_RLF_SUMMONED_DAMAGE'
---@field ABILITY_RLF_SUMMONED_DAMAGE	abilityreallevelfield	_ConvertAbilityRealLevelField('fbk5')
---
---ABILITY_RLF_DISTRIBUTED_DAMAGE_FACTOR_NCA1 'common.ABILITY_RLF_DISTRIBUTED_DAMAGE_FACTOR_NCA1'
---@field ABILITY_RLF_DISTRIBUTED_DAMAGE_FACTOR_NCA1	abilityreallevelfield	_ConvertAbilityRealLevelField('nca1')
---
---ABILITY_RLF_INITIAL_DAMAGE_PXF1 'common.ABILITY_RLF_INITIAL_DAMAGE_PXF1'
---@field ABILITY_RLF_INITIAL_DAMAGE_PXF1	abilityreallevelfield	_ConvertAbilityRealLevelField('pxf1')
---
---ABILITY_RLF_DAMAGE_PER_SECOND_PXF2 'common.ABILITY_RLF_DAMAGE_PER_SECOND_PXF2'
---@field ABILITY_RLF_DAMAGE_PER_SECOND_PXF2	abilityreallevelfield	_ConvertAbilityRealLevelField('pxf2')
---
---ABILITY_RLF_DAMAGE_PER_SECOND_MLS1 'common.ABILITY_RLF_DAMAGE_PER_SECOND_MLS1'
---@field ABILITY_RLF_DAMAGE_PER_SECOND_MLS1	abilityreallevelfield	_ConvertAbilityRealLevelField('mls1')
---
---ABILITY_RLF_BEAST_COLLISION_RADIUS 'common.ABILITY_RLF_BEAST_COLLISION_RADIUS'
---@field ABILITY_RLF_BEAST_COLLISION_RADIUS	abilityreallevelfield	_ConvertAbilityRealLevelField('Nst2')
---
---ABILITY_RLF_DAMAGE_AMOUNT_NST3 'common.ABILITY_RLF_DAMAGE_AMOUNT_NST3'
---@field ABILITY_RLF_DAMAGE_AMOUNT_NST3	abilityreallevelfield	_ConvertAbilityRealLevelField('Nst3')
---
---ABILITY_RLF_DAMAGE_RADIUS 'common.ABILITY_RLF_DAMAGE_RADIUS'
---@field ABILITY_RLF_DAMAGE_RADIUS	abilityreallevelfield	_ConvertAbilityRealLevelField('Nst4')
---
---ABILITY_RLF_DAMAGE_DELAY 'common.ABILITY_RLF_DAMAGE_DELAY'
---@field ABILITY_RLF_DAMAGE_DELAY	abilityreallevelfield	_ConvertAbilityRealLevelField('Nst5')
---
---ABILITY_RLF_FOLLOW_THROUGH_TIME 'common.ABILITY_RLF_FOLLOW_THROUGH_TIME'
---@field ABILITY_RLF_FOLLOW_THROUGH_TIME	abilityreallevelfield	_ConvertAbilityRealLevelField('Ncl1')
---
---ABILITY_RLF_ART_DURATION 'common.ABILITY_RLF_ART_DURATION'
---@field ABILITY_RLF_ART_DURATION	abilityreallevelfield	_ConvertAbilityRealLevelField('Ncl4')
---
---ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_NAB1 'common.ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_NAB1'
---@field ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_NAB1	abilityreallevelfield	_ConvertAbilityRealLevelField('Nab1')
---
---ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_NAB2 'common.ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_NAB2'
---@field ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_NAB2	abilityreallevelfield	_ConvertAbilityRealLevelField('Nab2')
---
---ABILITY_RLF_PRIMARY_DAMAGE 'common.ABILITY_RLF_PRIMARY_DAMAGE'
---@field ABILITY_RLF_PRIMARY_DAMAGE	abilityreallevelfield	_ConvertAbilityRealLevelField('Nab4')
---
---ABILITY_RLF_SECONDARY_DAMAGE 'common.ABILITY_RLF_SECONDARY_DAMAGE'
---@field ABILITY_RLF_SECONDARY_DAMAGE	abilityreallevelfield	_ConvertAbilityRealLevelField('Nab5')
---
---ABILITY_RLF_DAMAGE_INTERVAL_NAB6 'common.ABILITY_RLF_DAMAGE_INTERVAL_NAB6'
---@field ABILITY_RLF_DAMAGE_INTERVAL_NAB6	abilityreallevelfield	_ConvertAbilityRealLevelField('Nab6')
---
---ABILITY_RLF_GOLD_COST_FACTOR 'common.ABILITY_RLF_GOLD_COST_FACTOR'
---@field ABILITY_RLF_GOLD_COST_FACTOR	abilityreallevelfield	_ConvertAbilityRealLevelField('Ntm1')
---
---ABILITY_RLF_LUMBER_COST_FACTOR 'common.ABILITY_RLF_LUMBER_COST_FACTOR'
---@field ABILITY_RLF_LUMBER_COST_FACTOR	abilityreallevelfield	_ConvertAbilityRealLevelField('Ntm2')
---
---ABILITY_RLF_MOVE_SPEED_BONUS_NEG1 'common.ABILITY_RLF_MOVE_SPEED_BONUS_NEG1'
---@field ABILITY_RLF_MOVE_SPEED_BONUS_NEG1	abilityreallevelfield	_ConvertAbilityRealLevelField('Neg1')
---
---ABILITY_RLF_DAMAGE_BONUS_NEG2 'common.ABILITY_RLF_DAMAGE_BONUS_NEG2'
---@field ABILITY_RLF_DAMAGE_BONUS_NEG2	abilityreallevelfield	_ConvertAbilityRealLevelField('Neg2')
---
---ABILITY_RLF_DAMAGE_AMOUNT_NCS1 'common.ABILITY_RLF_DAMAGE_AMOUNT_NCS1'
---@field ABILITY_RLF_DAMAGE_AMOUNT_NCS1	abilityreallevelfield	_ConvertAbilityRealLevelField('Ncs1')
---
---ABILITY_RLF_DAMAGE_INTERVAL_NCS2 'common.ABILITY_RLF_DAMAGE_INTERVAL_NCS2'
---@field ABILITY_RLF_DAMAGE_INTERVAL_NCS2	abilityreallevelfield	_ConvertAbilityRealLevelField('Ncs2')
---
---ABILITY_RLF_MAX_DAMAGE_NCS4 'common.ABILITY_RLF_MAX_DAMAGE_NCS4'
---@field ABILITY_RLF_MAX_DAMAGE_NCS4	abilityreallevelfield	_ConvertAbilityRealLevelField('Ncs4')
---
---ABILITY_RLF_BUILDING_DAMAGE_FACTOR_NCS5 'common.ABILITY_RLF_BUILDING_DAMAGE_FACTOR_NCS5'
---@field ABILITY_RLF_BUILDING_DAMAGE_FACTOR_NCS5	abilityreallevelfield	_ConvertAbilityRealLevelField('Ncs5')
---
---ABILITY_RLF_EFFECT_DURATION 'common.ABILITY_RLF_EFFECT_DURATION'
---@field ABILITY_RLF_EFFECT_DURATION	abilityreallevelfield	_ConvertAbilityRealLevelField('Ncs6')
---
---ABILITY_RLF_SPAWN_INTERVAL_NSY1 'common.ABILITY_RLF_SPAWN_INTERVAL_NSY1'
---@field ABILITY_RLF_SPAWN_INTERVAL_NSY1	abilityreallevelfield	_ConvertAbilityRealLevelField('Nsy1')
---
---ABILITY_RLF_SPAWN_UNIT_DURATION 'common.ABILITY_RLF_SPAWN_UNIT_DURATION'
---@field ABILITY_RLF_SPAWN_UNIT_DURATION	abilityreallevelfield	_ConvertAbilityRealLevelField('Nsy3')
---
---ABILITY_RLF_SPAWN_UNIT_OFFSET 'common.ABILITY_RLF_SPAWN_UNIT_OFFSET'
---@field ABILITY_RLF_SPAWN_UNIT_OFFSET	abilityreallevelfield	_ConvertAbilityRealLevelField('Nsy4')
---
---ABILITY_RLF_LEASH_RANGE_NSY5 'common.ABILITY_RLF_LEASH_RANGE_NSY5'
---@field ABILITY_RLF_LEASH_RANGE_NSY5	abilityreallevelfield	_ConvertAbilityRealLevelField('Nsy5')
---
---ABILITY_RLF_SPAWN_INTERVAL_NFY1 'common.ABILITY_RLF_SPAWN_INTERVAL_NFY1'
---@field ABILITY_RLF_SPAWN_INTERVAL_NFY1	abilityreallevelfield	_ConvertAbilityRealLevelField('Nfy1')
---
---ABILITY_RLF_LEASH_RANGE_NFY2 'common.ABILITY_RLF_LEASH_RANGE_NFY2'
---@field ABILITY_RLF_LEASH_RANGE_NFY2	abilityreallevelfield	_ConvertAbilityRealLevelField('Nfy2')
---
---ABILITY_RLF_CHANCE_TO_DEMOLISH 'common.ABILITY_RLF_CHANCE_TO_DEMOLISH'
---@field ABILITY_RLF_CHANCE_TO_DEMOLISH	abilityreallevelfield	_ConvertAbilityRealLevelField('Nde1')
---
---ABILITY_RLF_DAMAGE_MULTIPLIER_BUILDINGS 'common.ABILITY_RLF_DAMAGE_MULTIPLIER_BUILDINGS'
---@field ABILITY_RLF_DAMAGE_MULTIPLIER_BUILDINGS	abilityreallevelfield	_ConvertAbilityRealLevelField('Nde2')
---
---ABILITY_RLF_DAMAGE_MULTIPLIER_UNITS 'common.ABILITY_RLF_DAMAGE_MULTIPLIER_UNITS'
---@field ABILITY_RLF_DAMAGE_MULTIPLIER_UNITS	abilityreallevelfield	_ConvertAbilityRealLevelField('Nde3')
---
---ABILITY_RLF_DAMAGE_MULTIPLIER_HEROES 'common.ABILITY_RLF_DAMAGE_MULTIPLIER_HEROES'
---@field ABILITY_RLF_DAMAGE_MULTIPLIER_HEROES	abilityreallevelfield	_ConvertAbilityRealLevelField('Nde4')
---
---ABILITY_RLF_BONUS_DAMAGE_MULTIPLIER 'common.ABILITY_RLF_BONUS_DAMAGE_MULTIPLIER'
---@field ABILITY_RLF_BONUS_DAMAGE_MULTIPLIER	abilityreallevelfield	_ConvertAbilityRealLevelField('Nic1')
---
---ABILITY_RLF_DEATH_DAMAGE_FULL_AMOUNT 'common.ABILITY_RLF_DEATH_DAMAGE_FULL_AMOUNT'
---@field ABILITY_RLF_DEATH_DAMAGE_FULL_AMOUNT	abilityreallevelfield	_ConvertAbilityRealLevelField('Nic2')
---
---ABILITY_RLF_DEATH_DAMAGE_FULL_AREA 'common.ABILITY_RLF_DEATH_DAMAGE_FULL_AREA'
---@field ABILITY_RLF_DEATH_DAMAGE_FULL_AREA	abilityreallevelfield	_ConvertAbilityRealLevelField('Nic3')
---
---ABILITY_RLF_DEATH_DAMAGE_HALF_AMOUNT 'common.ABILITY_RLF_DEATH_DAMAGE_HALF_AMOUNT'
---@field ABILITY_RLF_DEATH_DAMAGE_HALF_AMOUNT	abilityreallevelfield	_ConvertAbilityRealLevelField('Nic4')
---
---ABILITY_RLF_DEATH_DAMAGE_HALF_AREA 'common.ABILITY_RLF_DEATH_DAMAGE_HALF_AREA'
---@field ABILITY_RLF_DEATH_DAMAGE_HALF_AREA	abilityreallevelfield	_ConvertAbilityRealLevelField('Nic5')
---
---ABILITY_RLF_DEATH_DAMAGE_DELAY 'common.ABILITY_RLF_DEATH_DAMAGE_DELAY'
---@field ABILITY_RLF_DEATH_DAMAGE_DELAY	abilityreallevelfield	_ConvertAbilityRealLevelField('Nic6')
---
---ABILITY_RLF_DAMAGE_AMOUNT_NSO1 'common.ABILITY_RLF_DAMAGE_AMOUNT_NSO1'
---@field ABILITY_RLF_DAMAGE_AMOUNT_NSO1	abilityreallevelfield	_ConvertAbilityRealLevelField('Nso1')
---
---ABILITY_RLF_DAMAGE_PERIOD 'common.ABILITY_RLF_DAMAGE_PERIOD'
---@field ABILITY_RLF_DAMAGE_PERIOD	abilityreallevelfield	_ConvertAbilityRealLevelField('Nso2')
---
---ABILITY_RLF_DAMAGE_PENALTY 'common.ABILITY_RLF_DAMAGE_PENALTY'
---@field ABILITY_RLF_DAMAGE_PENALTY	abilityreallevelfield	_ConvertAbilityRealLevelField('Nso3')
---
---ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_NSO4 'common.ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_NSO4'
---@field ABILITY_RLF_MOVEMENT_SPEED_REDUCTION_PERCENT_NSO4	abilityreallevelfield	_ConvertAbilityRealLevelField('Nso4')
---
---ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_NSO5 'common.ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_NSO5'
---@field ABILITY_RLF_ATTACK_SPEED_REDUCTION_PERCENT_NSO5	abilityreallevelfield	_ConvertAbilityRealLevelField('Nso5')
---
---ABILITY_RLF_SPLIT_DELAY 'common.ABILITY_RLF_SPLIT_DELAY'
---@field ABILITY_RLF_SPLIT_DELAY	abilityreallevelfield	_ConvertAbilityRealLevelField('Nlm2')
---
---ABILITY_RLF_MAX_HITPOINT_FACTOR 'common.ABILITY_RLF_MAX_HITPOINT_FACTOR'
---@field ABILITY_RLF_MAX_HITPOINT_FACTOR	abilityreallevelfield	_ConvertAbilityRealLevelField('Nlm4')
---
---ABILITY_RLF_LIFE_DURATION_SPLIT_BONUS 'common.ABILITY_RLF_LIFE_DURATION_SPLIT_BONUS'
---@field ABILITY_RLF_LIFE_DURATION_SPLIT_BONUS	abilityreallevelfield	_ConvertAbilityRealLevelField('Nlm5')
---
---ABILITY_RLF_WAVE_INTERVAL 'common.ABILITY_RLF_WAVE_INTERVAL'
---@field ABILITY_RLF_WAVE_INTERVAL	abilityreallevelfield	_ConvertAbilityRealLevelField('Nvc3')
---
---ABILITY_RLF_BUILDING_DAMAGE_FACTOR_NVC4 'common.ABILITY_RLF_BUILDING_DAMAGE_FACTOR_NVC4'
---@field ABILITY_RLF_BUILDING_DAMAGE_FACTOR_NVC4	abilityreallevelfield	_ConvertAbilityRealLevelField('Nvc4')
---
---ABILITY_RLF_FULL_DAMAGE_AMOUNT_NVC5 'common.ABILITY_RLF_FULL_DAMAGE_AMOUNT_NVC5'
---@field ABILITY_RLF_FULL_DAMAGE_AMOUNT_NVC5	abilityreallevelfield	_ConvertAbilityRealLevelField('Nvc5')
---
---ABILITY_RLF_HALF_DAMAGE_FACTOR 'common.ABILITY_RLF_HALF_DAMAGE_FACTOR'
---@field ABILITY_RLF_HALF_DAMAGE_FACTOR	abilityreallevelfield	_ConvertAbilityRealLevelField('Nvc6')
---
---ABILITY_RLF_INTERVAL_BETWEEN_PULSES 'common.ABILITY_RLF_INTERVAL_BETWEEN_PULSES'
---@field ABILITY_RLF_INTERVAL_BETWEEN_PULSES	abilityreallevelfield	_ConvertAbilityRealLevelField('Tau5')
---
---ABILITY_BLF_PERCENT_BONUS_HAB2 'common.ABILITY_BLF_PERCENT_BONUS_HAB2'
---@field ABILITY_BLF_PERCENT_BONUS_HAB2	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Hab2')
---
---ABILITY_BLF_USE_TELEPORT_CLUSTERING_HMT3 'common.ABILITY_BLF_USE_TELEPORT_CLUSTERING_HMT3'
---@field ABILITY_BLF_USE_TELEPORT_CLUSTERING_HMT3	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Hmt3')
---
---ABILITY_BLF_NEVER_MISS_OCR5 'common.ABILITY_BLF_NEVER_MISS_OCR5'
---@field ABILITY_BLF_NEVER_MISS_OCR5	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Ocr5')
---
---ABILITY_BLF_EXCLUDE_ITEM_DAMAGE 'common.ABILITY_BLF_EXCLUDE_ITEM_DAMAGE'
---@field ABILITY_BLF_EXCLUDE_ITEM_DAMAGE	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Ocr6')
---
---ABILITY_BLF_BACKSTAB_DAMAGE 'common.ABILITY_BLF_BACKSTAB_DAMAGE'
---@field ABILITY_BLF_BACKSTAB_DAMAGE	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Owk4')
---
---ABILITY_BLF_INHERIT_UPGRADES_UAN3 'common.ABILITY_BLF_INHERIT_UPGRADES_UAN3'
---@field ABILITY_BLF_INHERIT_UPGRADES_UAN3	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Uan3')
---
---ABILITY_BLF_MANA_CONVERSION_AS_PERCENT 'common.ABILITY_BLF_MANA_CONVERSION_AS_PERCENT'
---@field ABILITY_BLF_MANA_CONVERSION_AS_PERCENT	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Udp3')
---
---ABILITY_BLF_LIFE_CONVERSION_AS_PERCENT 'common.ABILITY_BLF_LIFE_CONVERSION_AS_PERCENT'
---@field ABILITY_BLF_LIFE_CONVERSION_AS_PERCENT	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Udp4')
---
---ABILITY_BLF_LEAVE_TARGET_ALIVE 'common.ABILITY_BLF_LEAVE_TARGET_ALIVE'
---@field ABILITY_BLF_LEAVE_TARGET_ALIVE	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Udp5')
---
---ABILITY_BLF_PERCENT_BONUS_UAU3 'common.ABILITY_BLF_PERCENT_BONUS_UAU3'
---@field ABILITY_BLF_PERCENT_BONUS_UAU3	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Uau3')
---
---ABILITY_BLF_DAMAGE_IS_PERCENT_RECEIVED 'common.ABILITY_BLF_DAMAGE_IS_PERCENT_RECEIVED'
---@field ABILITY_BLF_DAMAGE_IS_PERCENT_RECEIVED	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Eah2')
---
---ABILITY_BLF_MELEE_BONUS 'common.ABILITY_BLF_MELEE_BONUS'
---@field ABILITY_BLF_MELEE_BONUS	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Ear2')
---
---ABILITY_BLF_RANGED_BONUS 'common.ABILITY_BLF_RANGED_BONUS'
---@field ABILITY_BLF_RANGED_BONUS	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Ear3')
---
---ABILITY_BLF_FLAT_BONUS 'common.ABILITY_BLF_FLAT_BONUS'
---@field ABILITY_BLF_FLAT_BONUS	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Ear4')
---
---ABILITY_BLF_NEVER_MISS_HBH5 'common.ABILITY_BLF_NEVER_MISS_HBH5'
---@field ABILITY_BLF_NEVER_MISS_HBH5	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Hbh5')
---
---ABILITY_BLF_PERCENT_BONUS_HAD2 'common.ABILITY_BLF_PERCENT_BONUS_HAD2'
---@field ABILITY_BLF_PERCENT_BONUS_HAD2	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Had2')
---
---ABILITY_BLF_CAN_DEACTIVATE 'common.ABILITY_BLF_CAN_DEACTIVATE'
---@field ABILITY_BLF_CAN_DEACTIVATE	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Hds1')
---
---ABILITY_BLF_RAISED_UNITS_ARE_INVULNERABLE 'common.ABILITY_BLF_RAISED_UNITS_ARE_INVULNERABLE'
---@field ABILITY_BLF_RAISED_UNITS_ARE_INVULNERABLE	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Hre2')
---
---ABILITY_BLF_PERCENTAGE_OAR2 'common.ABILITY_BLF_PERCENTAGE_OAR2'
---@field ABILITY_BLF_PERCENTAGE_OAR2	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Oar2')
---
---ABILITY_BLF_SUMMON_BUSY_UNITS 'common.ABILITY_BLF_SUMMON_BUSY_UNITS'
---@field ABILITY_BLF_SUMMON_BUSY_UNITS	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Btl2')
---
---ABILITY_BLF_CREATES_BLIGHT 'common.ABILITY_BLF_CREATES_BLIGHT'
---@field ABILITY_BLF_CREATES_BLIGHT	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Bli2')
---
---ABILITY_BLF_EXPLODES_ON_DEATH 'common.ABILITY_BLF_EXPLODES_ON_DEATH'
---@field ABILITY_BLF_EXPLODES_ON_DEATH	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Sds6')
---
---ABILITY_BLF_ALWAYS_AUTOCAST_FAE2 'common.ABILITY_BLF_ALWAYS_AUTOCAST_FAE2'
---@field ABILITY_BLF_ALWAYS_AUTOCAST_FAE2	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Fae2')
---
---ABILITY_BLF_REGENERATE_ONLY_AT_NIGHT 'common.ABILITY_BLF_REGENERATE_ONLY_AT_NIGHT'
---@field ABILITY_BLF_REGENERATE_ONLY_AT_NIGHT	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Mbt5')
---
---ABILITY_BLF_SHOW_SELECT_UNIT_BUTTON 'common.ABILITY_BLF_SHOW_SELECT_UNIT_BUTTON'
---@field ABILITY_BLF_SHOW_SELECT_UNIT_BUTTON	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Neu3')
---
---ABILITY_BLF_SHOW_UNIT_INDICATOR 'common.ABILITY_BLF_SHOW_UNIT_INDICATOR'
---@field ABILITY_BLF_SHOW_UNIT_INDICATOR	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Neu4')
---
---ABILITY_BLF_CHARGE_OWNING_PLAYER 'common.ABILITY_BLF_CHARGE_OWNING_PLAYER'
---@field ABILITY_BLF_CHARGE_OWNING_PLAYER	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Ans6')
---
---ABILITY_BLF_PERCENTAGE_ARM2 'common.ABILITY_BLF_PERCENTAGE_ARM2'
---@field ABILITY_BLF_PERCENTAGE_ARM2	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Arm2')
---
---ABILITY_BLF_TARGET_IS_INVULNERABLE 'common.ABILITY_BLF_TARGET_IS_INVULNERABLE'
---@field ABILITY_BLF_TARGET_IS_INVULNERABLE	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Pos3')
---
---ABILITY_BLF_TARGET_IS_MAGIC_IMMUNE 'common.ABILITY_BLF_TARGET_IS_MAGIC_IMMUNE'
---@field ABILITY_BLF_TARGET_IS_MAGIC_IMMUNE	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Pos4')
---
---ABILITY_BLF_KILL_ON_CASTER_DEATH 'common.ABILITY_BLF_KILL_ON_CASTER_DEATH'
---@field ABILITY_BLF_KILL_ON_CASTER_DEATH	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Ucb6')
---
---ABILITY_BLF_NO_TARGET_REQUIRED_REJ4 'common.ABILITY_BLF_NO_TARGET_REQUIRED_REJ4'
---@field ABILITY_BLF_NO_TARGET_REQUIRED_REJ4	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Rej4')
---
---ABILITY_BLF_ACCEPTS_GOLD 'common.ABILITY_BLF_ACCEPTS_GOLD'
---@field ABILITY_BLF_ACCEPTS_GOLD	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Rtn1')
---
---ABILITY_BLF_ACCEPTS_LUMBER 'common.ABILITY_BLF_ACCEPTS_LUMBER'
---@field ABILITY_BLF_ACCEPTS_LUMBER	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Rtn2')
---
---ABILITY_BLF_PREFER_HOSTILES_ROA5 'common.ABILITY_BLF_PREFER_HOSTILES_ROA5'
---@field ABILITY_BLF_PREFER_HOSTILES_ROA5	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Roa5')
---
---ABILITY_BLF_PREFER_FRIENDLIES_ROA6 'common.ABILITY_BLF_PREFER_FRIENDLIES_ROA6'
---@field ABILITY_BLF_PREFER_FRIENDLIES_ROA6	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Roa6')
---
---ABILITY_BLF_ROOTED_TURNING 'common.ABILITY_BLF_ROOTED_TURNING'
---@field ABILITY_BLF_ROOTED_TURNING	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Roo3')
---
---ABILITY_BLF_ALWAYS_AUTOCAST_SLO3 'common.ABILITY_BLF_ALWAYS_AUTOCAST_SLO3'
---@field ABILITY_BLF_ALWAYS_AUTOCAST_SLO3	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Slo3')
---
---ABILITY_BLF_HIDE_BUTTON 'common.ABILITY_BLF_HIDE_BUTTON'
---@field ABILITY_BLF_HIDE_BUTTON	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Ihid')
---
---ABILITY_BLF_USE_TELEPORT_CLUSTERING_ITP2 'common.ABILITY_BLF_USE_TELEPORT_CLUSTERING_ITP2'
---@field ABILITY_BLF_USE_TELEPORT_CLUSTERING_ITP2	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Itp2')
---
---ABILITY_BLF_IMMUNE_TO_MORPH_EFFECTS 'common.ABILITY_BLF_IMMUNE_TO_MORPH_EFFECTS'
---@field ABILITY_BLF_IMMUNE_TO_MORPH_EFFECTS	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Eth1')
---
---ABILITY_BLF_DOES_NOT_BLOCK_BUILDINGS 'common.ABILITY_BLF_DOES_NOT_BLOCK_BUILDINGS'
---@field ABILITY_BLF_DOES_NOT_BLOCK_BUILDINGS	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Eth2')
---
---ABILITY_BLF_AUTO_ACQUIRE_ATTACK_TARGETS 'common.ABILITY_BLF_AUTO_ACQUIRE_ATTACK_TARGETS'
---@field ABILITY_BLF_AUTO_ACQUIRE_ATTACK_TARGETS	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Gho1')
---
---ABILITY_BLF_IMMUNE_TO_MORPH_EFFECTS_GHO2 'common.ABILITY_BLF_IMMUNE_TO_MORPH_EFFECTS_GHO2'
---@field ABILITY_BLF_IMMUNE_TO_MORPH_EFFECTS_GHO2	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Gho2')
---
---ABILITY_BLF_DO_NOT_BLOCK_BUILDINGS 'common.ABILITY_BLF_DO_NOT_BLOCK_BUILDINGS'
---@field ABILITY_BLF_DO_NOT_BLOCK_BUILDINGS	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Gho3')
---
---ABILITY_BLF_INCLUDE_RANGED_DAMAGE 'common.ABILITY_BLF_INCLUDE_RANGED_DAMAGE'
---@field ABILITY_BLF_INCLUDE_RANGED_DAMAGE	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Ssk4')
---
---ABILITY_BLF_INCLUDE_MELEE_DAMAGE 'common.ABILITY_BLF_INCLUDE_MELEE_DAMAGE'
---@field ABILITY_BLF_INCLUDE_MELEE_DAMAGE	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Ssk5')
---
---ABILITY_BLF_MOVE_TO_PARTNER 'common.ABILITY_BLF_MOVE_TO_PARTNER'
---@field ABILITY_BLF_MOVE_TO_PARTNER	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('coa2')
---
---ABILITY_BLF_CAN_BE_DISPELLED 'common.ABILITY_BLF_CAN_BE_DISPELLED'
---@field ABILITY_BLF_CAN_BE_DISPELLED	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('cyc1')
---
---ABILITY_BLF_IGNORE_FRIENDLY_BUFFS 'common.ABILITY_BLF_IGNORE_FRIENDLY_BUFFS'
---@field ABILITY_BLF_IGNORE_FRIENDLY_BUFFS	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('dvm6')
---
---ABILITY_BLF_DROP_ITEMS_ON_DEATH 'common.ABILITY_BLF_DROP_ITEMS_ON_DEATH'
---@field ABILITY_BLF_DROP_ITEMS_ON_DEATH	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('inv2')
---
---ABILITY_BLF_CAN_USE_ITEMS 'common.ABILITY_BLF_CAN_USE_ITEMS'
---@field ABILITY_BLF_CAN_USE_ITEMS	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('inv3')
---
---ABILITY_BLF_CAN_GET_ITEMS 'common.ABILITY_BLF_CAN_GET_ITEMS'
---@field ABILITY_BLF_CAN_GET_ITEMS	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('inv4')
---
---ABILITY_BLF_CAN_DROP_ITEMS 'common.ABILITY_BLF_CAN_DROP_ITEMS'
---@field ABILITY_BLF_CAN_DROP_ITEMS	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('inv5')
---
---ABILITY_BLF_REPAIRS_ALLOWED 'common.ABILITY_BLF_REPAIRS_ALLOWED'
---@field ABILITY_BLF_REPAIRS_ALLOWED	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('liq4')
---
---ABILITY_BLF_CASTER_ONLY_SPLASH 'common.ABILITY_BLF_CASTER_ONLY_SPLASH'
---@field ABILITY_BLF_CASTER_ONLY_SPLASH	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('mfl6')
---
---ABILITY_BLF_NO_TARGET_REQUIRED_IRL4 'common.ABILITY_BLF_NO_TARGET_REQUIRED_IRL4'
---@field ABILITY_BLF_NO_TARGET_REQUIRED_IRL4	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('irl4')
---
---ABILITY_BLF_DISPEL_ON_ATTACK 'common.ABILITY_BLF_DISPEL_ON_ATTACK'
---@field ABILITY_BLF_DISPEL_ON_ATTACK	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('irl5')
---
---ABILITY_BLF_AMOUNT_IS_RAW_VALUE 'common.ABILITY_BLF_AMOUNT_IS_RAW_VALUE'
---@field ABILITY_BLF_AMOUNT_IS_RAW_VALUE	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('ipv3')
---
---ABILITY_BLF_SHARED_SPELL_COOLDOWN 'common.ABILITY_BLF_SHARED_SPELL_COOLDOWN'
---@field ABILITY_BLF_SHARED_SPELL_COOLDOWN	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('spb2')
---
---ABILITY_BLF_SLEEP_ONCE 'common.ABILITY_BLF_SLEEP_ONCE'
---@field ABILITY_BLF_SLEEP_ONCE	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('sla1')
---
---ABILITY_BLF_ALLOW_ON_ANY_PLAYER_SLOT 'common.ABILITY_BLF_ALLOW_ON_ANY_PLAYER_SLOT'
---@field ABILITY_BLF_ALLOW_ON_ANY_PLAYER_SLOT	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('sla2')
---
---ABILITY_BLF_DISABLE_OTHER_ABILITIES 'common.ABILITY_BLF_DISABLE_OTHER_ABILITIES'
---@field ABILITY_BLF_DISABLE_OTHER_ABILITIES	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Ncl5')
---
---ABILITY_BLF_ALLOW_BOUNTY 'common.ABILITY_BLF_ALLOW_BOUNTY'
---@field ABILITY_BLF_ALLOW_BOUNTY	abilitybooleanlevelfield	_ConvertAbilityBooleanLevelField('Ntm4')
---
---ABILITY_SLF_ICON_NORMAL 'common.ABILITY_SLF_ICON_NORMAL'
---@field ABILITY_SLF_ICON_NORMAL	abilitystringlevelfield	_ConvertAbilityStringLevelField('aart')
---
---ABILITY_SLF_CASTER 'common.ABILITY_SLF_CASTER'
---@field ABILITY_SLF_CASTER	abilitystringlevelfield	_ConvertAbilityStringLevelField('acat')
---
---ABILITY_SLF_TARGET 'common.ABILITY_SLF_TARGET'
---@field ABILITY_SLF_TARGET	abilitystringlevelfield	_ConvertAbilityStringLevelField('atat')
---
---ABILITY_SLF_SPECIAL 'common.ABILITY_SLF_SPECIAL'
---@field ABILITY_SLF_SPECIAL	abilitystringlevelfield	_ConvertAbilityStringLevelField('asat')
---
---ABILITY_SLF_EFFECT 'common.ABILITY_SLF_EFFECT'
---@field ABILITY_SLF_EFFECT	abilitystringlevelfield	_ConvertAbilityStringLevelField('aeat')
---
---ABILITY_SLF_AREA_EFFECT 'common.ABILITY_SLF_AREA_EFFECT'
---@field ABILITY_SLF_AREA_EFFECT	abilitystringlevelfield	_ConvertAbilityStringLevelField('aaea')
---
---ABILITY_SLF_LIGHTNING_EFFECTS 'common.ABILITY_SLF_LIGHTNING_EFFECTS'
---@field ABILITY_SLF_LIGHTNING_EFFECTS	abilitystringlevelfield	_ConvertAbilityStringLevelField('alig')
---
---ABILITY_SLF_MISSILE_ART 'common.ABILITY_SLF_MISSILE_ART'
---@field ABILITY_SLF_MISSILE_ART	abilitystringlevelfield	_ConvertAbilityStringLevelField('amat')
---
---ABILITY_SLF_TOOLTIP_LEARN 'common.ABILITY_SLF_TOOLTIP_LEARN'
---@field ABILITY_SLF_TOOLTIP_LEARN	abilitystringlevelfield	_ConvertAbilityStringLevelField('aret')
---
---ABILITY_SLF_TOOLTIP_LEARN_EXTENDED 'common.ABILITY_SLF_TOOLTIP_LEARN_EXTENDED'
---@field ABILITY_SLF_TOOLTIP_LEARN_EXTENDED	abilitystringlevelfield	_ConvertAbilityStringLevelField('arut')
---
---ABILITY_SLF_TOOLTIP_NORMAL 'common.ABILITY_SLF_TOOLTIP_NORMAL'
---@field ABILITY_SLF_TOOLTIP_NORMAL	abilitystringlevelfield	_ConvertAbilityStringLevelField('atp1')
---
---ABILITY_SLF_TOOLTIP_TURN_OFF 'common.ABILITY_SLF_TOOLTIP_TURN_OFF'
---@field ABILITY_SLF_TOOLTIP_TURN_OFF	abilitystringlevelfield	_ConvertAbilityStringLevelField('aut1')
---
---ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED 'common.ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED'
---@field ABILITY_SLF_TOOLTIP_NORMAL_EXTENDED	abilitystringlevelfield	_ConvertAbilityStringLevelField('aub1')
---
---ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED 'common.ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED'
---@field ABILITY_SLF_TOOLTIP_TURN_OFF_EXTENDED	abilitystringlevelfield	_ConvertAbilityStringLevelField('auu1')
---
---ABILITY_SLF_NORMAL_FORM_UNIT_EME1 'common.ABILITY_SLF_NORMAL_FORM_UNIT_EME1'
---@field ABILITY_SLF_NORMAL_FORM_UNIT_EME1	abilitystringlevelfield	_ConvertAbilityStringLevelField('Eme1')
---
---ABILITY_SLF_SPAWNED_UNITS 'common.ABILITY_SLF_SPAWNED_UNITS'
---@field ABILITY_SLF_SPAWNED_UNITS	abilitystringlevelfield	_ConvertAbilityStringLevelField('Ndp1')
---
---ABILITY_SLF_ABILITY_FOR_UNIT_CREATION 'common.ABILITY_SLF_ABILITY_FOR_UNIT_CREATION'
---@field ABILITY_SLF_ABILITY_FOR_UNIT_CREATION	abilitystringlevelfield	_ConvertAbilityStringLevelField('Nrc1')
---
---ABILITY_SLF_NORMAL_FORM_UNIT_MIL1 'common.ABILITY_SLF_NORMAL_FORM_UNIT_MIL1'
---@field ABILITY_SLF_NORMAL_FORM_UNIT_MIL1	abilitystringlevelfield	_ConvertAbilityStringLevelField('Mil1')
---
---ABILITY_SLF_ALTERNATE_FORM_UNIT_MIL2 'common.ABILITY_SLF_ALTERNATE_FORM_UNIT_MIL2'
---@field ABILITY_SLF_ALTERNATE_FORM_UNIT_MIL2	abilitystringlevelfield	_ConvertAbilityStringLevelField('Mil2')
---
---ABILITY_SLF_BASE_ORDER_ID_ANS5 'common.ABILITY_SLF_BASE_ORDER_ID_ANS5'
---@field ABILITY_SLF_BASE_ORDER_ID_ANS5	abilitystringlevelfield	_ConvertAbilityStringLevelField('Ans5')
---
---ABILITY_SLF_MORPH_UNITS_GROUND 'common.ABILITY_SLF_MORPH_UNITS_GROUND'
---@field ABILITY_SLF_MORPH_UNITS_GROUND	abilitystringlevelfield	_ConvertAbilityStringLevelField('Ply2')
---
---ABILITY_SLF_MORPH_UNITS_AIR 'common.ABILITY_SLF_MORPH_UNITS_AIR'
---@field ABILITY_SLF_MORPH_UNITS_AIR	abilitystringlevelfield	_ConvertAbilityStringLevelField('Ply3')
---
---ABILITY_SLF_MORPH_UNITS_AMPHIBIOUS 'common.ABILITY_SLF_MORPH_UNITS_AMPHIBIOUS'
---@field ABILITY_SLF_MORPH_UNITS_AMPHIBIOUS	abilitystringlevelfield	_ConvertAbilityStringLevelField('Ply4')
---
---ABILITY_SLF_MORPH_UNITS_WATER 'common.ABILITY_SLF_MORPH_UNITS_WATER'
---@field ABILITY_SLF_MORPH_UNITS_WATER	abilitystringlevelfield	_ConvertAbilityStringLevelField('Ply5')
---
---ABILITY_SLF_UNIT_TYPE_ONE 'common.ABILITY_SLF_UNIT_TYPE_ONE'
---@field ABILITY_SLF_UNIT_TYPE_ONE	abilitystringlevelfield	_ConvertAbilityStringLevelField('Rai3')
---
---ABILITY_SLF_UNIT_TYPE_TWO 'common.ABILITY_SLF_UNIT_TYPE_TWO'
---@field ABILITY_SLF_UNIT_TYPE_TWO	abilitystringlevelfield	_ConvertAbilityStringLevelField('Rai4')
---
---ABILITY_SLF_UNIT_TYPE_SOD2 'common.ABILITY_SLF_UNIT_TYPE_SOD2'
---@field ABILITY_SLF_UNIT_TYPE_SOD2	abilitystringlevelfield	_ConvertAbilityStringLevelField('Sod2')
---
---ABILITY_SLF_SUMMON_1_UNIT_TYPE 'common.ABILITY_SLF_SUMMON_1_UNIT_TYPE'
---@field ABILITY_SLF_SUMMON_1_UNIT_TYPE	abilitystringlevelfield	_ConvertAbilityStringLevelField('Ist1')
---
---ABILITY_SLF_SUMMON_2_UNIT_TYPE 'common.ABILITY_SLF_SUMMON_2_UNIT_TYPE'
---@field ABILITY_SLF_SUMMON_2_UNIT_TYPE	abilitystringlevelfield	_ConvertAbilityStringLevelField('Ist2')
---
---ABILITY_SLF_RACE_TO_CONVERT 'common.ABILITY_SLF_RACE_TO_CONVERT'
---@field ABILITY_SLF_RACE_TO_CONVERT	abilitystringlevelfield	_ConvertAbilityStringLevelField('Ndc1')
---
---ABILITY_SLF_PARTNER_UNIT_TYPE 'common.ABILITY_SLF_PARTNER_UNIT_TYPE'
---@field ABILITY_SLF_PARTNER_UNIT_TYPE	abilitystringlevelfield	_ConvertAbilityStringLevelField('coa1')
---
---ABILITY_SLF_PARTNER_UNIT_TYPE_ONE 'common.ABILITY_SLF_PARTNER_UNIT_TYPE_ONE'
---@field ABILITY_SLF_PARTNER_UNIT_TYPE_ONE	abilitystringlevelfield	_ConvertAbilityStringLevelField('dcp1')
---
---ABILITY_SLF_PARTNER_UNIT_TYPE_TWO 'common.ABILITY_SLF_PARTNER_UNIT_TYPE_TWO'
---@field ABILITY_SLF_PARTNER_UNIT_TYPE_TWO	abilitystringlevelfield	_ConvertAbilityStringLevelField('dcp2')
---
---ABILITY_SLF_REQUIRED_UNIT_TYPE 'common.ABILITY_SLF_REQUIRED_UNIT_TYPE'
---@field ABILITY_SLF_REQUIRED_UNIT_TYPE	abilitystringlevelfield	_ConvertAbilityStringLevelField('tpi1')
---
---ABILITY_SLF_CONVERTED_UNIT_TYPE 'common.ABILITY_SLF_CONVERTED_UNIT_TYPE'
---@field ABILITY_SLF_CONVERTED_UNIT_TYPE	abilitystringlevelfield	_ConvertAbilityStringLevelField('tpi2')
---
---ABILITY_SLF_SPELL_LIST 'common.ABILITY_SLF_SPELL_LIST'
---@field ABILITY_SLF_SPELL_LIST	abilitystringlevelfield	_ConvertAbilityStringLevelField('spb1')
---
---ABILITY_SLF_BASE_ORDER_ID_SPB5 'common.ABILITY_SLF_BASE_ORDER_ID_SPB5'
---@field ABILITY_SLF_BASE_ORDER_ID_SPB5	abilitystringlevelfield	_ConvertAbilityStringLevelField('spb5')
---
---ABILITY_SLF_BASE_ORDER_ID_NCL6 'common.ABILITY_SLF_BASE_ORDER_ID_NCL6'
---@field ABILITY_SLF_BASE_ORDER_ID_NCL6	abilitystringlevelfield	_ConvertAbilityStringLevelField('Ncl6')
---
---ABILITY_SLF_ABILITY_UPGRADE_1 'common.ABILITY_SLF_ABILITY_UPGRADE_1'
---@field ABILITY_SLF_ABILITY_UPGRADE_1	abilitystringlevelfield	_ConvertAbilityStringLevelField('Neg3')
---
---ABILITY_SLF_ABILITY_UPGRADE_2 'common.ABILITY_SLF_ABILITY_UPGRADE_2'
---@field ABILITY_SLF_ABILITY_UPGRADE_2	abilitystringlevelfield	_ConvertAbilityStringLevelField('Neg4')
---
---ABILITY_SLF_ABILITY_UPGRADE_3 'common.ABILITY_SLF_ABILITY_UPGRADE_3'
---@field ABILITY_SLF_ABILITY_UPGRADE_3	abilitystringlevelfield	_ConvertAbilityStringLevelField('Neg5')
---
---ABILITY_SLF_ABILITY_UPGRADE_4 'common.ABILITY_SLF_ABILITY_UPGRADE_4'
---@field ABILITY_SLF_ABILITY_UPGRADE_4	abilitystringlevelfield	_ConvertAbilityStringLevelField('Neg6')
---
---ABILITY_SLF_SPAWN_UNIT_ID_NSY2 'common.ABILITY_SLF_SPAWN_UNIT_ID_NSY2'
---@field ABILITY_SLF_SPAWN_UNIT_ID_NSY2	abilitystringlevelfield	_ConvertAbilityStringLevelField('Nsy2')
---
---Item
---Item 'common.ITEM_IF_LEVEL'
---@field ITEM_IF_LEVEL	itemintegerfield	_ConvertItemIntegerField('ilev')
---
---ITEM_IF_NUMBER_OF_CHARGES 'common.ITEM_IF_NUMBER_OF_CHARGES'
---@field ITEM_IF_NUMBER_OF_CHARGES	itemintegerfield	_ConvertItemIntegerField('iuse')
---
---ITEM_IF_COOLDOWN_GROUP 'common.ITEM_IF_COOLDOWN_GROUP'
---@field ITEM_IF_COOLDOWN_GROUP	itemintegerfield	_ConvertItemIntegerField('icid')
---
---ITEM_IF_MAX_HIT_POINTS 'common.ITEM_IF_MAX_HIT_POINTS'
---@field ITEM_IF_MAX_HIT_POINTS	itemintegerfield	_ConvertItemIntegerField('ihtp')
---
---ITEM_IF_HIT_POINTS 'common.ITEM_IF_HIT_POINTS'
---@field ITEM_IF_HIT_POINTS	itemintegerfield	_ConvertItemIntegerField('ihpc')
---
---ITEM_IF_PRIORITY 'common.ITEM_IF_PRIORITY'
---@field ITEM_IF_PRIORITY	itemintegerfield	_ConvertItemIntegerField('ipri')
---
---ITEM_IF_ARMOR_TYPE 'common.ITEM_IF_ARMOR_TYPE'
---@field ITEM_IF_ARMOR_TYPE	itemintegerfield	_ConvertItemIntegerField('iarm')
---
---ITEM_IF_TINTING_COLOR_RED 'common.ITEM_IF_TINTING_COLOR_RED'
---@field ITEM_IF_TINTING_COLOR_RED	itemintegerfield	_ConvertItemIntegerField('iclr')
---
---ITEM_IF_TINTING_COLOR_GREEN 'common.ITEM_IF_TINTING_COLOR_GREEN'
---@field ITEM_IF_TINTING_COLOR_GREEN	itemintegerfield	_ConvertItemIntegerField('iclg')
---
---ITEM_IF_TINTING_COLOR_BLUE 'common.ITEM_IF_TINTING_COLOR_BLUE'
---@field ITEM_IF_TINTING_COLOR_BLUE	itemintegerfield	_ConvertItemIntegerField('iclb')
---
---ITEM_IF_TINTING_COLOR_ALPHA 'common.ITEM_IF_TINTING_COLOR_ALPHA'
---@field ITEM_IF_TINTING_COLOR_ALPHA	itemintegerfield	_ConvertItemIntegerField('ical')
---
---ITEM_RF_SCALING_VALUE 'common.ITEM_RF_SCALING_VALUE'
---@field ITEM_RF_SCALING_VALUE	itemrealfield	_ConvertItemRealField('isca')
---
---ITEM_BF_DROPPED_WHEN_CARRIER_DIES 'common.ITEM_BF_DROPPED_WHEN_CARRIER_DIES'
---@field ITEM_BF_DROPPED_WHEN_CARRIER_DIES	itembooleanfield	_ConvertItemBooleanField('idrp')
---
---ITEM_BF_CAN_BE_DROPPED 'common.ITEM_BF_CAN_BE_DROPPED'
---@field ITEM_BF_CAN_BE_DROPPED	itembooleanfield	_ConvertItemBooleanField('idro')
---
---ITEM_BF_PERISHABLE 'common.ITEM_BF_PERISHABLE'
---@field ITEM_BF_PERISHABLE	itembooleanfield	_ConvertItemBooleanField('iper')
---
---ITEM_BF_INCLUDE_AS_RANDOM_CHOICE 'common.ITEM_BF_INCLUDE_AS_RANDOM_CHOICE'
---@field ITEM_BF_INCLUDE_AS_RANDOM_CHOICE	itembooleanfield	_ConvertItemBooleanField('iprn')
---
---ITEM_BF_USE_AUTOMATICALLY_WHEN_ACQUIRED 'common.ITEM_BF_USE_AUTOMATICALLY_WHEN_ACQUIRED'
---@field ITEM_BF_USE_AUTOMATICALLY_WHEN_ACQUIRED	itembooleanfield	_ConvertItemBooleanField('ipow')
---
---ITEM_BF_CAN_BE_SOLD_TO_MERCHANTS 'common.ITEM_BF_CAN_BE_SOLD_TO_MERCHANTS'
---@field ITEM_BF_CAN_BE_SOLD_TO_MERCHANTS	itembooleanfield	_ConvertItemBooleanField('ipaw')
---
---ITEM_BF_ACTIVELY_USED 'common.ITEM_BF_ACTIVELY_USED'
---@field ITEM_BF_ACTIVELY_USED	itembooleanfield	_ConvertItemBooleanField('iusa')
---
---ITEM_SF_MODEL_USED 'common.ITEM_SF_MODEL_USED'
---@field ITEM_SF_MODEL_USED	itemstringfield	_ConvertItemStringField('ifil')
---
---Unit
---Unit 'common.UNIT_IF_DEFENSE_TYPE'
---@field UNIT_IF_DEFENSE_TYPE	unitintegerfield	_ConvertUnitIntegerField('udty')
---
---UNIT_IF_ARMOR_TYPE 'common.UNIT_IF_ARMOR_TYPE'
---@field UNIT_IF_ARMOR_TYPE	unitintegerfield	_ConvertUnitIntegerField('uarm')
---
---UNIT_IF_LOOPING_FADE_IN_RATE 'common.UNIT_IF_LOOPING_FADE_IN_RATE'
---@field UNIT_IF_LOOPING_FADE_IN_RATE	unitintegerfield	_ConvertUnitIntegerField('ulfi')
---
---UNIT_IF_LOOPING_FADE_OUT_RATE 'common.UNIT_IF_LOOPING_FADE_OUT_RATE'
---@field UNIT_IF_LOOPING_FADE_OUT_RATE	unitintegerfield	_ConvertUnitIntegerField('ulfo')
---
---UNIT_IF_AGILITY 'common.UNIT_IF_AGILITY'
---@field UNIT_IF_AGILITY	unitintegerfield	_ConvertUnitIntegerField('uagc')
---
---UNIT_IF_INTELLIGENCE 'common.UNIT_IF_INTELLIGENCE'
---@field UNIT_IF_INTELLIGENCE	unitintegerfield	_ConvertUnitIntegerField('uinc')
---
---UNIT_IF_STRENGTH 'common.UNIT_IF_STRENGTH'
---@field UNIT_IF_STRENGTH	unitintegerfield	_ConvertUnitIntegerField('ustc')
---
---UNIT_IF_AGILITY_PERMANENT 'common.UNIT_IF_AGILITY_PERMANENT'
---@field UNIT_IF_AGILITY_PERMANENT	unitintegerfield	_ConvertUnitIntegerField('uagm')
---
---UNIT_IF_INTELLIGENCE_PERMANENT 'common.UNIT_IF_INTELLIGENCE_PERMANENT'
---@field UNIT_IF_INTELLIGENCE_PERMANENT	unitintegerfield	_ConvertUnitIntegerField('uinm')
---
---UNIT_IF_STRENGTH_PERMANENT 'common.UNIT_IF_STRENGTH_PERMANENT'
---@field UNIT_IF_STRENGTH_PERMANENT	unitintegerfield	_ConvertUnitIntegerField('ustm')
---
---UNIT_IF_AGILITY_WITH_BONUS 'common.UNIT_IF_AGILITY_WITH_BONUS'
---@field UNIT_IF_AGILITY_WITH_BONUS	unitintegerfield	_ConvertUnitIntegerField('uagb')
---
---UNIT_IF_INTELLIGENCE_WITH_BONUS 'common.UNIT_IF_INTELLIGENCE_WITH_BONUS'
---@field UNIT_IF_INTELLIGENCE_WITH_BONUS	unitintegerfield	_ConvertUnitIntegerField('uinb')
---
---UNIT_IF_STRENGTH_WITH_BONUS 'common.UNIT_IF_STRENGTH_WITH_BONUS'
---@field UNIT_IF_STRENGTH_WITH_BONUS	unitintegerfield	_ConvertUnitIntegerField('ustb')
---
---UNIT_IF_GOLD_BOUNTY_AWARDED_NUMBER_OF_DICE 'common.UNIT_IF_GOLD_BOUNTY_AWARDED_NUMBER_OF_DICE'
---@field UNIT_IF_GOLD_BOUNTY_AWARDED_NUMBER_OF_DICE	unitintegerfield	_ConvertUnitIntegerField('ubdi')
---
---UNIT_IF_GOLD_BOUNTY_AWARDED_BASE 'common.UNIT_IF_GOLD_BOUNTY_AWARDED_BASE'
---@field UNIT_IF_GOLD_BOUNTY_AWARDED_BASE	unitintegerfield	_ConvertUnitIntegerField('ubba')
---
---UNIT_IF_GOLD_BOUNTY_AWARDED_SIDES_PER_DIE 'common.UNIT_IF_GOLD_BOUNTY_AWARDED_SIDES_PER_DIE'
---@field UNIT_IF_GOLD_BOUNTY_AWARDED_SIDES_PER_DIE	unitintegerfield	_ConvertUnitIntegerField('ubsi')
---
---UNIT_IF_LUMBER_BOUNTY_AWARDED_NUMBER_OF_DICE 'common.UNIT_IF_LUMBER_BOUNTY_AWARDED_NUMBER_OF_DICE'
---@field UNIT_IF_LUMBER_BOUNTY_AWARDED_NUMBER_OF_DICE	unitintegerfield	_ConvertUnitIntegerField('ulbd')
---
---UNIT_IF_LUMBER_BOUNTY_AWARDED_BASE 'common.UNIT_IF_LUMBER_BOUNTY_AWARDED_BASE'
---@field UNIT_IF_LUMBER_BOUNTY_AWARDED_BASE	unitintegerfield	_ConvertUnitIntegerField('ulba')
---
---UNIT_IF_LUMBER_BOUNTY_AWARDED_SIDES_PER_DIE 'common.UNIT_IF_LUMBER_BOUNTY_AWARDED_SIDES_PER_DIE'
---@field UNIT_IF_LUMBER_BOUNTY_AWARDED_SIDES_PER_DIE	unitintegerfield	_ConvertUnitIntegerField('ulbs')
---
---UNIT_IF_LEVEL 'common.UNIT_IF_LEVEL'
---@field UNIT_IF_LEVEL	unitintegerfield	_ConvertUnitIntegerField('ulev')
---
---UNIT_IF_FORMATION_RANK 'common.UNIT_IF_FORMATION_RANK'
---@field UNIT_IF_FORMATION_RANK	unitintegerfield	_ConvertUnitIntegerField('ufor')
---
---UNIT_IF_ORIENTATION_INTERPOLATION 'common.UNIT_IF_ORIENTATION_INTERPOLATION'
---@field UNIT_IF_ORIENTATION_INTERPOLATION	unitintegerfield	_ConvertUnitIntegerField('uori')
---
---UNIT_IF_ELEVATION_SAMPLE_POINTS 'common.UNIT_IF_ELEVATION_SAMPLE_POINTS'
---@field UNIT_IF_ELEVATION_SAMPLE_POINTS	unitintegerfield	_ConvertUnitIntegerField('uept')
---
---UNIT_IF_TINTING_COLOR_RED 'common.UNIT_IF_TINTING_COLOR_RED'
---@field UNIT_IF_TINTING_COLOR_RED	unitintegerfield	_ConvertUnitIntegerField('uclr')
---
---UNIT_IF_TINTING_COLOR_GREEN 'common.UNIT_IF_TINTING_COLOR_GREEN'
---@field UNIT_IF_TINTING_COLOR_GREEN	unitintegerfield	_ConvertUnitIntegerField('uclg')
---
---UNIT_IF_TINTING_COLOR_BLUE 'common.UNIT_IF_TINTING_COLOR_BLUE'
---@field UNIT_IF_TINTING_COLOR_BLUE	unitintegerfield	_ConvertUnitIntegerField('uclb')
---
---UNIT_IF_TINTING_COLOR_ALPHA 'common.UNIT_IF_TINTING_COLOR_ALPHA'
---@field UNIT_IF_TINTING_COLOR_ALPHA	unitintegerfield	_ConvertUnitIntegerField('ucal')
---
---UNIT_IF_MOVE_TYPE 'common.UNIT_IF_MOVE_TYPE'
---@field UNIT_IF_MOVE_TYPE	unitintegerfield	_ConvertUnitIntegerField('umvt')
---
---UNIT_IF_TARGETED_AS 'common.UNIT_IF_TARGETED_AS'
---@field UNIT_IF_TARGETED_AS	unitintegerfield	_ConvertUnitIntegerField('utar')
---
---UNIT_IF_UNIT_CLASSIFICATION 'common.UNIT_IF_UNIT_CLASSIFICATION'
---@field UNIT_IF_UNIT_CLASSIFICATION	unitintegerfield	_ConvertUnitIntegerField('utyp')
---
---UNIT_IF_HIT_POINTS_REGENERATION_TYPE 'common.UNIT_IF_HIT_POINTS_REGENERATION_TYPE'
---@field UNIT_IF_HIT_POINTS_REGENERATION_TYPE	unitintegerfield	_ConvertUnitIntegerField('uhrt')
---
---UNIT_IF_PLACEMENT_PREVENTED_BY 'common.UNIT_IF_PLACEMENT_PREVENTED_BY'
---@field UNIT_IF_PLACEMENT_PREVENTED_BY	unitintegerfield	_ConvertUnitIntegerField('upar')
---
---UNIT_IF_PRIMARY_ATTRIBUTE 'common.UNIT_IF_PRIMARY_ATTRIBUTE'
---@field UNIT_IF_PRIMARY_ATTRIBUTE	unitintegerfield	_ConvertUnitIntegerField('upra')
---
---UNIT_RF_STRENGTH_PER_LEVEL 'common.UNIT_RF_STRENGTH_PER_LEVEL'
---@field UNIT_RF_STRENGTH_PER_LEVEL	unitrealfield	_ConvertUnitRealField('ustp')
---
---UNIT_RF_AGILITY_PER_LEVEL 'common.UNIT_RF_AGILITY_PER_LEVEL'
---@field UNIT_RF_AGILITY_PER_LEVEL	unitrealfield	_ConvertUnitRealField('uagp')
---
---UNIT_RF_INTELLIGENCE_PER_LEVEL 'common.UNIT_RF_INTELLIGENCE_PER_LEVEL'
---@field UNIT_RF_INTELLIGENCE_PER_LEVEL	unitrealfield	_ConvertUnitRealField('uinp')
---
---UNIT_RF_HIT_POINTS_REGENERATION_RATE 'common.UNIT_RF_HIT_POINTS_REGENERATION_RATE'
---@field UNIT_RF_HIT_POINTS_REGENERATION_RATE	unitrealfield	_ConvertUnitRealField('uhpr')
---
---UNIT_RF_MANA_REGENERATION 'common.UNIT_RF_MANA_REGENERATION'
---@field UNIT_RF_MANA_REGENERATION	unitrealfield	_ConvertUnitRealField('umpr')
---
---UNIT_RF_DEATH_TIME 'common.UNIT_RF_DEATH_TIME'
---@field UNIT_RF_DEATH_TIME	unitrealfield	_ConvertUnitRealField('udtm')
---
---UNIT_RF_FLY_HEIGHT 'common.UNIT_RF_FLY_HEIGHT'
---@field UNIT_RF_FLY_HEIGHT	unitrealfield	_ConvertUnitRealField('ufyh')
---
---UNIT_RF_TURN_RATE 'common.UNIT_RF_TURN_RATE'
---@field UNIT_RF_TURN_RATE	unitrealfield	_ConvertUnitRealField('umvr')
---
---UNIT_RF_ELEVATION_SAMPLE_RADIUS 'common.UNIT_RF_ELEVATION_SAMPLE_RADIUS'
---@field UNIT_RF_ELEVATION_SAMPLE_RADIUS	unitrealfield	_ConvertUnitRealField('uerd')
---
---UNIT_RF_FOG_OF_WAR_SAMPLE_RADIUS 'common.UNIT_RF_FOG_OF_WAR_SAMPLE_RADIUS'
---@field UNIT_RF_FOG_OF_WAR_SAMPLE_RADIUS	unitrealfield	_ConvertUnitRealField('ufrd')
---
---UNIT_RF_MAXIMUM_PITCH_ANGLE_DEGREES 'common.UNIT_RF_MAXIMUM_PITCH_ANGLE_DEGREES'
---@field UNIT_RF_MAXIMUM_PITCH_ANGLE_DEGREES	unitrealfield	_ConvertUnitRealField('umxp')
---
---UNIT_RF_MAXIMUM_ROLL_ANGLE_DEGREES 'common.UNIT_RF_MAXIMUM_ROLL_ANGLE_DEGREES'
---@field UNIT_RF_MAXIMUM_ROLL_ANGLE_DEGREES	unitrealfield	_ConvertUnitRealField('umxr')
---
---UNIT_RF_SCALING_VALUE 'common.UNIT_RF_SCALING_VALUE'
---@field UNIT_RF_SCALING_VALUE	unitrealfield	_ConvertUnitRealField('usca')
---
---UNIT_RF_ANIMATION_RUN_SPEED 'common.UNIT_RF_ANIMATION_RUN_SPEED'
---@field UNIT_RF_ANIMATION_RUN_SPEED	unitrealfield	_ConvertUnitRealField('urun')
---
---UNIT_RF_SELECTION_SCALE 'common.UNIT_RF_SELECTION_SCALE'
---@field UNIT_RF_SELECTION_SCALE	unitrealfield	_ConvertUnitRealField('ussc')
---
---UNIT_RF_SELECTION_CIRCLE_HEIGHT 'common.UNIT_RF_SELECTION_CIRCLE_HEIGHT'
---@field UNIT_RF_SELECTION_CIRCLE_HEIGHT	unitrealfield	_ConvertUnitRealField('uslz')
---
---UNIT_RF_SHADOW_IMAGE_HEIGHT 'common.UNIT_RF_SHADOW_IMAGE_HEIGHT'
---@field UNIT_RF_SHADOW_IMAGE_HEIGHT	unitrealfield	_ConvertUnitRealField('ushh')
---
---UNIT_RF_SHADOW_IMAGE_WIDTH 'common.UNIT_RF_SHADOW_IMAGE_WIDTH'
---@field UNIT_RF_SHADOW_IMAGE_WIDTH	unitrealfield	_ConvertUnitRealField('ushw')
---
---UNIT_RF_SHADOW_IMAGE_CENTER_X 'common.UNIT_RF_SHADOW_IMAGE_CENTER_X'
---@field UNIT_RF_SHADOW_IMAGE_CENTER_X	unitrealfield	_ConvertUnitRealField('ushx')
---
---UNIT_RF_SHADOW_IMAGE_CENTER_Y 'common.UNIT_RF_SHADOW_IMAGE_CENTER_Y'
---@field UNIT_RF_SHADOW_IMAGE_CENTER_Y	unitrealfield	_ConvertUnitRealField('ushy')
---
---UNIT_RF_ANIMATION_WALK_SPEED 'common.UNIT_RF_ANIMATION_WALK_SPEED'
---@field UNIT_RF_ANIMATION_WALK_SPEED	unitrealfield	_ConvertUnitRealField('uwal')
---
---UNIT_RF_DEFENSE 'common.UNIT_RF_DEFENSE'
---@field UNIT_RF_DEFENSE	unitrealfield	_ConvertUnitRealField('udfc')
---
---UNIT_RF_SIGHT_RADIUS 'common.UNIT_RF_SIGHT_RADIUS'
---@field UNIT_RF_SIGHT_RADIUS	unitrealfield	_ConvertUnitRealField('usir')
---
---UNIT_RF_PRIORITY 'common.UNIT_RF_PRIORITY'
---@field UNIT_RF_PRIORITY	unitrealfield	_ConvertUnitRealField('upri')
---
---UNIT_RF_SPEED 'common.UNIT_RF_SPEED'
---@field UNIT_RF_SPEED	unitrealfield	_ConvertUnitRealField('umvc')
---
---UNIT_RF_OCCLUDER_HEIGHT 'common.UNIT_RF_OCCLUDER_HEIGHT'
---@field UNIT_RF_OCCLUDER_HEIGHT	unitrealfield	_ConvertUnitRealField('uocc')
---
---UNIT_RF_HP 'common.UNIT_RF_HP'
---@field UNIT_RF_HP	unitrealfield	_ConvertUnitRealField('uhpc')
---
---UNIT_RF_MANA 'common.UNIT_RF_MANA'
---@field UNIT_RF_MANA	unitrealfield	_ConvertUnitRealField('umpc')
---
---UNIT_RF_ACQUISITION_RANGE 'common.UNIT_RF_ACQUISITION_RANGE'
---@field UNIT_RF_ACQUISITION_RANGE	unitrealfield	_ConvertUnitRealField('uacq')
---
---UNIT_RF_CAST_BACK_SWING 'common.UNIT_RF_CAST_BACK_SWING'
---@field UNIT_RF_CAST_BACK_SWING	unitrealfield	_ConvertUnitRealField('ucbs')
---
---UNIT_RF_CAST_POINT 'common.UNIT_RF_CAST_POINT'
---@field UNIT_RF_CAST_POINT	unitrealfield	_ConvertUnitRealField('ucpt')
---
---UNIT_RF_MINIMUM_ATTACK_RANGE 'common.UNIT_RF_MINIMUM_ATTACK_RANGE'
---@field UNIT_RF_MINIMUM_ATTACK_RANGE	unitrealfield	_ConvertUnitRealField('uamn')
---
---UNIT_BF_RAISABLE 'common.UNIT_BF_RAISABLE'
---@field UNIT_BF_RAISABLE	unitbooleanfield	_ConvertUnitBooleanField('urai')
---
---UNIT_BF_DECAYABLE 'common.UNIT_BF_DECAYABLE'
---@field UNIT_BF_DECAYABLE	unitbooleanfield	_ConvertUnitBooleanField('udec')
---
---UNIT_BF_IS_A_BUILDING 'common.UNIT_BF_IS_A_BUILDING'
---@field UNIT_BF_IS_A_BUILDING	unitbooleanfield	_ConvertUnitBooleanField('ubdg')
---
---UNIT_BF_USE_EXTENDED_LINE_OF_SIGHT 'common.UNIT_BF_USE_EXTENDED_LINE_OF_SIGHT'
---@field UNIT_BF_USE_EXTENDED_LINE_OF_SIGHT	unitbooleanfield	_ConvertUnitBooleanField('ulos')
---
---UNIT_BF_NEUTRAL_BUILDING_SHOWS_MINIMAP_ICON 'common.UNIT_BF_NEUTRAL_BUILDING_SHOWS_MINIMAP_ICON'
---@field UNIT_BF_NEUTRAL_BUILDING_SHOWS_MINIMAP_ICON	unitbooleanfield	_ConvertUnitBooleanField('unbm')
---
---UNIT_BF_HERO_HIDE_HERO_INTERFACE_ICON 'common.UNIT_BF_HERO_HIDE_HERO_INTERFACE_ICON'
---@field UNIT_BF_HERO_HIDE_HERO_INTERFACE_ICON	unitbooleanfield	_ConvertUnitBooleanField('uhhb')
---
---UNIT_BF_HERO_HIDE_HERO_MINIMAP_DISPLAY 'common.UNIT_BF_HERO_HIDE_HERO_MINIMAP_DISPLAY'
---@field UNIT_BF_HERO_HIDE_HERO_MINIMAP_DISPLAY	unitbooleanfield	_ConvertUnitBooleanField('uhhm')
---
---UNIT_BF_HERO_HIDE_HERO_DEATH_MESSAGE 'common.UNIT_BF_HERO_HIDE_HERO_DEATH_MESSAGE'
---@field UNIT_BF_HERO_HIDE_HERO_DEATH_MESSAGE	unitbooleanfield	_ConvertUnitBooleanField('uhhd')
---
---UNIT_BF_HIDE_MINIMAP_DISPLAY 'common.UNIT_BF_HIDE_MINIMAP_DISPLAY'
---@field UNIT_BF_HIDE_MINIMAP_DISPLAY	unitbooleanfield	_ConvertUnitBooleanField('uhom')
---
---UNIT_BF_SCALE_PROJECTILES 'common.UNIT_BF_SCALE_PROJECTILES'
---@field UNIT_BF_SCALE_PROJECTILES	unitbooleanfield	_ConvertUnitBooleanField('uscb')
---
---UNIT_BF_SELECTION_CIRCLE_ON_WATER 'common.UNIT_BF_SELECTION_CIRCLE_ON_WATER'
---@field UNIT_BF_SELECTION_CIRCLE_ON_WATER	unitbooleanfield	_ConvertUnitBooleanField('usew')
---
---UNIT_BF_HAS_WATER_SHADOW 'common.UNIT_BF_HAS_WATER_SHADOW'
---@field UNIT_BF_HAS_WATER_SHADOW	unitbooleanfield	_ConvertUnitBooleanField('ushr')
---
---UNIT_SF_NAME 'common.UNIT_SF_NAME'
---@field UNIT_SF_NAME	unitstringfield	_ConvertUnitStringField('unam')
---
---UNIT_SF_PROPER_NAMES 'common.UNIT_SF_PROPER_NAMES'
---@field UNIT_SF_PROPER_NAMES	unitstringfield	_ConvertUnitStringField('upro')
---
---UNIT_SF_GROUND_TEXTURE 'common.UNIT_SF_GROUND_TEXTURE'
---@field UNIT_SF_GROUND_TEXTURE	unitstringfield	_ConvertUnitStringField('uubs')
---
---UNIT_SF_SHADOW_IMAGE_UNIT 'common.UNIT_SF_SHADOW_IMAGE_UNIT'
---@field UNIT_SF_SHADOW_IMAGE_UNIT	unitstringfield	_ConvertUnitStringField('ushu')
---
---Unit Weapon
---Unit Weapon 'common.UNIT_WEAPON_IF_ATTACK_DAMAGE_NUMBER_OF_DICE'
---@field UNIT_WEAPON_IF_ATTACK_DAMAGE_NUMBER_OF_DICE	unitweaponintegerfield	_ConvertUnitWeaponIntegerField('ua1d')
---
---UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE 'common.UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE'
---@field UNIT_WEAPON_IF_ATTACK_DAMAGE_BASE	unitweaponintegerfield	_ConvertUnitWeaponIntegerField('ua1b')
---
---UNIT_WEAPON_IF_ATTACK_DAMAGE_SIDES_PER_DIE 'common.UNIT_WEAPON_IF_ATTACK_DAMAGE_SIDES_PER_DIE'
---@field UNIT_WEAPON_IF_ATTACK_DAMAGE_SIDES_PER_DIE	unitweaponintegerfield	_ConvertUnitWeaponIntegerField('ua1s')
---
---UNIT_WEAPON_IF_ATTACK_MAXIMUM_NUMBER_OF_TARGETS 'common.UNIT_WEAPON_IF_ATTACK_MAXIMUM_NUMBER_OF_TARGETS'
---@field UNIT_WEAPON_IF_ATTACK_MAXIMUM_NUMBER_OF_TARGETS	unitweaponintegerfield	_ConvertUnitWeaponIntegerField('utc1')
---
---UNIT_WEAPON_IF_ATTACK_ATTACK_TYPE 'common.UNIT_WEAPON_IF_ATTACK_ATTACK_TYPE'
---@field UNIT_WEAPON_IF_ATTACK_ATTACK_TYPE	unitweaponintegerfield	_ConvertUnitWeaponIntegerField('ua1t')
---
---UNIT_WEAPON_IF_ATTACK_WEAPON_SOUND 'common.UNIT_WEAPON_IF_ATTACK_WEAPON_SOUND'
---@field UNIT_WEAPON_IF_ATTACK_WEAPON_SOUND	unitweaponintegerfield	_ConvertUnitWeaponIntegerField('ucs1')
---
---UNIT_WEAPON_IF_ATTACK_AREA_OF_EFFECT_TARGETS 'common.UNIT_WEAPON_IF_ATTACK_AREA_OF_EFFECT_TARGETS'
---@field UNIT_WEAPON_IF_ATTACK_AREA_OF_EFFECT_TARGETS	unitweaponintegerfield	_ConvertUnitWeaponIntegerField('ua1p')
---
---UNIT_WEAPON_IF_ATTACK_TARGETS_ALLOWED 'common.UNIT_WEAPON_IF_ATTACK_TARGETS_ALLOWED'
---@field UNIT_WEAPON_IF_ATTACK_TARGETS_ALLOWED	unitweaponintegerfield	_ConvertUnitWeaponIntegerField('ua1g')
---
---UNIT_WEAPON_RF_ATTACK_BACKSWING_POINT 'common.UNIT_WEAPON_RF_ATTACK_BACKSWING_POINT'
---@field UNIT_WEAPON_RF_ATTACK_BACKSWING_POINT	unitweaponrealfield	_ConvertUnitWeaponRealField('ubs1')
---
---UNIT_WEAPON_RF_ATTACK_DAMAGE_POINT 'common.UNIT_WEAPON_RF_ATTACK_DAMAGE_POINT'
---@field UNIT_WEAPON_RF_ATTACK_DAMAGE_POINT	unitweaponrealfield	_ConvertUnitWeaponRealField('udp1')
---
---UNIT_WEAPON_RF_ATTACK_BASE_COOLDOWN 'common.UNIT_WEAPON_RF_ATTACK_BASE_COOLDOWN'
---@field UNIT_WEAPON_RF_ATTACK_BASE_COOLDOWN	unitweaponrealfield	_ConvertUnitWeaponRealField('ua1c')
---
---UNIT_WEAPON_RF_ATTACK_DAMAGE_LOSS_FACTOR 'common.UNIT_WEAPON_RF_ATTACK_DAMAGE_LOSS_FACTOR'
---@field UNIT_WEAPON_RF_ATTACK_DAMAGE_LOSS_FACTOR	unitweaponrealfield	_ConvertUnitWeaponRealField('udl1')
---
---UNIT_WEAPON_RF_ATTACK_DAMAGE_FACTOR_MEDIUM 'common.UNIT_WEAPON_RF_ATTACK_DAMAGE_FACTOR_MEDIUM'
---@field UNIT_WEAPON_RF_ATTACK_DAMAGE_FACTOR_MEDIUM	unitweaponrealfield	_ConvertUnitWeaponRealField('uhd1')
---
---UNIT_WEAPON_RF_ATTACK_DAMAGE_FACTOR_SMALL 'common.UNIT_WEAPON_RF_ATTACK_DAMAGE_FACTOR_SMALL'
---@field UNIT_WEAPON_RF_ATTACK_DAMAGE_FACTOR_SMALL	unitweaponrealfield	_ConvertUnitWeaponRealField('uqd1')
---
---UNIT_WEAPON_RF_ATTACK_DAMAGE_SPILL_DISTANCE 'common.UNIT_WEAPON_RF_ATTACK_DAMAGE_SPILL_DISTANCE'
---@field UNIT_WEAPON_RF_ATTACK_DAMAGE_SPILL_DISTANCE	unitweaponrealfield	_ConvertUnitWeaponRealField('usd1')
---
---UNIT_WEAPON_RF_ATTACK_DAMAGE_SPILL_RADIUS 'common.UNIT_WEAPON_RF_ATTACK_DAMAGE_SPILL_RADIUS'
---@field UNIT_WEAPON_RF_ATTACK_DAMAGE_SPILL_RADIUS	unitweaponrealfield	_ConvertUnitWeaponRealField('usr1')
---
---UNIT_WEAPON_RF_ATTACK_PROJECTILE_SPEED 'common.UNIT_WEAPON_RF_ATTACK_PROJECTILE_SPEED'
---@field UNIT_WEAPON_RF_ATTACK_PROJECTILE_SPEED	unitweaponrealfield	_ConvertUnitWeaponRealField('ua1z')
---
---UNIT_WEAPON_RF_ATTACK_PROJECTILE_ARC 'common.UNIT_WEAPON_RF_ATTACK_PROJECTILE_ARC'
---@field UNIT_WEAPON_RF_ATTACK_PROJECTILE_ARC	unitweaponrealfield	_ConvertUnitWeaponRealField('uma1')
---
---UNIT_WEAPON_RF_ATTACK_AREA_OF_EFFECT_FULL_DAMAGE 'common.UNIT_WEAPON_RF_ATTACK_AREA_OF_EFFECT_FULL_DAMAGE'
---@field UNIT_WEAPON_RF_ATTACK_AREA_OF_EFFECT_FULL_DAMAGE	unitweaponrealfield	_ConvertUnitWeaponRealField('ua1f')
---
---UNIT_WEAPON_RF_ATTACK_AREA_OF_EFFECT_MEDIUM_DAMAGE 'common.UNIT_WEAPON_RF_ATTACK_AREA_OF_EFFECT_MEDIUM_DAMAGE'
---@field UNIT_WEAPON_RF_ATTACK_AREA_OF_EFFECT_MEDIUM_DAMAGE	unitweaponrealfield	_ConvertUnitWeaponRealField('ua1h')
---
---UNIT_WEAPON_RF_ATTACK_AREA_OF_EFFECT_SMALL_DAMAGE 'common.UNIT_WEAPON_RF_ATTACK_AREA_OF_EFFECT_SMALL_DAMAGE'
---@field UNIT_WEAPON_RF_ATTACK_AREA_OF_EFFECT_SMALL_DAMAGE	unitweaponrealfield	_ConvertUnitWeaponRealField('ua1q')
---
---UNIT_WEAPON_RF_ATTACK_RANGE 'common.UNIT_WEAPON_RF_ATTACK_RANGE'
---@field UNIT_WEAPON_RF_ATTACK_RANGE	unitweaponrealfield	_ConvertUnitWeaponRealField('ua1r')
---
---UNIT_WEAPON_BF_ATTACK_SHOW_UI 'common.UNIT_WEAPON_BF_ATTACK_SHOW_UI'
---@field UNIT_WEAPON_BF_ATTACK_SHOW_UI	unitweaponbooleanfield	_ConvertUnitWeaponBooleanField('uwu1')
---
---UNIT_WEAPON_BF_ATTACKS_ENABLED 'common.UNIT_WEAPON_BF_ATTACKS_ENABLED'
---@field UNIT_WEAPON_BF_ATTACKS_ENABLED	unitweaponbooleanfield	_ConvertUnitWeaponBooleanField('uaen')
---
---UNIT_WEAPON_BF_ATTACK_PROJECTILE_HOMING_ENABLED 'common.UNIT_WEAPON_BF_ATTACK_PROJECTILE_HOMING_ENABLED'
---@field UNIT_WEAPON_BF_ATTACK_PROJECTILE_HOMING_ENABLED	unitweaponbooleanfield	_ConvertUnitWeaponBooleanField('umh1')
---
---UNIT_WEAPON_SF_ATTACK_PROJECTILE_ART 'common.UNIT_WEAPON_SF_ATTACK_PROJECTILE_ART'
---@field UNIT_WEAPON_SF_ATTACK_PROJECTILE_ART	unitweaponstringfield	_ConvertUnitWeaponStringField('ua1m')
---
---Move Type
---Move Type 'common.MOVE_TYPE_UNKNOWN'
---@field MOVE_TYPE_UNKNOWN	movetype	_ConvertMoveType(0)
---
---MOVE_TYPE_FOOT 'common.MOVE_TYPE_FOOT'
---@field MOVE_TYPE_FOOT	movetype	_ConvertMoveType(1)
---
---MOVE_TYPE_FLY 'common.MOVE_TYPE_FLY'
---@field MOVE_TYPE_FLY	movetype	_ConvertMoveType(2)
---
---MOVE_TYPE_HORSE 'common.MOVE_TYPE_HORSE'
---@field MOVE_TYPE_HORSE	movetype	_ConvertMoveType(4)
---
---MOVE_TYPE_HOVER 'common.MOVE_TYPE_HOVER'
---@field MOVE_TYPE_HOVER	movetype	_ConvertMoveType(8)
---
---MOVE_TYPE_FLOAT 'common.MOVE_TYPE_FLOAT'
---@field MOVE_TYPE_FLOAT	movetype	_ConvertMoveType(16)
---
---MOVE_TYPE_AMPHIBIOUS 'common.MOVE_TYPE_AMPHIBIOUS'
---@field MOVE_TYPE_AMPHIBIOUS	movetype	_ConvertMoveType(32)
---
---MOVE_TYPE_UNBUILDABLE 'common.MOVE_TYPE_UNBUILDABLE'
---@field MOVE_TYPE_UNBUILDABLE	movetype	_ConvertMoveType(64)
---
---Target Flag
---Target Flag 'common.TARGET_FLAG_NONE'
---@field TARGET_FLAG_NONE	targetflag	_ConvertTargetFlag(1)
---
---TARGET_FLAG_GROUND 'common.TARGET_FLAG_GROUND'
---@field TARGET_FLAG_GROUND	targetflag	_ConvertTargetFlag(2)
---
---TARGET_FLAG_AIR 'common.TARGET_FLAG_AIR'
---@field TARGET_FLAG_AIR	targetflag	_ConvertTargetFlag(4)
---
---TARGET_FLAG_STRUCTURE 'common.TARGET_FLAG_STRUCTURE'
---@field TARGET_FLAG_STRUCTURE	targetflag	_ConvertTargetFlag(8)
---
---TARGET_FLAG_WARD 'common.TARGET_FLAG_WARD'
---@field TARGET_FLAG_WARD	targetflag	_ConvertTargetFlag(16)
---
---TARGET_FLAG_ITEM 'common.TARGET_FLAG_ITEM'
---@field TARGET_FLAG_ITEM	targetflag	_ConvertTargetFlag(32)
---
---TARGET_FLAG_TREE 'common.TARGET_FLAG_TREE'
---@field TARGET_FLAG_TREE	targetflag	_ConvertTargetFlag(64)
---
---TARGET_FLAG_WALL 'common.TARGET_FLAG_WALL'
---@field TARGET_FLAG_WALL	targetflag	_ConvertTargetFlag(128)
---
---TARGET_FLAG_DEBRIS 'common.TARGET_FLAG_DEBRIS'
---@field TARGET_FLAG_DEBRIS	targetflag	_ConvertTargetFlag(256)
---
---TARGET_FLAG_DECORATION 'common.TARGET_FLAG_DECORATION'
---@field TARGET_FLAG_DECORATION	targetflag	_ConvertTargetFlag(512)
---
---TARGET_FLAG_BRIDGE 'common.TARGET_FLAG_BRIDGE'
---@field TARGET_FLAG_BRIDGE	targetflag	_ConvertTargetFlag(1024)
---
---defense type
---defense type 'common.DEFENSE_TYPE_LIGHT'
---@field DEFENSE_TYPE_LIGHT	defensetype	_ConvertDefenseType(0)
---
---DEFENSE_TYPE_MEDIUM 'common.DEFENSE_TYPE_MEDIUM'
---@field DEFENSE_TYPE_MEDIUM	defensetype	_ConvertDefenseType(1)
---
---DEFENSE_TYPE_LARGE 'common.DEFENSE_TYPE_LARGE'
---@field DEFENSE_TYPE_LARGE	defensetype	_ConvertDefenseType(2)
---
---DEFENSE_TYPE_FORT 'common.DEFENSE_TYPE_FORT'
---@field DEFENSE_TYPE_FORT	defensetype	_ConvertDefenseType(3)
---
---DEFENSE_TYPE_NORMAL 'common.DEFENSE_TYPE_NORMAL'
---@field DEFENSE_TYPE_NORMAL	defensetype	_ConvertDefenseType(4)
---
---DEFENSE_TYPE_HERO 'common.DEFENSE_TYPE_HERO'
---@field DEFENSE_TYPE_HERO	defensetype	_ConvertDefenseType(5)
---
---DEFENSE_TYPE_DIVINE 'common.DEFENSE_TYPE_DIVINE'
---@field DEFENSE_TYPE_DIVINE	defensetype	_ConvertDefenseType(6)
---
---DEFENSE_TYPE_NONE 'common.DEFENSE_TYPE_NONE'
---@field DEFENSE_TYPE_NONE	defensetype	_ConvertDefenseType(7)
---
---Hero Attribute
---Hero Attribute 'common.HERO_ATTRIBUTE_STR'
---@field HERO_ATTRIBUTE_STR	heroattribute	_ConvertHeroAttribute(1)
---
---HERO_ATTRIBUTE_INT 'common.HERO_ATTRIBUTE_INT'
---@field HERO_ATTRIBUTE_INT	heroattribute	_ConvertHeroAttribute(2)
---
---HERO_ATTRIBUTE_AGI 'common.HERO_ATTRIBUTE_AGI'
---@field HERO_ATTRIBUTE_AGI	heroattribute	_ConvertHeroAttribute(3)
---
---Armor Type
---Armor Type 'common.ARMOR_TYPE_WHOKNOWS'
---@field ARMOR_TYPE_WHOKNOWS	armortype	_ConvertArmorType(0)
---
---ARMOR_TYPE_FLESH 'common.ARMOR_TYPE_FLESH'
---@field ARMOR_TYPE_FLESH	armortype	_ConvertArmorType(1)
---
---ARMOR_TYPE_METAL 'common.ARMOR_TYPE_METAL'
---@field ARMOR_TYPE_METAL	armortype	_ConvertArmorType(2)
---
---ARMOR_TYPE_WOOD 'common.ARMOR_TYPE_WOOD'
---@field ARMOR_TYPE_WOOD	armortype	_ConvertArmorType(3)
---
---ARMOR_TYPE_ETHREAL 'common.ARMOR_TYPE_ETHREAL'
---@field ARMOR_TYPE_ETHREAL	armortype	_ConvertArmorType(4)
---
---ARMOR_TYPE_STONE 'common.ARMOR_TYPE_STONE'
---@field ARMOR_TYPE_STONE	armortype	_ConvertArmorType(5)
---
---Regeneration Type
---Regeneration Type 'common.REGENERATION_TYPE_NONE'
---@field REGENERATION_TYPE_NONE	regentype	_ConvertRegenType(0)
---
---REGENERATION_TYPE_ALWAYS 'common.REGENERATION_TYPE_ALWAYS'
---@field REGENERATION_TYPE_ALWAYS	regentype	_ConvertRegenType(1)
---
---REGENERATION_TYPE_BLIGHT 'common.REGENERATION_TYPE_BLIGHT'
---@field REGENERATION_TYPE_BLIGHT	regentype	_ConvertRegenType(2)
---
---REGENERATION_TYPE_DAY 'common.REGENERATION_TYPE_DAY'
---@field REGENERATION_TYPE_DAY	regentype	_ConvertRegenType(3)
---
---REGENERATION_TYPE_NIGHT 'common.REGENERATION_TYPE_NIGHT'
---@field REGENERATION_TYPE_NIGHT	regentype	_ConvertRegenType(4)
---
---Unit Category
---Unit Category 'common.UNIT_CATEGORY_GIANT'
---@field UNIT_CATEGORY_GIANT	unitcategory	_ConvertUnitCategory(1)
---
---UNIT_CATEGORY_UNDEAD 'common.UNIT_CATEGORY_UNDEAD'
---@field UNIT_CATEGORY_UNDEAD	unitcategory	_ConvertUnitCategory(2)
---
---UNIT_CATEGORY_SUMMONED 'common.UNIT_CATEGORY_SUMMONED'
---@field UNIT_CATEGORY_SUMMONED	unitcategory	_ConvertUnitCategory(4)
---
---UNIT_CATEGORY_MECHANICAL 'common.UNIT_CATEGORY_MECHANICAL'
---@field UNIT_CATEGORY_MECHANICAL	unitcategory	_ConvertUnitCategory(8)
---
---UNIT_CATEGORY_PEON 'common.UNIT_CATEGORY_PEON'
---@field UNIT_CATEGORY_PEON	unitcategory	_ConvertUnitCategory(16)
---
---UNIT_CATEGORY_SAPPER 'common.UNIT_CATEGORY_SAPPER'
---@field UNIT_CATEGORY_SAPPER	unitcategory	_ConvertUnitCategory(32)
---
---UNIT_CATEGORY_TOWNHALL 'common.UNIT_CATEGORY_TOWNHALL'
---@field UNIT_CATEGORY_TOWNHALL	unitcategory	_ConvertUnitCategory(64)
---
---UNIT_CATEGORY_ANCIENT 'common.UNIT_CATEGORY_ANCIENT'
---@field UNIT_CATEGORY_ANCIENT	unitcategory	_ConvertUnitCategory(128)
---
---UNIT_CATEGORY_NEUTRAL 'common.UNIT_CATEGORY_NEUTRAL'
---@field UNIT_CATEGORY_NEUTRAL	unitcategory	_ConvertUnitCategory(256)
---
---UNIT_CATEGORY_WARD 'common.UNIT_CATEGORY_WARD'
---@field UNIT_CATEGORY_WARD	unitcategory	_ConvertUnitCategory(512)
---
---UNIT_CATEGORY_STANDON 'common.UNIT_CATEGORY_STANDON'
---@field UNIT_CATEGORY_STANDON	unitcategory	_ConvertUnitCategory(1024)
---
---UNIT_CATEGORY_TAUREN 'common.UNIT_CATEGORY_TAUREN'
---@field UNIT_CATEGORY_TAUREN	unitcategory	_ConvertUnitCategory(2048)
---
---Pathing Flag
---Pathing Flag 'common.PATHING_FLAG_UNWALKABLE'
---@field PATHING_FLAG_UNWALKABLE	pathingflag	_ConvertPathingFlag(2)
---
---PATHING_FLAG_UNFLYABLE 'common.PATHING_FLAG_UNFLYABLE'
---@field PATHING_FLAG_UNFLYABLE	pathingflag	_ConvertPathingFlag(4)
---
---PATHING_FLAG_UNBUILDABLE 'common.PATHING_FLAG_UNBUILDABLE'
---@field PATHING_FLAG_UNBUILDABLE	pathingflag	_ConvertPathingFlag(8)
---
---PATHING_FLAG_UNPEONHARVEST 'common.PATHING_FLAG_UNPEONHARVEST'
---@field PATHING_FLAG_UNPEONHARVEST	pathingflag	_ConvertPathingFlag(16)
---
---PATHING_FLAG_BLIGHTED 'common.PATHING_FLAG_BLIGHTED'
---@field PATHING_FLAG_BLIGHTED	pathingflag	_ConvertPathingFlag(32)
---
---PATHING_FLAG_UNFLOATABLE 'common.PATHING_FLAG_UNFLOATABLE'
---@field PATHING_FLAG_UNFLOATABLE	pathingflag	_ConvertPathingFlag(64)
---
---PATHING_FLAG_UNAMPHIBIOUS 'common.PATHING_FLAG_UNAMPHIBIOUS'
---@field PATHING_FLAG_UNAMPHIBIOUS	pathingflag	_ConvertPathingFlag(128)
---
---PATHING_FLAG_UNITEMPLACABLE 'common.PATHING_FLAG_UNITEMPLACABLE'
---@field PATHING_FLAG_UNITEMPLACABLE	pathingflag	_ConvertPathingFlag(256)
local common = {}

---转换种族
---@param i integer
---@return race
function common.ConvertRace(i) end

---转换联盟类型
---@param i integer
---@return alliancetype
function common.ConvertAllianceType(i) end

---ConvertRacePref
---@param i integer
---@return racepreference
function common.ConvertRacePref(i) end

---ConvertIGameState
---@param i integer
---@return igamestate
function common.ConvertIGameState(i) end

---ConvertFGameState
---@param i integer
---@return fgamestate
function common.ConvertFGameState(i) end

---ConvertPlayerState
---@param i integer
---@return playerstate
function common.ConvertPlayerState(i) end

---ConvertPlayerScore
---@param i integer
---@return playerscore
function common.ConvertPlayerScore(i) end

---ConvertPlayerGameResult
---@param i integer
---@return playergameresult
function common.ConvertPlayerGameResult(i) end

---ConvertUnitState
---@param i integer
---@return unitstate
function common.ConvertUnitState(i) end

---ConvertAIDifficulty
---@param i integer
---@return aidifficulty
function common.ConvertAIDifficulty(i) end

---ConvertGameEvent
---@param i integer
---@return gameevent
function common.ConvertGameEvent(i) end

---ConvertPlayerEvent
---@param i integer
---@return playerevent
function common.ConvertPlayerEvent(i) end

---ConvertPlayerUnitEvent
---@param i integer
---@return playerunitevent
function common.ConvertPlayerUnitEvent(i) end

---ConvertWidgetEvent
---@param i integer
---@return widgetevent
function common.ConvertWidgetEvent(i) end

---ConvertDialogEvent
---@param i integer
---@return dialogevent
function common.ConvertDialogEvent(i) end

---ConvertUnitEvent
---@param i integer
---@return unitevent
function common.ConvertUnitEvent(i) end

---ConvertLimitOp
---@param i integer
---@return limitop
function common.ConvertLimitOp(i) end

---ConvertUnitType
---@param i integer
---@return unittype
function common.ConvertUnitType(i) end

---ConvertGameSpeed
---@param i integer
---@return gamespeed
function common.ConvertGameSpeed(i) end

---ConvertPlacement
---@param i integer
---@return placement
function common.ConvertPlacement(i) end

---ConvertStartLocPrio
---@param i integer
---@return startlocprio
function common.ConvertStartLocPrio(i) end

---ConvertGameDifficulty
---@param i integer
---@return gamedifficulty
function common.ConvertGameDifficulty(i) end

---ConvertGameType
---@param i integer
---@return gametype
function common.ConvertGameType(i) end

---ConvertMapFlag
---@param i integer
---@return mapflag
function common.ConvertMapFlag(i) end

---ConvertMapVisibility
---@param i integer
---@return mapvisibility
function common.ConvertMapVisibility(i) end

---ConvertMapSetting
---@param i integer
---@return mapsetting
function common.ConvertMapSetting(i) end

---ConvertMapDensity
---@param i integer
---@return mapdensity
function common.ConvertMapDensity(i) end

---ConvertMapControl
---@param i integer
---@return mapcontrol
function common.ConvertMapControl(i) end

---ConvertPlayerColor
---@param i integer
---@return playercolor
function common.ConvertPlayerColor(i) end

---ConvertPlayerSlotState
---@param i integer
---@return playerslotstate
function common.ConvertPlayerSlotState(i) end

---ConvertVolumeGroup
---@param i integer
---@return volumegroup
function common.ConvertVolumeGroup(i) end

---ConvertCameraField
---@param i integer
---@return camerafield
function common.ConvertCameraField(i) end

---ConvertBlendMode
---@param i integer
---@return blendmode
function common.ConvertBlendMode(i) end

---ConvertRarityControl
---@param i integer
---@return raritycontrol
function common.ConvertRarityControl(i) end

---ConvertTexMapFlags
---@param i integer
---@return texmapflags
function common.ConvertTexMapFlags(i) end

---ConvertFogState
---@param i integer
---@return fogstate
function common.ConvertFogState(i) end

---ConvertEffectType
---@param i integer
---@return effecttype
function common.ConvertEffectType(i) end

---ConvertVersion
---@param i integer
---@return version
function common.ConvertVersion(i) end

---ConvertItemType
---@param i integer
---@return itemtype
function common.ConvertItemType(i) end

---ConvertAttackType
---@param i integer
---@return attacktype
function common.ConvertAttackType(i) end

---ConvertDamageType
---@param i integer
---@return damagetype
function common.ConvertDamageType(i) end

---ConvertWeaponType
---@param i integer
---@return weapontype
function common.ConvertWeaponType(i) end

---ConvertSoundType
---@param i integer
---@return soundtype
function common.ConvertSoundType(i) end

---ConvertPathingType
---@param i integer
---@return pathingtype
function common.ConvertPathingType(i) end

---ConvertMouseButtonType
---@param i integer
---@return mousebuttontype
function common.ConvertMouseButtonType(i) end

---ConvertAnimType
---@param i integer
---@return animtype
function common.ConvertAnimType(i) end

---ConvertSubAnimType
---@param i integer
---@return subanimtype
function common.ConvertSubAnimType(i) end

---ConvertOriginFrameType
---@param i integer
---@return originframetype
function common.ConvertOriginFrameType(i) end

---ConvertFramePointType
---@param i integer
---@return framepointtype
function common.ConvertFramePointType(i) end

---ConvertTextAlignType
---@param i integer
---@return textaligntype
function common.ConvertTextAlignType(i) end

---ConvertFrameEventType
---@param i integer
---@return frameeventtype
function common.ConvertFrameEventType(i) end

---ConvertOsKeyType
---@param i integer
---@return oskeytype
function common.ConvertOsKeyType(i) end

---ConvertAbilityIntegerField
---@param i integer
---@return abilityintegerfield
function common.ConvertAbilityIntegerField(i) end

---ConvertAbilityRealField
---@param i integer
---@return abilityrealfield
function common.ConvertAbilityRealField(i) end

---ConvertAbilityBooleanField
---@param i integer
---@return abilitybooleanfield
function common.ConvertAbilityBooleanField(i) end

---ConvertAbilityStringField
---@param i integer
---@return abilitystringfield
function common.ConvertAbilityStringField(i) end

---ConvertAbilityIntegerLevelField
---@param i integer
---@return abilityintegerlevelfield
function common.ConvertAbilityIntegerLevelField(i) end

---ConvertAbilityRealLevelField
---@param i integer
---@return abilityreallevelfield
function common.ConvertAbilityRealLevelField(i) end

---ConvertAbilityBooleanLevelField
---@param i integer
---@return abilitybooleanlevelfield
function common.ConvertAbilityBooleanLevelField(i) end

---ConvertAbilityStringLevelField
---@param i integer
---@return abilitystringlevelfield
function common.ConvertAbilityStringLevelField(i) end

---ConvertAbilityIntegerLevelArrayField
---@param i integer
---@return abilityintegerlevelarrayfield
function common.ConvertAbilityIntegerLevelArrayField(i) end

---ConvertAbilityRealLevelArrayField
---@param i integer
---@return abilityreallevelarrayfield
function common.ConvertAbilityRealLevelArrayField(i) end

---ConvertAbilityBooleanLevelArrayField
---@param i integer
---@return abilitybooleanlevelarrayfield
function common.ConvertAbilityBooleanLevelArrayField(i) end

---ConvertAbilityStringLevelArrayField
---@param i integer
---@return abilitystringlevelarrayfield
function common.ConvertAbilityStringLevelArrayField(i) end

---ConvertUnitIntegerField
---@param i integer
---@return unitintegerfield
function common.ConvertUnitIntegerField(i) end

---ConvertUnitRealField
---@param i integer
---@return unitrealfield
function common.ConvertUnitRealField(i) end

---ConvertUnitBooleanField
---@param i integer
---@return unitbooleanfield
function common.ConvertUnitBooleanField(i) end

---ConvertUnitStringField
---@param i integer
---@return unitstringfield
function common.ConvertUnitStringField(i) end

---ConvertUnitWeaponIntegerField
---@param i integer
---@return unitweaponintegerfield
function common.ConvertUnitWeaponIntegerField(i) end

---ConvertUnitWeaponRealField
---@param i integer
---@return unitweaponrealfield
function common.ConvertUnitWeaponRealField(i) end

---ConvertUnitWeaponBooleanField
---@param i integer
---@return unitweaponbooleanfield
function common.ConvertUnitWeaponBooleanField(i) end

---ConvertUnitWeaponStringField
---@param i integer
---@return unitweaponstringfield
function common.ConvertUnitWeaponStringField(i) end

---ConvertItemIntegerField
---@param i integer
---@return itemintegerfield
function common.ConvertItemIntegerField(i) end

---ConvertItemRealField
---@param i integer
---@return itemrealfield
function common.ConvertItemRealField(i) end

---ConvertItemBooleanField
---@param i integer
---@return itembooleanfield
function common.ConvertItemBooleanField(i) end

---ConvertItemStringField
---@param i integer
---@return itemstringfield
function common.ConvertItemStringField(i) end

---ConvertMoveType
---@param i integer
---@return movetype
function common.ConvertMoveType(i) end

---ConvertTargetFlag
---@param i integer
---@return targetflag
function common.ConvertTargetFlag(i) end

---ConvertArmorType
---@param i integer
---@return armortype
function common.ConvertArmorType(i) end

---ConvertHeroAttribute
---@param i integer
---@return heroattribute
function common.ConvertHeroAttribute(i) end

---ConvertDefenseType
---@param i integer
---@return defensetype
function common.ConvertDefenseType(i) end

---ConvertRegenType
---@param i integer
---@return regentype
function common.ConvertRegenType(i) end

---ConvertUnitCategory
---@param i integer
---@return unitcategory
function common.ConvertUnitCategory(i) end

---ConvertPathingFlag
---@param i integer
---@return pathingflag
function common.ConvertPathingFlag(i) end

---OrderId
---@param orderIdString string
---@return integer
function common.OrderId(orderIdString) end

---OrderId2String
---@param orderId integer
---@return string
function common.OrderId2String(orderId) end

---UnitId
---@param unitIdString string
---@return integer
function common.UnitId(unitIdString) end

---UnitId2String
---@param unitId integer
---@return string
function common.UnitId2String(unitId) end

---Not currently working correctly...
---@param abilityIdString string
---@return integer
function common.AbilityId(abilityIdString) end

---AbilityId2String
---@param abilityId integer
---@return string
function common.AbilityId2String(abilityId) end

---Looks up the "name" field for any object (unit, item, ability)
---物体名称 [C]
---@param objectId integer
---@return string
function common.GetObjectName(objectId) end

---获取最大的玩家数
---@return integer
function common.GetBJMaxPlayers() end

---GetBJPlayerNeutralVictim
---@return integer
function common.GetBJPlayerNeutralVictim() end

---GetBJPlayerNeutralExtra
---@return integer
function common.GetBJPlayerNeutralExtra() end

---GetBJMaxPlayerSlots
---@return integer
function common.GetBJMaxPlayerSlots() end

---GetPlayerNeutralPassive
---@return integer
function common.GetPlayerNeutralPassive() end

---GetPlayerNeutralAggressive
---@return integer
function common.GetPlayerNeutralAggressive() end

---MathAPI
---转换 度 到 弧度
---@param degrees real
---@return real
function common.Deg2Rad(degrees) end

---转换 弧度 到 度
---@param radians real
---@return real
function common.Rad2Deg(radians) end

---正弦(弧度) [R]
---@param radians real
---@return real
function common.Sin(radians) end

---余弦(弧度) [R]
---@param radians real
---@return real
function common.Cos(radians) end

---正切(弧度) [R]
---@param radians real
---@return real
function common.Tan(radians) end

---Expect values between -1 and 1...returns 0 for invalid input
---反正弦(弧度) [R]
---@param y real
---@return real
function common.Asin(y) end

---反余弦(弧度) [R]
---@param x real
---@return real
function common.Acos(x) end

---反正切(弧度) [R]
---@param x real
---@return real
function common.Atan(x) end

---Returns 0 if x and y are both 0
---反正切(Y:X)(弧度) [R]
---@param y real
---@param x real
---@return real
function common.Atan2(y,x) end

---Returns 0 if x < 0
---平方根
---@param x real
---@return real
function common.SquareRoot(x) end

---computes x to the y power
---y  0.0             > 1
---x 0.0 and y < 0    > 0
---求幂
---@param x real
---@param power real
---@return real
function common.Pow(x,power) end

---MathRound
---@param r real
---@return integer
function common.MathRound(r) end

---String Utility API
---转换整数变量为实数
---@param i integer
---@return real
function common.I2R(i) end

---转换实数为整数
---@param r real
---@return integer
function common.R2I(r) end

---将整数转换为字符串
---@param i integer
---@return string
function common.I2S(i) end

---将实数转换为字符串
---@param r real
---@return string
function common.R2S(r) end

---将实数转换为格式化字符串
---@param r real
---@param width integer
---@param precision integer
---@return string
function common.R2SW(r,width,precision) end

---转换字串符为整数
---@param s string
---@return integer
function common.S2I(s) end

---转换字符串为实数
---@param s string
---@return real
function common.S2R(s) end

---GetHandleId
---@param h handle
---@return integer
function common.GetHandleId(h) end

---截取字符串 [R]
---@param source string
---@param start integer
---@param end_ integer
---@return string
function common.SubString(source,start,end_) end

---字串符长度
---@param s string
---@return integer
function common.StringLength(s) end

---将字串符转换为大小写字母
---@param source string
---@param upper boolean
---@return string
function common.StringCase(source,upper) end

---StringHash
---@param s string
---@return integer
function common.StringHash(s) end

---本地字符串 [R]
---@param source string
---@return string
function common.GetLocalizedString(source) end

---本地热键
---@param source string
---@return integer
function common.GetLocalizedHotkey(source) end

---SetMapName
---@param name string
function common.SetMapName(name) end

---SetMapDescription
---@param description string
function common.SetMapDescription(description) end

---SetTeams
---@param teamcount integer
function common.SetTeams(teamcount) end

---SetPlayers
---@param playercount integer
function common.SetPlayers(playercount) end

---DefineStartLocation
---@param whichStartLoc integer
---@param x real
---@param y real
function common.DefineStartLocation(whichStartLoc,x,y) end

---DefineStartLocationLoc
---@param whichStartLoc integer
---@param whichLocation location
function common.DefineStartLocationLoc(whichStartLoc,whichLocation) end

---SetStartLocPrioCount
---@param whichStartLoc integer
---@param prioSlotCount integer
function common.SetStartLocPrioCount(whichStartLoc,prioSlotCount) end

---SetStartLocPrio
---@param whichStartLoc integer
---@param prioSlotIndex integer
---@param otherStartLocIndex integer
---@param priority startlocprio
function common.SetStartLocPrio(whichStartLoc,prioSlotIndex,otherStartLocIndex,priority) end

---GetStartLocPrioSlot
---@param whichStartLoc integer
---@param prioSlotIndex integer
---@return integer
function common.GetStartLocPrioSlot(whichStartLoc,prioSlotIndex) end

---GetStartLocPrio
---@param whichStartLoc integer
---@param prioSlotIndex integer
---@return startlocprio
function common.GetStartLocPrio(whichStartLoc,prioSlotIndex) end

---SetEnemyStartLocPrioCount
---@param whichStartLoc integer
---@param prioSlotCount integer
function common.SetEnemyStartLocPrioCount(whichStartLoc,prioSlotCount) end

---SetEnemyStartLocPrio
---@param whichStartLoc integer
---@param prioSlotIndex integer
---@param otherStartLocIndex integer
---@param priority startlocprio
function common.SetEnemyStartLocPrio(whichStartLoc,prioSlotIndex,otherStartLocIndex,priority) end

---SetGameTypeSupported
---@param whichGameType gametype
---@param value boolean
function common.SetGameTypeSupported(whichGameType,value) end

---设置地图参数
---@param whichMapFlag mapflag
---@param value boolean
function common.SetMapFlag(whichMapFlag,value) end

---SetGamePlacement
---@param whichPlacementType placement
function common.SetGamePlacement(whichPlacementType) end

---设定游戏速度
---@param whichspeed gamespeed
function common.SetGameSpeed(whichspeed) end

---设置游戏难度 [R]
---@param whichdifficulty gamedifficulty
function common.SetGameDifficulty(whichdifficulty) end

---SetResourceDensity
---@param whichdensity mapdensity
function common.SetResourceDensity(whichdensity) end

---SetCreatureDensity
---@param whichdensity mapdensity
function common.SetCreatureDensity(whichdensity) end

---队伍数量
---@return integer
function common.GetTeams() end

---玩家数量
---@return integer
function common.GetPlayers() end

---IsGameTypeSupported
---@param whichGameType gametype
---@return boolean
function common.IsGameTypeSupported(whichGameType) end

---GetGameTypeSelected
---@return gametype
function common.GetGameTypeSelected() end

---地图参数
---@param whichMapFlag mapflag
---@return boolean
function common.IsMapFlagSet(whichMapFlag) end

---GetGamePlacement
---@return placement
function common.GetGamePlacement() end

---当前游戏速度
---@return gamespeed
function common.GetGameSpeed() end

---难度等级
---@return gamedifficulty
function common.GetGameDifficulty() end

---GetResourceDensity
---@return mapdensity
function common.GetResourceDensity() end

---GetCreatureDensity
---@return mapdensity
function common.GetCreatureDensity() end

---GetStartLocationX
---@param whichStartLocation integer
---@return real
function common.GetStartLocationX(whichStartLocation) end

---GetStartLocationY
---@param whichStartLocation integer
---@return real
function common.GetStartLocationY(whichStartLocation) end

---GetStartLocationLoc
---@param whichStartLocation integer
---@return location
function common.GetStartLocationLoc(whichStartLocation) end

---设置玩家队伍
---@param whichPlayer player
---@param whichTeam integer
function common.SetPlayerTeam(whichPlayer,whichTeam) end

---SetPlayerStartLocation
---@param whichPlayer player
---@param startLocIndex integer
function common.SetPlayerStartLocation(whichPlayer,startLocIndex) end

---forces player to have the specified start loc and marks the start loc as occupied
---which removes it from consideration for subsequently placed players
---( i.e. you can use this to put people in a fixed loc and then
---use random placement for any unplaced players etc )
---use random placement for any unplaced players etc )
---@param whichPlayer player
---@param startLocIndex integer
function common.ForcePlayerStartLocation(whichPlayer,startLocIndex) end

---改变玩家颜色 [R]
---@param whichPlayer player
---@param color playercolor
function common.SetPlayerColor(whichPlayer,color) end

---设置联盟状态(指定项目) [R]
---@param sourcePlayer player
---@param otherPlayer player
---@param whichAllianceSetting alliancetype
---@param value boolean
function common.SetPlayerAlliance(sourcePlayer,otherPlayer,whichAllianceSetting,value) end

---设置税率 [R]
---@param sourcePlayer player
---@param otherPlayer player
---@param whichResource playerstate
---@param rate integer
function common.SetPlayerTaxRate(sourcePlayer,otherPlayer,whichResource,rate) end

---SetPlayerRacePreference
---@param whichPlayer player
---@param whichRacePreference racepreference
function common.SetPlayerRacePreference(whichPlayer,whichRacePreference) end

---SetPlayerRaceSelectable
---@param whichPlayer player
---@param value boolean
function common.SetPlayerRaceSelectable(whichPlayer,value) end

---SetPlayerController
---@param whichPlayer player
---@param controlType mapcontrol
function common.SetPlayerController(whichPlayer,controlType) end

---设置玩家名字
---@param whichPlayer player
---@param name string
function common.SetPlayerName(whichPlayer,name) end

---显示/隐藏计分屏显示 [R]
---@param whichPlayer player
---@param flag boolean
function common.SetPlayerOnScoreScreen(whichPlayer,flag) end

---玩家在的队伍
---@param whichPlayer player
---@return integer
function common.GetPlayerTeam(whichPlayer) end

---GetPlayerStartLocation
---@param whichPlayer player
---@return integer
function common.GetPlayerStartLocation(whichPlayer) end

---玩家的颜色
---@param whichPlayer player
---@return playercolor
function common.GetPlayerColor(whichPlayer) end

---GetPlayerSelectable
---@param whichPlayer player
---@return boolean
function common.GetPlayerSelectable(whichPlayer) end

---玩家控制者
---@param whichPlayer player
---@return mapcontrol
function common.GetPlayerController(whichPlayer) end

---玩家游戏属性
---@param whichPlayer player
---@return playerslotstate
function common.GetPlayerSlotState(whichPlayer) end

---玩家税率 [R]
---@param sourcePlayer player
---@param otherPlayer player
---@param whichResource playerstate
---@return integer
function common.GetPlayerTaxRate(sourcePlayer,otherPlayer,whichResource) end

---玩家的种族选择
---@param whichPlayer player
---@param pref racepreference
---@return boolean
function common.IsPlayerRacePrefSet(whichPlayer,pref) end

---玩家名字
---@param whichPlayer player
---@return string
function common.GetPlayerName(whichPlayer) end

---Timer API
---新建计时器 [R]
---@return timer
function common.CreateTimer() end

---删除计时器 [R]
---@param whichTimer timer
function common.DestroyTimer(whichTimer) end

---运行计时器 [C]
---@param whichTimer timer
---@param timeout real
---@param periodic boolean
---@param handlerFunc code
function common.TimerStart(whichTimer,timeout,periodic,handlerFunc) end

---计时器经过的时间
---@param whichTimer timer
---@return real
function common.TimerGetElapsed(whichTimer) end

---计时器剩余时间
---@param whichTimer timer
---@return real
function common.TimerGetRemaining(whichTimer) end

---计时器初始的时间
---@param whichTimer timer
---@return real
function common.TimerGetTimeout(whichTimer) end

---暂停计时器 [R]
---@param whichTimer timer
function common.PauseTimer(whichTimer) end

---恢复计时器 [R]
---@param whichTimer timer
function common.ResumeTimer(whichTimer) end

---事件响应 - 计时器期满
---@return timer
function common.GetExpiredTimer() end

---Group API
---新建的单位组 [R]
---@return group
function common.CreateGroup() end

---删除单位组 [R]
---@param whichGroup group
function common.DestroyGroup(whichGroup) end

---添加单位 [R]
---@param whichGroup group
---@param whichUnit unit
---@return boolean
function common.GroupAddUnit(whichGroup,whichUnit) end

---移除单位 [R]
---@param whichGroup group
---@param whichUnit unit
---@return boolean
function common.GroupRemoveUnit(whichGroup,whichUnit) end

---清除
---@param whichGroup group
function common.GroupClear(whichGroup) end

---GroupEnumUnitsOfType
---@param whichGroup group
---@param unitname string
---@param filter boolexpr
function common.GroupEnumUnitsOfType(whichGroup,unitname,filter) end

---GroupEnumUnitsOfPlayer
---@param whichGroup group
---@param whichPlayer player
---@param filter boolexpr
function common.GroupEnumUnitsOfPlayer(whichGroup,whichPlayer,filter) end

---GroupEnumUnitsOfTypeCounted
---@param whichGroup group
---@param unitname string
---@param filter boolexpr
---@param countLimit integer
function common.GroupEnumUnitsOfTypeCounted(whichGroup,unitname,filter,countLimit) end

---GroupEnumUnitsInRect
---@param whichGroup group
---@param r rect
---@param filter boolexpr
function common.GroupEnumUnitsInRect(whichGroup,r,filter) end

---GroupEnumUnitsInRectCounted
---@param whichGroup group
---@param r rect
---@param filter boolexpr
---@param countLimit integer
function common.GroupEnumUnitsInRectCounted(whichGroup,r,filter,countLimit) end

---选取单位添加到单位组(坐标)
---@param whichGroup group
---@param x real
---@param y real
---@param radius real
---@param filter boolexpr
function common.GroupEnumUnitsInRange(whichGroup,x,y,radius,filter) end

---选取单位添加到单位组(点)
---@param whichGroup group
---@param whichLocation location
---@param radius real
---@param filter boolexpr
function common.GroupEnumUnitsInRangeOfLoc(whichGroup,whichLocation,radius,filter) end

---选取单位添加到单位组(坐标)(不建议使用)
---@param whichGroup group
---@param x real
---@param y real
---@param radius real
---@param filter boolexpr
---@param countLimit integer
function common.GroupEnumUnitsInRangeCounted(whichGroup,x,y,radius,filter,countLimit) end

---选取单位添加到单位组(点)(不建议使用)
---@param whichGroup group
---@param whichLocation location
---@param radius real
---@param filter boolexpr
---@param countLimit integer
function common.GroupEnumUnitsInRangeOfLocCounted(whichGroup,whichLocation,radius,filter,countLimit) end

---GroupEnumUnitsSelected
---@param whichGroup group
---@param whichPlayer player
---@param filter boolexpr
function common.GroupEnumUnitsSelected(whichGroup,whichPlayer,filter) end

---发送单位组命令到 没有目标
---@param whichGroup group
---@param order string
---@return boolean
function common.GroupImmediateOrder(whichGroup,order) end

---发布命令(无目标)(ID)
---@param whichGroup group
---@param order integer
---@return boolean
function common.GroupImmediateOrderById(whichGroup,order) end

---发布命令(指定坐标) [R]
---@param whichGroup group
---@param order string
---@param x real
---@param y real
---@return boolean
function common.GroupPointOrder(whichGroup,order,x,y) end

---发送单位组命令到 点
---@param whichGroup group
---@param order string
---@param whichLocation location
---@return boolean
function common.GroupPointOrderLoc(whichGroup,order,whichLocation) end

---发布命令(指定坐标)(ID)
---@param whichGroup group
---@param order integer
---@param x real
---@param y real
---@return boolean
function common.GroupPointOrderById(whichGroup,order,x,y) end

---发布命令(指定点)(ID)
---@param whichGroup group
---@param order integer
---@param whichLocation location
---@return boolean
function common.GroupPointOrderByIdLoc(whichGroup,order,whichLocation) end

---发送单位组命令到 单位
---@param whichGroup group
---@param order string
---@param targetWidget widget
---@return boolean
function common.GroupTargetOrder(whichGroup,order,targetWidget) end

---发布命令(指定单位)(ID)
---@param whichGroup group
---@param order integer
---@param targetWidget widget
---@return boolean
function common.GroupTargetOrderById(whichGroup,order,targetWidget) end

---This will be difficult to support with potentially disjoint, cell-based regions
---as it would involve enumerating all the cells that are covered by a particularregion
---a better implementation would be a trigger that adds relevant units as they enter
---and removes them if they leave...
---选取所有单位在单位组做 多动作
---@param whichGroup group
---@param callback code
function common.ForGroup(whichGroup,callback) end

---单位组中第一个单位
---@param whichGroup group
---@return unit
function common.FirstOfGroup(whichGroup) end

---Force API
---新建玩家组 [R]
---@return force
function common.CreateForce() end

---删除玩家组 [R]
---@param whichForce force
function common.DestroyForce(whichForce) end

---添加玩家 [R]
---@param whichForce force
---@param whichPlayer player
function common.ForceAddPlayer(whichForce,whichPlayer) end

---移除玩家 [R]
---@param whichForce force
---@param whichPlayer player
function common.ForceRemovePlayer(whichForce,whichPlayer) end

---清除玩家
---@param whichForce force
function common.ForceClear(whichForce) end

---ForceEnumPlayers
---@param whichForce force
---@param filter boolexpr
function common.ForceEnumPlayers(whichForce,filter) end

---ForceEnumPlayersCounted
---@param whichForce force
---@param filter boolexpr
---@param countLimit integer
function common.ForceEnumPlayersCounted(whichForce,filter,countLimit) end

---ForceEnumAllies
---@param whichForce force
---@param whichPlayer player
---@param filter boolexpr
function common.ForceEnumAllies(whichForce,whichPlayer,filter) end

---ForceEnumEnemies
---@param whichForce force
---@param whichPlayer player
---@param filter boolexpr
function common.ForceEnumEnemies(whichForce,whichPlayer,filter) end

---选取所有玩家在玩家组做动作(单一的)
---@param whichForce force
---@param callback code
function common.ForForce(whichForce,callback) end

---Region and Location API
---将坐标转换为区域
---@param minx real
---@param miny real
---@param maxx real
---@param maxy real
---@return rect
function common.Rect(minx,miny,maxx,maxy) end

---将点转换为区域
---@param min location
---@param max location
---@return rect
function common.RectFromLoc(min,max) end

---删除矩形区域 [R]
---@param whichRect rect
function common.RemoveRect(whichRect) end

---设置矩形区域(指定坐标) [R]
---@param whichRect rect
---@param minx real
---@param miny real
---@param maxx real
---@param maxy real
function common.SetRect(whichRect,minx,miny,maxx,maxy) end

---设置矩形区域(指定点) [R]
---@param whichRect rect
---@param min location
---@param max location
function common.SetRectFromLoc(whichRect,min,max) end

---移动矩形区域(指定坐标) [R]
---@param whichRect rect
---@param newCenterX real
---@param newCenterY real
function common.MoveRectTo(whichRect,newCenterX,newCenterY) end

---移动区域
---@param whichRect rect
---@param newCenterLoc location
function common.MoveRectToLoc(whichRect,newCenterLoc) end

---区域中心的 X 坐标
---@param whichRect rect
---@return real
function common.GetRectCenterX(whichRect) end

---区域中心的 Y 坐标
---@param whichRect rect
---@return real
function common.GetRectCenterY(whichRect) end

---区域最小 X 坐标
---@param whichRect rect
---@return real
function common.GetRectMinX(whichRect) end

---区域最小 Y 坐标
---@param whichRect rect
---@return real
function common.GetRectMinY(whichRect) end

---区域最大 X 坐标
---@param whichRect rect
---@return real
function common.GetRectMaxX(whichRect) end

---区域最大 Y 坐标
---@param whichRect rect
---@return real
function common.GetRectMaxY(whichRect) end

---新建区域 [R]
---@return region
function common.CreateRegion() end

---删除不规则区域 [R]
---@param whichRegion region
function common.RemoveRegion(whichRegion) end

---添加区域 [R]
---@param whichRegion region
---@param r rect
function common.RegionAddRect(whichRegion,r) end

---移除区域 [R]
---@param whichRegion region
---@param r rect
function common.RegionClearRect(whichRegion,r) end

---添加单元点(指定坐标) [R]
---@param whichRegion region
---@param x real
---@param y real
function common.RegionAddCell(whichRegion,x,y) end

---添加单元点(指定点) [R]
---@param whichRegion region
---@param whichLocation location
function common.RegionAddCellAtLoc(whichRegion,whichLocation) end

---移除单元点(指定坐标) [R]
---@param whichRegion region
---@param x real
---@param y real
function common.RegionClearCell(whichRegion,x,y) end

---移除单元点(指定点) [R]
---@param whichRegion region
---@param whichLocation location
function common.RegionClearCellAtLoc(whichRegion,whichLocation) end

---转换坐标到点
---@param x real
---@param y real
---@return location
function common.Location(x,y) end

---清除点 [R]
---@param whichLocation location
function common.RemoveLocation(whichLocation) end

---移动点 [R]
---@param whichLocation location
---@param newX real
---@param newY real
function common.MoveLocation(whichLocation,newX,newY) end

---X 坐标
---@param whichLocation location
---@return real
function common.GetLocationX(whichLocation) end

---Y 坐标
---@param whichLocation location
---@return real
function common.GetLocationY(whichLocation) end

---This function is asynchronous. The values it returns are not guaranteed synchronous between each player.
---If you attempt to use it in a synchronous manner, it may cause a desync.
---点的Z轴高度 [R]
---@param whichLocation location
---@return real
function common.GetLocationZ(whichLocation) end

---单位检查
---@param whichRegion region
---@param whichUnit unit
---@return boolean
function common.IsUnitInRegion(whichRegion,whichUnit) end

---包含坐标
---@param whichRegion region
---@param x real
---@param y real
---@return boolean
function common.IsPointInRegion(whichRegion,x,y) end

---包含点
---@param whichRegion region
---@param whichLocation location
---@return boolean
function common.IsLocationInRegion(whichRegion,whichLocation) end

---Returns full map bounds, including unplayable borders, in world coordinates
---Returns full map bounds, including unplayable borders, in world coordinates
---@return rect
function common.GetWorldBounds() end

---Native trigger interface
---新建触发 [R]
---@return trigger
function common.CreateTrigger() end

---删除触发器 [R]
---@param whichTrigger trigger
function common.DestroyTrigger(whichTrigger) end

---ResetTrigger
---@param whichTrigger trigger
function common.ResetTrigger(whichTrigger) end

---打开触发器
---@param whichTrigger trigger
function common.EnableTrigger(whichTrigger) end

---关掉触发器
---@param whichTrigger trigger
function common.DisableTrigger(whichTrigger) end

---触发器打开
---@param whichTrigger trigger
---@return boolean
function common.IsTriggerEnabled(whichTrigger) end

---TriggerWaitOnSleeps
---@param whichTrigger trigger
---@param flag boolean
function common.TriggerWaitOnSleeps(whichTrigger,flag) end

---IsTriggerWaitOnSleeps
---@param whichTrigger trigger
---@return boolean
function common.IsTriggerWaitOnSleeps(whichTrigger) end

---匹配的单位
---@return unit
function common.GetFilterUnit() end

---选取的单位
---@return unit
function common.GetEnumUnit() end

---匹配的可毁坏物
---@return destructable
function common.GetFilterDestructable() end

---选取的可毁坏物
---@return destructable
function common.GetEnumDestructable() end

---匹配的物品
---@return item
function common.GetFilterItem() end

---选取的物品
---@return item
function common.GetEnumItem() end

---ParseTags
---@param taggedString string
---@return string
function common.ParseTags(taggedString) end

---匹配的玩家
---@return player
function common.GetFilterPlayer() end

---选取的玩家
---@return player
function common.GetEnumPlayer() end

---当前触发器
---@return trigger
function common.GetTriggeringTrigger() end

---GetTriggerEventId
---@return eventid
function common.GetTriggerEventId() end

---触发器赋值统计
---@param whichTrigger trigger
---@return integer
function common.GetTriggerEvalCount(whichTrigger) end

---触发器运行次数统计
---@param whichTrigger trigger
---@return integer
function common.GetTriggerExecCount(whichTrigger) end

---运行函数 [R]
---@param funcName string
function common.ExecuteFunc(funcName) end

---Boolean Expr API ( for compositing trigger conditions and unit filter funcs...)
---@param operandA boolexpr
---@param operandB boolexpr
---@return boolexpr
function common.And(operandA,operandB) end

---Or
---@param operandA boolexpr
---@param operandB boolexpr
---@return boolexpr
function common.Or(operandA,operandB) end

---Not
---@param operand boolexpr
---@return boolexpr
function common.Not(operand) end

---限制条件为
---@param func code
---@return conditionfunc
function common.Condition(func) end

---DestroyCondition
---@param c conditionfunc
function common.DestroyCondition(c) end

---Filter
---@param func code
---@return filterfunc
function common.Filter(func) end

---DestroyFilter
---@param f filterfunc
function common.DestroyFilter(f) end

---DestroyBoolExpr
---@param e boolexpr
function common.DestroyBoolExpr(e) end

---变量的值
---@param whichTrigger trigger
---@param varName string
---@param opcode limitop
---@param limitval real
---@return event
function common.TriggerRegisterVariableEvent(whichTrigger,varName,opcode,limitval) end

---Creates it's own timer and triggers when it expires
---Creates it's own timer and triggers when it expires
---@param whichTrigger trigger
---@param timeout real
---@param periodic boolean
---@return event
function common.TriggerRegisterTimerEvent(whichTrigger,timeout,periodic) end

---Triggers when the timer you tell it about expires
---Triggers when the timer you tell it about expires
---@param whichTrigger trigger
---@param t timer
---@return event
function common.TriggerRegisterTimerExpireEvent(whichTrigger,t) end

---TriggerRegisterGameStateEvent
---@param whichTrigger trigger
---@param whichState gamestate
---@param opcode limitop
---@param limitval real
---@return event
function common.TriggerRegisterGameStateEvent(whichTrigger,whichState,opcode,limitval) end

---TriggerRegisterDialogEvent
---@param whichTrigger trigger
---@param whichDialog dialog
---@return event
function common.TriggerRegisterDialogEvent(whichTrigger,whichDialog) end

---对话框按钮被点击 [R]
---@param whichTrigger trigger
---@param whichButton button
---@return event
function common.TriggerRegisterDialogButtonEvent(whichTrigger,whichButton) end

---EVENT_GAME_STATE_LIMIT
---EVENT_GAME_STATE_LIMIT
---@return gamestate
function common.GetEventGameState() end

---比赛游戏事件
---@param whichTrigger trigger
---@param whichGameEvent gameevent
---@return event
function common.TriggerRegisterGameEvent(whichTrigger,whichGameEvent) end

---EVENT_GAME_VICTORY
---EVENT_GAME_VICTORY
---@return player
function common.GetWinningPlayer() end

---单位进入不规则区域(指定条件) [R]
---@param whichTrigger trigger
---@param whichRegion region
---@param filter boolexpr
---@return event
function common.TriggerRegisterEnterRegion(whichTrigger,whichRegion,filter) end

---EVENT_GAME_ENTER_REGION
---触发区域 [R]
---@return region
function common.GetTriggeringRegion() end

---正在进入的单位
---@return unit
function common.GetEnteringUnit() end

---单位离开不规则区域(指定条件) [R]
---@param whichTrigger trigger
---@param whichRegion region
---@param filter boolexpr
---@return event
function common.TriggerRegisterLeaveRegion(whichTrigger,whichRegion,filter) end

---正在离开的单位
---@return unit
function common.GetLeavingUnit() end

---鼠标点击可追踪物 [R]
---@param whichTrigger trigger
---@param t trackable
---@return event
function common.TriggerRegisterTrackableHitEvent(whichTrigger,t) end

---鼠标移动到追踪对象 [R]
---@param whichTrigger trigger
---@param t trackable
---@return event
function common.TriggerRegisterTrackableTrackEvent(whichTrigger,t) end

---EVENT_COMMAND_BUTTON_CLICK
---EVENT_COMMAND_BUTTON_CLICK
---@param whichTrigger trigger
---@param whichAbility integer
---@param order string
---@return event
function common.TriggerRegisterCommandEvent(whichTrigger,whichAbility,order) end

---TriggerRegisterUpgradeCommandEvent
---@param whichTrigger trigger
---@param whichUpgrade integer
---@return event
function common.TriggerRegisterUpgradeCommandEvent(whichTrigger,whichUpgrade) end

---EVENT_GAME_TRACKABLE_HIT
---EVENT_GAME_TRACKABLE_TRACK
---事件响应 - 触发可追踪物 [R]
---@return trackable
function common.GetTriggeringTrackable() end

---EVENT_DIALOG_BUTTON_CLICK
---EVENT_DIALOG_BUTTON_CLICK
---@return button
function common.GetClickedButton() end

---GetClickedDialog
---@return dialog
function common.GetClickedDialog() end

---EVENT_GAME_TOURNAMENT_FINISH_SOON
---比赛剩余时间
---@return real
function common.GetTournamentFinishSoonTimeRemaining() end

---比赛结束规则
---@return integer
function common.GetTournamentFinishNowRule() end

---GetTournamentFinishNowPlayer
---@return player
function common.GetTournamentFinishNowPlayer() end

---对战比赛得分
---@param whichPlayer player
---@return integer
function common.GetTournamentScore(whichPlayer) end

---EVENT_GAME_SAVE
---储存游戏文件名
---@return string
function common.GetSaveBasicFilename() end

---TriggerRegisterPlayerEvent
---@param whichTrigger trigger
---@param whichPlayer player
---@param whichPlayerEvent playerevent
---@return event
function common.TriggerRegisterPlayerEvent(whichTrigger,whichPlayer,whichPlayerEvent) end

---EVENT_PLAYER_DEFEAT
---EVENT_PLAYER_VICTORY
---触发玩家
---@return player
function common.GetTriggerPlayer() end

---TriggerRegisterPlayerUnitEvent
---@param whichTrigger trigger
---@param whichPlayer player
---@param whichPlayerUnitEvent playerunitevent
---@param filter boolexpr
---@return event
function common.TriggerRegisterPlayerUnitEvent(whichTrigger,whichPlayer,whichPlayerUnitEvent,filter) end

---EVENT_PLAYER_HERO_LEVEL
---EVENT_UNIT_HERO_LEVEL
---英雄升级
---@return unit
function common.GetLevelingUnit() end

---EVENT_PLAYER_HERO_SKILL
---EVENT_UNIT_HERO_SKILL
---学习技能的英雄
---@return unit
function common.GetLearningUnit() end

---学习技能 [R]
---@return integer
function common.GetLearnedSkill() end

---学习的技能的等级
---@return integer
function common.GetLearnedSkillLevel() end

---EVENT_PLAYER_HERO_REVIVABLE
---可复活的英雄
---@return unit
function common.GetRevivableUnit() end

---EVENT_PLAYER_HERO_REVIVE_START
---EVENT_PLAYER_HERO_REVIVE_CANCEL
---EVENT_PLAYER_HERO_REVIVE_FINISH
---EVENT_UNIT_HERO_REVIVE_START
---EVENT_UNIT_HERO_REVIVE_CANCEL
---EVENT_UNIT_HERO_REVIVE_FINISH
---复活英雄
---@return unit
function common.GetRevivingUnit() end

---EVENT_PLAYER_UNIT_ATTACKED
---攻击的单位
---@return unit
function common.GetAttacker() end

---EVENT_PLAYER_UNIT_RESCUED
---EVENT_PLAYER_UNIT_RESCUED
---@return unit
function common.GetRescuer() end

---EVENT_PLAYER_UNIT_DEATH
---垂死的单位
---@return unit
function common.GetDyingUnit() end

---GetKillingUnit
---@return unit
function common.GetKillingUnit() end

---EVENT_PLAYER_UNIT_DECAY
---尸体腐烂单位
---@return unit
function common.GetDecayingUnit() end

---EVENT_PLAYER_UNIT_CONSTRUCT_START
---正在建造的建筑
---@return unit
function common.GetConstructingStructure() end

---EVENT_PLAYER_UNIT_CONSTRUCT_FINISH
---EVENT_PLAYER_UNIT_CONSTRUCT_CANCEL
---取消建造中的建筑
---@return unit
function common.GetCancelledStructure() end

---已建造的建筑
---@return unit
function common.GetConstructedStructure() end

---EVENT_PLAYER_UNIT_RESEARCH_START
---EVENT_PLAYER_UNIT_RESEARCH_CANCEL
---EVENT_PLAYER_UNIT_RESEARCH_FINISH
---研究科技单位
---@return unit
function common.GetResearchingUnit() end

---研究的 科技-类型
---@return integer
function common.GetResearched() end

---EVENT_PLAYER_UNIT_TRAIN_START
---EVENT_PLAYER_UNIT_TRAIN_CANCEL
---EVENT_PLAYER_UNIT_TRAIN_FINISH
---EVENT_PLAYER_UNIT_TRAIN_FINISH
---@return integer
function common.GetTrainedUnitType() end

---EVENT_PLAYER_UNIT_TRAIN_FINISH
---@return unit
function common.GetTrainedUnit() end

---EVENT_PLAYER_UNIT_DETECTED
---EVENT_PLAYER_UNIT_DETECTED
---@return unit
function common.GetDetectedUnit() end

---EVENT_PLAYER_UNIT_SUMMONED
---正在召唤的单位
---@return unit
function common.GetSummoningUnit() end

---已召唤单位
---@return unit
function common.GetSummonedUnit() end

---EVENT_PLAYER_UNIT_LOADED
---EVENT_PLAYER_UNIT_LOADED
---@return unit
function common.GetTransportUnit() end

---GetLoadedUnit
---@return unit
function common.GetLoadedUnit() end

---EVENT_PLAYER_UNIT_SELL
---出售单位
---@return unit
function common.GetSellingUnit() end

---被出售单位
---@return unit
function common.GetSoldUnit() end

---在购买的单位
---@return unit
function common.GetBuyingUnit() end

---EVENT_PLAYER_UNIT_SELL_ITEM
---卖出的物品
---@return item
function common.GetSoldItem() end

---EVENT_PLAYER_UNIT_CHANGE_OWNER
---改变了所有者的单位
---@return unit
function common.GetChangingUnit() end

---前一个所有者
---@return player
function common.GetChangingUnitPrevOwner() end

---EVENT_PLAYER_UNIT_DROP_ITEM
---EVENT_PLAYER_UNIT_PICKUP_ITEM
---EVENT_PLAYER_UNIT_USE_ITEM
---英雄操作物品
---@return unit
function common.GetManipulatingUnit() end

---物品存在操作
---@return item
function common.GetManipulatedItem() end

---EVENT_PLAYER_UNIT_ISSUED_ORDER
---收到命令的单位
---@return unit
function common.GetOrderedUnit() end

---GetIssuedOrderId
---@return integer
function common.GetIssuedOrderId() end

---EVENT_PLAYER_UNIT_ISSUED_POINT_ORDER
---命令发布点X坐标 [R]
---@return real
function common.GetOrderPointX() end

---命令发布点Y坐标 [R]
---@return real
function common.GetOrderPointY() end

---目标的位置
---@return location
function common.GetOrderPointLoc() end

---EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER
---EVENT_PLAYER_UNIT_ISSUED_TARGET_ORDER
---@return widget
function common.GetOrderTarget() end

---目标的可毁坏物
---@return destructable
function common.GetOrderTargetDestructable() end

---目标的物品
---@return item
function common.GetOrderTargetItem() end

---目标的单位
---@return unit
function common.GetOrderTargetUnit() end

---EVENT_UNIT_SPELL_CHANNEL
---EVENT_UNIT_SPELL_CAST
---EVENT_UNIT_SPELL_EFFECT
---EVENT_UNIT_SPELL_FINISH
---EVENT_UNIT_SPELL_ENDCAST
---EVENT_PLAYER_UNIT_SPELL_CHANNEL
---EVENT_PLAYER_UNIT_SPELL_CAST
---EVENT_PLAYER_UNIT_SPELL_EFFECT
---EVENT_PLAYER_UNIT_SPELL_FINISH
---EVENT_PLAYER_UNIT_SPELL_ENDCAST
---技能单位
---@return unit
function common.GetSpellAbilityUnit() end

---使用的技能
---@return integer
function common.GetSpellAbilityId() end

---使用的技能
---@return ability
function common.GetSpellAbility() end

---对其使用技能的目标点
---@return location
function common.GetSpellTargetLoc() end

---GetSpellTargetX
---@return real
function common.GetSpellTargetX() end

---GetSpellTargetY
---@return real
function common.GetSpellTargetY() end

---对其使用技能的目标可毁坏物
---@return destructable
function common.GetSpellTargetDestructable() end

---对其使用技能的目标物品
---@return item
function common.GetSpellTargetItem() end

---对其使用技能的目标单位
---@return unit
function common.GetSpellTargetUnit() end

---联盟状态改变(特殊)
---@param whichTrigger trigger
---@param whichPlayer player
---@param whichAlliance alliancetype
---@return event
function common.TriggerRegisterPlayerAllianceChange(whichTrigger,whichPlayer,whichAlliance) end

---属性
---@param whichTrigger trigger
---@param whichPlayer player
---@param whichState playerstate
---@param opcode limitop
---@param limitval real
---@return event
function common.TriggerRegisterPlayerStateEvent(whichTrigger,whichPlayer,whichState,opcode,limitval) end

---EVENT_PLAYER_STATE_LIMIT
---EVENT_PLAYER_STATE_LIMIT
---@return playerstate
function common.GetEventPlayerState() end

---玩家输入聊天信息
---@param whichTrigger trigger
---@param whichPlayer player
---@param chatMessageToDetect string
---@param exactMatchOnly boolean
---@return event
function common.TriggerRegisterPlayerChatEvent(whichTrigger,whichPlayer,chatMessageToDetect,exactMatchOnly) end

---returns the actual string they typed in ( same as what you registered for
---if you required exact match )
---输入的聊天字符
---@return string
function common.GetEventPlayerChatString() end

---returns the string that you registered for
---匹配的聊天字符
---@return string
function common.GetEventPlayerChatStringMatched() end

---可毁坏物死亡
---@param whichTrigger trigger
---@param whichWidget widget
---@return event
function common.TriggerRegisterDeathEvent(whichTrigger,whichWidget) end

---触发单位
---@return unit
function common.GetTriggerUnit() end

---TriggerRegisterUnitStateEvent
---@param whichTrigger trigger
---@param whichUnit unit
---@param whichState unitstate
---@param opcode limitop
---@param limitval real
---@return event
function common.TriggerRegisterUnitStateEvent(whichTrigger,whichUnit,whichState,opcode,limitval) end

---EVENT_UNIT_STATE_LIMIT
---EVENT_UNIT_STATE_LIMIT
---获取单位状态
---@return unitstate
function common.GetEventUnitState() end

---详细单位的事件
---@param whichTrigger trigger
---@param whichUnit unit
---@param whichEvent unitevent
---@return event
function common.TriggerRegisterUnitEvent(whichTrigger,whichUnit,whichEvent) end

---EVENT_UNIT_DAMAGED
---被伤害的生命值
---@return real
function common.GetEventDamage() end

---伤害来源
---@return unit
function common.GetEventDamageSource() end

---EVENT_UNIT_DETECTED
---EVENT_UNIT_DETECTED
---@return player
function common.GetEventDetectingPlayer() end

---TriggerRegisterFilterUnitEvent
---@param whichTrigger trigger
---@param whichUnit unit
---@param whichEvent unitevent
---@param filter boolexpr
---@return event
function common.TriggerRegisterFilterUnitEvent(whichTrigger,whichUnit,whichEvent,filter) end

---EVENT_UNIT_ACQUIRED_TARGET
---EVENT_UNIT_TARGET_IN_RANGE
---目标单位
---@return unit
function common.GetEventTargetUnit() end

---TriggerRegisterUnitInRange
---@param whichTrigger trigger
---@param whichUnit unit
---@param range real
---@param filter boolexpr
---@return event
function common.TriggerRegisterUnitInRange(whichTrigger,whichUnit,range,filter) end

---添加触发器限制条件
---@param whichTrigger trigger
---@param condition boolexpr
---@return triggercondition
function common.TriggerAddCondition(whichTrigger,condition) end

---TriggerRemoveCondition
---@param whichTrigger trigger
---@param whichCondition triggercondition
function common.TriggerRemoveCondition(whichTrigger,whichCondition) end

---TriggerClearConditions
---@param whichTrigger trigger
function common.TriggerClearConditions(whichTrigger) end

---添加触发器动作
---@param whichTrigger trigger
---@param actionFunc code
---@return triggeraction
function common.TriggerAddAction(whichTrigger,actionFunc) end

---TriggerRemoveAction
---@param whichTrigger trigger
---@param whichAction triggeraction
function common.TriggerRemoveAction(whichTrigger,whichAction) end

---TriggerClearActions
---@param whichTrigger trigger
function common.TriggerClearActions(whichTrigger) end

---等待
---@param timeout real
function common.TriggerSleepAction(timeout) end

---TriggerWaitForSound
---@param s sound
---@param offset real
function common.TriggerWaitForSound(s,offset) end

---触发器条件成立
---@param whichTrigger trigger
---@return boolean
function common.TriggerEvaluate(whichTrigger) end

---运行触发器 (忽略条件)
---@param whichTrigger trigger
function common.TriggerExecute(whichTrigger) end

---TriggerExecuteWait
---@param whichTrigger trigger
function common.TriggerExecuteWait(whichTrigger) end

---TriggerSyncStart
function common.TriggerSyncStart() end

---TriggerSyncReady
function common.TriggerSyncReady() end

---Widget API
---Widget API
---@param whichWidget widget
---@return real
function common.GetWidgetLife(whichWidget) end

---SetWidgetLife
---@param whichWidget widget
---@param newLife real
function common.SetWidgetLife(whichWidget,newLife) end

---GetWidgetX
---@param whichWidget widget
---@return real
function common.GetWidgetX(whichWidget) end

---GetWidgetY
---@param whichWidget widget
---@return real
function common.GetWidgetY(whichWidget) end

---GetTriggerWidget
---@return widget
function common.GetTriggerWidget() end

---Destructable Object API
---Facing arguments are specified in degrees
---Facing arguments are specified in degrees
---@param objectid integer
---@param x real
---@param y real
---@param face real
---@param scale real
---@param variation integer
---@return destructable
function common.CreateDestructable(objectid,x,y,face,scale,variation) end

---新建可破坏物 [R]
---@param objectid integer
---@param x real
---@param y real
---@param z real
---@param face real
---@param scale real
---@param variation integer
---@return destructable
function common.CreateDestructableZ(objectid,x,y,z,face,scale,variation) end

---CreateDeadDestructable
---@param objectid integer
---@param x real
---@param y real
---@param face real
---@param scale real
---@param variation integer
---@return destructable
function common.CreateDeadDestructable(objectid,x,y,face,scale,variation) end

---新建可破坏物(死亡的) [R]
---@param objectid integer
---@param x real
---@param y real
---@param z real
---@param face real
---@param scale real
---@param variation integer
---@return destructable
function common.CreateDeadDestructableZ(objectid,x,y,z,face,scale,variation) end

---删除 可毁坏物
---@param d destructable
function common.RemoveDestructable(d) end

---杀死 可毁坏物
---@param d destructable
function common.KillDestructable(d) end

---SetDestructableInvulnerable
---@param d destructable
---@param flag boolean
function common.SetDestructableInvulnerable(d,flag) end

---IsDestructableInvulnerable
---@param d destructable
---@return boolean
function common.IsDestructableInvulnerable(d) end

---EnumDestructablesInRect
---@param r rect
---@param filter boolexpr
---@param actionFunc code
function common.EnumDestructablesInRect(r,filter,actionFunc) end

---建筑的类型
---@param d destructable
---@return integer
function common.GetDestructableTypeId(d) end

---可破坏物所在X轴坐标 [R]
---@param d destructable
---@return real
function common.GetDestructableX(d) end

---可破坏物所在Y轴坐标 [R]
---@param d destructable
---@return real
function common.GetDestructableY(d) end

---设置 可毁坏物 生命 (值)
---@param d destructable
---@param life real
function common.SetDestructableLife(d,life) end

---生命值 (可毁坏物)
---@param d destructable
---@return real
function common.GetDestructableLife(d) end

---SetDestructableMaxLife
---@param d destructable
---@param max real
function common.SetDestructableMaxLife(d,max) end

---最大生命值 (可毁坏物)
---@param d destructable
---@return real
function common.GetDestructableMaxLife(d) end

---复活 可毁坏物
---@param d destructable
---@param life real
---@param birth boolean
function common.DestructableRestoreLife(d,life,birth) end

---QueueDestructableAnimation
---@param d destructable
---@param whichAnimation string
function common.QueueDestructableAnimation(d,whichAnimation) end

---SetDestructableAnimation
---@param d destructable
---@param whichAnimation string
function common.SetDestructableAnimation(d,whichAnimation) end

---改变可破坏物动画播放速度 [R]
---@param d destructable
---@param speedFactor real
function common.SetDestructableAnimationSpeed(d,speedFactor) end

---显示/隐藏 [R]
---@param d destructable
---@param flag boolean
function common.ShowDestructable(d,flag) end

---闭塞高度 (可毁坏物)
---@param d destructable
---@return real
function common.GetDestructableOccluderHeight(d) end

---设置闭塞高度
---@param d destructable
---@param height real
function common.SetDestructableOccluderHeight(d,height) end

---可毁坏物的名字
---@param d destructable
---@return string
function common.GetDestructableName(d) end

---GetTriggerDestructable
---@return destructable
function common.GetTriggerDestructable() end

---Item API
---创建
---@param itemid integer
---@param x real
---@param y real
---@return item
function common.CreateItem(itemid,x,y) end

---删除物品
---@param whichItem item
function common.RemoveItem(whichItem) end

---物品的所有者
---@param whichItem item
---@return player
function common.GetItemPlayer(whichItem) end

---物品的类别
---@param i item
---@return integer
function common.GetItemTypeId(i) end

---物品的X轴坐标 [R]
---@param i item
---@return real
function common.GetItemX(i) end

---物品的Y轴坐标 [R]
---@param i item
---@return real
function common.GetItemY(i) end

---移动物品到坐标(立即)(指定坐标) [R]
---@param i item
---@param x real
---@param y real
function common.SetItemPosition(i,x,y) end

---SetItemDropOnDeath
---@param whichItem item
---@param flag boolean
function common.SetItemDropOnDeath(whichItem,flag) end

---SetItemDroppable
---@param i item
---@param flag boolean
function common.SetItemDroppable(i,flag) end

---设置物品能否变卖
---@param i item
---@param flag boolean
function common.SetItemPawnable(i,flag) end

---SetItemPlayer
---@param whichItem item
---@param whichPlayer player
---@param changeColor boolean
function common.SetItemPlayer(whichItem,whichPlayer,changeColor) end

---SetItemInvulnerable
---@param whichItem item
---@param flag boolean
function common.SetItemInvulnerable(whichItem,flag) end

---物品是无敌的
---@param whichItem item
---@return boolean
function common.IsItemInvulnerable(whichItem) end

---显示/隐藏 [R]
---@param whichItem item
---@param show boolean
function common.SetItemVisible(whichItem,show) end

---物品可见 [R]
---@param whichItem item
---@return boolean
function common.IsItemVisible(whichItem) end

---物品所有者
---@param whichItem item
---@return boolean
function common.IsItemOwned(whichItem) end

---物品是拾取时自动使用的 [R]
---@param whichItem item
---@return boolean
function common.IsItemPowerup(whichItem) end

---物品可被市场随机出售 [R]
---@param whichItem item
---@return boolean
function common.IsItemSellable(whichItem) end

---物品可被抵押 [R]
---@param whichItem item
---@return boolean
function common.IsItemPawnable(whichItem) end

---IsItemIdPowerup
---@param itemId integer
---@return boolean
function common.IsItemIdPowerup(itemId) end

---IsItemIdSellable
---@param itemId integer
---@return boolean
function common.IsItemIdSellable(itemId) end

---IsItemIdPawnable
---@param itemId integer
---@return boolean
function common.IsItemIdPawnable(itemId) end

---EnumItemsInRect
---@param r rect
---@param filter boolexpr
---@param actionFunc code
function common.EnumItemsInRect(r,filter,actionFunc) end

---物品等级
---@param whichItem item
---@return integer
function common.GetItemLevel(whichItem) end

---GetItemType
---@param whichItem item
---@return itemtype
function common.GetItemType(whichItem) end

---设置重生神符的产生单位类型
---@param whichItem item
---@param unitId integer
function common.SetItemDropID(whichItem,unitId) end

---物品名
---@param whichItem item
---@return string
function common.GetItemName(whichItem) end

---物品的数量
---@param whichItem item
---@return integer
function common.GetItemCharges(whichItem) end

---设置物品数量[使用次数]
---@param whichItem item
---@param charges integer
function common.SetItemCharges(whichItem,charges) end

---物品自定义值
---@param whichItem item
---@return integer
function common.GetItemUserData(whichItem) end

---设置物品自定义数据
---@param whichItem item
---@param data integer
function common.SetItemUserData(whichItem,data) end

---Unit API
---Facing arguments are specified in degrees
---新建单位(指定坐标) [R]
---@param id player
---@param unitid integer
---@param x real
---@param y real
---@param face real
---@return unit
function common.CreateUnit(id,unitid,x,y,face) end

---CreateUnitByName
---@param whichPlayer player
---@param unitname string
---@param x real
---@param y real
---@param face real
---@return unit
function common.CreateUnitByName(whichPlayer,unitname,x,y,face) end

---新建单位(指定点) [R]
---@param id player
---@param unitid integer
---@param whichLocation location
---@param face real
---@return unit
function common.CreateUnitAtLoc(id,unitid,whichLocation,face) end

---CreateUnitAtLocByName
---@param id player
---@param unitname string
---@param whichLocation location
---@param face real
---@return unit
function common.CreateUnitAtLocByName(id,unitname,whichLocation,face) end

---新建尸体 [R]
---@param whichPlayer player
---@param unitid integer
---@param x real
---@param y real
---@param face real
---@return unit
function common.CreateCorpse(whichPlayer,unitid,x,y,face) end

---杀死单位
---@param whichUnit unit
function common.KillUnit(whichUnit) end

---删除单位
---@param whichUnit unit
function common.RemoveUnit(whichUnit) end

---显示/隐藏 [R]
---@param whichUnit unit
---@param show boolean
function common.ShowUnit(whichUnit,show) end

---设置单位属性 [R]
---@param whichUnit unit
---@param whichUnitState unitstate
---@param newVal real
function common.SetUnitState(whichUnit,whichUnitState,newVal) end

---设置X坐标 [R]
---@param whichUnit unit
---@param newX real
function common.SetUnitX(whichUnit,newX) end

---设置Y坐标 [R]
---@param whichUnit unit
---@param newY real
function common.SetUnitY(whichUnit,newY) end

---移动单位(立即)(指定坐标) [R]
---@param whichUnit unit
---@param newX real
---@param newY real
function common.SetUnitPosition(whichUnit,newX,newY) end

---移动单位 (立刻)
---@param whichUnit unit
---@param whichLocation location
function common.SetUnitPositionLoc(whichUnit,whichLocation) end

---设置单位面向角度 [R]
---@param whichUnit unit
---@param facingAngle real
function common.SetUnitFacing(whichUnit,facingAngle) end

---设置单位面对角度
---@param whichUnit unit
---@param facingAngle real
---@param duration real
function common.SetUnitFacingTimed(whichUnit,facingAngle,duration) end

---设置单位移动速度
---@param whichUnit unit
---@param newSpeed real
function common.SetUnitMoveSpeed(whichUnit,newSpeed) end

---SetUnitFlyHeight
---@param whichUnit unit
---@param newHeight real
---@param rate real
function common.SetUnitFlyHeight(whichUnit,newHeight,rate) end

---SetUnitTurnSpeed
---@param whichUnit unit
---@param newTurnSpeed real
function common.SetUnitTurnSpeed(whichUnit,newTurnSpeed) end

---改变单位转向角度(弧度制) [R]
---@param whichUnit unit
---@param newPropWindowAngle real
function common.SetUnitPropWindow(whichUnit,newPropWindowAngle) end

---SetUnitAcquireRange
---@param whichUnit unit
---@param newAcquireRange real
function common.SetUnitAcquireRange(whichUnit,newAcquireRange) end

---锁定指定单位的警戒点 [R]
---@param whichUnit unit
---@param creepGuard boolean
function common.SetUnitCreepGuard(whichUnit,creepGuard) end

---单位射程 (当前)
---@param whichUnit unit
---@return real
function common.GetUnitAcquireRange(whichUnit) end

---转向速度 (当前)
---@param whichUnit unit
---@return real
function common.GetUnitTurnSpeed(whichUnit) end

---当前转向角度(弧度制) [R]
---@param whichUnit unit
---@return real
function common.GetUnitPropWindow(whichUnit) end

---飞行高度 (当前)
---@param whichUnit unit
---@return real
function common.GetUnitFlyHeight(whichUnit) end

---单位射程 (默认)
---@param whichUnit unit
---@return real
function common.GetUnitDefaultAcquireRange(whichUnit) end

---转向速度 (默认)
---@param whichUnit unit
---@return real
function common.GetUnitDefaultTurnSpeed(whichUnit) end

---GetUnitDefaultPropWindow
---@param whichUnit unit
---@return real
function common.GetUnitDefaultPropWindow(whichUnit) end

---飞行高度 (默认)
---@param whichUnit unit
---@return real
function common.GetUnitDefaultFlyHeight(whichUnit) end

---改变单位所有者
---@param whichUnit unit
---@param whichPlayer player
---@param changeColor boolean
function common.SetUnitOwner(whichUnit,whichPlayer,changeColor) end

---改变单位颜色
---@param whichUnit unit
---@param whichColor playercolor
function common.SetUnitColor(whichUnit,whichColor) end

---改变单位尺寸(按倍数) [R]
---@param whichUnit unit
---@param scaleX real
---@param scaleY real
---@param scaleZ real
function common.SetUnitScale(whichUnit,scaleX,scaleY,scaleZ) end

---改变单位动画播放速度(按倍数) [R]
---@param whichUnit unit
---@param timeScale real
function common.SetUnitTimeScale(whichUnit,timeScale) end

---SetUnitBlendTime
---@param whichUnit unit
---@param blendTime real
function common.SetUnitBlendTime(whichUnit,blendTime) end

---改变单位的颜色(RGB:0-255) [R]
---@param whichUnit unit
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function common.SetUnitVertexColor(whichUnit,red,green,blue,alpha) end

---QueueUnitAnimation
---@param whichUnit unit
---@param whichAnimation string
function common.QueueUnitAnimation(whichUnit,whichAnimation) end

---播放单位动作
---@param whichUnit unit
---@param whichAnimation string
function common.SetUnitAnimation(whichUnit,whichAnimation) end

---播放单位指定序号动动作 [R]
---@param whichUnit unit
---@param whichAnimation integer
function common.SetUnitAnimationByIndex(whichUnit,whichAnimation) end

---播放单位动作 (指定概率)
---@param whichUnit unit
---@param whichAnimation string
---@param rarity raritycontrol
function common.SetUnitAnimationWithRarity(whichUnit,whichAnimation,rarity) end

---添加/删除 单位动画附加名 [R]
---@param whichUnit unit
---@param animProperties string
---@param add boolean
function common.AddUnitAnimationProperties(whichUnit,animProperties,add) end

---锁定单位脸面对方向
---@param whichUnit unit
---@param whichBone string
---@param lookAtTarget unit
---@param offsetX real
---@param offsetY real
---@param offsetZ real
function common.SetUnitLookAt(whichUnit,whichBone,lookAtTarget,offsetX,offsetY,offsetZ) end

---重置单位面对方向
---@param whichUnit unit
function common.ResetUnitLookAt(whichUnit) end

---设置可否营救(对玩家) [R]
---@param whichUnit unit
---@param byWhichPlayer player
---@param flag boolean
function common.SetUnitRescuable(whichUnit,byWhichPlayer,flag) end

---设置营救单位的营救距离
---@param whichUnit unit
---@param range real
function common.SetUnitRescueRange(whichUnit,range) end

---设置英雄力量 [R]
---@param whichHero unit
---@param newStr integer
---@param permanent boolean
function common.SetHeroStr(whichHero,newStr,permanent) end

---设置英雄敏捷 [R]
---@param whichHero unit
---@param newAgi integer
---@param permanent boolean
function common.SetHeroAgi(whichHero,newAgi,permanent) end

---设置英雄智力 [R]
---@param whichHero unit
---@param newInt integer
---@param permanent boolean
function common.SetHeroInt(whichHero,newInt,permanent) end

---英雄力量 [R]
---@param whichHero unit
---@param includeBonuses boolean
---@return integer
function common.GetHeroStr(whichHero,includeBonuses) end

---英雄敏捷 [R]
---@param whichHero unit
---@param includeBonuses boolean
---@return integer
function common.GetHeroAgi(whichHero,includeBonuses) end

---英雄智力 [R]
---@param whichHero unit
---@param includeBonuses boolean
---@return integer
function common.GetHeroInt(whichHero,includeBonuses) end

---降低等级 [R]
---@param whichHero unit
---@param howManyLevels integer
---@return boolean
function common.UnitStripHeroLevel(whichHero,howManyLevels) end

---英雄的经验值
---@param whichHero unit
---@return integer
function common.GetHeroXP(whichHero) end

---设置英雄经验值
---@param whichHero unit
---@param newXpVal integer
---@param showEyeCandy boolean
function common.SetHeroXP(whichHero,newXpVal,showEyeCandy) end

---未用完的技能点数
---@param whichHero unit
---@return integer
function common.GetHeroSkillPoints(whichHero) end

---添加剩余技能点 [R]
---@param whichHero unit
---@param skillPointDelta integer
---@return boolean
function common.UnitModifySkillPoints(whichHero,skillPointDelta) end

---增加经验值 [R]
---@param whichHero unit
---@param xpToAdd integer
---@param showEyeCandy boolean
function common.AddHeroXP(whichHero,xpToAdd,showEyeCandy) end

---设置英雄等级
---@param whichHero unit
---@param level integer
---@param showEyeCandy boolean
function common.SetHeroLevel(whichHero,level,showEyeCandy) end

---英雄等级
---@param whichHero unit
---@return integer
function common.GetHeroLevel(whichHero) end

---单位等级
---@param whichUnit unit
---@return integer
function common.GetUnitLevel(whichUnit) end

---英雄的姓名
---@param whichHero unit
---@return string
function common.GetHeroProperName(whichHero) end

---允许/禁止经验获取 [R]
---@param whichHero unit
---@param flag boolean
function common.SuspendHeroXP(whichHero,flag) end

---英雄获得经验值
---@param whichHero unit
---@return boolean
function common.IsSuspendedXP(whichHero) end

---英雄学习技能
---@param whichHero unit
---@param abilcode integer
function common.SelectHeroSkill(whichHero,abilcode) end

---单位技能等级 [R]
---@param whichUnit unit
---@param abilcode integer
---@return integer
function common.GetUnitAbilityLevel(whichUnit,abilcode) end

---降低技能等级 [R]
---@param whichUnit unit
---@param abilcode integer
---@return integer
function common.DecUnitAbilityLevel(whichUnit,abilcode) end

---提升技能等级 [R]
---@param whichUnit unit
---@param abilcode integer
---@return integer
function common.IncUnitAbilityLevel(whichUnit,abilcode) end

---设置技能等级 [R]
---@param whichUnit unit
---@param abilcode integer
---@param level integer
---@return integer
function common.SetUnitAbilityLevel(whichUnit,abilcode,level) end

---立即复活(指定坐标) [R]
---@param whichHero unit
---@param x real
---@param y real
---@param doEyecandy boolean
---@return boolean
function common.ReviveHero(whichHero,x,y,doEyecandy) end

---复活英雄（立即）
---@param whichHero unit
---@param loc location
---@param doEyecandy boolean
---@return boolean
function common.ReviveHeroLoc(whichHero,loc,doEyecandy) end

---SetUnitExploded
---@param whichUnit unit
---@param exploded boolean
function common.SetUnitExploded(whichUnit,exploded) end

---设置单位 无敌/可攻击
---@param whichUnit unit
---@param flag boolean
function common.SetUnitInvulnerable(whichUnit,flag) end

---暂停/恢复 [R]
---@param whichUnit unit
---@param flag boolean
function common.PauseUnit(whichUnit,flag) end

---IsUnitPaused
---@param whichHero unit
---@return boolean
function common.IsUnitPaused(whichHero) end

---设置碰撞 打开/关闭
---@param whichUnit unit
---@param flag boolean
function common.SetUnitPathing(whichUnit,flag) end

---清除所有选定
function common.ClearSelection() end

---SelectUnit
---@param whichUnit unit
---@param flag boolean
function common.SelectUnit(whichUnit,flag) end

---单位的 附加值
---@param whichUnit unit
---@return integer
function common.GetUnitPointValue(whichUnit) end

---单位-类型的 附加值
---@param unitType integer
---@return integer
function common.GetUnitPointValueByType(unitType) end

---给予物品 [R]
---@param whichUnit unit
---@param whichItem item
---@return boolean
function common.UnitAddItem(whichUnit,whichItem) end

---UnitAddItemById
---@param whichUnit unit
---@param itemId integer
---@return item
function common.UnitAddItemById(whichUnit,itemId) end

---新建物品到指定物品栏 [R]
---@param whichUnit unit
---@param itemId integer
---@param itemSlot integer
---@return boolean
function common.UnitAddItemToSlotById(whichUnit,itemId,itemSlot) end

---UnitRemoveItem
---@param whichUnit unit
---@param whichItem item
function common.UnitRemoveItem(whichUnit,whichItem) end

---UnitRemoveItemFromSlot
---@param whichUnit unit
---@param itemSlot integer
---@return item
function common.UnitRemoveItemFromSlot(whichUnit,itemSlot) end

---英雄已有物品
---@param whichUnit unit
---@param whichItem item
---@return boolean
function common.UnitHasItem(whichUnit,whichItem) end

---单位持有物品
---@param whichUnit unit
---@param itemSlot integer
---@return item
function common.UnitItemInSlot(whichUnit,itemSlot) end

---UnitInventorySize
---@param whichUnit unit
---@return integer
function common.UnitInventorySize(whichUnit) end

---发布丢弃物品命令(指定坐标) [R]
---@param whichUnit unit
---@param whichItem item
---@param x real
---@param y real
---@return boolean
function common.UnitDropItemPoint(whichUnit,whichItem,x,y) end

---移动物品到物品栏 [R]
---@param whichUnit unit
---@param whichItem item
---@param slot integer
---@return boolean
function common.UnitDropItemSlot(whichUnit,whichItem,slot) end

---UnitDropItemTarget
---@param whichUnit unit
---@param whichItem item
---@param target widget
---@return boolean
function common.UnitDropItemTarget(whichUnit,whichItem,target) end

---使用物品
---@param whichUnit unit
---@param whichItem item
---@return boolean
function common.UnitUseItem(whichUnit,whichItem) end

---使用物品(指定坐标)
---@param whichUnit unit
---@param whichItem item
---@param x real
---@param y real
---@return boolean
function common.UnitUseItemPoint(whichUnit,whichItem,x,y) end

---对单位使用物品
---@param whichUnit unit
---@param whichItem item
---@param target widget
---@return boolean
function common.UnitUseItemTarget(whichUnit,whichItem,target) end

---单位所在X轴坐标 [R]
---@param whichUnit unit
---@return real
function common.GetUnitX(whichUnit) end

---单位所在Y轴坐标 [R]
---@param whichUnit unit
---@return real
function common.GetUnitY(whichUnit) end

---单位的位置
---@param whichUnit unit
---@return location
function common.GetUnitLoc(whichUnit) end

---单位面向角度
---@param whichUnit unit
---@return real
function common.GetUnitFacing(whichUnit) end

---单位移动速度 (当前)
---@param whichUnit unit
---@return real
function common.GetUnitMoveSpeed(whichUnit) end

---单位移动速度 (默认)
---@param whichUnit unit
---@return real
function common.GetUnitDefaultMoveSpeed(whichUnit) end

---属性 [R]
---@param whichUnit unit
---@param whichUnitState unitstate
---@return real
function common.GetUnitState(whichUnit,whichUnitState) end

---单位的所有者
---@param whichUnit unit
---@return player
function common.GetOwningPlayer(whichUnit) end

---单位的类型
---@param whichUnit unit
---@return integer
function common.GetUnitTypeId(whichUnit) end

---单位的种族
---@param whichUnit unit
---@return race
function common.GetUnitRace(whichUnit) end

---单位名字
---@param whichUnit unit
---@return string
function common.GetUnitName(whichUnit) end

---GetUnitFoodUsed
---@param whichUnit unit
---@return integer
function common.GetUnitFoodUsed(whichUnit) end

---GetUnitFoodMade
---@param whichUnit unit
---@return integer
function common.GetUnitFoodMade(whichUnit) end

---单位-类型 提供的人口
---@param unitId integer
---@return integer
function common.GetFoodMade(unitId) end

---单位-类型 使用的人口
---@param unitId integer
---@return integer
function common.GetFoodUsed(unitId) end

---允许/禁止 人口占用 [R]
---@param whichUnit unit
---@param useFood boolean
function common.SetUnitUseFood(whichUnit,useFood) end

---聚集点
---@param whichUnit unit
---@return location
function common.GetUnitRallyPoint(whichUnit) end

---拥有源聚集点单位
---@param whichUnit unit
---@return unit
function common.GetUnitRallyUnit(whichUnit) end

---单位 聚集点
---@param whichUnit unit
---@return destructable
function common.GetUnitRallyDestructable(whichUnit) end

---单位在 单位组
---@param whichUnit unit
---@param whichGroup group
---@return boolean
function common.IsUnitInGroup(whichUnit,whichGroup) end

---是玩家组里玩家的单位
---@param whichUnit unit
---@param whichForce force
---@return boolean
function common.IsUnitInForce(whichUnit,whichForce) end

---是玩家的单位
---@param whichUnit unit
---@param whichPlayer player
---@return boolean
function common.IsUnitOwnedByPlayer(whichUnit,whichPlayer) end

---单位所属玩家的同盟玩家
---@param whichUnit unit
---@param whichPlayer player
---@return boolean
function common.IsUnitAlly(whichUnit,whichPlayer) end

---单位所属玩家的敌对玩家
---@param whichUnit unit
---@param whichPlayer player
---@return boolean
function common.IsUnitEnemy(whichUnit,whichPlayer) end

---单位对于玩家可见
---@param whichUnit unit
---@param whichPlayer player
---@return boolean
function common.IsUnitVisible(whichUnit,whichPlayer) end

---被检测到
---@param whichUnit unit
---@param whichPlayer player
---@return boolean
function common.IsUnitDetected(whichUnit,whichPlayer) end

---单位对于玩家不可见
---@param whichUnit unit
---@param whichPlayer player
---@return boolean
function common.IsUnitInvisible(whichUnit,whichPlayer) end

---单位被战争迷雾遮挡
---@param whichUnit unit
---@param whichPlayer player
---@return boolean
function common.IsUnitFogged(whichUnit,whichPlayer) end

---单位被黑色阴影遮挡
---@param whichUnit unit
---@param whichPlayer player
---@return boolean
function common.IsUnitMasked(whichUnit,whichPlayer) end

---玩家已选定单位
---@param whichUnit unit
---@param whichPlayer player
---@return boolean
function common.IsUnitSelected(whichUnit,whichPlayer) end

---单位种族检查
---@param whichUnit unit
---@param whichRace race
---@return boolean
function common.IsUnitRace(whichUnit,whichRace) end

---检查单位 分类
---@param whichUnit unit
---@param whichUnitType unittype
---@return boolean
function common.IsUnitType(whichUnit,whichUnitType) end

---IsUnit
---@param whichUnit unit
---@param whichSpecifiedUnit unit
---@return boolean
function common.IsUnit(whichUnit,whichSpecifiedUnit) end

---在指定单位范围内 [R]
---@param whichUnit unit
---@param otherUnit unit
---@param distance real
---@return boolean
function common.IsUnitInRange(whichUnit,otherUnit,distance) end

---在指定坐标范围内 [R]
---@param whichUnit unit
---@param x real
---@param y real
---@param distance real
---@return boolean
function common.IsUnitInRangeXY(whichUnit,x,y,distance) end

---在指定点范围内 [R]
---@param whichUnit unit
---@param whichLocation location
---@param distance real
---@return boolean
function common.IsUnitInRangeLoc(whichUnit,whichLocation,distance) end

---IsUnitHidden
---@param whichUnit unit
---@return boolean
function common.IsUnitHidden(whichUnit) end

---IsUnitIllusion
---@param whichUnit unit
---@return boolean
function common.IsUnitIllusion(whichUnit) end

---IsUnitInTransport
---@param whichUnit unit
---@param whichTransport unit
---@return boolean
function common.IsUnitInTransport(whichUnit,whichTransport) end

---IsUnitLoaded
---@param whichUnit unit
---@return boolean
function common.IsUnitLoaded(whichUnit) end

---单位类型是英雄单位
---@param unitId integer
---@return boolean
function common.IsHeroUnitId(unitId) end

---检查单位-类型 分类
---@param unitId integer
---@param whichUnitType unittype
---@return boolean
function common.IsUnitIdType(unitId,whichUnitType) end

---共享视野 [R]
---@param whichUnit unit
---@param whichPlayer player
---@param share boolean
function common.UnitShareVision(whichUnit,whichPlayer,share) end

---暂停尸体腐烂 [R]
---@param whichUnit unit
---@param suspend boolean
function common.UnitSuspendDecay(whichUnit,suspend) end

---添加类别 [R]
---@param whichUnit unit
---@param whichUnitType unittype
---@return boolean
function common.UnitAddType(whichUnit,whichUnitType) end

---删除类别 [R]
---@param whichUnit unit
---@param whichUnitType unittype
---@return boolean
function common.UnitRemoveType(whichUnit,whichUnitType) end

---添加技能 [R]
---@param whichUnit unit
---@param abilityId integer
---@return boolean
function common.UnitAddAbility(whichUnit,abilityId) end

---删除技能 [R]
---@param whichUnit unit
---@param abilityId integer
---@return boolean
function common.UnitRemoveAbility(whichUnit,abilityId) end

---设置技能永久性 [R]
---@param whichUnit unit
---@param permanent boolean
---@param abilityId integer
---@return boolean
function common.UnitMakeAbilityPermanent(whichUnit,permanent,abilityId) end

---删除魔法效果(指定极性) [R]
---@param whichUnit unit
---@param removePositive boolean
---@param removeNegative boolean
function common.UnitRemoveBuffs(whichUnit,removePositive,removeNegative) end

---删除魔法效果(详细类别) [R]
---@param whichUnit unit
---@param removePositive boolean
---@param removeNegative boolean
---@param magic boolean
---@param physical boolean
---@param timedLife boolean
---@param aura boolean
---@param autoDispel boolean
function common.UnitRemoveBuffsEx(whichUnit,removePositive,removeNegative,magic,physical,timedLife,aura,autoDispel) end

---UnitHasBuffsEx
---@param whichUnit unit
---@param removePositive boolean
---@param removeNegative boolean
---@param magic boolean
---@param physical boolean
---@param timedLife boolean
---@param aura boolean
---@param autoDispel boolean
---@return boolean
function common.UnitHasBuffsEx(whichUnit,removePositive,removeNegative,magic,physical,timedLife,aura,autoDispel) end

---拥有Buff数量 [R]
---@param whichUnit unit
---@param removePositive boolean
---@param removeNegative boolean
---@param magic boolean
---@param physical boolean
---@param timedLife boolean
---@param aura boolean
---@param autoDispel boolean
---@return integer
function common.UnitCountBuffsEx(whichUnit,removePositive,removeNegative,magic,physical,timedLife,aura,autoDispel) end

---UnitAddSleep
---@param whichUnit unit
---@param add boolean
function common.UnitAddSleep(whichUnit,add) end

---UnitCanSleep
---@param whichUnit unit
---@return boolean
function common.UnitCanSleep(whichUnit) end

---设置单位睡眠(无论何时)
---@param whichUnit unit
---@param add boolean
function common.UnitAddSleepPerm(whichUnit,add) end

---单位在睡觉
---@param whichUnit unit
---@return boolean
function common.UnitCanSleepPerm(whichUnit) end

---UnitIsSleeping
---@param whichUnit unit
---@return boolean
function common.UnitIsSleeping(whichUnit) end

---UnitWakeUp
---@param whichUnit unit
function common.UnitWakeUp(whichUnit) end

---设置生命周期 [R]
---@param whichUnit unit
---@param buffId integer
---@param duration real
function common.UnitApplyTimedLife(whichUnit,buffId,duration) end

---UnitIgnoreAlarm
---@param whichUnit unit
---@param flag boolean
---@return boolean
function common.UnitIgnoreAlarm(whichUnit,flag) end

---UnitIgnoreAlarmToggled
---@param whichUnit unit
---@return boolean
function common.UnitIgnoreAlarmToggled(whichUnit) end

---重设单位技能Cooldown
---@param whichUnit unit
function common.UnitResetCooldown(whichUnit) end

---设置建筑物 建筑升级比
---@param whichUnit unit
---@param constructionPercentage integer
function common.UnitSetConstructionProgress(whichUnit,constructionPercentage) end

---设置建筑物 科技升级比
---@param whichUnit unit
---@param upgradePercentage integer
function common.UnitSetUpgradeProgress(whichUnit,upgradePercentage) end

---暂停/恢复生命周期 [R]
---@param whichUnit unit
---@param flag boolean
function common.UnitPauseTimedLife(whichUnit,flag) end

---UnitSetUsesAltIcon
---@param whichUnit unit
---@param flag boolean
function common.UnitSetUsesAltIcon(whichUnit,flag) end

---伤害区域 [R]
---@param whichUnit unit
---@param delay real
---@param radius real
---@param x real
---@param y real
---@param amount real
---@param attack boolean
---@param ranged boolean
---@param attackType attacktype
---@param damageType damagetype
---@param weaponType weapontype
---@return boolean
function common.UnitDamagePoint(whichUnit,delay,radius,x,y,amount,attack,ranged,attackType,damageType,weaponType) end

---伤害目标 [R]
---@param whichUnit unit
---@param target widget
---@param amount real
---@param attack boolean
---@param ranged boolean
---@param attackType attacktype
---@param damageType damagetype
---@param weaponType weapontype
---@return boolean
function common.UnitDamageTarget(whichUnit,target,amount,attack,ranged,attackType,damageType,weaponType) end

---给单位发送命令到 没有目标
---@param whichUnit unit
---@param order string
---@return boolean
function common.IssueImmediateOrder(whichUnit,order) end

---发布命令(无目标)(ID)
---@param whichUnit unit
---@param order integer
---@return boolean
function common.IssueImmediateOrderById(whichUnit,order) end

---发布命令(指定坐标)
---@param whichUnit unit
---@param order string
---@param x real
---@param y real
---@return boolean
function common.IssuePointOrder(whichUnit,order,x,y) end

---给单位发送命令到 点
---@param whichUnit unit
---@param order string
---@param whichLocation location
---@return boolean
function common.IssuePointOrderLoc(whichUnit,order,whichLocation) end

---发布命令(指定坐标)(ID)
---@param whichUnit unit
---@param order integer
---@param x real
---@param y real
---@return boolean
function common.IssuePointOrderById(whichUnit,order,x,y) end

---发布命令(指定点)(ID)
---@param whichUnit unit
---@param order integer
---@param whichLocation location
---@return boolean
function common.IssuePointOrderByIdLoc(whichUnit,order,whichLocation) end

---给单位发送命令到 单位
---@param whichUnit unit
---@param order string
---@param targetWidget widget
---@return boolean
function common.IssueTargetOrder(whichUnit,order,targetWidget) end

---发布命令(指定单位)(ID)
---@param whichUnit unit
---@param order integer
---@param targetWidget widget
---@return boolean
function common.IssueTargetOrderById(whichUnit,order,targetWidget) end

---IssueInstantPointOrder
---@param whichUnit unit
---@param order string
---@param x real
---@param y real
---@param instantTargetWidget widget
---@return boolean
function common.IssueInstantPointOrder(whichUnit,order,x,y,instantTargetWidget) end

---IssueInstantPointOrderById
---@param whichUnit unit
---@param order integer
---@param x real
---@param y real
---@param instantTargetWidget widget
---@return boolean
function common.IssueInstantPointOrderById(whichUnit,order,x,y,instantTargetWidget) end

---IssueInstantTargetOrder
---@param whichUnit unit
---@param order string
---@param targetWidget widget
---@param instantTargetWidget widget
---@return boolean
function common.IssueInstantTargetOrder(whichUnit,order,targetWidget,instantTargetWidget) end

---IssueInstantTargetOrderById
---@param whichUnit unit
---@param order integer
---@param targetWidget widget
---@param instantTargetWidget widget
---@return boolean
function common.IssueInstantTargetOrderById(whichUnit,order,targetWidget,instantTargetWidget) end

---IssueBuildOrder
---@param whichPeon unit
---@param unitToBuild string
---@param x real
---@param y real
---@return boolean
function common.IssueBuildOrder(whichPeon,unitToBuild,x,y) end

---发布建造命令(指定坐标) [R]
---@param whichPeon unit
---@param unitId integer
---@param x real
---@param y real
---@return boolean
function common.IssueBuildOrderById(whichPeon,unitId,x,y) end

---发布中介命令(无目标)
---@param forWhichPlayer player
---@param neutralStructure unit
---@param unitToBuild string
---@return boolean
function common.IssueNeutralImmediateOrder(forWhichPlayer,neutralStructure,unitToBuild) end

---发布中介命令(无目标)(ID)
---@param forWhichPlayer player
---@param neutralStructure unit
---@param unitId integer
---@return boolean
function common.IssueNeutralImmediateOrderById(forWhichPlayer,neutralStructure,unitId) end

---发布中介命令(指定坐标)
---@param forWhichPlayer player
---@param neutralStructure unit
---@param unitToBuild string
---@param x real
---@param y real
---@return boolean
function common.IssueNeutralPointOrder(forWhichPlayer,neutralStructure,unitToBuild,x,y) end

---发布中介命令(指定坐标)(ID)
---@param forWhichPlayer player
---@param neutralStructure unit
---@param unitId integer
---@param x real
---@param y real
---@return boolean
function common.IssueNeutralPointOrderById(forWhichPlayer,neutralStructure,unitId,x,y) end

---发布中介命令(指定单位)
---@param forWhichPlayer player
---@param neutralStructure unit
---@param unitToBuild string
---@param target widget
---@return boolean
function common.IssueNeutralTargetOrder(forWhichPlayer,neutralStructure,unitToBuild,target) end

---发布中介命令(指定单位)(ID)
---@param forWhichPlayer player
---@param neutralStructure unit
---@param unitId integer
---@param target widget
---@return boolean
function common.IssueNeutralTargetOrderById(forWhichPlayer,neutralStructure,unitId,target) end

---单位当前的命令
---@param whichUnit unit
---@return integer
function common.GetUnitCurrentOrder(whichUnit) end

---设置金矿资源
---@param whichUnit unit
---@param amount integer
function common.SetResourceAmount(whichUnit,amount) end

---添加金矿资源
---@param whichUnit unit
---@param amount integer
function common.AddResourceAmount(whichUnit,amount) end

---黄金资源数量
---@param whichUnit unit
---@return integer
function common.GetResourceAmount(whichUnit) end

---传送门目的地X坐标
---@param waygate unit
---@return real
function common.WaygateGetDestinationX(waygate) end

---传送门目的地Y坐标
---@param waygate unit
---@return real
function common.WaygateGetDestinationY(waygate) end

---设置传送门目的坐标 [R]
---@param waygate unit
---@param x real
---@param y real
function common.WaygateSetDestination(waygate,x,y) end

---WaygateActivate
---@param waygate unit
---@param activate boolean
function common.WaygateActivate(waygate,activate) end

---WaygateIsActive
---@param waygate unit
---@return boolean
function common.WaygateIsActive(waygate) end

---增加 物品-类型 (到所有商店)
---@param itemId integer
---@param currentStock integer
---@param stockMax integer
function common.AddItemToAllStock(itemId,currentStock,stockMax) end

---AddItemToStock
---@param whichUnit unit
---@param itemId integer
---@param currentStock integer
---@param stockMax integer
function common.AddItemToStock(whichUnit,itemId,currentStock,stockMax) end

---增加 单位-类型 (到所有商店)
---@param unitId integer
---@param currentStock integer
---@param stockMax integer
function common.AddUnitToAllStock(unitId,currentStock,stockMax) end

---AddUnitToStock
---@param whichUnit unit
---@param unitId integer
---@param currentStock integer
---@param stockMax integer
function common.AddUnitToStock(whichUnit,unitId,currentStock,stockMax) end

---删除 物品-类型 (从所有商店)
---@param itemId integer
function common.RemoveItemFromAllStock(itemId) end

---RemoveItemFromStock
---@param whichUnit unit
---@param itemId integer
function common.RemoveItemFromStock(whichUnit,itemId) end

---删除 单位-类型 (从所有商店)
---@param unitId integer
function common.RemoveUnitFromAllStock(unitId) end

---RemoveUnitFromStock
---@param whichUnit unit
---@param unitId integer
function common.RemoveUnitFromStock(whichUnit,unitId) end

---限制物品的位置 (从所有商店)
---@param slots integer
function common.SetAllItemTypeSlots(slots) end

---限制单位的位置 (从所有商店)
---@param slots integer
function common.SetAllUnitTypeSlots(slots) end

---限制物品的位置 (从商店)
---@param whichUnit unit
---@param slots integer
function common.SetItemTypeSlots(whichUnit,slots) end

---限制单位的位置 (从商店)
---@param whichUnit unit
---@param slots integer
function common.SetUnitTypeSlots(whichUnit,slots) end

---单位自定义值
---@param whichUnit unit
---@return integer
function common.GetUnitUserData(whichUnit) end

---设置单位自定义数据
---@param whichUnit unit
---@param data integer
function common.SetUnitUserData(whichUnit,data) end

---Player API
---Player API
---@param number integer
---@return player
function common.Player(number) end

---本地玩家 [R]
---@return player
function common.GetLocalPlayer() end

---玩家是玩家的同盟
---@param whichPlayer player
---@param otherPlayer player
---@return boolean
function common.IsPlayerAlly(whichPlayer,otherPlayer) end

---玩家是玩家的敌人
---@param whichPlayer player
---@param otherPlayer player
---@return boolean
function common.IsPlayerEnemy(whichPlayer,otherPlayer) end

---玩家在玩家组
---@param whichPlayer player
---@param whichForce force
---@return boolean
function common.IsPlayerInForce(whichPlayer,whichForce) end

---玩家是裁判或观察者 [R]
---@param whichPlayer player
---@return boolean
function common.IsPlayerObserver(whichPlayer) end

---坐标可见
---@param x real
---@param y real
---@param whichPlayer player
---@return boolean
function common.IsVisibleToPlayer(x,y,whichPlayer) end

---点对于玩家可见
---@param whichLocation location
---@param whichPlayer player
---@return boolean
function common.IsLocationVisibleToPlayer(whichLocation,whichPlayer) end

---坐标在迷雾中
---@param x real
---@param y real
---@param whichPlayer player
---@return boolean
function common.IsFoggedToPlayer(x,y,whichPlayer) end

---点被迷雾遮挡
---@param whichLocation location
---@param whichPlayer player
---@return boolean
function common.IsLocationFoggedToPlayer(whichLocation,whichPlayer) end

---坐标在黑色阴影中
---@param x real
---@param y real
---@param whichPlayer player
---@return boolean
function common.IsMaskedToPlayer(x,y,whichPlayer) end

---点被黑色阴影遮挡
---@param whichLocation location
---@param whichPlayer player
---@return boolean
function common.IsLocationMaskedToPlayer(whichLocation,whichPlayer) end

---玩家的种族
---@param whichPlayer player
---@return race
function common.GetPlayerRace(whichPlayer) end

---玩家ID - 1 [R]
---@param whichPlayer player
---@return integer
function common.GetPlayerId(whichPlayer) end

---单位数量
---@param whichPlayer player
---@param includeIncomplete boolean
---@return integer
function common.GetPlayerUnitCount(whichPlayer,includeIncomplete) end

---GetPlayerTypedUnitCount
---@param whichPlayer player
---@param unitName string
---@param includeIncomplete boolean
---@param includeUpgrades boolean
---@return integer
function common.GetPlayerTypedUnitCount(whichPlayer,unitName,includeIncomplete,includeUpgrades) end

---获得建筑数量
---@param whichPlayer player
---@param includeIncomplete boolean
---@return integer
function common.GetPlayerStructureCount(whichPlayer,includeIncomplete) end

---获得玩家属性
---@param whichPlayer player
---@param whichPlayerState playerstate
---@return integer
function common.GetPlayerState(whichPlayer,whichPlayerState) end

---获得玩家得分
---@param whichPlayer player
---@param whichPlayerScore playerscore
---@return integer
function common.GetPlayerScore(whichPlayer,whichPlayerScore) end

---玩家与玩家结盟
---@param sourcePlayer player
---@param otherPlayer player
---@param whichAllianceSetting alliancetype
---@return boolean
function common.GetPlayerAlliance(sourcePlayer,otherPlayer,whichAllianceSetting) end

---GetPlayerHandicap
---@param whichPlayer player
---@return real
function common.GetPlayerHandicap(whichPlayer) end

---GetPlayerHandicapXP
---@param whichPlayer player
---@return real
function common.GetPlayerHandicapXP(whichPlayer) end

---GetPlayerHandicapReviveTime
---@param whichPlayer player
---@return real
function common.GetPlayerHandicapReviveTime(whichPlayer) end

---GetPlayerHandicapDamage
---@param whichPlayer player
---@return real
function common.GetPlayerHandicapDamage(whichPlayer) end

---设置生命上限 [R]
---@param whichPlayer player
---@param handicap real
function common.SetPlayerHandicap(whichPlayer,handicap) end

---设置经验获得率 [R]
---@param whichPlayer player
---@param handicap real
function common.SetPlayerHandicapXP(whichPlayer,handicap) end

---SetPlayerHandicapReviveTime
---@param whichPlayer player
---@param handicap real
function common.SetPlayerHandicapReviveTime(whichPlayer,handicap) end

---SetPlayerHandicapDamage
---@param whichPlayer player
---@param handicap real
function common.SetPlayerHandicapDamage(whichPlayer,handicap) end

---SetPlayerTechMaxAllowed
---@param whichPlayer player
---@param techid integer
---@param maximum integer
function common.SetPlayerTechMaxAllowed(whichPlayer,techid,maximum) end

---GetPlayerTechMaxAllowed
---@param whichPlayer player
---@param techid integer
---@return integer
function common.GetPlayerTechMaxAllowed(whichPlayer,techid) end

---增加科技等级
---@param whichPlayer player
---@param techid integer
---@param levels integer
function common.AddPlayerTechResearched(whichPlayer,techid,levels) end

---SetPlayerTechResearched
---@param whichPlayer player
---@param techid integer
---@param setToLevel integer
function common.SetPlayerTechResearched(whichPlayer,techid,setToLevel) end

---GetPlayerTechResearched
---@param whichPlayer player
---@param techid integer
---@param specificonly boolean
---@return boolean
function common.GetPlayerTechResearched(whichPlayer,techid,specificonly) end

---获取玩家科技数量
---@param whichPlayer player
---@param techid integer
---@param specificonly boolean
---@return integer
function common.GetPlayerTechCount(whichPlayer,techid,specificonly) end

---SetPlayerUnitsOwner
---@param whichPlayer player
---@param newOwner integer
function common.SetPlayerUnitsOwner(whichPlayer,newOwner) end

---CripplePlayer
---@param whichPlayer player
---@param toWhichPlayers force
---@param flag boolean
function common.CripplePlayer(whichPlayer,toWhichPlayers,flag) end

---允许/禁用 技能 [R]
---@param whichPlayer player
---@param abilid integer
---@param avail boolean
function common.SetPlayerAbilityAvailable(whichPlayer,abilid,avail) end

---设置玩家属性
---@param whichPlayer player
---@param whichPlayerState playerstate
---@param value integer
function common.SetPlayerState(whichPlayer,whichPlayerState,value) end

---踢除玩家
---@param whichPlayer player
---@param gameResult playergameresult
function common.RemovePlayer(whichPlayer,gameResult) end

---Used to store hero level data for the scorescreen
---before units are moved to neutral passive in melee games
---@param whichPlayer player
function common.CachePlayerHeroData(whichPlayer) end

---Fog of War API
---设置地图迷雾(矩形区域) [R]
---@param forWhichPlayer player
---@param whichState fogstate
---@param where rect
---@param useSharedVision boolean
function common.SetFogStateRect(forWhichPlayer,whichState,where,useSharedVision) end

---设置地图迷雾(圆范围) [R]
---@param forWhichPlayer player
---@param whichState fogstate
---@param centerx real
---@param centerY real
---@param radius real
---@param useSharedVision boolean
function common.SetFogStateRadius(forWhichPlayer,whichState,centerx,centerY,radius,useSharedVision) end

---SetFogStateRadiusLoc
---@param forWhichPlayer player
---@param whichState fogstate
---@param center location
---@param radius real
---@param useSharedVision boolean
function common.SetFogStateRadiusLoc(forWhichPlayer,whichState,center,radius,useSharedVision) end

---启用/禁用黑色阴影 [R]
---@param enable boolean
function common.FogMaskEnable(enable) end

---允许黑色阴影
---@return boolean
function common.IsFogMaskEnabled() end

---启用/禁用 战争迷雾 [R]
---@param enable boolean
function common.FogEnable(enable) end

---允许战争迷雾
---@return boolean
function common.IsFogEnabled() end

---新建可见度修正器(矩形区域) [R]
---@param forWhichPlayer player
---@param whichState fogstate
---@param where rect
---@param useSharedVision boolean
---@param afterUnits boolean
---@return fogmodifier
function common.CreateFogModifierRect(forWhichPlayer,whichState,where,useSharedVision,afterUnits) end

---新建可见度修正器(圆范围) [R]
---@param forWhichPlayer player
---@param whichState fogstate
---@param centerx real
---@param centerY real
---@param radius real
---@param useSharedVision boolean
---@param afterUnits boolean
---@return fogmodifier
function common.CreateFogModifierRadius(forWhichPlayer,whichState,centerx,centerY,radius,useSharedVision,afterUnits) end

---CreateFogModifierRadiusLoc
---@param forWhichPlayer player
---@param whichState fogstate
---@param center location
---@param radius real
---@param useSharedVision boolean
---@param afterUnits boolean
---@return fogmodifier
function common.CreateFogModifierRadiusLoc(forWhichPlayer,whichState,center,radius,useSharedVision,afterUnits) end

---删除可见度修正器
---@param whichFogModifier fogmodifier
function common.DestroyFogModifier(whichFogModifier) end

---允许可见度修正器
---@param whichFogModifier fogmodifier
function common.FogModifierStart(whichFogModifier) end

---禁止可见度修正器
---@param whichFogModifier fogmodifier
function common.FogModifierStop(whichFogModifier) end

---Game API
---Game API
---@return version
function common.VersionGet() end

---VersionCompatible
---@param whichVersion version
---@return boolean
function common.VersionCompatible(whichVersion) end

---VersionSupported
---@param whichVersion version
---@return boolean
function common.VersionSupported(whichVersion) end

---EndGame
---@param doScoreScreen boolean
function common.EndGame(doScoreScreen) end

---Async only!
---切换关卡 [R]
---@param newLevel string
---@param doScoreScreen boolean
function common.ChangeLevel(newLevel,doScoreScreen) end

---RestartGame
---@param doScoreScreen boolean
function common.RestartGame(doScoreScreen) end

---ReloadGame
function common.ReloadGame() end

---%%% SetCampaignMenuRace is deprecated.  It must remain to support
---old maps which use it, but all new maps should use SetCampaignMenuRaceEx
---old maps which use it, but all new maps should use SetCampaignMenuRaceEx
---@param r race
function common.SetCampaignMenuRace(r) end

---SetCampaignMenuRaceEx
---@param campaignIndex integer
function common.SetCampaignMenuRaceEx(campaignIndex) end

---ForceCampaignSelectScreen
function common.ForceCampaignSelectScreen() end

---LoadGame
---@param saveFileName string
---@param doScoreScreen boolean
function common.LoadGame(saveFileName,doScoreScreen) end

---保存进度 [R]
---@param saveFileName string
function common.SaveGame(saveFileName) end

---RenameSaveDirectory
---@param sourceDirName string
---@param destDirName string
---@return boolean
function common.RenameSaveDirectory(sourceDirName,destDirName) end

---RemoveSaveDirectory
---@param sourceDirName string
---@return boolean
function common.RemoveSaveDirectory(sourceDirName) end

---CopySaveGame
---@param sourceSaveName string
---@param destSaveName string
---@return boolean
function common.CopySaveGame(sourceSaveName,destSaveName) end

---游戏进度是存在的
---@param saveName string
---@return boolean
function common.SaveGameExists(saveName) end

---SetMaxCheckpointSaves
---@param maxCheckpointSaves integer
function common.SetMaxCheckpointSaves(maxCheckpointSaves) end

---SaveGameCheckpoint
---@param saveFileName string
---@param showWindow boolean
function common.SaveGameCheckpoint(saveFileName,showWindow) end

---SyncSelections
function common.SyncSelections() end

---SetFloatGameState
---@param whichFloatGameState fgamestate
---@param value real
function common.SetFloatGameState(whichFloatGameState,value) end

---GetFloatGameState
---@param whichFloatGameState fgamestate
---@return real
function common.GetFloatGameState(whichFloatGameState) end

---SetIntegerGameState
---@param whichIntegerGameState igamestate
---@param value integer
function common.SetIntegerGameState(whichIntegerGameState,value) end

---GetIntegerGameState
---@param whichIntegerGameState igamestate
---@return integer
function common.GetIntegerGameState(whichIntegerGameState) end

---Campaign API
---Campaign API
---@param cleared boolean
function common.SetTutorialCleared(cleared) end

---SetMissionAvailable
---@param campaignNumber integer
---@param missionNumber integer
---@param available boolean
function common.SetMissionAvailable(campaignNumber,missionNumber,available) end

---SetCampaignAvailable
---@param campaignNumber integer
---@param available boolean
function common.SetCampaignAvailable(campaignNumber,available) end

---SetOpCinematicAvailable
---@param campaignNumber integer
---@param available boolean
function common.SetOpCinematicAvailable(campaignNumber,available) end

---SetEdCinematicAvailable
---@param campaignNumber integer
---@param available boolean
function common.SetEdCinematicAvailable(campaignNumber,available) end

---GetDefaultDifficulty
---@return gamedifficulty
function common.GetDefaultDifficulty() end

---SetDefaultDifficulty
---@param g gamedifficulty
function common.SetDefaultDifficulty(g) end

---SetCustomCampaignButtonVisible
---@param whichButton integer
---@param visible boolean
function common.SetCustomCampaignButtonVisible(whichButton,visible) end

---GetCustomCampaignButtonVisible
---@param whichButton integer
---@return boolean
function common.GetCustomCampaignButtonVisible(whichButton) end

---关闭游戏录像功能 [R]
function common.DoNotSaveReplay() end

---Dialog API
---新建对话框 [R]
---@return dialog
function common.DialogCreate() end

---删除 [R]
---@param whichDialog dialog
function common.DialogDestroy(whichDialog) end

---DialogClear
---@param whichDialog dialog
function common.DialogClear(whichDialog) end

---DialogSetMessage
---@param whichDialog dialog
---@param messageText string
function common.DialogSetMessage(whichDialog,messageText) end

---添加对话框按钮 [R]
---@param whichDialog dialog
---@param buttonText string
---@param hotkey integer
---@return button
function common.DialogAddButton(whichDialog,buttonText,hotkey) end

---添加退出游戏按钮 [R]
---@param whichDialog dialog
---@param doScoreScreen boolean
---@param buttonText string
---@param hotkey integer
---@return button
function common.DialogAddQuitButton(whichDialog,doScoreScreen,buttonText,hotkey) end

---显示/隐藏 [R]
---@param whichPlayer player
---@param whichDialog dialog
---@param flag boolean
function common.DialogDisplay(whichPlayer,whichDialog,flag) end

---Creates a new or reads in an existing game cache file stored
---in the current campaign profile dir
---读取所有缓存
---@return boolean
function common.ReloadGameCachesFromDisk() end

---新建游戏缓存 [R]
---@param campaignFile string
---@return gamecache
function common.InitGameCache(campaignFile) end

---SaveGameCache
---@param whichCache gamecache
---@return boolean
function common.SaveGameCache(whichCache) end

---记录整数
---@param cache gamecache
---@param missionKey string
---@param key string
---@param value integer
function common.StoreInteger(cache,missionKey,key,value) end

---记录实数
---@param cache gamecache
---@param missionKey string
---@param key string
---@param value real
function common.StoreReal(cache,missionKey,key,value) end

---记录布尔值
---@param cache gamecache
---@param missionKey string
---@param key string
---@param value boolean
function common.StoreBoolean(cache,missionKey,key,value) end

---StoreUnit
---@param cache gamecache
---@param missionKey string
---@param key string
---@param whichUnit unit
---@return boolean
function common.StoreUnit(cache,missionKey,key,whichUnit) end

---记录字符串
---@param cache gamecache
---@param missionKey string
---@param key string
---@param value string
---@return boolean
function common.StoreString(cache,missionKey,key,value) end

---SyncStoredInteger
---@param cache gamecache
---@param missionKey string
---@param key string
function common.SyncStoredInteger(cache,missionKey,key) end

---SyncStoredReal
---@param cache gamecache
---@param missionKey string
---@param key string
function common.SyncStoredReal(cache,missionKey,key) end

---SyncStoredBoolean
---@param cache gamecache
---@param missionKey string
---@param key string
function common.SyncStoredBoolean(cache,missionKey,key) end

---SyncStoredUnit
---@param cache gamecache
---@param missionKey string
---@param key string
function common.SyncStoredUnit(cache,missionKey,key) end

---SyncStoredString
---@param cache gamecache
---@param missionKey string
---@param key string
function common.SyncStoredString(cache,missionKey,key) end

---HaveStoredInteger
---@param cache gamecache
---@param missionKey string
---@param key string
---@return boolean
function common.HaveStoredInteger(cache,missionKey,key) end

---HaveStoredReal
---@param cache gamecache
---@param missionKey string
---@param key string
---@return boolean
function common.HaveStoredReal(cache,missionKey,key) end

---HaveStoredBoolean
---@param cache gamecache
---@param missionKey string
---@param key string
---@return boolean
function common.HaveStoredBoolean(cache,missionKey,key) end

---HaveStoredUnit
---@param cache gamecache
---@param missionKey string
---@param key string
---@return boolean
function common.HaveStoredUnit(cache,missionKey,key) end

---HaveStoredString
---@param cache gamecache
---@param missionKey string
---@param key string
---@return boolean
function common.HaveStoredString(cache,missionKey,key) end

---删除缓存 [C]
---@param cache gamecache
function common.FlushGameCache(cache) end

---删除类别
---@param cache gamecache
---@param missionKey string
function common.FlushStoredMission(cache,missionKey) end

---FlushStoredInteger
---@param cache gamecache
---@param missionKey string
---@param key string
function common.FlushStoredInteger(cache,missionKey,key) end

---FlushStoredReal
---@param cache gamecache
---@param missionKey string
---@param key string
function common.FlushStoredReal(cache,missionKey,key) end

---FlushStoredBoolean
---@param cache gamecache
---@param missionKey string
---@param key string
function common.FlushStoredBoolean(cache,missionKey,key) end

---FlushStoredUnit
---@param cache gamecache
---@param missionKey string
---@param key string
function common.FlushStoredUnit(cache,missionKey,key) end

---FlushStoredString
---@param cache gamecache
---@param missionKey string
---@param key string
function common.FlushStoredString(cache,missionKey,key) end

---Will return 0 if the specified value's data is not found in the cache
---缓存读取整数 [C]
---@param cache gamecache
---@param missionKey string
---@param key string
---@return integer
function common.GetStoredInteger(cache,missionKey,key) end

---缓存读取实数 [C]
---@param cache gamecache
---@param missionKey string
---@param key string
---@return real
function common.GetStoredReal(cache,missionKey,key) end

---读取布尔值[R]
---@param cache gamecache
---@param missionKey string
---@param key string
---@return boolean
function common.GetStoredBoolean(cache,missionKey,key) end

---读取字符串 [C]
---@param cache gamecache
---@param missionKey string
---@param key string
---@return string
function common.GetStoredString(cache,missionKey,key) end

---RestoreUnit
---@param cache gamecache
---@param missionKey string
---@param key string
---@param forWhichPlayer player
---@param x real
---@param y real
---@param facing real
---@return unit
function common.RestoreUnit(cache,missionKey,key,forWhichPlayer,x,y,facing) end

---<1.24> 新建哈希表 [C]
---@return hashtable
function common.InitHashtable() end

---<1.24> 保存整数 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param value integer
function common.SaveInteger(table,parentKey,childKey,value) end

---<1.24> 保存实数 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param value real
function common.SaveReal(table,parentKey,childKey,value) end

---<1.24> 保存布尔 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param value boolean
function common.SaveBoolean(table,parentKey,childKey,value) end

---<1.24> 保存字符串 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param value string
---@return boolean
function common.SaveStr(table,parentKey,childKey,value) end

---<1.24> 保存玩家 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichPlayer player
---@return boolean
function common.SavePlayerHandle(table,parentKey,childKey,whichPlayer) end

---SaveWidgetHandle
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichWidget widget
---@return boolean
function common.SaveWidgetHandle(table,parentKey,childKey,whichWidget) end

---<1.24> 保存可破坏物 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichDestructable destructable
---@return boolean
function common.SaveDestructableHandle(table,parentKey,childKey,whichDestructable) end

---<1.24> 保存物品 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichItem item
---@return boolean
function common.SaveItemHandle(table,parentKey,childKey,whichItem) end

---<1.24> 保存单位 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichUnit unit
---@return boolean
function common.SaveUnitHandle(table,parentKey,childKey,whichUnit) end

---SaveAbilityHandle
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichAbility ability
---@return boolean
function common.SaveAbilityHandle(table,parentKey,childKey,whichAbility) end

---<1.24> 保存计时器 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichTimer timer
---@return boolean
function common.SaveTimerHandle(table,parentKey,childKey,whichTimer) end

---<1.24> 保存触发器 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichTrigger trigger
---@return boolean
function common.SaveTriggerHandle(table,parentKey,childKey,whichTrigger) end

---<1.24> 保存触发条件 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichTriggercondition triggercondition
---@return boolean
function common.SaveTriggerConditionHandle(table,parentKey,childKey,whichTriggercondition) end

---<1.24> 保存触发动作 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichTriggeraction triggeraction
---@return boolean
function common.SaveTriggerActionHandle(table,parentKey,childKey,whichTriggeraction) end

---<1.24> 保存触发事件 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichEvent event
---@return boolean
function common.SaveTriggerEventHandle(table,parentKey,childKey,whichEvent) end

---<1.24> 保存玩家组 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichForce force
---@return boolean
function common.SaveForceHandle(table,parentKey,childKey,whichForce) end

---<1.24> 保存单位组 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichGroup group
---@return boolean
function common.SaveGroupHandle(table,parentKey,childKey,whichGroup) end

---<1.24> 保存点 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichLocation location
---@return boolean
function common.SaveLocationHandle(table,parentKey,childKey,whichLocation) end

---<1.24> 保存区域(矩型) [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichRect rect
---@return boolean
function common.SaveRectHandle(table,parentKey,childKey,whichRect) end

---<1.24> 保存布尔表达式 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichBoolexpr boolexpr
---@return boolean
function common.SaveBooleanExprHandle(table,parentKey,childKey,whichBoolexpr) end

---<1.24> 保存音效 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichSound sound
---@return boolean
function common.SaveSoundHandle(table,parentKey,childKey,whichSound) end

---<1.24> 保存特效 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichEffect effect
---@return boolean
function common.SaveEffectHandle(table,parentKey,childKey,whichEffect) end

---<1.24> 保存单位池 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichUnitpool unitpool
---@return boolean
function common.SaveUnitPoolHandle(table,parentKey,childKey,whichUnitpool) end

---<1.24> 保存物品池 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichItempool itempool
---@return boolean
function common.SaveItemPoolHandle(table,parentKey,childKey,whichItempool) end

---<1.24> 保存任务 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichQuest quest
---@return boolean
function common.SaveQuestHandle(table,parentKey,childKey,whichQuest) end

---<1.24> 保存任务要求 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichQuestitem questitem
---@return boolean
function common.SaveQuestItemHandle(table,parentKey,childKey,whichQuestitem) end

---<1.24> 保存失败条件 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichDefeatcondition defeatcondition
---@return boolean
function common.SaveDefeatConditionHandle(table,parentKey,childKey,whichDefeatcondition) end

---<1.24> 保存计时器窗口 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichTimerdialog timerdialog
---@return boolean
function common.SaveTimerDialogHandle(table,parentKey,childKey,whichTimerdialog) end

---<1.24> 保存排行榜 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichLeaderboard leaderboard
---@return boolean
function common.SaveLeaderboardHandle(table,parentKey,childKey,whichLeaderboard) end

---<1.24> 保存多面板 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichMultiboard multiboard
---@return boolean
function common.SaveMultiboardHandle(table,parentKey,childKey,whichMultiboard) end

---<1.24> 保存多面板项目 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichMultiboarditem multiboarditem
---@return boolean
function common.SaveMultiboardItemHandle(table,parentKey,childKey,whichMultiboarditem) end

---<1.24> 保存可追踪物 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichTrackable trackable
---@return boolean
function common.SaveTrackableHandle(table,parentKey,childKey,whichTrackable) end

---<1.24> 保存对话框 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichDialog dialog
---@return boolean
function common.SaveDialogHandle(table,parentKey,childKey,whichDialog) end

---<1.24> 保存对话框按钮 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichButton button
---@return boolean
function common.SaveButtonHandle(table,parentKey,childKey,whichButton) end

---<1.24> 保存漂浮文字 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichTexttag texttag
---@return boolean
function common.SaveTextTagHandle(table,parentKey,childKey,whichTexttag) end

---<1.24> 保存闪电效果 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichLightning lightning
---@return boolean
function common.SaveLightningHandle(table,parentKey,childKey,whichLightning) end

---<1.24> 保存图像 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichImage image
---@return boolean
function common.SaveImageHandle(table,parentKey,childKey,whichImage) end

---<1.24> 保存地面纹理变化 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichUbersplat ubersplat
---@return boolean
function common.SaveUbersplatHandle(table,parentKey,childKey,whichUbersplat) end

---<1.24> 保存区域(不规则) [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichRegion region
---@return boolean
function common.SaveRegionHandle(table,parentKey,childKey,whichRegion) end

---<1.24> 保存迷雾状态 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichFogState fogstate
---@return boolean
function common.SaveFogStateHandle(table,parentKey,childKey,whichFogState) end

---<1.24> 保存可见度修正器 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichFogModifier fogmodifier
---@return boolean
function common.SaveFogModifierHandle(table,parentKey,childKey,whichFogModifier) end

---<1.24> 保存实体对象 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichAgent agent
---@return boolean
function common.SaveAgentHandle(table,parentKey,childKey,whichAgent) end

---<1.24> 保存哈希表 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichHashtable hashtable
---@return boolean
function common.SaveHashtableHandle(table,parentKey,childKey,whichHashtable) end

---SaveFrameHandle
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@param whichFrameHandle framehandle
---@return boolean
function common.SaveFrameHandle(table,parentKey,childKey,whichFrameHandle) end

---<1.24> 从哈希表提取整数 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return integer
function common.LoadInteger(table,parentKey,childKey) end

---<1.24> 从哈希表提取实数 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return real
function common.LoadReal(table,parentKey,childKey) end

---<1.24> 从哈希表提取布尔 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return boolean
function common.LoadBoolean(table,parentKey,childKey) end

---<1.24> 从哈希表提取字符串 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return string
function common.LoadStr(table,parentKey,childKey) end

---<1.24> 从哈希表提取玩家 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return player
function common.LoadPlayerHandle(table,parentKey,childKey) end

---LoadWidgetHandle
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return widget
function common.LoadWidgetHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取可破坏物 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return destructable
function common.LoadDestructableHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取物品 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return item
function common.LoadItemHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取单位 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return unit
function common.LoadUnitHandle(table,parentKey,childKey) end

---LoadAbilityHandle
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return ability
function common.LoadAbilityHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取计时器 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return timer
function common.LoadTimerHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取触发器 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return trigger
function common.LoadTriggerHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取触发条件 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return triggercondition
function common.LoadTriggerConditionHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取触发动作 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return triggeraction
function common.LoadTriggerActionHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取触发事件 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return event
function common.LoadTriggerEventHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取玩家组 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return force
function common.LoadForceHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取单位组 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return group
function common.LoadGroupHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取点 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return location
function common.LoadLocationHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取区域(矩型) [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return rect
function common.LoadRectHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取布尔表达式 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return boolexpr
function common.LoadBooleanExprHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取音效 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return sound
function common.LoadSoundHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取特效 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return effect
function common.LoadEffectHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取单位池 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return unitpool
function common.LoadUnitPoolHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取物品池 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return itempool
function common.LoadItemPoolHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取任务 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return quest
function common.LoadQuestHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取任务要求 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return questitem
function common.LoadQuestItemHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取失败条件 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return defeatcondition
function common.LoadDefeatConditionHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取计时器窗口 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return timerdialog
function common.LoadTimerDialogHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取排行榜 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return leaderboard
function common.LoadLeaderboardHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取多面板 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return multiboard
function common.LoadMultiboardHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取多面板项目 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return multiboarditem
function common.LoadMultiboardItemHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取可追踪物 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return trackable
function common.LoadTrackableHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取对话框 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return dialog
function common.LoadDialogHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取对话框按钮 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return button
function common.LoadButtonHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取漂浮文字 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return texttag
function common.LoadTextTagHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取闪电效果 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return lightning
function common.LoadLightningHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取图象 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return image
function common.LoadImageHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取地面纹理变化 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return ubersplat
function common.LoadUbersplatHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取区域(不规则) [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return region
function common.LoadRegionHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取迷雾状态 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return fogstate
function common.LoadFogStateHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取可见度修正器 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return fogmodifier
function common.LoadFogModifierHandle(table,parentKey,childKey) end

---<1.24> 从哈希表提取哈希表 [C]
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return hashtable
function common.LoadHashtableHandle(table,parentKey,childKey) end

---LoadFrameHandle
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return framehandle
function common.LoadFrameHandle(table,parentKey,childKey) end

---HaveSavedInteger
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return boolean
function common.HaveSavedInteger(table,parentKey,childKey) end

---HaveSavedReal
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return boolean
function common.HaveSavedReal(table,parentKey,childKey) end

---HaveSavedBoolean
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return boolean
function common.HaveSavedBoolean(table,parentKey,childKey) end

---HaveSavedString
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return boolean
function common.HaveSavedString(table,parentKey,childKey) end

---HaveSavedHandle
---@param table hashtable
---@param parentKey integer
---@param childKey integer
---@return boolean
function common.HaveSavedHandle(table,parentKey,childKey) end

---RemoveSavedInteger
---@param table hashtable
---@param parentKey integer
---@param childKey integer
function common.RemoveSavedInteger(table,parentKey,childKey) end

---RemoveSavedReal
---@param table hashtable
---@param parentKey integer
---@param childKey integer
function common.RemoveSavedReal(table,parentKey,childKey) end

---RemoveSavedBoolean
---@param table hashtable
---@param parentKey integer
---@param childKey integer
function common.RemoveSavedBoolean(table,parentKey,childKey) end

---RemoveSavedString
---@param table hashtable
---@param parentKey integer
---@param childKey integer
function common.RemoveSavedString(table,parentKey,childKey) end

---RemoveSavedHandle
---@param table hashtable
---@param parentKey integer
---@param childKey integer
function common.RemoveSavedHandle(table,parentKey,childKey) end

---<1.24> 清空哈希表 [C]
---@param table hashtable
function common.FlushParentHashtable(table) end

---<1.24> 清空哈希表主索引 [C]
---@param table hashtable
---@param parentKey integer
function common.FlushChildHashtable(table,parentKey) end

---Randomization API
---随机数字
---@param lowBound integer
---@param highBound integer
---@return integer
function common.GetRandomInt(lowBound,highBound) end

---随机数
---@param lowBound real
---@param highBound real
---@return real
function common.GetRandomReal(lowBound,highBound) end

---新建单位池 [R]
---@return unitpool
function common.CreateUnitPool() end

---删除单位池 [R]
---@param whichPool unitpool
function common.DestroyUnitPool(whichPool) end

---添加单位类型 [R]
---@param whichPool unitpool
---@param unitId integer
---@param weight real
function common.UnitPoolAddUnitType(whichPool,unitId,weight) end

---删除单位类型 [R]
---@param whichPool unitpool
---@param unitId integer
function common.UnitPoolRemoveUnitType(whichPool,unitId) end

---选择放置单位 [R]
---@param whichPool unitpool
---@param forWhichPlayer player
---@param x real
---@param y real
---@param facing real
---@return unit
function common.PlaceRandomUnit(whichPool,forWhichPlayer,x,y,facing) end

---新建物品池 [R]
---@return itempool
function common.CreateItemPool() end

---删除物品池 [R]
---@param whichItemPool itempool
function common.DestroyItemPool(whichItemPool) end

---添加物品类型 [R]
---@param whichItemPool itempool
---@param itemId integer
---@param weight real
function common.ItemPoolAddItemType(whichItemPool,itemId,weight) end

---删除物品类型 [R]
---@param whichItemPool itempool
---@param itemId integer
function common.ItemPoolRemoveItemType(whichItemPool,itemId) end

---选择放置物品 [R]
---@param whichItemPool itempool
---@param x real
---@param y real
---@return item
function common.PlaceRandomItem(whichItemPool,x,y) end

---Choose any random unit/item. (NP means Neutral Passive)
---Choose any random unit/item. (NP means Neutral Passive)
---@param level integer
---@return integer
function common.ChooseRandomCreep(level) end

---ChooseRandomNPBuilding
---@return integer
function common.ChooseRandomNPBuilding() end

---ChooseRandomItem
---@param level integer
---@return integer
function common.ChooseRandomItem(level) end

---ChooseRandomItemEx
---@param whichType itemtype
---@param level integer
---@return integer
function common.ChooseRandomItemEx(whichType,level) end

---设置随机种子
---@param seed integer
function common.SetRandomSeed(seed) end

---Visual API
---Visual API
---@param a real
---@param b real
---@param c real
---@param d real
---@param e real
function common.SetTerrainFog(a,b,c,d,e) end

---ResetTerrainFog
function common.ResetTerrainFog() end

---SetUnitFog
---@param a real
---@param b real
---@param c real
---@param d real
---@param e real
function common.SetUnitFog(a,b,c,d,e) end

---设置迷雾 [R]
---@param style integer
---@param zstart real
---@param zend real
---@param density real
---@param red real
---@param green real
---@param blue real
function common.SetTerrainFogEx(style,zstart,zend,density,red,green,blue) end

---对玩家显示文本消息(自动限时) [R]
---@param toPlayer player
---@param x real
---@param y real
---@param message string
function common.DisplayTextToPlayer(toPlayer,x,y,message) end

---对玩家显示文本消息(指定时间) [R]
---@param toPlayer player
---@param x real
---@param y real
---@param duration real
---@param message string
function common.DisplayTimedTextToPlayer(toPlayer,x,y,duration,message) end

---DisplayTimedTextFromPlayer
---@param toPlayer player
---@param x real
---@param y real
---@param duration real
---@param message string
function common.DisplayTimedTextFromPlayer(toPlayer,x,y,duration,message) end

---清空文本信息(所有玩家) [R]
function common.ClearTextMessages() end

---SetDayNightModels
---@param terrainDNCFile string
---@param unitDNCFile string
function common.SetDayNightModels(terrainDNCFile,unitDNCFile) end

---SetPortraitLight
---@param portraitDNCFile string
function common.SetPortraitLight(portraitDNCFile) end

---设置天空
---@param skyModelFile string
function common.SetSkyModel(skyModelFile) end

---启用/禁用玩家控制权(所有玩家) [R]
---@param b boolean
function common.EnableUserControl(b) end

---EnableUserUI
---@param b boolean
function common.EnableUserUI(b) end

---SuspendTimeOfDay
---@param b boolean
function common.SuspendTimeOfDay(b) end

---设置昼夜时间流逝速度 [R]
---@param r real
function common.SetTimeOfDayScale(r) end

---GetTimeOfDayScale
---@return real
function common.GetTimeOfDayScale() end

---开启/关闭 信箱模式(所有玩家) [R]
---@param flag boolean
---@param fadeDuration real
function common.ShowInterface(flag,fadeDuration) end

---暂停/恢复游戏 [R]
---@param flag boolean
function common.PauseGame(flag) end

---闪动指示器(对单位) [R]
---@param whichUnit unit
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function common.UnitAddIndicator(whichUnit,red,green,blue,alpha) end

---AddIndicator
---@param whichWidget widget
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function common.AddIndicator(whichWidget,red,green,blue,alpha) end

---小地图信号(所有玩家) [R]
---@param x real
---@param y real
---@param duration real
function common.PingMinimap(x,y,duration) end

---小地图信号(指定颜色)(所有玩家) [R]
---@param x real
---@param y real
---@param duration real
---@param red integer
---@param green integer
---@param blue integer
---@param extraEffects boolean
function common.PingMinimapEx(x,y,duration,red,green,blue,extraEffects) end

---CreateMinimapIconOnUnit
---@param whichUnit unit
---@param red integer
---@param green integer
---@param blue integer
---@param pingPath string
---@param fogVisibility fogstate
---@return minimapicon
function common.CreateMinimapIconOnUnit(whichUnit,red,green,blue,pingPath,fogVisibility) end

---CreateMinimapIconAtLoc
---@param where location
---@param red integer
---@param green integer
---@param blue integer
---@param pingPath string
---@param fogVisibility fogstate
---@return minimapicon
function common.CreateMinimapIconAtLoc(where,red,green,blue,pingPath,fogVisibility) end

---CreateMinimapIcon
---@param x real
---@param y real
---@param red integer
---@param green integer
---@param blue integer
---@param pingPath string
---@param fogVisibility fogstate
---@return minimapicon
function common.CreateMinimapIcon(x,y,red,green,blue,pingPath,fogVisibility) end

---SkinManagerGetLocalPath
---@param key string
---@return string
function common.SkinManagerGetLocalPath(key) end

---DestroyMinimapIcon
---@param pingId minimapicon
function common.DestroyMinimapIcon(pingId) end

---SetMinimapIconVisible
---@param whichMinimapIcon minimapicon
---@param visible boolean
function common.SetMinimapIconVisible(whichMinimapIcon,visible) end

---SetMinimapIconOrphanDestroy
---@param whichMinimapIcon minimapicon
---@param doDestroy boolean
function common.SetMinimapIconOrphanDestroy(whichMinimapIcon,doDestroy) end

---允许/禁止闭塞(所有玩家) [R]
---@param flag boolean
function common.EnableOcclusion(flag) end

---SetIntroShotText
---@param introText string
function common.SetIntroShotText(introText) end

---SetIntroShotModel
---@param introModelPath string
function common.SetIntroShotModel(introModelPath) end

---允许/禁止 边界染色(所有玩家) [R]
---@param b boolean
function common.EnableWorldFogBoundary(b) end

---PlayModelCinematic
---@param modelName string
function common.PlayModelCinematic(modelName) end

---PlayCinematic
---@param movieName string
function common.PlayCinematic(movieName) end

---ForceUIKey
---@param key string
function common.ForceUIKey(key) end

---ForceUICancel
function common.ForceUICancel() end

---DisplayLoadDialog
function common.DisplayLoadDialog() end

---改变小地图的特殊图标
---@param iconPath string
function common.SetAltMinimapIcon(iconPath) end

---禁用 重新开始任务按钮
---@param flag boolean
function common.DisableRestartMission(flag) end

---新建漂浮文字 [R]
---@return texttag
function common.CreateTextTag() end

---DestroyTextTag
---@param t texttag
function common.DestroyTextTag(t) end

---改变文字内容 [R]
---@param t texttag
---@param s string
---@param height real
function common.SetTextTagText(t,s,height) end

---改变位置(坐标) [R]
---@param t texttag
---@param x real
---@param y real
---@param heightOffset real
function common.SetTextTagPos(t,x,y,heightOffset) end

---SetTextTagPosUnit
---@param t texttag
---@param whichUnit unit
---@param heightOffset real
function common.SetTextTagPosUnit(t,whichUnit,heightOffset) end

---改变颜色 [R]
---@param t texttag
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function common.SetTextTagColor(t,red,green,blue,alpha) end

---设置速率 [R]
---@param t texttag
---@param xvel real
---@param yvel real
function common.SetTextTagVelocity(t,xvel,yvel) end

---显示/隐藏 (所有玩家) [R]
---@param t texttag
---@param flag boolean
function common.SetTextTagVisibility(t,flag) end

---SetTextTagSuspended
---@param t texttag
---@param flag boolean
function common.SetTextTagSuspended(t,flag) end

---SetTextTagPermanent
---@param t texttag
---@param flag boolean
function common.SetTextTagPermanent(t,flag) end

---SetTextTagAge
---@param t texttag
---@param age real
function common.SetTextTagAge(t,age) end

---SetTextTagLifespan
---@param t texttag
---@param lifespan real
function common.SetTextTagLifespan(t,lifespan) end

---SetTextTagFadepoint
---@param t texttag
---@param fadepoint real
function common.SetTextTagFadepoint(t,fadepoint) end

---保留英雄按钮
---@param reserved integer
function common.SetReservedLocalHeroButtons(reserved) end

---结盟滤色镜的设置值
---@return integer
function common.GetAllyColorFilterState() end

---设置结盟滤色镜
---@param state integer
function common.SetAllyColorFilterState(state) end

---野生单位显示是开启的
---@return boolean
function common.GetCreepCampFilterState() end

---显示/隐藏野生生物图标在小地图
---@param state boolean
function common.SetCreepCampFilterState(state) end

---允许/禁止小地图按钮
---@param enableAlly boolean
---@param enableCreep boolean
function common.EnableMinimapFilterButtons(enableAlly,enableCreep) end

---允许/禁止框选
---@param state boolean
---@param ui boolean
function common.EnableDragSelect(state,ui) end

---允许/禁止预选
---@param state boolean
---@param ui boolean
function common.EnablePreSelect(state,ui) end

---允许/禁止选择
---@param state boolean
---@param ui boolean
function common.EnableSelect(state,ui) end

---Trackable API
---新建可追踪物 [R]
---@param trackableModelPath string
---@param x real
---@param y real
---@param facing real
---@return trackable
function common.CreateTrackable(trackableModelPath,x,y,facing) end

---Quest API
---新建任务 [R]
---@return quest
function common.CreateQuest() end

---DestroyQuest
---@param whichQuest quest
function common.DestroyQuest(whichQuest) end

---QuestSetTitle
---@param whichQuest quest
---@param title string
function common.QuestSetTitle(whichQuest,title) end

---QuestSetDescription
---@param whichQuest quest
---@param description string
function common.QuestSetDescription(whichQuest,description) end

---QuestSetIconPath
---@param whichQuest quest
---@param iconPath string
function common.QuestSetIconPath(whichQuest,iconPath) end

---QuestSetRequired
---@param whichQuest quest
---@param required boolean
function common.QuestSetRequired(whichQuest,required) end

---QuestSetCompleted
---@param whichQuest quest
---@param completed boolean
function common.QuestSetCompleted(whichQuest,completed) end

---QuestSetDiscovered
---@param whichQuest quest
---@param discovered boolean
function common.QuestSetDiscovered(whichQuest,discovered) end

---QuestSetFailed
---@param whichQuest quest
---@param failed boolean
function common.QuestSetFailed(whichQuest,failed) end

---启用/禁用 任务 [R]
---@param whichQuest quest
---@param enabled boolean
function common.QuestSetEnabled(whichQuest,enabled) end

---任务是必须完成的
---@param whichQuest quest
---@return boolean
function common.IsQuestRequired(whichQuest) end

---任务完成
---@param whichQuest quest
---@return boolean
function common.IsQuestCompleted(whichQuest) end

---任务已发现
---@param whichQuest quest
---@return boolean
function common.IsQuestDiscovered(whichQuest) end

---任务失败
---@param whichQuest quest
---@return boolean
function common.IsQuestFailed(whichQuest) end

---允许任务
---@param whichQuest quest
---@return boolean
function common.IsQuestEnabled(whichQuest) end

---QuestCreateItem
---@param whichQuest quest
---@return questitem
function common.QuestCreateItem(whichQuest) end

---QuestItemSetDescription
---@param whichQuestItem questitem
---@param description string
function common.QuestItemSetDescription(whichQuestItem,description) end

---QuestItemSetCompleted
---@param whichQuestItem questitem
---@param completed boolean
function common.QuestItemSetCompleted(whichQuestItem,completed) end

---任务条件完成
---@param whichQuestItem questitem
---@return boolean
function common.IsQuestItemCompleted(whichQuestItem) end

---CreateDefeatCondition
---@return defeatcondition
function common.CreateDefeatCondition() end

---DestroyDefeatCondition
---@param whichCondition defeatcondition
function common.DestroyDefeatCondition(whichCondition) end

---DefeatConditionSetDescription
---@param whichCondition defeatcondition
---@param description string
function common.DefeatConditionSetDescription(whichCondition,description) end

---FlashQuestDialogButton
function common.FlashQuestDialogButton() end

---ForceQuestDialogUpdate
function common.ForceQuestDialogUpdate() end

---Timer Dialog API
---新建计时器窗口 [R]
---@param t timer
---@return timerdialog
function common.CreateTimerDialog(t) end

---销毁计时器窗口
---@param whichDialog timerdialog
function common.DestroyTimerDialog(whichDialog) end

---设置计时器窗口标题
---@param whichDialog timerdialog
---@param title string
function common.TimerDialogSetTitle(whichDialog,title) end

---改变计时器窗口文字颜色 [R]
---@param whichDialog timerdialog
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function common.TimerDialogSetTitleColor(whichDialog,red,green,blue,alpha) end

---改变计时器窗口计时颜色 [R]
---@param whichDialog timerdialog
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function common.TimerDialogSetTimeColor(whichDialog,red,green,blue,alpha) end

---设置计时器窗口速率 [R]
---@param whichDialog timerdialog
---@param speedMultFactor real
function common.TimerDialogSetSpeed(whichDialog,speedMultFactor) end

---显示/隐藏 计时器窗口(所有玩家) [R]
---@param whichDialog timerdialog
---@param display boolean
function common.TimerDialogDisplay(whichDialog,display) end

---判断计时器窗口是否显示
---@param whichDialog timerdialog
---@return boolean
function common.IsTimerDialogDisplayed(whichDialog) end

---TimerDialogSetRealTimeRemaining
---@param whichDialog timerdialog
---@param timeRemaining real
function common.TimerDialogSetRealTimeRemaining(whichDialog,timeRemaining) end

---Create a leaderboard object
---新建排行榜 [R]
---@return leaderboard
function common.CreateLeaderboard() end

---DestroyLeaderboard
---@param lb leaderboard
function common.DestroyLeaderboard(lb) end

---显示/隐藏 [R]
---@param lb leaderboard
---@param show boolean
function common.LeaderboardDisplay(lb,show) end

---IsLeaderboardDisplayed
---@param lb leaderboard
---@return boolean
function common.IsLeaderboardDisplayed(lb) end

---行数
---@param lb leaderboard
---@return integer
function common.LeaderboardGetItemCount(lb) end

---LeaderboardSetSizeByItemCount
---@param lb leaderboard
---@param count integer
function common.LeaderboardSetSizeByItemCount(lb,count) end

---LeaderboardAddItem
---@param lb leaderboard
---@param label string
---@param value integer
---@param p player
function common.LeaderboardAddItem(lb,label,value,p) end

---LeaderboardRemoveItem
---@param lb leaderboard
---@param index integer
function common.LeaderboardRemoveItem(lb,index) end

---LeaderboardRemovePlayerItem
---@param lb leaderboard
---@param p player
function common.LeaderboardRemovePlayerItem(lb,p) end

---清空 [R]
---@param lb leaderboard
function common.LeaderboardClear(lb) end

---LeaderboardSortItemsByValue
---@param lb leaderboard
---@param ascending boolean
function common.LeaderboardSortItemsByValue(lb,ascending) end

---LeaderboardSortItemsByPlayer
---@param lb leaderboard
---@param ascending boolean
function common.LeaderboardSortItemsByPlayer(lb,ascending) end

---LeaderboardSortItemsByLabel
---@param lb leaderboard
---@param ascending boolean
function common.LeaderboardSortItemsByLabel(lb,ascending) end

---LeaderboardHasPlayerItem
---@param lb leaderboard
---@param p player
---@return boolean
function common.LeaderboardHasPlayerItem(lb,p) end

---LeaderboardGetPlayerIndex
---@param lb leaderboard
---@param p player
---@return integer
function common.LeaderboardGetPlayerIndex(lb,p) end

---LeaderboardSetLabel
---@param lb leaderboard
---@param label string
function common.LeaderboardSetLabel(lb,label) end

---LeaderboardGetLabelText
---@param lb leaderboard
---@return string
function common.LeaderboardGetLabelText(lb) end

---设置玩家使用的排行榜 [R]
---@param toPlayer player
---@param lb leaderboard
function common.PlayerSetLeaderboard(toPlayer,lb) end

---PlayerGetLeaderboard
---@param toPlayer player
---@return leaderboard
function common.PlayerGetLeaderboard(toPlayer) end

---设置文字颜色 [R]
---@param lb leaderboard
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function common.LeaderboardSetLabelColor(lb,red,green,blue,alpha) end

---设置数值颜色 [R]
---@param lb leaderboard
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function common.LeaderboardSetValueColor(lb,red,green,blue,alpha) end

---LeaderboardSetStyle
---@param lb leaderboard
---@param showLabel boolean
---@param showNames boolean
---@param showValues boolean
---@param showIcons boolean
function common.LeaderboardSetStyle(lb,showLabel,showNames,showValues,showIcons) end

---LeaderboardSetItemValue
---@param lb leaderboard
---@param whichItem integer
---@param val integer
function common.LeaderboardSetItemValue(lb,whichItem,val) end

---LeaderboardSetItemLabel
---@param lb leaderboard
---@param whichItem integer
---@param val string
function common.LeaderboardSetItemLabel(lb,whichItem,val) end

---LeaderboardSetItemStyle
---@param lb leaderboard
---@param whichItem integer
---@param showLabel boolean
---@param showValue boolean
---@param showIcon boolean
function common.LeaderboardSetItemStyle(lb,whichItem,showLabel,showValue,showIcon) end

---LeaderboardSetItemLabelColor
---@param lb leaderboard
---@param whichItem integer
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function common.LeaderboardSetItemLabelColor(lb,whichItem,red,green,blue,alpha) end

---LeaderboardSetItemValueColor
---@param lb leaderboard
---@param whichItem integer
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function common.LeaderboardSetItemValueColor(lb,whichItem,red,green,blue,alpha) end

---Create a multiboard object
---新建多面板 [R]
---@return multiboard
function common.CreateMultiboard() end

---DestroyMultiboard
---@param lb multiboard
function common.DestroyMultiboard(lb) end

---显示/隐藏 [R]
---@param lb multiboard
---@param show boolean
function common.MultiboardDisplay(lb,show) end

---多列面板 是已显示的
---@param lb multiboard
---@return boolean
function common.IsMultiboardDisplayed(lb) end

---最大/最小化 [R]
---@param lb multiboard
---@param minimize boolean
function common.MultiboardMinimize(lb,minimize) end

---多列面板 是最小化的
---@param lb multiboard
---@return boolean
function common.IsMultiboardMinimized(lb) end

---清除 多列面板
---@param lb multiboard
function common.MultiboardClear(lb) end

---改变 多列面板 标题
---@param lb multiboard
---@param label string
function common.MultiboardSetTitleText(lb,label) end

---多列面板 的标题
---@param lb multiboard
---@return string
function common.MultiboardGetTitleText(lb) end

---设置标题颜色 [R]
---@param lb multiboard
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function common.MultiboardSetTitleTextColor(lb,red,green,blue,alpha) end

---获得多列面板 的行数
---@param lb multiboard
---@return integer
function common.MultiboardGetRowCount(lb) end

---获得多列面板 的列数
---@param lb multiboard
---@return integer
function common.MultiboardGetColumnCount(lb) end

---改变多列面板'列数'
---@param lb multiboard
---@param count integer
function common.MultiboardSetColumnCount(lb,count) end

---改变多列面板'行数'
---@param lb multiboard
---@param count integer
function common.MultiboardSetRowCount(lb,count) end

---broadcast settings to all items
---设置所有项目显示风格 [R]
---@param lb multiboard
---@param showValues boolean
---@param showIcons boolean
function common.MultiboardSetItemsStyle(lb,showValues,showIcons) end

---设置所有项目文本 [R]
---@param lb multiboard
---@param value string
function common.MultiboardSetItemsValue(lb,value) end

---设置所有项目颜色 [R]
---@param lb multiboard
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function common.MultiboardSetItemsValueColor(lb,red,green,blue,alpha) end

---设置所有项目宽度 [R]
---@param lb multiboard
---@param width real
function common.MultiboardSetItemsWidth(lb,width) end

---设置所有项目图标 [R]
---@param lb multiboard
---@param iconPath string
function common.MultiboardSetItemsIcon(lb,iconPath) end

---funcs for modifying individual items
---多面板项目 [R]
---@param lb multiboard
---@param row integer
---@param column integer
---@return multiboarditem
function common.MultiboardGetItem(lb,row,column) end

---删除多面板项目 [R]
---@param mbi multiboarditem
function common.MultiboardReleaseItem(mbi) end

---设置指定项目显示风格 [R]
---@param mbi multiboarditem
---@param showValue boolean
---@param showIcon boolean
function common.MultiboardSetItemStyle(mbi,showValue,showIcon) end

---设置指定项目文本 [R]
---@param mbi multiboarditem
---@param val string
function common.MultiboardSetItemValue(mbi,val) end

---设置指定项目颜色 [R]
---@param mbi multiboarditem
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function common.MultiboardSetItemValueColor(mbi,red,green,blue,alpha) end

---设置指定项目宽度 [R]
---@param mbi multiboarditem
---@param width real
function common.MultiboardSetItemWidth(mbi,width) end

---设置指定项目图标 [R]
---@param mbi multiboarditem
---@param iconFileName string
function common.MultiboardSetItemIcon(mbi,iconFileName) end

---meant to unequivocally suspend display of existing and
---subsequently displayed multiboards
---显示/隐藏多面板模式 [R]
---@param flag boolean
function common.MultiboardSuppressDisplay(flag) end

---Camera API
---Camera API
---@param x real
---@param y real
function common.SetCameraPosition(x,y) end

---设置空格键转向点(所有玩家) [R]
---@param x real
---@param y real
function common.SetCameraQuickPosition(x,y) end

---设置可用镜头区域(所有玩家) [R]
---@param x1 real
---@param y1 real
---@param x2 real
---@param y2 real
---@param x3 real
---@param y3 real
---@param x4 real
---@param y4 real
function common.SetCameraBounds(x1,y1,x2,y2,x3,y3,x4,y4) end

---停止播放镜头(所有玩家) [R]
function common.StopCamera() end

---重置游戏镜头(所有玩家) [R]
---@param duration real
function common.ResetToGameCamera(duration) end

---PanCameraTo
---@param x real
---@param y real
function common.PanCameraTo(x,y) end

---平移镜头(所有玩家)(限时) [R]
---@param x real
---@param y real
---@param duration real
function common.PanCameraToTimed(x,y,duration) end

---PanCameraToWithZ
---@param x real
---@param y real
---@param zOffsetDest real
function common.PanCameraToWithZ(x,y,zOffsetDest) end

---指定高度平移镜头(所有玩家)(限时) [R]
---@param x real
---@param y real
---@param zOffsetDest real
---@param duration real
function common.PanCameraToTimedWithZ(x,y,zOffsetDest,duration) end

---播放电影镜头(所有玩家) [R]
---@param cameraModelFile string
function common.SetCinematicCamera(cameraModelFile) end

---指定点旋转镜头(所有玩家)(弧度)(限时) [R]
---@param x real
---@param y real
---@param radiansToSweep real
---@param duration real
function common.SetCameraRotateMode(x,y,radiansToSweep,duration) end

---设置镜头属性(所有玩家)(限时) [R]
---@param whichField camerafield
---@param value real
---@param duration real
function common.SetCameraField(whichField,value,duration) end

---AdjustCameraField
---@param whichField camerafield
---@param offset real
---@param duration real
function common.AdjustCameraField(whichField,offset,duration) end

---锁定镜头到单位(所有玩家) [R]
---@param whichUnit unit
---@param xoffset real
---@param yoffset real
---@param inheritOrientation boolean
function common.SetCameraTargetController(whichUnit,xoffset,yoffset,inheritOrientation) end

---锁定镜头到单位(固定镜头源)(所有玩家) [R]
---@param whichUnit unit
---@param xoffset real
---@param yoffset real
function common.SetCameraOrientController(whichUnit,xoffset,yoffset) end

---CreateCameraSetup
---@return camerasetup
function common.CreateCameraSetup() end

---CameraSetupSetField
---@param whichSetup camerasetup
---@param whichField camerafield
---@param value real
---@param duration real
function common.CameraSetupSetField(whichSetup,whichField,value,duration) end

---镜头属性(指定镜头) [R]
---@param whichSetup camerasetup
---@param whichField camerafield
---@return real
function common.CameraSetupGetField(whichSetup,whichField) end

---CameraSetupSetDestPosition
---@param whichSetup camerasetup
---@param x real
---@param y real
---@param duration real
function common.CameraSetupSetDestPosition(whichSetup,x,y,duration) end

---摄象机的目标
---@param whichSetup camerasetup
---@return location
function common.CameraSetupGetDestPositionLoc(whichSetup) end

---CameraSetupGetDestPositionX
---@param whichSetup camerasetup
---@return real
function common.CameraSetupGetDestPositionX(whichSetup) end

---CameraSetupGetDestPositionY
---@param whichSetup camerasetup
---@return real
function common.CameraSetupGetDestPositionY(whichSetup) end

---CameraSetupApply
---@param whichSetup camerasetup
---@param doPan boolean
---@param panTimed boolean
function common.CameraSetupApply(whichSetup,doPan,panTimed) end

---CameraSetupApplyWithZ
---@param whichSetup camerasetup
---@param zDestOffset real
function common.CameraSetupApplyWithZ(whichSetup,zDestOffset) end

---应用镜头(所有玩家)(限时) [R]
---@param whichSetup camerasetup
---@param doPan boolean
---@param forceDuration real
function common.CameraSetupApplyForceDuration(whichSetup,doPan,forceDuration) end

---CameraSetupApplyForceDurationWithZ
---@param whichSetup camerasetup
---@param zDestOffset real
---@param forceDuration real
function common.CameraSetupApplyForceDurationWithZ(whichSetup,zDestOffset,forceDuration) end

---CameraSetTargetNoise
---@param mag real
---@param velocity real
function common.CameraSetTargetNoise(mag,velocity) end

---CameraSetSourceNoise
---@param mag real
---@param velocity real
function common.CameraSetSourceNoise(mag,velocity) end

---摇晃镜头目标(所有玩家) [R]
---@param mag real
---@param velocity real
---@param vertOnly boolean
function common.CameraSetTargetNoiseEx(mag,velocity,vertOnly) end

---摇晃镜头源(所有玩家) [R]
---@param mag real
---@param velocity real
---@param vertOnly boolean
function common.CameraSetSourceNoiseEx(mag,velocity,vertOnly) end

---CameraSetSmoothingFactor
---@param factor real
function common.CameraSetSmoothingFactor(factor) end

---CameraSetFocalDistance
---@param distance real
function common.CameraSetFocalDistance(distance) end

---CameraSetDepthOfFieldScale
---@param scale real
function common.CameraSetDepthOfFieldScale(scale) end

---SetCineFilterTexture
---@param filename string
function common.SetCineFilterTexture(filename) end

---SetCineFilterBlendMode
---@param whichMode blendmode
function common.SetCineFilterBlendMode(whichMode) end

---SetCineFilterTexMapFlags
---@param whichFlags texmapflags
function common.SetCineFilterTexMapFlags(whichFlags) end

---SetCineFilterStartUV
---@param minu real
---@param minv real
---@param maxu real
---@param maxv real
function common.SetCineFilterStartUV(minu,minv,maxu,maxv) end

---SetCineFilterEndUV
---@param minu real
---@param minv real
---@param maxu real
---@param maxv real
function common.SetCineFilterEndUV(minu,minv,maxu,maxv) end

---SetCineFilterStartColor
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function common.SetCineFilterStartColor(red,green,blue,alpha) end

---SetCineFilterEndColor
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function common.SetCineFilterEndColor(red,green,blue,alpha) end

---SetCineFilterDuration
---@param duration real
function common.SetCineFilterDuration(duration) end

---DisplayCineFilter
---@param flag boolean
function common.DisplayCineFilter(flag) end

---IsCineFilterDisplayed
---@return boolean
function common.IsCineFilterDisplayed() end

---SetCinematicScene
---@param portraitUnitId integer
---@param color playercolor
---@param speakerTitle string
---@param text string
---@param sceneDuration real
---@param voiceoverDuration real
function common.SetCinematicScene(portraitUnitId,color,speakerTitle,text,sceneDuration,voiceoverDuration) end

---EndCinematicScene
function common.EndCinematicScene() end

---ForceCinematicSubtitles
---@param flag boolean
function common.ForceCinematicSubtitles(flag) end

---SetCinematicAudio
---@param cinematicAudio boolean
function common.SetCinematicAudio(cinematicAudio) end

---GetCameraMargin
---@param whichMargin integer
---@return real
function common.GetCameraMargin(whichMargin) end

---These return values for the local players camera only...
---These return values for the local players camera only...
---@return real
function common.GetCameraBoundMinX() end

---GetCameraBoundMinY
---@return real
function common.GetCameraBoundMinY() end

---GetCameraBoundMaxX
---@return real
function common.GetCameraBoundMaxX() end

---GetCameraBoundMaxY
---@return real
function common.GetCameraBoundMaxY() end

---当前摄象机的数值
---@param whichField camerafield
---@return real
function common.GetCameraField(whichField) end

---当前摄象机的目标的 X 坐标
---@return real
function common.GetCameraTargetPositionX() end

---当前摄象机的目标的 Y 坐标
---@return real
function common.GetCameraTargetPositionY() end

---当前摄象机的目标的 Z 坐标
---@return real
function common.GetCameraTargetPositionZ() end

---当前摄象机的目标
---@return location
function common.GetCameraTargetPositionLoc() end

---当前摄象机的位置的 X 坐标
---@return real
function common.GetCameraEyePositionX() end

---当前摄象机的位置的 Y 坐标
---@return real
function common.GetCameraEyePositionY() end

---当前摄象机的位置的 Z 坐标
---@return real
function common.GetCameraEyePositionZ() end

---当前照相机的位置
---@return location
function common.GetCameraEyePositionLoc() end

---Sound API
---@param environmentName string
function common.NewSoundEnvironment(environmentName) end

---CreateSound
---@param fileName string
---@param looping boolean
---@param is3D boolean
---@param stopwhenoutofrange boolean
---@param fadeInRate integer
---@param fadeOutRate integer
---@param eaxSetting string
---@return sound
function common.CreateSound(fileName,looping,is3D,stopwhenoutofrange,fadeInRate,fadeOutRate,eaxSetting) end

---CreateSoundFilenameWithLabel
---@param fileName string
---@param looping boolean
---@param is3D boolean
---@param stopwhenoutofrange boolean
---@param fadeInRate integer
---@param fadeOutRate integer
---@param SLKEntryName string
---@return sound
function common.CreateSoundFilenameWithLabel(fileName,looping,is3D,stopwhenoutofrange,fadeInRate,fadeOutRate,SLKEntryName) end

---CreateSoundFromLabel
---@param soundLabel string
---@param looping boolean
---@param is3D boolean
---@param stopwhenoutofrange boolean
---@param fadeInRate integer
---@param fadeOutRate integer
---@return sound
function common.CreateSoundFromLabel(soundLabel,looping,is3D,stopwhenoutofrange,fadeInRate,fadeOutRate) end

---CreateMIDISound
---@param soundLabel string
---@param fadeInRate integer
---@param fadeOutRate integer
---@return sound
function common.CreateMIDISound(soundLabel,fadeInRate,fadeOutRate) end

---SetSoundParamsFromLabel
---@param soundHandle sound
---@param soundLabel string
function common.SetSoundParamsFromLabel(soundHandle,soundLabel) end

---SetSoundDistanceCutoff
---@param soundHandle sound
---@param cutoff real
function common.SetSoundDistanceCutoff(soundHandle,cutoff) end

---SetSoundChannel
---@param soundHandle sound
---@param channel integer
function common.SetSoundChannel(soundHandle,channel) end

---设置音效音量 [R]
---@param soundHandle sound
---@param volume integer
function common.SetSoundVolume(soundHandle,volume) end

---SetSoundPitch
---@param soundHandle sound
---@param pitch real
function common.SetSoundPitch(soundHandle,pitch) end

---the following method must be called immediately after calling "StartSound"
---设置音效播放时间点 [R]
---@param soundHandle sound
---@param millisecs integer
function common.SetSoundPlayPosition(soundHandle,millisecs) end

---these calls are only valid if the sound was created with 3d enabled
---设置3D声音距离
---@param soundHandle sound
---@param minDist real
---@param maxDist real
function common.SetSoundDistances(soundHandle,minDist,maxDist) end

---SetSoundConeAngles
---@param soundHandle sound
---@param inside real
---@param outside real
---@param outsideVolume integer
function common.SetSoundConeAngles(soundHandle,inside,outside,outsideVolume) end

---SetSoundConeOrientation
---@param soundHandle sound
---@param x real
---@param y real
---@param z real
function common.SetSoundConeOrientation(soundHandle,x,y,z) end

---设置3D音效位置(指定坐标) [R]
---@param soundHandle sound
---@param x real
---@param y real
---@param z real
function common.SetSoundPosition(soundHandle,x,y,z) end

---SetSoundVelocity
---@param soundHandle sound
---@param x real
---@param y real
---@param z real
function common.SetSoundVelocity(soundHandle,x,y,z) end

---AttachSoundToUnit
---@param soundHandle sound
---@param whichUnit unit
function common.AttachSoundToUnit(soundHandle,whichUnit) end

---StartSound
---@param soundHandle sound
function common.StartSound(soundHandle) end

---StopSound
---@param soundHandle sound
---@param killWhenDone boolean
---@param fadeOut boolean
function common.StopSound(soundHandle,killWhenDone,fadeOut) end

---KillSoundWhenDone
---@param soundHandle sound
function common.KillSoundWhenDone(soundHandle) end

---Music Interface. Note that if music is disabled, these calls do nothing
---设置背景音乐列表 [R]
---@param musicName string
---@param random boolean
---@param index integer
function common.SetMapMusic(musicName,random,index) end

---ClearMapMusic
function common.ClearMapMusic() end

---PlayMusic
---@param musicName string
function common.PlayMusic(musicName) end

---PlayMusicEx
---@param musicName string
---@param frommsecs integer
---@param fadeinmsecs integer
function common.PlayMusicEx(musicName,frommsecs,fadeinmsecs) end

---StopMusic
---@param fadeOut boolean
function common.StopMusic(fadeOut) end

---ResumeMusic
function common.ResumeMusic() end

---播放主题音乐 [C]
---@param musicFileName string
function common.PlayThematicMusic(musicFileName) end

---跳播主题音乐 [R]
---@param musicFileName string
---@param frommsecs integer
function common.PlayThematicMusicEx(musicFileName,frommsecs) end

---停止主题音乐[C]
function common.EndThematicMusic() end

---设置背景音乐音量 [R]
---@param volume integer
function common.SetMusicVolume(volume) end

---设置背景音乐播放时间点 [R]
---@param millisecs integer
function common.SetMusicPlayPosition(millisecs) end

---SetThematicMusicVolume
---@param volume integer
function common.SetThematicMusicVolume(volume) end

---设置主题音乐播放时间点 [R]
---@param millisecs integer
function common.SetThematicMusicPlayPosition(millisecs) end

---other music and sound calls
---other music and sound calls
---@param soundHandle sound
---@param duration integer
function common.SetSoundDuration(soundHandle,duration) end

---GetSoundDuration
---@param soundHandle sound
---@return integer
function common.GetSoundDuration(soundHandle) end

---GetSoundFileDuration
---@param musicFileName string
---@return integer
function common.GetSoundFileDuration(musicFileName) end

---设置多通道音量 [R]
---@param vgroup volumegroup
---@param scale real
function common.VolumeGroupSetVolume(vgroup,scale) end

---VolumeGroupReset
function common.VolumeGroupReset() end

---GetSoundIsPlaying
---@param soundHandle sound
---@return boolean
function common.GetSoundIsPlaying(soundHandle) end

---GetSoundIsLoading
---@param soundHandle sound
---@return boolean
function common.GetSoundIsLoading(soundHandle) end

---RegisterStackedSound
---@param soundHandle sound
---@param byPosition boolean
---@param rectwidth real
---@param rectheight real
function common.RegisterStackedSound(soundHandle,byPosition,rectwidth,rectheight) end

---UnregisterStackedSound
---@param soundHandle sound
---@param byPosition boolean
---@param rectwidth real
---@param rectheight real
function common.UnregisterStackedSound(soundHandle,byPosition,rectwidth,rectheight) end

---SetSoundFacialAnimationLabel
---@param soundHandle sound
---@param animationLabel string
---@return boolean
function common.SetSoundFacialAnimationLabel(soundHandle,animationLabel) end

---SetSoundFacialAnimationGroupLabel
---@param soundHandle sound
---@param groupLabel string
---@return boolean
function common.SetSoundFacialAnimationGroupLabel(soundHandle,groupLabel) end

---SetSoundFacialAnimationSetFilepath
---@param soundHandle sound
---@param animationSetFilepath string
---@return boolean
function common.SetSoundFacialAnimationSetFilepath(soundHandle,animationSetFilepath) end

---Subtitle support that is attached to the soundHandle rather than as disperate data with the legacy UI
---Subtitle support that is attached to the soundHandle rather than as disperate data with the legacy UI
---@param soundHandle sound
---@param speakerName string
---@return boolean
function common.SetDialogueSpeakerNameKey(soundHandle,speakerName) end

---GetDialogueSpeakerNameKey
---@param soundHandle sound
---@return string
function common.GetDialogueSpeakerNameKey(soundHandle) end

---SetDialogueTextKey
---@param soundHandle sound
---@param dialogueText string
---@return boolean
function common.SetDialogueTextKey(soundHandle,dialogueText) end

---GetDialogueTextKey
---@param soundHandle sound
---@return string
function common.GetDialogueTextKey(soundHandle) end

---Effects API
---新建天气效果 [R]
---@param where rect
---@param effectID integer
---@return weathereffect
function common.AddWeatherEffect(where,effectID) end

---RemoveWeatherEffect
---@param whichEffect weathereffect
function common.RemoveWeatherEffect(whichEffect) end

---打开/关闭天气效果
---@param whichEffect weathereffect
---@param enable boolean
function common.EnableWeatherEffect(whichEffect,enable) end

---新建地形变化:弹坑 [R]
---@param x real
---@param y real
---@param radius real
---@param depth real
---@param duration integer
---@param permanent boolean
---@return terraindeformation
function common.TerrainDeformCrater(x,y,radius,depth,duration,permanent) end

---新建地形变化:波纹 [R]
---@param x real
---@param y real
---@param radius real
---@param depth real
---@param duration integer
---@param count integer
---@param spaceWaves real
---@param timeWaves real
---@param radiusStartPct real
---@param limitNeg boolean
---@return terraindeformation
function common.TerrainDeformRipple(x,y,radius,depth,duration,count,spaceWaves,timeWaves,radiusStartPct,limitNeg) end

---新建地形变化:冲击波 [R]
---@param x real
---@param y real
---@param dirX real
---@param dirY real
---@param distance real
---@param speed real
---@param radius real
---@param depth real
---@param trailTime integer
---@param count integer
---@return terraindeformation
function common.TerrainDeformWave(x,y,dirX,dirY,distance,speed,radius,depth,trailTime,count) end

---新建地形变化:随机 [R]
---@param x real
---@param y real
---@param radius real
---@param minDelta real
---@param maxDelta real
---@param duration integer
---@param updateInterval integer
---@return terraindeformation
function common.TerrainDeformRandom(x,y,radius,minDelta,maxDelta,duration,updateInterval) end

---停止地形变化 [R]
---@param deformation terraindeformation
---@param duration integer
function common.TerrainDeformStop(deformation,duration) end

---停止所有地域变形
function common.TerrainDeformStopAll() end

---新建特效(创建到坐标) [R]
---@param modelName string
---@param x real
---@param y real
---@return effect
function common.AddSpecialEffect(modelName,x,y) end

---新建特效(创建到点) [R]
---@param modelName string
---@param where location
---@return effect
function common.AddSpecialEffectLoc(modelName,where) end

---新建特效(创建到单位) [R]
---@param modelName string
---@param targetWidget widget
---@param attachPointName string
---@return effect
function common.AddSpecialEffectTarget(modelName,targetWidget,attachPointName) end

---DestroyEffect
---@param whichEffect effect
function common.DestroyEffect(whichEffect) end

---AddSpellEffect
---@param abilityString string
---@param t effecttype
---@param x real
---@param y real
---@return effect
function common.AddSpellEffect(abilityString,t,x,y) end

---AddSpellEffectLoc
---@param abilityString string
---@param t effecttype
---@param where location
---@return effect
function common.AddSpellEffectLoc(abilityString,t,where) end

---新建特效(指定技能，创建到坐标) [R]
---@param abilityId integer
---@param t effecttype
---@param x real
---@param y real
---@return effect
function common.AddSpellEffectById(abilityId,t,x,y) end

---新建特效(指定技能，创建到点) [R]
---@param abilityId integer
---@param t effecttype
---@param where location
---@return effect
function common.AddSpellEffectByIdLoc(abilityId,t,where) end

---AddSpellEffectTarget
---@param modelName string
---@param t effecttype
---@param targetWidget widget
---@param attachPoint string
---@return effect
function common.AddSpellEffectTarget(modelName,t,targetWidget,attachPoint) end

---新建特效(指定技能，创建到单位) [R]
---@param abilityId integer
---@param t effecttype
---@param targetWidget widget
---@param attachPoint string
---@return effect
function common.AddSpellEffectTargetById(abilityId,t,targetWidget,attachPoint) end

---新建闪电效果 [R]
---@param codeName string
---@param checkVisibility boolean
---@param x1 real
---@param y1 real
---@param x2 real
---@param y2 real
---@return lightning
function common.AddLightning(codeName,checkVisibility,x1,y1,x2,y2) end

---新建闪电效果(指定Z轴) [R]
---@param codeName string
---@param checkVisibility boolean
---@param x1 real
---@param y1 real
---@param z1 real
---@param x2 real
---@param y2 real
---@param z2 real
---@return lightning
function common.AddLightningEx(codeName,checkVisibility,x1,y1,z1,x2,y2,z2) end

---DestroyLightning
---@param whichBolt lightning
---@return boolean
function common.DestroyLightning(whichBolt) end

---MoveLightning
---@param whichBolt lightning
---@param checkVisibility boolean
---@param x1 real
---@param y1 real
---@param x2 real
---@param y2 real
---@return boolean
function common.MoveLightning(whichBolt,checkVisibility,x1,y1,x2,y2) end

---移动闪电效果(指定坐标) [R]
---@param whichBolt lightning
---@param checkVisibility boolean
---@param x1 real
---@param y1 real
---@param z1 real
---@param x2 real
---@param y2 real
---@param z2 real
---@return boolean
function common.MoveLightningEx(whichBolt,checkVisibility,x1,y1,z1,x2,y2,z2) end

---GetLightningColorA
---@param whichBolt lightning
---@return real
function common.GetLightningColorA(whichBolt) end

---GetLightningColorR
---@param whichBolt lightning
---@return real
function common.GetLightningColorR(whichBolt) end

---GetLightningColorG
---@param whichBolt lightning
---@return real
function common.GetLightningColorG(whichBolt) end

---GetLightningColorB
---@param whichBolt lightning
---@return real
function common.GetLightningColorB(whichBolt) end

---SetLightningColor
---@param whichBolt lightning
---@param r real
---@param g real
---@param b real
---@param a real
---@return boolean
function common.SetLightningColor(whichBolt,r,g,b,a) end

---GetAbilityEffect
---@param abilityString string
---@param t effecttype
---@param index integer
---@return string
function common.GetAbilityEffect(abilityString,t,index) end

---GetAbilityEffectById
---@param abilityId integer
---@param t effecttype
---@param index integer
---@return string
function common.GetAbilityEffectById(abilityId,t,index) end

---GetAbilitySound
---@param abilityString string
---@param t soundtype
---@return string
function common.GetAbilitySound(abilityString,t) end

---GetAbilitySoundById
---@param abilityId integer
---@param t soundtype
---@return string
function common.GetAbilitySoundById(abilityId,t) end

---Terrain API
---地形悬崖高度(指定坐标) [R]
---@param x real
---@param y real
---@return integer
function common.GetTerrainCliffLevel(x,y) end

---设置水颜色 [R]
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function common.SetWaterBaseColor(red,green,blue,alpha) end

---设置 水变形 开/关
---@param val boolean
function common.SetWaterDeforms(val) end

---指定坐标地形 [R]
---@param x real
---@param y real
---@return integer
function common.GetTerrainType(x,y) end

---地形样式(指定坐标) [R]
---@param x real
---@param y real
---@return integer
function common.GetTerrainVariance(x,y) end

---改变地形类型(指定坐标) [R]
---@param x real
---@param y real
---@param terrainType integer
---@param variation integer
---@param area integer
---@param shape integer
function common.SetTerrainType(x,y,terrainType,variation,area,shape) end

---地形通行状态关闭(指定坐标) [R]
---@param x real
---@param y real
---@param t pathingtype
---@return boolean
function common.IsTerrainPathable(x,y,t) end

---设置地形通行状态(指定坐标) [R]
---@param x real
---@param y real
---@param t pathingtype
---@param flag boolean
function common.SetTerrainPathable(x,y,t,flag) end

---Image API
---新建图像 [R]
---@param file string
---@param sizeX real
---@param sizeY real
---@param sizeZ real
---@param posX real
---@param posY real
---@param posZ real
---@param originX real
---@param originY real
---@param originZ real
---@param imageType integer
---@return image
function common.CreateImage(file,sizeX,sizeY,sizeZ,posX,posY,posZ,originX,originY,originZ,imageType) end

---删除图像
---@param whichImage image
function common.DestroyImage(whichImage) end

---显示/隐藏 [R]
---@param whichImage image
---@param flag boolean
function common.ShowImage(whichImage,flag) end

---改变图像高度
---@param whichImage image
---@param flag boolean
---@param height real
function common.SetImageConstantHeight(whichImage,flag,height) end

---改变图像位置(指定坐标) [R]
---@param whichImage image
---@param x real
---@param y real
---@param z real
function common.SetImagePosition(whichImage,x,y,z) end

---改变图像颜色 [R]
---@param whichImage image
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
function common.SetImageColor(whichImage,red,green,blue,alpha) end

---改变图像着色状态
---@param whichImage image
---@param flag boolean
function common.SetImageRender(whichImage,flag) end

---改变图像永久着色状态
---@param whichImage image
---@param flag boolean
function common.SetImageRenderAlways(whichImage,flag) end

---改变图像水上状态
---@param whichImage image
---@param flag boolean
---@param useWaterAlpha boolean
function common.SetImageAboveWater(whichImage,flag,useWaterAlpha) end

---改变图像类型
---@param whichImage image
---@param imageType integer
function common.SetImageType(whichImage,imageType) end

---Ubersplat API
---新建地面纹理变化 [R]
---@param x real
---@param y real
---@param name string
---@param red integer
---@param green integer
---@param blue integer
---@param alpha integer
---@param forcePaused boolean
---@param noBirthTime boolean
---@return ubersplat
function common.CreateUbersplat(x,y,name,red,green,blue,alpha,forcePaused,noBirthTime) end

---删除地面纹理
---@param whichSplat ubersplat
function common.DestroyUbersplat(whichSplat) end

---重置地面纹理
---@param whichSplat ubersplat
function common.ResetUbersplat(whichSplat) end

---完成地面纹理
---@param whichSplat ubersplat
function common.FinishUbersplat(whichSplat) end

---显示/隐藏 地面纹理变化[R]
---@param whichSplat ubersplat
---@param flag boolean
function common.ShowUbersplat(whichSplat,flag) end

---改变地面纹理着色状态
---@param whichSplat ubersplat
---@param flag boolean
function common.SetUbersplatRender(whichSplat,flag) end

---改变地面纹理永久着色状态
---@param whichSplat ubersplat
---@param flag boolean
function common.SetUbersplatRenderAlways(whichSplat,flag) end

---Blight API
---创建/删除荒芜地表(圆范围)(指定坐标) [R]
---@param whichPlayer player
---@param x real
---@param y real
---@param radius real
---@param addBlight boolean
function common.SetBlight(whichPlayer,x,y,radius,addBlight) end

---创建/删除荒芜地表(矩形区域) [R]
---@param whichPlayer player
---@param r rect
---@param addBlight boolean
function common.SetBlightRect(whichPlayer,r,addBlight) end

---SetBlightPoint
---@param whichPlayer player
---@param x real
---@param y real
---@param addBlight boolean
function common.SetBlightPoint(whichPlayer,x,y,addBlight) end

---SetBlightLoc
---@param whichPlayer player
---@param whichLocation location
---@param radius real
---@param addBlight boolean
function common.SetBlightLoc(whichPlayer,whichLocation,radius,addBlight) end

---新建不死族金矿 [R]
---@param id player
---@param x real
---@param y real
---@param face real
---@return unit
function common.CreateBlightedGoldmine(id,x,y,face) end

---坐标点被荒芜地表覆盖 [R]
---@param x real
---@param y real
---@return boolean
function common.IsPointBlighted(x,y) end

---Doodad API
---播放圆范围内地形装饰物动画 [R]
---@param x real
---@param y real
---@param radius real
---@param doodadID integer
---@param nearestOnly boolean
---@param animName string
---@param animRandom boolean
function common.SetDoodadAnimation(x,y,radius,doodadID,nearestOnly,animName,animRandom) end

---播放矩形区域内地形装饰物动画 [R]
---@param r rect
---@param doodadID integer
---@param animName string
---@param animRandom boolean
function common.SetDoodadAnimationRect(r,doodadID,animName,animRandom) end

---Computer AI interface
---启动对战 AI
---@param num player
---@param script string
function common.StartMeleeAI(num,script) end

---启动战役 AI
---@param num player
---@param script string
function common.StartCampaignAI(num,script) end

---发送 AI 命令
---@param num player
---@param command integer
---@param data integer
function common.CommandAI(num,command,data) end

---暂停/恢复 AI脚本运行 [R]
---@param p player
---@param pause boolean
function common.PauseCompAI(p,pause) end

---对战 AI
---@param num player
---@return aidifficulty
function common.GetAIDifficulty(num) end

---忽略单位的防守职责
---@param hUnit unit
function common.RemoveGuardPosition(hUnit) end

---恢复单位的防守职责
---@param hUnit unit
function common.RecycleGuardPosition(hUnit) end

---忽略所有单位的防守职责
---@param num player
function common.RemoveAllGuardPositions(num) end

---** Cheat标签 **
---@param cheatStr string
function common.Cheat(cheatStr) end

---无法胜利 [R]
---@return boolean
function common.IsNoVictoryCheat() end

---无法失败 [R]
---@return boolean
function common.IsNoDefeatCheat() end

---预读文件
---@param filename string
function common.Preload(filename) end

---开始预读
---@param timeout real
function common.PreloadEnd(timeout) end

---PreloadStart
function common.PreloadStart() end

---PreloadRefresh
function common.PreloadRefresh() end

---PreloadEndEx
function common.PreloadEndEx() end

---PreloadGenClear
function common.PreloadGenClear() end

---PreloadGenStart
function common.PreloadGenStart() end

---PreloadGenEnd
---@param filename string
function common.PreloadGenEnd(filename) end

---预读一批文件
---@param filename string
function common.Preloader(filename) end

---Automation Test
---Automation Test
---@param testType string
function common.AutomationSetTestType(testType) end

---AutomationTestStart
---@param testName string
function common.AutomationTestStart(testName) end

---AutomationTestEnd
function common.AutomationTestEnd() end

---AutomationTestingFinished
function common.AutomationTestingFinished() end

---RequestExtraIntegerData
---@param dataType integer
---@param whichPlayer player
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 integer
---@param param5 integer
---@param param6 integer
---@return integer
function common.RequestExtraIntegerData(dataType,whichPlayer,param1,param2,param3,param4,param5,param6) end

---RequestExtraBooleanData
---@param dataType integer
---@param whichPlayer player
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 integer
---@param param5 integer
---@param param6 integer
---@return boolean
function common.RequestExtraBooleanData(dataType,whichPlayer,param1,param2,param3,param4,param5,param6) end

---RequestExtraStringData
---@param dataType integer
---@param whichPlayer player
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 integer
---@param param5 integer
---@param param6 integer
---@return string
function common.RequestExtraStringData(dataType,whichPlayer,param1,param2,param3,param4,param5,param6) end

---RequestExtraRealData
---@param dataType integer
---@param whichPlayer player
---@param param1 string
---@param param2 string
---@param param3 boolean
---@param param4 integer
---@param param5 integer
---@param param6 integer
---@return real
function common.RequestExtraRealData(dataType,whichPlayer,param1,param2,param3,param4,param5,param6) end

---CreateCommandButtonEffect
---@param abilityId integer
---@param order string
---@return commandbuttoneffect
function common.CreateCommandButtonEffect(abilityId,order) end

---CreateUpgradeCommandButtonEffect
---@param whichUprgade integer
---@return commandbuttoneffect
function common.CreateUpgradeCommandButtonEffect(whichUprgade) end

---CreateLearnCommandButtonEffect
---@param abilityId integer
---@return commandbuttoneffect
function common.CreateLearnCommandButtonEffect(abilityId) end

---DestroyCommandButtonEffect
---@param whichEffect commandbuttoneffect
function common.DestroyCommandButtonEffect(whichEffect) end

return common
