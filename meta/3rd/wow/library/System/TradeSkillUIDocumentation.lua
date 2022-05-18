---@meta
C_TradeSkillUI = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TradeSkillUI.CraftRecipe)
---@param recipeSpellID number
---@param numCasts number
---@param optionalReagents? OptionalReagentInfo[]
---@param recipeLevel? number
function C_TradeSkillUI.CraftRecipe(recipeSpellID, numCasts, optionalReagents, recipeLevel) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TradeSkillUI.GetAllProfessionTradeSkillLines)
---@return number[] skillLineID
function C_TradeSkillUI.GetAllProfessionTradeSkillLines() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TradeSkillUI.GetOptionalReagentBonusText)
---@param recipeSpellID number
---@param optionalReagentIndex number
---@param optionalReagents OptionalReagentInfo[]
---@return string bonusText
function C_TradeSkillUI.GetOptionalReagentBonusText(recipeSpellID, optionalReagentIndex, optionalReagents) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TradeSkillUI.GetOptionalReagentInfo)
---@param recipeSpellID number
---@return OptionalReagentSlot[] slots
function C_TradeSkillUI.GetOptionalReagentInfo(recipeSpellID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TradeSkillUI.GetRecipeInfo)
---@param recipeSpellID number
---@param recipeLevel? number
---@return TradeSkillRecipeInfo? recipeInfo
function C_TradeSkillUI.GetRecipeInfo(recipeSpellID, recipeLevel) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TradeSkillUI.GetRecipeNumReagents)
---@param recipeSpellID number
---@param recipeLevel? number
---@return number numReagents
function C_TradeSkillUI.GetRecipeNumReagents(recipeSpellID, recipeLevel) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TradeSkillUI.GetRecipeReagentInfo)
---@param recipeSpellID number
---@param reagentIndex number
---@param recipeLevel? number
---@return string? reagentName
---@return number? reagentFileID
---@return number reagentCount
---@return number playerReagentCount
function C_TradeSkillUI.GetRecipeReagentInfo(recipeSpellID, reagentIndex, recipeLevel) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TradeSkillUI.GetRecipeRepeatCount)
---@return number recastTimes
function C_TradeSkillUI.GetRecipeRepeatCount() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TradeSkillUI.GetTradeSkillDisplayName)
---@param skillLineID number
---@return string professionDisplayName
function C_TradeSkillUI.GetTradeSkillDisplayName(skillLineID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TradeSkillUI.GetTradeSkillLine)
---@return number skillLineID
---@return string skillLineDisplayName
---@return number skillLineRank
---@return number skillLineMaxRank
---@return number skillLineModifier
---@return number? parentSkillLineID
---@return string? parentSkillLineDisplayName
function C_TradeSkillUI.GetTradeSkillLine() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TradeSkillUI.GetTradeSkillLineInfoByID)
---@param skillLineID number
---@return string skillLineDisplayName
---@return number skillLineRank
---@return number skillLineMaxRank
---@return number skillLineModifier
---@return number? parentSkillLineID
function C_TradeSkillUI.GetTradeSkillLineInfoByID(skillLineID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TradeSkillUI.IsEmptySkillLineCategory)
---@param categoryID number
---@return boolean effectivelyKnown
function C_TradeSkillUI.IsEmptySkillLineCategory(categoryID) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_TradeSkillUI.SetRecipeRepeatCount)
---@param recipeSpellID number
---@param numCasts number
---@param optionalReagents? OptionalReagentInfo[]
function C_TradeSkillUI.SetRecipeRepeatCount(recipeSpellID, numCasts, optionalReagents) end

---@class OptionalReagentSlot
---@field requiredSkillRank number
---@field lockedReason string|nil
---@field slotText string|nil
---@field options number[]
