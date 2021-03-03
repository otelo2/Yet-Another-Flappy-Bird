Pipe = Class{}

--Load the image one time instead of each instance 
local PIPE_IMAGE = love.graphics.newImage('Images/tentacle.png')

--Speed ad which the pipe scrolls
PIPE_SPEED = 60

--Dimensions of the pipe image
PIPE_HEIGHT = 288
PIPE_WIRDTH = 70

function Pipe:init(orientation, y)
    -- load bird image and assign width and height
    self.x = VIRTUAL_WIDTH
    self.y = y

    self.width = PIPE_IMAGE:getWidth()
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
    0, 1, self.orientation == 'top' and -1 or 1)
end