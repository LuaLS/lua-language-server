---@meta
C_ScenarioInfo = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ScenarioInfo.GetJailersTowerTypeString)
---@param runType JailersTowerType
---@return string? typeString
function C_ScenarioInfo.GetJailersTowerTypeString(runType) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ScenarioInfo.GetScenarioInfo)
---@return ScenarioInformation scenarioInfo
function C_ScenarioInfo.GetScenarioInfo() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_ScenarioInfo.GetScenarioStepInfo)
---@param scenarioStepID? number
---@return ScenarioStepInfo scenarioStepInfo
function C_ScenarioInfo.GetScenarioStepInfo(scenarioStepID) end

---@class ScenarioInformation
---@field name string
---@field currentStage number
---@field numStages number
---@field flags number
---@field isComplete boolean
---@field xp number
---@field money number
---@field type number
---@field area string
---@field uiTextureKit string

---@class ScenarioStepInfo
---@field title string
---@field description string
---@field numCriteria number
---@field stepFailed boolean
---@field isBonusStep boolean
---@field isForCurrentStepOnly boolean
---@field shouldShowBonusObjective boolean
---@field spells ScenarioStepSpellInfo[]
---@field weightedProgress number|nil
---@field rewardQuestID number
---@field widgetSetID number|nil

---@class ScenarioStepSpellInfo
---@field spellID number
---@field name string
---@field icon number
