Pipe = Class{}

--Load the image one time instead of each instance 
local PIPE_IMAGE = love.graphics.newImage('Images/tentacle.png')

--Speed ad which the pipe scrolls
PIPE_SPEED = 60

--Dimensions of the pipe image
PIPE_HEIGHT = 120
PIPE_WIDTH = 84

function Pipe:init(orientation, y)
    -- load bird image and assign width and height
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_WIDTH--PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT

    self.orientation = orientation
    --Position bird in the middle of the screen

end

function Pipe:update(dt)

end

function Pipe:render()
    --draw
    love.graphics.draw(PIPE_IMAGE, self.x, 
    (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
    0, 0.5, self.orientation == 'top' and -0.5 or 0.5)
end