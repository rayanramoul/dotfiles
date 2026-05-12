-- 27" 4K monitors at scale 1.5 (logical 2560 wide, integer ratio).

hl.monitor({ output = "DP-2", mode = "3840x2160@60",  position = "0x0",    scale = "1.5" })
hl.monitor({ output = "DP-1", mode = "3840x2160@160", position = "2560x0", scale = "1.5" })
