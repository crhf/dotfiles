local java_cmds = vim.api.nvim_create_augroup("java_cmds", { clear = true })
local cache_vars = {}

local root_files = {
	-- '.git',
	"mvnw",
	"gradlew",
	"pom.xml",
	"build.gradle",
}

local function find_root(markers, bufname)
	local api = vim.api
	local uv = vim.loop
	local path = require("jdtls.path")

	bufname = bufname or api.nvim_buf_get_name(api.nvim_get_current_buf())
	local dirname = vim.fn.fnamemodify(bufname, ":p:h")
	local getparent = function(p)
		return vim.fn.fnamemodify(p, ":h")
	end
	local highest = ""
	while getparent(dirname) ~= dirname do
		for _, marker in ipairs(markers) do
			if uv.fs_stat(path.join(dirname, marker)) then
				-- return dirname
				highest = dirname
			end
		end
		dirname = getparent(dirname)
	end
	if highest ~= "" then
		return highest
	end

	dirname = vim.fn.fnamemodify(bufname, ":p:h")
	while getparent(dirname) ~= dirname do
		if uv.fs_stat(path.join(dirname, ".git")) then
			return dirname
		end
		dirname = getparent(dirname)
	end

	return vim.fn.fnamemodify(bufname, ":p:h")
end

local features = {
	-- change this to `true` to enable codelens
	codelens = false,

	-- change this to `true` if you have `nvim-dap`,
	-- `java-test` and `java-debug-adapter` installed
	debugger = true,
}

local function get_jdtls_paths()
	if cache_vars.paths then
		return cache_vars.paths
	end

	local path = {}

	path.data_dir = vim.fn.stdpath("cache") .. "/nvim-jdtls"

	local jdtls_install = require("mason-registry").get_package("jdtls"):get_install_path()

	path.java_agent = jdtls_install .. "/lombok.jar"
	path.launcher_jar = vim.fn.glob(jdtls_install .. "/plugins/org.eclipse.equinox.launcher_*.jar")

	if vim.fn.has("mac") == 1 then
		path.platform_config = jdtls_install .. "/config_mac"
	elseif vim.fn.has("unix") == 1 then
		path.platform_config = jdtls_install .. "/config_linux"
	elseif vim.fn.has("win32") == 1 then
		path.platform_config = jdtls_install .. "/config_win"
	end

	path.bundles = {}

	---
	-- Include java-test bundle if present
	---
	local java_test_path = require("mason-registry").get_package("java-test"):get_install_path()

	local java_test_bundle = vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar"), "\n")

	if java_test_bundle[1] ~= "" then
		vim.list_extend(path.bundles, java_test_bundle)
	end

	---
	-- Include java-debug-adapter bundle if present
	---
	local java_debug_path = require("mason-registry").get_package("java-debug-adapter"):get_install_path()

	local java_debug_bundle =
		vim.split(vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar"), "\n")

	if java_debug_bundle[1] ~= "" then
		vim.list_extend(path.bundles, java_debug_bundle)
	end

	---
	-- Useful if you're starting jdtls with a Java version that's
	-- different from the one the project uses.
	---
	path.runtimes = {
		-- Note: the field `name` must be a valid `ExecutionEnvironment`,
		-- you can find the list here:
		-- https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
		--
		-- This example assume you are using sdkman: https://sdkman.io
		{
			name = "JavaSE-1.8",
			path = vim.fn.expand("~/.sdkman/candidates/java/8.0.372.fx-zulu/"),
		},
		{
			name = "JavaSE-17",
			path = vim.fn.expand("~/.sdkman/candidates/java/17.0.7-zulu/"),
		},
		{
			name = "JavaSE-11",
			path = vim.fn.expand("~/.sdkman/candidates/java/11.0.21-zulu/"),
		},
	}

	cache_vars.paths = path

	return path
end

local function enable_codelens(bufnr)
	pcall(vim.lsp.codelens.refresh)

	vim.api.nvim_create_autocmd("BufWritePost", {
		buffer = bufnr,
		group = java_cmds,
		desc = "refresh codelens",
		callback = function()
			pcall(vim.lsp.codelens.refresh)
		end,
	})
end

local function enable_debugger(bufnr)
	require("jdtls").setup_dap({ hotcodereplace = "auto" })
	require("jdtls.dap").setup_dap_main_class_configs()

	local opts = { buffer = bufnr }
	vim.keymap.set("n", "<leader>df", "<cmd>lua require('jdtls').test_class()<cr>", opts)
	vim.keymap.set("n", "<leader>dn", "<cmd>lua require('jdtls').test_nearest_method()<cr>", opts)
end

local function jdtls_on_attach(client, bufnr)
	if features.debugger then
		enable_debugger(bufnr)
	end

	if features.codelens then
		enable_codelens(bufnr)
	end

	if client.server_capabilities.documentSymbolProvider then
		require("nvim-navic").attach(client, bufnr)
	end

	-- The following mappings are based on the suggested usage of nvim-jdtls
	-- https://github.com/mfussenegger/nvim-jdtls#usage

	local opts = { buffer = bufnr }
	vim.keymap.set("n", "<A-o>", "<cmd>lua require('jdtls').organize_imports()<cr>", opts)
	vim.keymap.set("n", "crv", "<cmd>lua require('jdtls').extract_variable()<cr>", opts)
	vim.keymap.set("x", "crv", "<esc><cmd>lua require('jdtls').extract_variable(true)<cr>", opts)
	vim.keymap.set("n", "crc", "<cmd>lua require('jdtls').extract_constant()<cr>", opts)
	vim.keymap.set("x", "crc", "<esc><cmd>lua require('jdtls').extract_constant(true)<cr>", opts)
	vim.keymap.set("x", "crm", "<esc><Cmd>lua require('jdtls').extract_method(true)<cr>", opts)

	vim.keymap.set("n", "<leader>ws", function()
		vim.ui.input({ prompt = "Workspace symbols: " }, function(query)
			require("telescope.builtin").lsp_workspace_symbols({ query = query })
		end)
	end, opts)

	--- Guard against servers without the signatureHelper capability
	if client.server_capabilities.signatureHelpProvider then
		require("lsp-overloads").setup(client, {
			-- UI options are mostly the same as those passed to vim.lsp.util.open_floating_preview
			ui = {
				border = "single", -- The border to use for the signature popup window. Accepts same border values as |nvim_open_win()|.
				height = nil, -- Height of the signature popup window (nil allows dynamic sizing based on content of the help)
				width = nil, -- Width of the signature popup window (nil allows dynamic sizing based on content of the help)
				wrap = true, -- Wrap long lines
				wrap_at = nil, -- Character to wrap at for computing height when wrap enabled
				max_width = nil, -- Maximum signature popup width
				max_height = nil, -- Maximum signature popup height
				-- Events that will close the signature popup window: use {"CursorMoved", "CursorMovedI", "InsertCharPre"} to hide the window when typing
				close_events = { "CursorMoved", "BufHidden", "InsertLeave" },
				focusable = true, -- Make the popup float focusable
				focus = false, -- If focusable is also true, and this is set to true, navigating through overloads will focus into the popup window (probably not what you want)
				offset_x = 0, -- Horizontal offset of the floating window relative to the cursor position
				offset_y = 0, -- Vertical offset of the floating window relative to the cursor position
				floating_window_above_cur_line = false, -- Attempt to float the popup above the cursor position
				-- (note, if the height of the float would be greater than the space left above the cursor, it will default
				-- to placing the float below the cursor. The max_height option allows for finer tuning of this)
			},
			keymaps = {
				next_signature = "<C-d>",
				previous_signature = "<C-u>",
				next_parameter = "<C-l>",
				previous_parameter = "<C-h>",
				close_signature = "<C-e>",
			},
			display_automatically = true, -- Uses trigger characters to automatically display the signature overloads when typing a method signature
		})
	end
end

local function jdtls_setup(event)
	local jdtls = require("jdtls")

	local path = get_jdtls_paths()
	-- local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
	-- local root_dir = jdtls.setup.find_root(root_files)
	local root_dir = find_root(root_files)
	-- local data_dir = path.data_dir .. '/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')
	local data_dir_name = vim.fn.fnamemodify(root_dir, ":p:gs?/?-?")
	data_dir_name = string.sub(data_dir_name, 2, string.len(data_dir_name) - 1)
	local data_dir = path.data_dir .. "/" .. data_dir_name

	if cache_vars.capabilities == nil then
		jdtls.extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

		local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
		cache_vars.capabilities = vim.tbl_deep_extend(
			"force",
			vim.lsp.protocol.make_client_capabilities(),
			ok_cmp and cmp_lsp.default_capabilities() or {}
		)
	end

	-- The command that starts the language server
	-- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
	local cmd = {
		-- 💀
		"/home/haifeng/.sdkman/candidates/java/17.0.7-zulu/bin/java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-javaagent:" .. path.java_agent,
		"-Xms1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",

		-- 💀
		"-jar",
		path.launcher_jar,

		-- 💀
		"-configuration",
		path.platform_config,

		-- 💀
		"-data",
		data_dir,
	}

	local lsp_settings = {
		java = {
			-- jdt = {
			--   ls = {
			--     vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m"
			--   }
			-- },
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				updateBuildConfiguration = "interactive",
				runtimes = path.runtimes,
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			-- inlayHints = {
			--   parameterNames = {
			--     enabled = 'all' -- literals, all, none
			--   }
			-- },
			format = {
				enabled = true,
				-- settings = {
				--   profile = 'asdf'
				-- },
			},
		},
		signatureHelp = {
			enabled = true,
		},
		completion = {
			favoriteStaticMembers = {
				"org.hamcrest.MatcherAssert.assertThat",
				"org.hamcrest.Matchers.*",
				"org.hamcrest.CoreMatchers.*",
				"org.junit.jupiter.api.Assertions.*",
				"java.util.Objects.requireNonNull",
				"java.util.Objects.requireNonNullElse",
				"org.mockito.Mockito.*",
			},
		},
		contentProvider = {
			preferred = "fernflower",
		},
		extendedClientCapabilities = jdtls.extendedClientCapabilities,
		sources = {
			organizeImports = {
				starThreshold = 9999,
				staticStarThreshold = 9999,
			},
		},
		codeGeneration = {
			toString = {
				template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
			},
			useBlocks = true,
		}

		-- handlers = {
		-- 	["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		-- 		-- Disable virtual_text
		-- 		virtual_text = false,
		-- 	}),
		-- },
	}

	-- This starts a new client & server,
	-- or attaches to an existing client & server depending on the `root_dir`.
	jdtls.start_or_attach({
		cmd = cmd,
		settings = lsp_settings,
		on_attach = jdtls_on_attach,
		capabilities = cache_vars.capabilities,
		-- root_dir = jdtls.setup.find_root(root_files), -- .. '/src/main/java',
		root_dir = find_root(root_files), -- .. '/src/main/java',
		flags = {
			allow_incremental_sync = true,
		},
		init_options = {
			bundles = path.bundles,
		}
	})
end

vim.api.nvim_create_autocmd("FileType", {
	group = java_cmds,
	pattern = { "java" },
	desc = "Setup jdtls",
	callback = jdtls_setup,
})
