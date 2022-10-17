local function particalUpdate (self,dt)
	local QUAD_SCALE = 4;

	self.rotation = self.rotation + (self.rotationSpeed * dt);
	self.posX = self.posX + (self.motionX * dt);
	self.posY = self.posY + (self.motionY * dt);

	self.lifeTime = self.lifeTime - dt;
	local scale = (self.lifeTime / self.startLifeTime) - 1;
	scale = 1 - (scale * scale);
	self.quadScaleX, self.quadScaleY = scale * QUAD_SCALE, scale * QUAD_SCALE;
	if self.lifeTime < 0 then entitySystem.destroy(self) end
end

particalFuncs = {
	
}

function particalFuncs.spawnParticals (num, quad, x, y, speed, lifeTime, rotationSpeed, impulseX, impulseY)
	if rotationSpeed == nil then rotationSpeed = 0; end
	if impulseX == nil then impulseX = 0; end
	if impulseY == nil then impulseY = 0; end

	for i = 1, num do
		local rotation = 0;
		if rotationSpeed ~= 0 then rotation = math.random() * math.pi * 2; end
		local r = math.random () * math.pi * 2;
		--local am = math.random();
		--am = 1 - (am * am * am);
		--local mx, my = math.cos(r) * am, math.sin(r) * am;
		local mx, my = (math.random() * 2) - 1, (math.random() * 2) - 1;

		local lt = 0.5 + math.random()

		local partical = {
			posX = x,
			posY = y,
			
			quad = quad,

			quadScaleX = 4,
			quadScaleY = 4,

			startLifeTime = lifeTime * lt;
			lifeTime = lifeTime * lt;

			rotation = rotation,
			rotationSpeed = (math.random ()-0.5) * rotationSpeed * math.pi * 2;

			motionX = (mx * speed) + impulseX,
			motionY = (my * speed) + impulseY,

			update = particalUpdate,
		}

		table.insert(gameWorld.allObjects, partical);
		table.insert(gameWorld.particals, partical);
	end
end

function particalFuncs.bulletParticals (x,y, speed, impulseX, impulseY)
	particalFuncs.spawnParticals(6, ASSETS.PARTICAL_QUADS[2], x, y, speed, 0.4, 4, impulseX, impulseY);
end

--function particalFuncs.bulletHit (x,y, speed)
--	particalFuncs.spawnParticals(4, ASSETS.PARTICAL_QUADS[2], x, y, speed, 0.4, 2);
--end

function particalFuncs.groundParticals (x,y, speed)
	particalFuncs.spawnParticals(8, ASSETS.PARTICAL_QUADS[1], x, y, speed, 0.75, 5);
end

function particalFuncs.windParticals (x,y, speed, impulseX, impulseY)
	particalFuncs.spawnParticals(10, ASSETS.PARTICAL_QUADS[4], x, y, 120, 0.75, 0, impulseX, impulseY);
end

function particalFuncs.enemyDeath (x,y)
	particalFuncs.spawnParticals(12, ASSETS.PARTICAL_QUADS[2], x,y, 90, 1, 1);
end
