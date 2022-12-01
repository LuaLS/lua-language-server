---@meta

---@class cc.UserDefault 
local UserDefault={ }
cc.UserDefault=UserDefault




---* Set integer value by key.<br>
---* param key The key to set.<br>
---* param value A integer value to set to the key.<br>
---* js NA
---@param key char
---@param value int
---@return self
function UserDefault:setIntegerForKey (key,value) end
---* delete any value by key,<br>
---* param key The key to delete value.<br>
---* js NA
---@param key char
---@return self
function UserDefault:deleteValueForKey (key) end
---@overload fun(char:char,float:float):self
---@overload fun(char:char):self
---@param key char
---@param defaultValue float
---@return float
function UserDefault:getFloatForKey (key,defaultValue) end
---@overload fun(char:char,boolean:boolean):self
---@overload fun(char:char):self
---@param key char
---@param defaultValue boolean
---@return boolean
function UserDefault:getBoolForKey (key,defaultValue) end
---* Set double value by key.<br>
---* param key The key to set.<br>
---* param value A double value to set to the key.<br>
---* js NA
---@param key char
---@param value double
---@return self
function UserDefault:setDoubleForKey (key,value) end
---* Set float value by key.<br>
---* param key The key to set.<br>
---* param value A float value to set to the key.<br>
---* js NA
---@param key char
---@param value float
---@return self
function UserDefault:setFloatForKey (key,value) end
---@overload fun(char:char,string:string):self
---@overload fun(char:char):self
---@param key char
---@param defaultValue string
---@return string
function UserDefault:getStringForKey (key,defaultValue) end
---* Set string value by key.<br>
---* param key The key to set.<br>
---* param value A string value to set to the key.<br>
---* js NA
---@param key char
---@param value string
---@return self
function UserDefault:setStringForKey (key,value) end
---* You should invoke this function to save values set by setXXXForKey().<br>
---* js NA
---@return self
function UserDefault:flush () end
---@overload fun(char:char,int:int):self
---@overload fun(char:char):self
---@param key char
---@param defaultValue int
---@return int
function UserDefault:getIntegerForKey (key,defaultValue) end
---@overload fun(char:char,double:double):self
---@overload fun(char:char):self
---@param key char
---@param defaultValue double
---@return double
function UserDefault:getDoubleForKey (key,defaultValue) end
---* Set bool value by key.<br>
---* param key The key to set.<br>
---* param value A bool value to set to the key.<br>
---* js NA
---@param key char
---@param value boolean
---@return self
function UserDefault:setBoolForKey (key,value) end
---* js NA
---@return self
function UserDefault:destroyInstance () end
---*  All supported platforms other iOS & Android use xml file to save values. This function is return the file path of the xml path.<br>
---* js NA
---@return string
function UserDefault:getXMLFilePath () end
---*  All supported platforms other iOS & Android use xml file to save values. This function checks whether the xml file exists or not.<br>
---* return True if the xml file exists, false if not.<br>
---* js NA
---@return boolean
function UserDefault:isXMLFileExist () end