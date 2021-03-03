Bird = Class{}

GRAVITY = 30 --?

local BIRD_IMAGE = love.graphics.newImage("Images/austronaut.png")

function Bird:init()
    self.x = VIRTUAL_WIDTH / 2 - 9
    self.y = VIRTUAL_HEIGHT / 2 - 12
    -- load bird image and assign width and height

    --Position bird in the middle of the screen

end

function Bird:update(dt)
	--the bird falls according to the GRAVITY
    self.y = self.y + GRAVITY * dt

    --The bird is always in the middle
    --there is no change in self.x 

end

function Bird:render()
    love.graphics.draw(BIRD_IMAGE, self.x, self.y)
end