---------------------------------------------------------
-- conf.lua
-- configure game window, and other various things.
---------------------------------------------------------

function love.conf(t)
	t.title = "Canny the can"
	t.author = "Norubal"
	t.version = "0.8.0"
	t.release = true
	
	t.screen.width = 816
	t.screen.height = 480
    
	t.modules.joystick = false
	t.modules.physics = false
	t.modules.mouse = false
    
	t.screen.vsync = false
end
