require "data"

function love.conf(t)
    t.window.width = WIDTH
    t.window.height = HEIGHT
    t.modules.joystick = false
    t.modules.physics = false
end