local STATS = {
	SHOOT_AREA = 64;
	FIRE_RECOV = 0.7;
	BULLET_SPEED = 210;

	HIT_RECOVERY_TIME = 0.5;
	HIT_RECOVERY_AMOUNT = 0.5;

	DAMAGE = 2;

	QUAD_SCALE = 4;
}

local enemy = {
	motionX = 0;
	motionY = 90;

	fireRecov = 0;

	collidedX = false, collidedY = false;
	
	hitRecov = 0;

	quad = ASSETS.WALL_QUAD;
	quadScaleX = -4;
	quadScaleY = 4;

	animationTime = 0;

	dir = -1;
};
collision.makeCollider (0,0,12,20,enemy);

objectSuperTypes.makeEnemy(2,enemy);

entityTypes.bugEnemy = enemy;

local function moveToPlayer (self)
	self.motionY = math.abs(self.motionY) * helpers.getDir(gameWorld.player.posY - self.posY);
end

function enemy:start()
	--dself.agroRange = helpers.copy(self.agroRange);
	table.insert(gameWorld.hittable, self);
	table.insert(gameWorld.mainLayer, self);
end

function enemy:update(dt)
	if gameWorld.player == nil then return; end
	self.animationTime = (self.animationTime + (dt * ASSETS.ANIMATION_FPS)) % 2;
	self.quad = ASSETS.BUG_ENEMY_QUADS[helpers.animateLoop(self.animationTime,2)]

	self.hitRecov = helpers.linearReduce(self.hitRecov, (dt / STATS.HIT_RECOVERY_TIME));

	self:tryHitPlayer(100);
	self:updateAgro(500, 32);

	if math.abs(self.posX - gameWorld.player.posX) < self.sizeX then
		moveToPlayer(self);
	end


	if self.agro then
		self.dir = helpers.getDir (gameWorld.player.posX - self.posX)
		self.fireRecov = self.fireRecov - dt;
		if self.fireRecov < 0 and math.abs(gameWorld.player.posY - self.posY) <= STATS.SHOOT_AREA then
			local bul = gameWorld.add (entityTypes.bullet, self.posX, self.posY);
			bul.motionX = self.dir * STATS.BULLET_SPEED;
			bul.damage = STATS.DAMAGE;
			bul.creator = self;
			self.fireRecov = STATS.FIRE_RECOV;

			audioHelpers.playAudio(ASSETS.ENEMY_SHOOT_SFX);
		end

		self.collidedX, self.collidedY = self:moveAndCollide(gameWorld.exposedWalls, dt);
		if self.collidedY then self.motionY = -self.motionY; end
	end


	self.quadScaleX, self.quadScaleY = helpers.squish(STATS.QUAD_SCALE, self.hitRecov, STATS.HIT_RECOVERY_AMOUNT);
	self.quadScaleX = self.dir * self.quadScaleX;
end

function enemy:onMessage (m,x,y)
	if m == "hit" then
		self.hitRecov = 1;
		if self:hit(x) then
			particalFuncs.enemyDeath(self.posX, self.posY);
		end
		--moveToPlayer(self);
		self.motionY = -self.motionY;
		return true;
	elseif m == "bounce" then
		self.motionY = -helpers.getDir(x) * math.abs(self.motionY);
	end
	return false;
end