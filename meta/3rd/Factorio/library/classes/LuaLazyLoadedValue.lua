---@meta

---A lazily loaded value. For performance reasons, we sometimes return a custom lazily-loaded value type instead of the native Lua value. This custom type lazily constructs the necessary value when [LuaLazyLoadedValue::get](LuaLazyLoadedValue::get) is called, therefore preventing its unnecessary construction in some cases.
---
---An instance of LuaLazyLoadedValue is only valid during the event it was created from and cannot be saved.
---@class LuaLazyLoadedValue<K>: {object_name:string; valid:boolean; get:fun():K; help:fun():string}
