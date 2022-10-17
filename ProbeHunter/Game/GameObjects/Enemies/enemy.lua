local STATS = {
	FREEZE_DIST = 12;
	MOVEMENT_SPEED = 180;
	JUMP_SPEED = 560;
	GRAVITY = 640 * 1.5 * 0.5;
	
	--BOUNCE = 100;
	BULLET_BOUNCE = 200;

	QUAD_SCALE = 4;

	HIT_RECOVERY_TIME = 0.5;
	HIT_RECOVERY_AMOUNT = 0.5;

	WALK_LOOP_SPEED = 1;
}

local enemy = {
	motionX = 0, motionY = 0;
	health = 3;

	grounded = false;
	quad = ASSETS.ENEMY_QUAD;
	quadScaleX = -STATS.QUAD_SCALE;
	quadScaleY = STATS.QUAD_SCALE;

	animationTime = 0;

	hitRecov = 0;
	lmDir = -1
}

collision.makeCollider(0,0,16,16, enemy);

objectSuperTypes.makeEnemy(4, enemy);
entityTypes.enemy = enemy;

function enemy:start ()
	table.insert (gameWorld.hittable, self);
	table.insert (gameWorld.mainLayer, self);
end

function enemy:update (dt)
	if gameWorld.player == nil then return; end
	
	self.hitRecov = helpers.linearReduce (self.hitRecov, (dt/STATS.HIT_RECOVERY_TIME));

	--if math.abs(self.posX - gameWorld.player.posX) < self.sizeX then
	--	self.motionY = math.abs(self.motionY) * helpers.getDir(gameWorld.player.posY - self.posY);
	--end
	
	self:tryHitPlayer(10000);
	
	self:updateAgro(256, 64);
	if self.grounded and self.agro then
		if math.abs(self.posX - gameWorld.player.posX) > STATS.FREEZE_DIST then
			local enDir = helpers.getDir(gameWorld.player.posX - self.posX);
			self.lmDir = enDir;
			self.motionX = STATS.MOVEMENT_SPEED * enDir;
			self.quadScaleX = enDir * 4;

			self.animationTime = (self.animationTime + (dt * STATS.WALK_LOOP_SPEED)) % 2;
		elseif self.posY > gameWorld.player.posY then -- jumps
			audioHelpers.playAudio(ASSETS.ENEMY_JUMP_SFX);
			self.motionY = -STATS.JUMP_SPEED;
		end
	else
		self.motionX = 0;

		self.animationTime = 0;
	end

	
	local collidedX, collidedY = self:moveAndCollide (gameWorld.exposedWalls, self.motionX * dt,
	helpers.parabola(dt, STATS.GRAVITY, self.motionY, 0));
	self.motionY = helpers.parabolaDerivative(dt,STATS.GRAVITY, self.motionY);
	
	self.grounded = collidedY and self.motionY >= 0;
	if collidedY then
		self.motionY = 0;
	end

	-- setScale
	if self.hitRecov > 0 then 
		self.quadScaleX, self.quadScaleY = helpers.squish(STATS.QUAD_SCALE, self.hitRecov, STATS.HIT_RECOVERY_AMOUNT);
	else
		local squishAm = math.sin(self.animationTime * math.pi);
		squishAm = squishAm * squishAm;
		self.quadScaleX, self.quadScaleY = STATS.QUAD_SCALE * (1 - (0.25 * squishAm)), STATS.QUAD_SCALE;
	end
	self.quadScaleX = self.lmDir * self.quadScaleX;
end

function enemy:onMessage (m, x, y)
	if m == "hit" then
		self.motionY = -STATS.BULLET_BOUNCE;
		self.hitRecov = 1;
		if self:hit(x) then
			particalFuncs.enemyDeath(self.posX, self.posY);
		end

		return true;
	elseif m == "bounce" then
		self.motionY = -x;
	end
end