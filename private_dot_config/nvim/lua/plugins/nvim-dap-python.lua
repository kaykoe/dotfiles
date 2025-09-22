return {
	"mfussenegger/nvim-dap-python",
	-- stylua: ignore
	config = function()
		if vim.fn.has("win32") == 1 then
			require("dap-python").setup(LazyVim.get_pkg_path("debugpy", "/venv/Scripts/pythonw.exe"))
		else
			require("dap-python").setup("uv")
		end
		for _, config in ipairs(require("dap").configurations.python) do
			config.justMyCode = false
		end
	end,
}
