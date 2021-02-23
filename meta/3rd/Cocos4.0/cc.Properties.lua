---@meta

---@class cc.Properties 
local Properties={ }
cc.Properties=Properties




---* Returns the value of a variable that is set in this Properties object.<br>
---* Variables take on the format ${name} and are inherited from parent Property objects.<br>
---* param name Name of the variable to get.<br>
---* param defaultValue Value to return if the variable is not found.<br>
---* return The value of the specified variable, or defaultValue if not found.
---@param name char
---@param defaultValue char
---@return char
function Properties:getVariable (name,defaultValue) end
---* Get the value of the given property as a string. This can always be retrieved,<br>
---* whatever the intended type of the property.<br>
---* param name The name of the property to interpret, or NULL to return the current property's value.<br>
---* param defaultValue The default value to return if the specified property does not exist.<br>
---* return The value of the given property as a string, or the empty string if no property with that name exists.
---@return char
function Properties:getString () end
---* Interpret the value of the given property as a long integer.<br>
---* If the property does not exist, zero will be returned.<br>
---* If the property exists but could not be scanned, an error will be logged and zero will be returned.<br>
---* param name The name of the property to interpret, or NULL to return the current property's value.<br>
---* return The value of the given property interpreted as a long.<br>
---* Zero if the property does not exist or could not be scanned.
---@return long
function Properties:getLong () end
---@overload fun():self
---@overload fun(char:char,boolean:boolean,boolean:boolean):self
---@param id char
---@param searchNames boolean
---@param recurse boolean
---@return self
function Properties:getNamespace (id,searchNames,recurse) end
---* Gets the file path for the given property if the file exists.<br>
---* This method will first search for the file relative to the working directory.<br>
---* If the file is not found then it will search relative to the directory the bundle file is in.<br>
---* param name The name of the property.<br>
---* param path The string to copy the path to if the file exists.<br>
---* return True if the property exists and the file exists, false otherwise.<br>
---* script{ignore}
---@param name char
---@param path string
---@return boolean
function Properties:getPath (name,path) end
---* Interpret the value of the given property as a Matrix.<br>
---* If the property does not exist, out will be set to the identity matrix.<br>
---* If the property exists but could not be scanned, an error will be logged and out will be set<br>
---* to the identity matrix.<br>
---* param name The name of the property to interpret, or NULL to return the current property's value.<br>
---* param out The matrix to set to this property's interpreted value.<br>
---* return True on success, false if the property does not exist or could not be scanned.
---@param name char
---@param out mat4_table
---@return boolean
function Properties:getMat4 (name,out) end
---* Check if a property with the given name is specified in this Properties object.<br>
---* param name The name of the property to query.<br>
---* return True if the property exists, false otherwise.
---@param name char
---@return boolean
function Properties:exists (name) end
---* Sets the value of the property with the specified name.<br>
---* If there is no property in this namespace with the current name,<br>
---* one is added. Otherwise, the value of the first property with the<br>
---* specified name is updated.<br>
---* If name is NULL, the value current property (see getNextProperty) is<br>
---* set, unless there is no current property, in which case false<br>
---* is returned.<br>
---* param name The name of the property to set.<br>
---* param value The property value.<br>
---* return True if the property was set, false otherwise.
---@param name char
---@param value char
---@return boolean
function Properties:setString (name,value) end
---* Get the ID of this Property's namespace. The ID should be a unique identifier,<br>
---* but its uniqueness is not enforced.<br>
---* return The ID of this Property's namespace.
---@return char
function Properties:getId () end
---* Rewind the getNextProperty() and getNextNamespace() iterators<br>
---* to the beginning of the file.
---@return self
function Properties:rewind () end
---* Sets the value of the specified variable.<br>
---* param name Name of the variable to set.<br>
---* param value The value to set.
---@param name char
---@param value char
---@return self
function Properties:setVariable (name,value) end
---* Interpret the value of the given property as a boolean.<br>
---* param name The name of the property to interpret, or NULL to return the current property's value.<br>
---* param defaultValue the default value to return if the specified property does not exist within the properties file.<br>
---* return true if the property exists and its value is "true", otherwise false.
---@return boolean
function Properties:getBool () end
---@overload fun(char:char,vec3_table1:vec4_table):self
---@overload fun(char:char,vec3_table:vec3_table):self
---@param name char
---@param out vec3_table
---@return boolean
function Properties:getColor (name,out) end
---* Returns the type of a property.<br>
---* param name The name of the property to interpret, or NULL to return the current property's type.<br>
---* return The type of the property.
---@return int
function Properties:getType () end
---* Get the next namespace.
---@return self
function Properties:getNextNamespace () end
---* Interpret the value of the given property as an integer.<br>
---* If the property does not exist, zero will be returned.<br>
---* If the property exists but could not be scanned, an error will be logged and zero will be returned.<br>
---* param name The name of the property to interpret, or NULL to return the current property's value.<br>
---* return The value of the given property interpreted as an integer.<br>
---* Zero if the property does not exist or could not be scanned.
---@return int
function Properties:getInt () end
---* Interpret the value of the given property as a Vector3.<br>
---* If the property does not exist, out will be set to Vector3(0.0f, 0.0f, 0.0f).<br>
---* If the property exists but could not be scanned, an error will be logged and out will be set<br>
---* to Vector3(0.0f, 0.0f, 0.0f).<br>
---* param name The name of the property to interpret, or NULL to return the current property's value.<br>
---* param out The vector to set to this property's interpreted value.<br>
---* return True on success, false if the property does not exist or could not be scanned.
---@param name char
---@param out vec3_table
---@return boolean
function Properties:getVec3 (name,out) end
---* Interpret the value of the given property as a Vector2.<br>
---* If the property does not exist, out will be set to Vector2(0.0f, 0.0f).<br>
---* If the property exists but could not be scanned, an error will be logged and out will be set<br>
---* to Vector2(0.0f, 0.0f).<br>
---* param name The name of the property to interpret, or NULL to return the current property's value.<br>
---* param out The vector to set to this property's interpreted value.<br>
---* return True on success, false if the property does not exist or could not be scanned.
---@param name char
---@param out vec2_table
---@return boolean
function Properties:getVec2 (name,out) end
---* Interpret the value of the given property as a Vector4.<br>
---* If the property does not exist, out will be set to Vector4(0.0f, 0.0f, 0.0f, 0.0f).<br>
---* If the property exists but could not be scanned, an error will be logged and out will be set<br>
---* to Vector4(0.0f, 0.0f, 0.0f, 0.0f).<br>
---* param name The name of the property to interpret, or NULL to return the current property's value.<br>
---* param out The vector to set to this property's interpreted value.<br>
---* return True on success, false if the property does not exist or could not be scanned.
---@param name char
---@param out vec4_table
---@return boolean
function Properties:getVec4 (name,out) end
---* Get the name of the next property.<br>
---* If a valid next property is returned, the value of the property can be<br>
---* retrieved using any of the get methods in this class, passing NULL for the property name.<br>
---* return The name of the next property, or NULL if there are no properties remaining.
---@return char
function Properties:getNextProperty () end
---* Interpret the value of the given property as a floating-point number.<br>
---* If the property does not exist, zero will be returned.<br>
---* If the property exists but could not be scanned, an error will be logged and zero will be returned.<br>
---* param name The name of the property to interpret, or NULL to return the current property's value.<br>
---* return The value of the given property interpreted as a float.<br>
---* Zero if the property does not exist or could not be scanned.
---@return float
function Properties:getFloat () end
---* Interpret the value of the given property as a Quaternion specified as an axis angle.<br>
---* If the property does not exist, out will be set to Quaternion().<br>
---* If the property exists but could not be scanned, an error will be logged and out will be set<br>
---* to Quaternion().<br>
---* param name The name of the property to interpret, or NULL to return the current property's value.<br>
---* param out The quaternion to set to this property's interpreted value.<br>
---* return True on success, false if the property does not exist or could not be scanned.
---@param name char
---@param out cc.Quaternion
---@return boolean
function Properties:getQuaternionFromAxisAngle (name,out) end
---@overload fun(char:char,vec3_table1:vec4_table):self
---@overload fun(char:char,vec3_table:vec3_table):self
---@param str char
---@param out vec3_table
---@return boolean
function Properties:parseColor (str,out) end
---* Attempts to parse the specified string as a Vector3 value.<br>
---* On error, false is returned and the output is set to all zero values.<br>
---* param str The string to parse.<br>
---* param out The value to populate if successful.<br>
---* return True if a valid Vector3 was parsed, false otherwise.
---@param str char
---@param out vec3_table
---@return boolean
function Properties:parseVec3 (str,out) end
---* Attempts to parse the specified string as an axis-angle value.<br>
---* The specified string is expected to contain four comma-separated<br>
---* values, where the first three values represents the axis and the<br>
---* fourth value represents the angle, in degrees.<br>
---* On error, false is returned and the output is set to all zero values.<br>
---* param str The string to parse.<br>
---* param out A Quaternion populated with the orientation of the axis-angle, if successful.<br>
---* return True if a valid axis-angle was parsed, false otherwise.
---@param str char
---@param out cc.Quaternion
---@return boolean
function Properties:parseAxisAngle (str,out) end
---* Attempts to parse the specified string as a Vector2 value.<br>
---* On error, false is returned and the output is set to all zero values.<br>
---* param str The string to parse.<br>
---* param out The value to populate if successful.<br>
---* return True if a valid Vector2 was parsed, false otherwise.
---@param str char
---@param out vec2_table
---@return boolean
function Properties:parseVec2 (str,out) end
---* Attempts to parse the specified string as a Vector4 value.<br>
---* On error, false is returned and the output is set to all zero values.<br>
---* param str The string to parse.<br>
---* param out The value to populate if successful.<br>
---* return True if a valid Vector4 was parsed, false otherwise.
---@param str char
---@param out vec4_table
---@return boolean
function Properties:parseVec4 (str,out) end