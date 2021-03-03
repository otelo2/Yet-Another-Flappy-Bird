Bird = Class{}

GRAVITY = 15 --?

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

    if love.keyboard.wasPressed('space') or love.keyboard.wasPressed('w') then
    	self.dy = -2
    end

    --The bird is always in the middle
    --there is no change in self.x 
    self.y = math.max(0, self.y + self.dy)
end

function Bird:collides(pipe)
	if (self.x + 16) >= pipe.x and self.x <= pipe.x + pipe.width then
		if self.y + 25 >= pipe.y and self.y <= pipe.y + pipe.height then
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

function Bird:marshmallow(magicplace)
	--top
	if self.y <= magicplace then
		if self.y >= (magicplace + 12) then
			return true
		end
	end
	--bottom
	if (self.y + 25) <= magicplace then
		if (self.y + 25) >= (magicplace + 12) then
			return true
		end
	end
	--center
	if (self.y + 12) <= magicplace then
		if (self.y + 12) >= (magicplace + 12) then		
			return true 
		end
	end

	return false
end

function Bird:render()
    love.graphics.draw(BIRD_IMAGE, self.x, self.y)
end

function Bird:die()
    love.graphics.draw(BIRD_IMAGE, self.x, self.y+15, math.rad(-45), 1, 1)
end

function Bird:reset()
	--Set the bird to its initial values
	self.x = VIRTUAL_WIDTH / 2 - 9
    self.y = VIRTUAL_HEIGHT / 2 - 12
    self.dy = 0
end