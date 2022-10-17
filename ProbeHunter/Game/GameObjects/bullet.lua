local bullet = {
	motionX = 0, motionY = 0;
	lifeTime = 10;
	creator = nil;

	PARTICAL_WALL_SPEED = 0.06;
	PARTICAL_HIT_SPEED = 0.15;
	PARTICAL_HIT_IMPULSE = 0.3;

	damage = 1;
	quad = ASSETS.BULLET_QUAD;
	quadScaleX = 4;
	quadScaleY = 4;
	hitFreeze = 0.04;
}
collision.makeCollider (0, 0, 8, 8, bullet)
entityTypes.bullet = bullet;

function bullet:start ()
	table.insert(gameWorld.bulletLayer, self);
end

function bullet:update (dt)
	local ox, oy = self.posX, self.posY;
	
	self.posX = self.posX + (self.motionX * dt);
	self.posY = self.posY + (self.motionY * dt);
	ox = (self.posX + ox) * 0.5;
	oy = (self.posY + oy) * 0.5;

	for i = 1, #gameWorld.hittable do
		if self.creator ~= gameWorld.hittable[i] and self:collide(gameWorld.hittable[i]) then
			if entitySystem.message(gameWorld.hittable[i], "hit", self.damage) then
				gameWorld.timeFreeze = self.hitFreeze;
				--particalFuncs.bulletParticals(self.posX, self.posY, 20, 0, 0);
				--print(helpers.tableToString(entityTypes.hitFlash))
				--gameWorld.add(entityTypes.hitFlash, self.posX, self.posY);
				particalFuncs.bulletParticals(self.posX,self.posY,
				self.PARTICAL_HIT_SPEED * helpers.distance(self.motionX, self.motionY),
				self.motionX* self.PARTICAL_HIT_IMPULSE, self.motionY* self.PARTICAL_HIT_IMPULSE);

				entitySystem.destroy (self);
			end
		end
	end
	
	
	if self:multiCollide (gameWorld.walls) then 
		--particalFuncs.bulletParticals(ox, oy, 40, 0, 0);
		particalFuncs.bulletParticals(ox,oy,
		self.PARTICAL_WALL_SPEED * helpers.distance(self.motionX, self.motionY),0,0);
		entitySystem.destroy(self);
	end
	
	self.lifeTime = self.lifeTime - dt;
	if self.lifeTime < 0 then
		entitySystem.destroy(self);
	end
end

function bullet:onMessage (m, x, y)
	if m == "bounce" then
		self.motionY = -x;
	end
end