Bird = Class{}

GRAVITY = 20 --?

local BIRD_IMAGE = love.graphics.newImage("Images/austronaut.png")

function Bird:init()
    --Position bird in the middle of the screen
	self.x = VIRTUAL_WIDTH / 2 - 9
    self.y = VIRTUAL_HEIGHT / 2 - 12
    self.dy = 0
end

function Bird:update(dt)
	--the bird falls according to the GRAVITY
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
    	self.dy = -5
    end

    --The bird is always in the middle
    --there is no change in self.x 
    self.y = self.y + self.dy
end

function Bird:collides(pipe)
	--bottom
	if (self.x + 16) >= pipe.x and self.x <= pipe.x + 84 then
		if self.y + 25 >= pipe.y and self.y <= pipe.y + 120 then
			return true
		end
	end

	return false
end

function Bird:crashes()
	--bottom
	if self.y + 55 >= VIRTUAL_HEIGHT then
		return true 
	end

	return false
end

function Bird:render()
    love.graphics.draw(BIRD_IMAGE, self.x, self.y)
end