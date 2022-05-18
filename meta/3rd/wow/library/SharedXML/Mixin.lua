---@meta
---[FrameXML](https://www.townlong-yak.com/framexml/go/Mixin)
--- Copies mixins into an existing object
---@param object table
---@vararg table
---@return table mixin
function Mixin(object, ...)
	for i = 1, select("#", ...) do
		local mixin = select(i, ...);
		for k, v in pairs(mixin) do
			object[k] = v;
		end
	end
	return object;
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/CreateFromMixins)
--- Copies mixins into a new object
---@vararg table
---@return table mixin
function CreateFromMixins(...)
	return Mixin({}, ...)
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/CreateAndInitFromMixin)
--- Copies mixins into a new object and initializes it
---@param mixin table
---@vararg table
---@return table mixin
function CreateAndInitFromMixin(mixin, ...)
	local object = CreateFromMixins(mixin);
	object:Init(...);
	return object;
end
