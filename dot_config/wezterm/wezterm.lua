local config = {}

local wezterm = require("wezterm")

config.color_scheme = "Gruvbox Dark (Gogh)"
config.font_size = 19

-- 1. 开启 FreeType 的轻量 hinting（更接近 VSCode 的效果）
config.freetype_load_target = 'Light'      -- 可选: Normal, Light, Mono, HorizontalLcd
config.freetype_render_target = 'Light'  -- 启用子像素渲染
config.freetype_load_flags = "NO_HINTING"

-- 2. 如果在 macOS 上，可以试试这个
config.front_end = 'WebGpu'  -- 换用 WebGPU 后端，渲染质量可能有变化

-- 3. 轻盈的代码字体，中文使用文楷等宽作为 fallback
config.font = wezterm.font_with_fallback({
	{ family = "IBM Plex Mono", weight = "Light" },
	{ family = "LXGW WenKai Mono", weight = "Light" },
})

-- 4. 行高和像素间距微调
config.line_height = 1.08
config.cell_width = 1.0

config.keys = {
	-- ... your other key bindings ...

	{
		key = "T",
		mods = "CTRL|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

-- 当非活跃 tab 收到 bell 时显示视觉提示
config.audible_bell = "Disabled"  -- 关掉声音
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 75,
}

-- tab bar 上未聚焦 tab 有输出时的样式
config.colors = {
  tab_bar = {
    inactive_tab_hover = {
      bg_color = '#3b3052',
      fg_color = '#909090',
    },
  },
}

return config
