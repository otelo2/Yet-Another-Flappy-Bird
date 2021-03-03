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

--From https://github.com/games50/fifty-bird/blob/master/bird7/main.lua
--Table of spawning PipePairs
local pipePairs = {}

spawnTimer = 0

lastY = -PIPE_HEIGHT + math.random(80) + 20
--End of reference

--Create the game states variable
state = "none" 

function love.load()
    --initialize nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --set the window title
    love.window.setTitle('Floppy Astronaut')
    
    --initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen=false,
		resizable=true,	
		vsync=true
	})

    --initialize the input table
    love.keyboard.keysPressed = {}

    --Load the background images
    background = love.graphics.newImage("Images/background.png")
    --Load the ground image
    ground = love.graphics.newImage("Images/ground.png")
    --Load campfire
    campfire = love.graphics.newImage("Images/campfire.jpg")
    --Load the trophy image
    trophy = love.graphics.newImage("Images/trophy.png")
    --Load the marshmallow image
    marshmallow = love.graphics.newImage("Images/marshmallow.png")
    --Load the victory image
    victory = love.graphics.newImage("Images/win.jpg")
    
    --Create the bird object
    bird = Bird()
    --Where the argument is the y position of the top pipe
    pipes = PipePair(-137)
    --Sets the initial score
    score = 0
    --Bestscore initialization
    bestscore = 0
    record = false
    initial = true
    count = 0

    --winnig item
    marshmallowshow = false
    love.math.setRandomSeed(love.timer.getTime())
    magicplace = VIRTUAL_HEIGHT/2-12


    --Load the sound effects
    --When the astronaut goes up
    flySounds = {
        love.audio.newSource("Sounds/Propulsor/air1.mp3", "static"),
        love.audio.newSource("Sounds/Propulsor/air2.mp3", "static"),
        love.audio.newSource("Sounds/Propulsor/air3.mp3", "static"),
        love.audio.newSource("Sounds/Propulsor/air4.mp3", "static"),
        love.audio.newSource("Sounds/Propulsor/air5.mp3", "static"),
        love.audio.newSource("Sounds/Propulsor/air6.mp3", "static"),
        love.audio.newSource("Sounds/Propulsor/air7.mp3", "static"),
        love.audio.newSource("Sounds/Propulsor/air8.mp3", "static"),
        love.audio.newSource("Sounds/Propulsor/air9.mp3", "static")
    }

    --When a colision with a tentacle
    tentacleSounds = {
        love.audio.newSource("Sounds/Tentacle/tentacle1.mp3", "static"),
        love.audio.newSource("Sounds/Tentacle/tentacle2.mp3", "static")
    }

    --When you get a point
    scoreSounds = {
        love.audio.newSource("Sounds/Score/score1.ogg", "static"),
        love.audio.newSource("Sounds/Score/score2.ogg", "static"),
        love.audio.newSource("Sounds/Score/score3.ogg", "static"),
        love.audio.newSource("Sounds/Score/score4.ogg", "static"),
    }

    --When you crash on the floor
    floorSounds = {
        love.audio.newSource("Sounds/Floor/floor1.mp3", "static"),
        love.audio.newSource("Sounds/Floor/floor2.mp3", "static"),
        love.audio.newSource("Sounds/Floor/floor3.mp3", "static"),
        love.audio.newSource("Sounds/Floor/floor4.mp3", "static")
    }

    --letters
    smallfont = love.graphics.newFont('Font/ARCADECLASSIC.ttf', 10)
    font = love.graphics.newFont('Font/ARCADECLASSIC.ttf', 18)

    --Load the music
    startingMusic = love.audio.newSource("Music/mainMenu.mp3", "stream")
    startingMusic:setVolume(0.5) --50% volume
    playingMusic = love.audio.newSource("Music/playing.mp3", "stream")
    playingMusic:setVolume(0.1) --10% volume

    --Set the game state to starting
    state = "starting"
end


--This is executed when the window is resized
function love.resize(w, h)
    --Pass to the push library the new dimensions of the window
    push:resize(w,h)
end


--Runs when a key is pressed
function love.keypressed(key)
    -- table to cath all the times that the user clics on a key
    if state == "playing" then
        love.keyboard.keysPressed[key] = true
    end

    --Space to start playing
    if key == 'space' or 'w' then
        if state == "starting" then
            state = "playing"
            initial = false
        end

        if state == "playing" then
            --Play a random fyling sound. The '#' gives the number of elements in the table
            flySounds[math.random(#flySounds)]:play()
        end

        if state == "finish" or state == "champion" then
            --So you don't miss the finish screen
            love.timer.sleep(1)
            --Reset all values
            state = "starting"
            marshmallowshow = false
            bird:reset()
            --Set a nil value to all elements of the table. Pretty much empties it
            for k in pairs (pipePairs) do
                pipePairs[k] = nil
            end
            score = 0
            record = false
        end
    end

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
    --Describe what should happen when we are playing
    if state == "playing" then
        --Play the music for this state
        playingMusic:play()
        startingMusic:stop()

        --scroll background by present speed * dt, loops back to 0 after the looping point
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT

        --scroll ground, loops back to 0 after the looping point
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) % GROUND_LOOPING_POINT

        --bird class
        bird:update(dt)
        if bird:crashes() then
            floorSounds[math.random(#floorSounds)]:play()
            state="finish"
        end

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
                if bird:collides(pipe) then
                    tentacleSounds[math.random(#tentacleSounds)]:play()
                    -- pause the game to show collision
                    state="finish"
                    --set the bestscore
                end
            end

            --Increse the score if we got through a pipe
            if pair.x < VIRTUAL_WIDTH/2-16 and pair.dangerous==true then
                score = score + 1
                magicplace = love.math.random(VIRTUAL_HEIGHT-24-55)
                scoreSounds[math.random(#scoreSounds)]:play()
                pair.dangerous=false
                if score >= 1 then
                    marshmallowshow = true
                end
                --update the bestscore if needed
                if bestscore < score then
                    bestscore = score
                    record = true
                end
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
    --End of the playing state
    if state == "starting" then
        --Play the main menu music
        startingMusic:play()
        playingMusic:stop()
    end

    --check if the bird takes the marshmallow
    if state == "playing" and bird:marshmallow(magicplace) and marshmallowshow then
        --count = count +1
        state = "champion"
        score = 999999
        bestscore = score
    else
        --debug
        count = count+1
    end

    --reset the input table
    --if it is not restarted... the astronaut floats away
    love.keyboard.keysPressed = {}
end


function love.draw()
    --start the filter
    push:apply("start")   
    
    love.graphics.setFont(font)     
    
    --What we render at the start screen
    if state == "starting" then
        if initial then
            love.graphics.draw(campfire, -60, -40)
        else
        --draw the background
        love.graphics.draw(background, -backgroundScroll, 0, 0, 1, 0.65)

        --draw the ground on top of the background, toward the bottom of the screen
        love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-30, 0, 1, 0.1)

        --bird class
        bird:render()
        end

        --Draw the title of the game
        love.graphics.printf('Floppy Astronaut', 0,0,VIRTUAL_WIDTH,'center')

        --Draw the prompt to start the game
        love.graphics.printf('Press space to start!', 0,30,VIRTUAL_WIDTH,'center')

    end
    --End of the starting state

    --What is rendered when we play
    if state == "playing" then
        --draw the background
        love.graphics.draw(background, -backgroundScroll, 0, 0, 1, 0.65)

        --bird class
        bird:render()

        -- render all the pipe pairs in our scene
        for k, pair in pairs(pipePairs) do
            pair:render()
        end

        --draw the ground on top of the background, toward the bottom of the screen
        love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-30, 0, 1, 0.1)

        --print the score 
        love.graphics.print(tostring(score), VIRTUAL_WIDTH/2, 20)

        --change the font
        love.graphics.setFont(smallfont)
        love.graphics.print('BESTSCORE', VIRTUAL_WIDTH-70, 10)
        love.graphics.print(tostring(bestscore), VIRTUAL_WIDTH-45, 20)

        if marshmallowshow then
            love.graphics.draw(marshmallow, VIRTUAL_WIDTH/2-12, magicplace, 0, 0.05, 0.05)
        end
    end
    --End of the playing state

    --What is rendered when we lost
    if state == "finish" then
        --draw the background
        love.graphics.draw(background, -backgroundScroll, 0, 0, 1, 0.65)
        
        --bird class
        bird:die()
        
        -- render all the pipe pairs in our scene
        for k, pair in pairs(pipePairs) do
            pair:render()
        end
        
        --draw the ground on top of the background, toward the bottom of the screen
        love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT-30, 0, 1, 0.1)

        if record then
            love.graphics.print('NEW   RECORD', VIRTUAL_WIDTH/2-45, 15)
            love.graphics.print(tostring(score), VIRTUAL_WIDTH/2, 30)
            --added trophy picture
            love.graphics.draw(trophy, VIRTUAL_WIDTH/2-145, 10)
        else
            love.graphics.printf('Final score ' .. tostring(score) ..'!', 0,30,VIRTUAL_WIDTH,'center')
        end
    end

    --What is rendered when we win
    if state == "champion" then
        --draw the background
        love.graphics.draw(victory, 90,-10, 0,0.4,0.4)
        love.graphics.print('VICTORY', 0+30, 15)
        love.graphics.print('SCORE', VIRTUAL_WIDTH-80, VIRTUAL_HEIGHT-45)
        love.graphics.print(tostring(score), VIRTUAL_WIDTH-80, VIRTUAL_HEIGHT-30)
    end
    --DEBUG INFO
    --love.graphics.print(tostring(magicplace), 0, 0)
    --love.graphics.print(tostring(count), 0, 30)
    --love.graphics.print(tostring(bird.y), 0, 15)
    
    --end the virtual resolution handling library
    push:apply("end")
end