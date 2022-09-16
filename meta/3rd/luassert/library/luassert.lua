---@meta

---@class luassert
---@field unique fun(v1,deep?:boolean,failure_message?:string)
---@field is_unique fun(v1,deep?:boolean,failure_message?:string)
---@field not_unique fun(v1,deep?:boolean,failure_message?:string)
---@field near fun(expected:number|string,actual:number|string,tolerance:number|string,failure_message?:string)
---@field is_near fun(expected:number|string,actual:number|string,tolerance:number|string,failure_message?:string)
---@field not_near fun(expected:number|string,actual:number|string,tolerance:number|string,failure_message?:string)
---@field matches fun(pattern:string,actual:string|number,init?:number,plain?:boolean,failure_message?:string)
---@field is_matches fun(pattern:string,actual:string|number,init?:number,plain?:boolean,failure_message?:string)
---@field not_matches fun(pattern:string,actual:string|number,init?:number,plain?:boolean,failure_message?:string)
---@field equal fun(v1,v2,failure_message?:string)
---@field equals fun(v1:table,v2:table,failure_message?:string)
---@field is_equal fun(v1,v2,failure_message?:string)
---@field is_equals fun(v1:table,v2:table,failure_message?:string)
---@field not_equal fun(v1,v2,failure_message?:string)
---@field not_equals fun(v1:table,v2:table,failure_message?:string)
---@field same fun(v1,v2,failure_message?:string)
---@field is_same fun(v1,v2,failure_message?:string)
---@field not_same fun(v1,v2,failure_message?:string)
---@field truthy fun(v1,v2,failure_message?:string)
---@field falsy fun(v1,v2,failure_message?:string)
---@field error fun(func:fun(),err_expected?:string,failure_message?:string)
---@field errors fun(func:fun(),err_expected?:string,failure_message?:string)
---@field has_error fun(func:fun(),err_expected?:string,failure_message?:string)
---@field has_errors fun(func:fun(),err_expected?:string,failure_message?:string)
---@field no_error fun(func:fun(),err_expected?:string,failure_message?:string)
---@field no_errors fun(func:fun(),err_expected?:string,failure_message?:string)
---@field error_matches fun(func:fun(),pattern:string,init?:number,plain?:boolean,failure_message?:string)
---@field is_error_matches fun(func:fun(),pattern:string,init?:number,plain?:boolean,failure_message?:string)
---@field not_error_matches fun(func:fun(),pattern:string,init?:number,plain?:boolean,failure_message?:string)
---@field number fun(v)
---@field string fun(v)
---@field table fun(v)
---@field userdata fun(v)
---@field function fun(v)
---@field thread fun(v)
---@field boolean fun(v)
---@field returned_arguments fun(...,fn:function)
---@field property fun(name:string,obj)
---@field is_number fun(v)
---@field is_string fun(v)
---@field is_table fun(v)
---@field is_nil fun(v)
---@field is_userdata fun(v)
---@field is_function fun(v)
---@field is_thread fun(v)
---@field is_boolean fun(v)
---@field is_true fun(b)
---@field is_returned_arguments fun(...,fn:function)
---@field is_false fun(b)
---@field has_property fun(name:string,obj)
---@field not_number fun(v)
---@field not_string fun(v)
---@field not_table fun(v)
---@field not_nil fun(v)
---@field not_userdata fun(v)
---@field not_function fun(v)
---@field not_thread fun(v)
---@field not_boolean fun(v)
---@field not_true fun(b)
---@field not_false fun(b)
---@field not_returned_arguments fun(...,fn:function)
---@field no_property fun(name:string,obj)
---@field message fun(failure_message:string)
---@module 'luassert'
local luassert = {}

---comment
---@param fn function
---@param failure_message? string
---@return luassert_spy
function luassert.spy(fn,failure_message)
end

---comment
---@param fn function
---@param failure_message? string
---@return luassert_stub
function luassert.stub(fn,failure_message)
end


return luassert