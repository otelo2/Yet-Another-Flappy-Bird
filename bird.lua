Bird = Class{}

GRAVITY = 20 --?

--TODO: Find image for the bird

function Bird:init()
    -- load bird image and assign width and height

    --Position bird in the middle of the screen

end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    --The bird is always in the middle
    --self.dx = 

end

function Bird:render()
    --draw
end