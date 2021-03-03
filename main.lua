--physical screen dimensions
push = require 'push'
Class = require 'class'

require 'Bird'
require 'Pipe'
require 'PipePair'

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

--Table of spawning PipePairs
local pipePairs = {}

spawnTimer = 0

lastY = -PIPE_HEIGHT + math.random(80) + 20

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
    --Where the argument is the y position of the top pipe
    pipes = PipePair(-137)
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

    --Pipes class
    pipes:update(dt)

    --Next section is taken from: https://github.com/games50/fifty-bird/blob/master/bird7/main.lua
    spawnTimer = spawnTimer + dt

    -- spawn a new PipePair if the timer is past 1 seconds
    if spawnTimer > 2 then
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        -- no higher than 10 pixels below the top edge of the screen,
        -- and no lower than a gap length (90 pixels) from the bottom
        local y = math.max(-PIPE_HEIGHT + 10, 
            math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        lastY = y
        print(y)
        table.insert(pipePairs, PipePair(y))
        spawnTimer = 0
    end

    -- for every pipe pair in the scene...
    for k, pair in pairs(pipePairs) do
        pair:update(dt)

        -- check to see if bird collided with pipe
        for l, pipe in pairs(pair.pipes) do
            --if bird:collides(pipe) then
                -- pause the game to show collision
                scrolling = false
            --end
        end

        -- if pipe is no longer visible past left edge, remove it from scene
        if pair.x < -PIPE_WIDTH then
            pair.remove = true
        end
    end

    -- remove any flagged pipes
    -- we need this second loop, rather than deleting in the previous loop, because
    -- modifying the table in-place without explicit keys will result in skipping the
    -- next pipe, since all implicit keys (numerical indices) are automatically shifted
    -- down after a table removal
    for k, pair in pairs(pipePairs) do
        if pair.remove then
            table.remove(pipePairs, k)
        end
    end
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

    -- render all the pipe pairs in our scene
    for k, pair in pairs(pipePairs) do
        pair:render()
    end

    --end the virtual resolution handling library
    push:apply("end")
end