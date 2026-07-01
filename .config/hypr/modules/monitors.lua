------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "HDMI-A-1",
    -- mode     = "preferred",
	mode = "1366x768@60.00",
	-- mode = "1920x1080@60.00",
    scale    = "auto",
    position = "0x0",
})
hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@60.00",
	scale = 1,
	position = "1920x0"
})
