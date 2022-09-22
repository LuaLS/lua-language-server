files = {
	".*_spec%.lua",
	".*_test%.lua",
}

configs = {
	{
		key = "Lua.workspace.library",
		action = "add",
		value = "${3rd}/luassert/library",
	},
}
