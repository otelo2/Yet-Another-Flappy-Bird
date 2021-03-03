Bird = Class{}

GRAVITY = 50 --?

local BIRD_IMAGE = love.graphics.newImage("Images/austronaut.png")

function Bird:init()
    self.x = VIRTUAL_WIDTH / 2 - 9
    self.y = VIRTUAL_HEIGHT / 2 - 12
    self.dy = 0
    -- load bird image and assign width and height

    --Position bird in the middle of the screen

end

function Bird:update(dt)
	--the bird falls according to the GRAVITY
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
    	self.dy = -2
    --else
    --	self.dy = 1
    end

    --The bird is always in the middle
    --there is no change in self.x 

    self.y = self.y + self.dy

end

function Bird:render()
    love.graphics.draw(BIRD_IMAGE, self.x, self.y)
end