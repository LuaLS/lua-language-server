---@meta
---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector3DMixin)
---@class Vector3DMixin
---@field x number|nil
---@field y number|nil
---@field z number|nil
Vector3DMixin = {}

---[FrameXML](https://www.townlong-yak.com/framexml/go/CreateVector3D)
---@param x number
---@param y number
---@param z number
---@return Vector3DMixin
function CreateVector3D(x, y, z) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/AreVector3DEqual)
---@param left Vector3DMixin
---@param right Vector3DMixin
---@return boolean
function AreVector3DEqual(left, right) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector3DMixin:IsEqualTo)
---@param otherVector Vector3DMixin
---@return boolean
function Vector3DMixin:IsEqualTo(otherVector) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector3DMixin:GetXYZ)
---@return number x
---@return number y
---@return number z
function Vector3DMixin:GetXYZ() end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector3DMixin:SetXYZ)
---@param x number
---@param y number
---@param z number
function Vector3DMixin:SetXYZ(x, y, z) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector3DMixin:ScaleBy)
---@param scalar number
function Vector3DMixin:ScaleBy(scalar) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector3DMixin:DivideBy)
---@param scalar number
function Vector3DMixin:DivideBy(scalar) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector3DMixin:Add)
---@param other Vector3DMixin
function Vector3DMixin:Add(other) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector3DMixin:Subtract)
---@param other Vector3DMixin
function Vector3DMixin:Subtract(other) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector3DMixin:Cross)
---@param other Vector3DMixin
function Vector3DMixin:Cross(other) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector3DMixin:Dot)
---@param other Vector3DMixin
---@return number
function Vector3DMixin:Dot(other) end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector3DMixin:GetLengthSquared)
---@return number
function Vector3DMixin:GetLengthSquared() end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector3DMixin:GetLength)
---@return number
function Vector3DMixin:GetLength() end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector3DMixin:Normalize)
function Vector3DMixin:Normalize() end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Vector3DMixin:Clone)
---@return Vector3DMixin
function Vector3DMixin:Clone() end
