local lightCrystal = {
	quad = ASSETS.LIGHT_CRYSTAL;
	quadScaleX = 4;
	quadScaleY = 4;
	motionX = 0;
	motionY = 200;
	ground = nil;
	isFalling = true;
}
collision.makeCollider(0,0,8,4,lightCrystal);
local lightStrength = 0.75;

entityTypes.lightCrystal = lightCrystal;

function lightCrystal:start ()
	local dir = (self.posX + self.posY) / 32;
	dir = dir - 1;
	dir = dir % 2
	dir = 2 * (dir - 0.5);
	self.quadScaleX = 4 * helpers.getDir(dir);

	table.insert(gameWorld.mainLayer2, self);
end

function lightCrystal:update (dt)
	lightingSystem.addLight(self.posX, self.posY, 128*1.5,

	0.75*lightStrength,1*lightStrength,0.75*lightStrength);
	if (self.ground == nil) then
		local collidedX, collidedY = self:moveAndCollide(gameWorld.exposedWalls, dt);
		if (not collidedY) then
			for i = 1, #gameWorld.hittable do
				if self:collide(gameWorld.hittable[i]) then
					entitySystem.message(gameWorld.hittable[i], "hit", 100);
				end
			end
		else
			for i = 1, #gameWorld.exposedWalls do
				if collision.pointInCollider(self.posX, self.posY + (self.sizeY*1.5),gameWorld.exposedWalls[i]) then
					self.ground = gameWorld.exposedWalls[i];
				end
				break;
			end
		end
	end
end