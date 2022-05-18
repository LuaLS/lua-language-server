---@meta
---@class Region : ParentedObject
---[Documentation](https://wowpedia.fandom.com/wiki/UIOBJECT_Region)
local Region = {}

---@return boolean canChange
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_CanChangeProtectedState)
function Region:CanChangeProtectedState() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_ClearAllPoints)
function Region:ClearAllPoints() end

---@return AnimationGroup
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_CreateAnimationGroup)
function Region:CreateAnimationGroup() end

---@return number alpha
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_GetAlpha)
function Region:GetAlpha() end

---@return AnimationGroup, ...
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_GetAnimationGroups)
function Region:GetAnimationGroups() end

---@return number bottom
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_GetBottom)
function Region:GetBottom() end

---@return number center
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_GetCenter)
function Region:GetCenter() end

---@return number effectiveScale
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_GetEffectiveScale)
function Region:GetEffectiveScale() end

---@return number height
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_GetHeight)
function Region:GetHeight() end

---@return number left
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_GetLeft)
function Region:GetLeft() end

---@return number numPoints
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_GetNumPoints)
function Region:GetNumPoints() end

---@param index number
---@return string point
---@return Region relativeTo
---@return string relativePoint
---@return number xOfs
---@return number yOfs
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_GetPoint)
function Region:GetPoint(index) end

---@return number left
---@return number bottom
---@return number width
---@return number height
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_GetRect)
function Region:GetRect() end

---@return number right
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_GetRight)
function Region:GetRight() end

---@return number scale
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_GetScale)
function Region:GetScale() end

---@return number left
---@return number bottom
---@return number width
---@return number height
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_GetScaledRect)
function Region:GetScaledRect() end

---@return number width
---@return number height
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_GetSize)
function Region:GetSize() end

---@return number top
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_GetTop)
function Region:GetTop() end

---@return number width
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_GetWidth)
function Region:GetWidth() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_Hide)
function Region:Hide() end

---@return boolean isDragging
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_IsDragging)
function Region:IsDragging() end

---@return boolean ignoringAlpha
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_IsIgnoringParentAlpha)
function Region:IsIgnoringParentAlpha() end

---@return boolean ignoringScale
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_IsIgnoringParentScale)
function Region:IsIgnoringParentScale() end

---@param top number
---@param bottom number
---@param left number
---@param right number
---@return boolean
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_IsMouseOver)
function Region:IsMouseOver(top, bottom, left, right) end

---@return boolean loaded
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_IsObjectLoaded)
function Region:IsObjectLoaded() end

---@return boolean protected
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_IsProtected)
function Region:IsProtected() end

---@return boolean rectValid
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_IsRectValid)
function Region:IsRectValid() end

---@return boolean isShown
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_IsShown)
function Region:IsShown() end

---@return boolean isVisible
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_IsVisible)
function Region:IsVisible() end

---@param region Region|string|nil
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_SetAllPoints)
function Region:SetAllPoints(region) end

---@param alpha number
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_SetAlpha)
function Region:SetAlpha(alpha) end

---@param height number
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_SetHeight)
function Region:SetHeight(height) end

---@param ignoreAlpha boolean
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_SetIgnoreParentAlpha)
function Region:SetIgnoreParentAlpha(ignoreAlpha) end

---@param ignoreScale boolean
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_SetIgnoreParentScale)
function Region:SetIgnoreParentScale(ignoreScale) end

---@param region Region|string|nil
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_SetParent)
function Region:SetParent(region) end

---@param point AnchorPoint
---@param relativeTo Region|string
---@param relativePoint string
---@param ofsx number
---@param ofsy number
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_SetPoint)
function Region:SetPoint(point, relativeTo, relativePoint, ofsx, ofsy) end

---@param scale number
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_SetScale)
function Region:SetScale(scale) end

---@param shown boolean
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_SetShown)
function Region:SetShown(shown) end

---@param width number
---@param height number
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_SetSize)
function Region:SetSize(width, height) end

---@param width number
---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_SetWidth)
function Region:SetWidth(width) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_Show)
function Region:Show() end

---[Documentation](https://wowpedia.fandom.com/wiki/API_Region_StopAnimating)
function Region:StopAnimating() end


---@class LayeredRegion : Region
---[Documentation](https://wowpedia.fandom.com/wiki/UIOBJECT_LayeredRegion)
local LayeredRegion = {}

---@return DrawLayer layer
---[Documentation](https://wowpedia.fandom.com/wiki/API_LayeredRegion_GetDrawLayer)
function LayeredRegion:GetDrawLayer() end

---@param layer DrawLayer
---@param sublevel? number
---[Documentation](https://wowpedia.fandom.com/wiki/API_LayeredRegion_SetDrawLayer)
function LayeredRegion:SetDrawLayer(layer, sublevel) end

---[Documentation](https://wowpedia.fandom.com/wiki/API_LayeredRegion_SetVertexColor)
function LayeredRegion:SetVertexColor(r, g, b, a) end
