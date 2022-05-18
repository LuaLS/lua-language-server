---@meta
---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector2DMixin)
---@class Vector2DMixin
---@field x number|nil
---@field y number|nil
Vector2DMixin = {}

---[FrameXML](https://www.townlong-yak.com/framexml/go/CreateVector2D)
---@param x number
---@param y number
---@return Vector2DMixin
function CreateVector2D(x, y) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/AreVector2DEqual)
---@param left Vector2DMixin
---@param right Vector2DMixin
---@return boolean
function AreVector2DEqual(left, right) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector2DMixin:IsEqualTo)
---@param otherVector Vector2DMixin
---@return boolean
function Vector2DMixin:IsEqualTo(otherVector) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector2DMixin:GetXY)
---@return number x
---@return number y
function Vector2DMixin:GetXY() end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector2DMixin:SetXY)
---@param x number
---@param y number
function Vector2DMixin:SetXY(x, y) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector2DMixin:ScaleBy)
---@param scalar number
function Vector2DMixin:ScaleBy(scalar) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector2DMixin:DivideBy)
---@param scalar number
function Vector2DMixin:DivideBy(scalar) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector2DMixin:Add)
---@param other Vector2DMixin
function Vector2DMixin:Add(other) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector2DMixin:Subtract)
---@param other Vector2DMixin
function Vector2DMixin:Subtract(other) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector2DMixin:Cross)
---@param other Vector2DMixin
function Vector2DMixin:Cross(other) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector2DMixin:Dot)
---@param other Vector2DMixin
---@return number
function Vector2DMixin:Dot(other) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector2DMixin:IsZero)
---@return boolean
function Vector2DMixin:IsZero() end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector2DMixin:GetLengthSquared)
---@return number
function Vector2DMixin:GetLengthSquared() end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector2DMixin:GetLength)
---@return number
function Vector2DMixin:GetLength() end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector2DMixin:Normalize)
function Vector2DMixin:Normalize() end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector2DMixin:RotateDirection)
---@param rotationRadians number
function Vector2DMixin:RotateDirection(rotationRadians) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector2DMixin:Clone)
---@return Vector2DMixin
function Vector2DMixin:Clone() end
