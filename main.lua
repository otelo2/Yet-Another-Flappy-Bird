--physical screen dimensions
push = require 'push'
Class = require 'class'

require 'Bird'
require 'pipe'
require 'pipePair'

--Virtual resolution dimensions
VIRTUAL_HEIGHT  = 243
VIRTUAL_WIDTH   = 432
WINDOW_HEIGHT   = 720
WINDOW_WIDTH    = 1280

--Starting scroll location
backgroundScroll = 0
groundScroll = 0

--Scroll speed (scaled by dt)
BACKGROUND_SCROLL_SPEED = 30
GROUND_SCROLL_SPEED = 60

--Point at which we should loop our background back to x 0
BACKGROUND_LOOPING_POINT = 1328
GROUND_LOOPING_POINT = 740
--
--BIRD_SPEED    =

function love.load()
    --initialize nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --set the window title
    love.window.setTitle('Something something')
    
    --initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen=false,			--NO se puede usar pantalla completa
		resizable=true,	
		vsync=true
	})

    --initialize the input table
    love.keyboard.keysPressed = {}

    --Load the background images
    background = love.graphics.newImage("Images/background.png")
    --Load the ground image
    ground = love.graphics.newImage("Images/ground.png")
    
    bird = Bird()
end

--This is executed when the window is resized
function love.resize(w, h)
    --Pass to the push library the new dimensions of the window
    push:resize(w,h)
end


function love.keypressed(key)
    -- table to cath all the times that the user clics on a key
    love.keyboard.keysPressed['space'] = true
    
    --exit the game pressing esc
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    --find out if the user pressed the key or not
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end


function love.update(dt)
    --scroll background by present speed * dt, loops back to 0 after the looping point
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    
    --scroll ground, loops back to 0 after the looping point
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

    --bird class
    bird:update(dt)

end


function love.draw()
    --start the filter
    push:apply("start")   	
    
    --draw the background
    love.graphics.draw(background, -backgroundScroll, 0, 0, 1, 0.65)

    --draw the ground on top of the background, toward the bottom of the screen
    --TODO: Se ve cortado cuando vuelve a repetirse el scroll
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-30, 0, 1, 0.1)

    --bird class
    bird:render()

    --end the virtual resolution handling library
    push:apply("end")
end