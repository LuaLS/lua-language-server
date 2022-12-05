---@meta

---@class ccs.ActionManagerEx :cc.Ref
local ActionManagerEx={ }
ccs.ActionManagerEx=ActionManagerEx




---* Stop an Action with a name.<br>
---* param jsonName  UI file name<br>
---* param actionName  action name in the UIfile.<br>
---* return  ActionObject which named as the param name
---@param jsonName char
---@param actionName char
---@return ccs.ActionObject
function ActionManagerEx:stopActionByName (jsonName,actionName) end
---* Gets an ActionObject with a name.<br>
---* param jsonName  UI file name<br>
---* param actionName  action name in the UI file.<br>
---* return  ActionObject which named as the param name
---@param jsonName char
---@param actionName char
---@return ccs.ActionObject
function ActionManagerEx:getActionByName (jsonName,actionName) end
---* 
---@return int
function ActionManagerEx:getStudioVersionNumber () end
---@overload fun(char:char,char:char,cc.CallFunc:cc.CallFunc):self
---@overload fun(char:char,char:char):self
---@param jsonName char
---@param actionName char
---@param func cc.CallFunc
---@return ccs.ActionObject
function ActionManagerEx:playActionByName (jsonName,actionName,func) end
---* Release all actions.
---@return self
function ActionManagerEx:releaseActions () end
---* Purges ActionManager point.<br>
---* js purge<br>
---* lua destroyActionManager
---@return self
function ActionManagerEx:destroyInstance () end
---* Gets the static instance of ActionManager.<br>
---* js getInstance<br>
---* lua getInstance
---@return self
function ActionManagerEx:getInstance () end