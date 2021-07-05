---@meta

---@class cc.Physics3DConstraint :cc.Ref
local Physics3DConstraint={ }
cc.Physics3DConstraint=Physics3DConstraint




---* set enable or not
---@param enabled boolean
---@return self
function Physics3DConstraint:setEnabled (enabled) end
---* set the impulse that break the constraint
---@param impulse float
---@return self
function Physics3DConstraint:setBreakingImpulse (impulse) end
---* get user data
---@return void
function Physics3DConstraint:getUserData () end
---* get the impulse that break the constraint
---@return float
function Physics3DConstraint:getBreakingImpulse () end
---* get rigid body a
---@return cc.Physics3DRigidBody
function Physics3DConstraint:getBodyA () end
---* is it enabled
---@return boolean
function Physics3DConstraint:isEnabled () end
---* get override number of solver iterations
---@return int
function Physics3DConstraint:getOverrideNumSolverIterations () end
---* get rigid body b
---@return cc.Physics3DRigidBody
function Physics3DConstraint:getBodyB () end
---* override the number of constraint solver iterations used to solve this constraint, -1 will use the default number of iterations, as specified in SolverInfo.m_numIterations
---@param overrideNumIterations int
---@return self
function Physics3DConstraint:setOverrideNumSolverIterations (overrideNumIterations) end
---* get constraint type
---@return int
function Physics3DConstraint:getConstraintType () end
---* get user data
---@param userData void
---@return self
function Physics3DConstraint:setUserData (userData) end
---* 
---@return btTypedConstraint
function Physics3DConstraint:getbtContraint () end