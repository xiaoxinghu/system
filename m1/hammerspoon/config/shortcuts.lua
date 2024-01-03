-- hs.loadSpoon("AClock")
-- spoon.AClock:init()

hs.hotkey.bind({ "cmd", "ctrl", "alt", "shift" }, "t", function()
	hs.application.launchOrFocus("Warp")
end)

hs.hotkey.bind({ "cmd", "ctrl", "alt", "shift" }, "e", function()
	-- hs.application.launchOrFocus("/Users/xiaoxing/Applications/Home Manager Apps/Emacs.app")
	hs.application.launchOrFocus("/Applications/Nix Apps/Emacs.app")
end)

hs.hotkey.bind({ "cmd", "ctrl", "alt", "shift" }, "b", function()
	hs.application.launchOrFocus("Safari")
end)

hs.hotkey.bind({ "cmd", "ctrl", "alt", "shift" }, "x", function()
	hs.application.launchOrFocus("Xcode")
end)

hs.hotkey.bind({ "cmd", "ctrl", "alt", "shift" }, "s", function()
	hs.application.launchOrFocus("Slack")
end)

hs.hotkey.bind({ "cmd", "ctrl", "alt", "shift" }, "c", function()
	hs.application.launchOrFocus("Google Chrome")
end)
