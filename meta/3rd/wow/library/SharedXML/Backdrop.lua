---@meta
---@class backdropInfo
---@field bgFile string
---@field edgeFile string
---@field tile boolean
---@field tileSize number
---@field tileEdge boolean
---@field edgeSize number
---@field insets backdropInsets

---@class backdropInsets
---@field left number
---@field right number
---@field top number
---@field bottom number

---@class BackdropTemplate
---[Documentation](https://wowpedia.fandom.com/wiki/BackdropTemplate)
local BackdropTemplateMixin = {}

---[FrameXML](https://www.townlong-yak.com/framexml/go/BackdropTemplateMixin:OnBackdropLoaded)
function BackdropTemplateMixin:OnBackdropLoaded() end

---[FrameXML](https://www.townlong-yak.com/framexml/go/BackdropTemplateMixin:OnBackdropSizeChanged)
function BackdropTemplateMixin:OnBackdropSizeChanged() end

---@return number
---[FrameXML](https://www.townlong-yak.com/framexml/go/BackdropTemplateMixin:GetEdgeSize)
function BackdropTemplateMixin:GetEdgeSize() end

---[FrameXML](https://www.townlong-yak.com/framexml/go/BackdropTemplateMixin:SetupTextureCoordinates)
function BackdropTemplateMixin:SetupTextureCoordinates() end

---[FrameXML](https://www.townlong-yak.com/framexml/go/BackdropTemplateMixin:SetupPieceVisuals)
function BackdropTemplateMixin:SetupPieceVisuals(piece, setupInfo, pieceLayout) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/BackdropTemplateMixin:SetBorderBlendMode)
function BackdropTemplateMixin:SetBorderBlendMode(blendMode) end

---@param backdropInfo backdropInfo
---[FrameXML](https://www.townlong-yak.com/framexml/go/BackdropTemplateMixin:HasBackdropInfo)
function BackdropTemplateMixin:HasBackdropInfo(backdropInfo) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/BackdropTemplateMixin:ClearBackdrop)
function BackdropTemplateMixin:ClearBackdrop() end

---[FrameXML](https://www.townlong-yak.com/framexml/go/BackdropTemplateMixin:ApplyBackdrop)
function BackdropTemplateMixin:ApplyBackdrop() end

---@param backdropInfo backdropInfo
---[FrameXML](https://www.townlong-yak.com/framexml/go/BackdropTemplateMixin:SetBackdrop)
function BackdropTemplateMixin:SetBackdrop(backdropInfo) end

---@return backdropInfo
---[FrameXML](https://www.townlong-yak.com/framexml/go/BackdropTemplateMixin:GetBackdrop)
function BackdropTemplateMixin:GetBackdrop() end

---@return number r Returns nil if `self.backdropInfo` is not defined
---@return number g
---@return number b
---@return number a
---[FrameXML](https://www.townlong-yak.com/framexml/go/BackdropTemplateMixin:GetBackdropColor)
function BackdropTemplateMixin:GetBackdropColor() end

---@param r number
---@param g number
---@param b number
---@param a? number
---[FrameXML](https://www.townlong-yak.com/framexml/go/BackdropTemplateMixin:SetBackdropColor)
function BackdropTemplateMixin:SetBackdropColor(r, g, b, a) end

---@return number r Returns nil if `self.backdropInfo` is not defined
---@return number g
---@return number b
---@return number a
---[FrameXML](https://www.townlong-yak.com/framexml/go/BackdropTemplateMixin:GetBackdropBorderColor)
function BackdropTemplateMixin:GetBackdropBorderColor() end

---@param r number
---@param g number
---@param b number
---@param a? number
---[FrameXML](https://www.townlong-yak.com/framexml/go/BackdropTemplateMixin:SetBackdropBorderColor)
function BackdropTemplateMixin:SetBackdropBorderColor(r, g, b, a) end
