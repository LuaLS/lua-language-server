---@meta
C_SplashScreen = {}

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SplashScreen.AcknowledgeSplash)
function C_SplashScreen.AcknowledgeSplash() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SplashScreen.CanViewSplashScreen)
---@return boolean canView
function C_SplashScreen.CanViewSplashScreen() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_C_SplashScreen.RequestLatestSplashScreen)
---@param fromGameMenu boolean
function C_SplashScreen.RequestLatestSplashScreen(fromGameMenu) end

---@class SplashScreenInfo
---@field textureKit string
---@field minDisplayCharLevel number
---@field minQuestDisplayLevel number
---@field soundKitID number
---@field allianceQuestID number|nil
---@field hordeQuestID number|nil
---@field header string
---@field topLeftFeatureTitle string
---@field topLeftFeatureDesc string
---@field bottomLeftFeatureTitle string
---@field bottomLeftFeatureDesc string
---@field rightFeatureTitle string
---@field rightFeatureDesc string
---@field shouldShowQuest boolean
---@field screenType SplashScreenType
