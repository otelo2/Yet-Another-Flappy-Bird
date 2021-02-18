--physical screen dimensions
push = require 'push'

--Virtual resolution dimensions
--Values PENDING
VIRTUAL_HEIGHT  = 243
VIRTUAL_WIDTH   = 432
WINDOW_HEIGHT   = 720
WINDOW_WIDTH    = 1280

--
--BIRD_SPEED    =





function love.load()
    --initialize nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    --set the window title
    love.window.setTitle('Something something')
    
    --initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen=false,													--NO se puede usar la pantalla completa
		resizable=false,													--NO se puede cambiar el tamaño de la ventana
		vsync=true
	})

    --Load the background images
    background = love.graphics.newImage("Images/background.png")
    --Load the ground image
    ground = love.graphics.newImage("Images/ground.png")

end


function love.keypressed(key)
    -- "escape"
    
    --exit the game pressing esc
    if key == 'escape' then
        love.event.quit()
    end
end


function love.update(dt)
    --nothing yet
end


function love.draw()
    --start the filter
    push:apply("start")   	
    
    --draw the background
    love.graphics.draw(background, 0, 0, 0, 1, 1)

    --draw the ground on top of the background, toward the bottom of the screen
    love.graphics.draw(background, 0, VIRTUAL_HEIGHT-50, 0, 1, 1)

    --end the virtual resolution handling library
    push:apply("end")
end