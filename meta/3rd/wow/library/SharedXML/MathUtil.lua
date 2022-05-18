---@meta
---[FrameXML](https://www.townlong-yak.com/framexml/go/Lerp)
---@param startValue number
---@param endValue number
---@param amount number
---@return number
function Lerp(startValue, endValue, amount)
	return (1 - amount) * startValue + amount * endValue;
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Clamp)
---@param value number
---@param min number
---@param max number
---@return number
function Clamp(value, min, max)
	if value > max then
		return max;
	elseif value < min then
		return min;
	end
	return value;
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Saturate)
---@param value number
---@return number
function Saturate(value)
	return Clamp(value, 0.0, 1.0);
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Wrap)
---@param value number
---@param max number
---@return number
function Wrap(value, max)
	return (value - 1) % max + 1;
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/ClampDegrees)
---@param value number
---@return number
function ClampDegrees(value)
	return ClampMod(value, 360);
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/ClampMod)
---@param value number
---@param mod number
---@return number
function ClampMod(value, mod)
	return ((value % mod) + mod) % mod;
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/NegateIf)
---@param value number
---@param condition boolean
---@return number
function NegateIf(value, condition)
	return condition and -value or value;
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/PercentageBetween)
---@param value number
---@param startValue number
---@param endValue number
---@return number
function PercentageBetween(value, startValue, endValue)
	if startValue == endValue then
		return 0.0;
	end
	return (value - startValue) / (endValue - startValue);
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/ClampedPercentageBetween)
---@param value number
---@param startValue number
---@param endValue number
---@return number
function ClampedPercentageBetween(value, startValue, endValue)
	return Saturate(PercentageBetween(value, startValue, endValue));
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/DeltaLerp)
---@param value number
---@param startValue number
---@param endValue number
---@param timeSec number
---@return number
local TARGET_FRAME_PER_SEC = 60.0;
function DeltaLerp(startValue, endValue, amount, timeSec)
	return Lerp(startValue, endValue, Saturate(amount * timeSec * TARGET_FRAME_PER_SEC));
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/FrameDeltaLerp)
---@param startValue number
---@param endValue number
---@param amount number
---@return number
function FrameDeltaLerp(startValue, endValue, amount)
	--return DeltaLerp(startValue, endValue, amount, GetTickTime());
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/RandomFloatInRange)
---@param minValue number
---@param maxValue number
---@return number
function RandomFloatInRange(minValue, maxValue)
	return Lerp(minValue, maxValue, math.random());
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Round)
---@param value number
---@return number
function Round(value)
	if value < 0.0 then
		return math.ceil(value - .5);
	end
	return math.floor(value + .5);
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/Square)
---@param value number
---@return number
function Square(value)
	return value * value;
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/CalculateDistanceSq)
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function CalculateDistanceSq(x1, y1, x2, y2)
	local dx = x2 - x1;
	local dy = y2 - y1;
	return (dx * dx) + (dy * dy);
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/CalculateDistance)
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function CalculateDistance(x1, y1, x2, y2)
	return math.sqrt(CalculateDistanceSq(x1, y1, x2, y2));
end

---[FrameXML](https://www.townlong-yak.com/framexml/go/CalculateAngleBetween)
---@param x1 number
---@param y1 number
---@param x2 number
---@param y2 number
---@return number
function CalculateAngleBetween(x1, y1, x2, y2)
	---@diagnostic disable-next-line: deprecated
	return math.atan2(y2 - y1, x2 - x1);
end
