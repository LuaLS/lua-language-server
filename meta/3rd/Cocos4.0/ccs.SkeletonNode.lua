---@meta

---@class ccs.SkeletonNode :ccs.BoneNode
local SkeletonNode={ }
ccs.SkeletonNode=SkeletonNode




---* get bonenode in skeleton node by bone name
---@param boneName string
---@return ccs.BoneNode
function SkeletonNode:getBoneNode (boneName) end
---@overload fun(map_table0:string):self
---@overload fun(map_table:map_table):self
---@param boneSkinNameMap map_table
---@return self
function SkeletonNode:changeSkins (boneSkinNameMap) end
---* brief: add a boneSkinNameMap as a SkinGroup named groupName<br>
---* param: groupName, key<br>
---* param: boneSkinNameMap, map <name of bone, name of skin to display which added to bone>
---@param groupName string
---@param boneSkinNameMap map_table
---@return self
function SkeletonNode:addSkinGroup (groupName,boneSkinNameMap) end
---* get All bones in this skeleton, <bone's name, BoneNode>
---@return map_table
function SkeletonNode:getAllSubBonesMap () end
---* 
---@return self
function SkeletonNode:create () end
---* 
---@return rect_table
function SkeletonNode:getBoundingBox () end
---* 
---@return boolean
function SkeletonNode:init () end
---* 
---@return self
function SkeletonNode:SkeletonNode () end