local STATS = {
	MOVEMENT_SPEED = 120;

	BULLET_SPEED = 700;
	HIT_RECOV = 0.2;
	FIRE_RECOV = 0.8;
	FIRE_RECOV2 = 0.1;
	BURST_NUMBER = 2;

	QUAD_SCALE = 4;
	PREDICT_TIME = 0.14;
	B_PREDICT_TIME = 0.002;

	SB_AREA = 64;
	SPEED_BOOST = 2.2;

	LIGHT_RADIUS = 128 * 2;
	LIGHT_COLOR_R = 2;
	LIGHT_COLOR_G = 0.25;
	LIGHT_COLOR_B = 0.25;
}

local drone = {
	motionX = 0;
	motionY = 0;

	quad = ASSETS.ALIEN_DRONE_QUADS[1];
	quadScaleX = 4;
	quadScaleY = 4;

	fireRecov = 0;
	hitRecov = 0;
}
collision.makeCollider (0,0,16,16,drone)
objectSuperTypes.makeEnemy(3,drone);
entityTypes.alienDrone = drone;

function drone:start ()
	table.insert(gameWorld.hittable, self);
	table.insert(gameWorld.mainLayer, self);
end

function drone:update (dt)
	if gameWorld.player == nil then return; end
	local player = gameWorld.player;
	--print ("a");
	self:tryHitPlayer(1000);
	self:updateAgro (128 + 64, 128);
	local plMotionX, plMotionY = player.motionX, player.motionY;
	--if plOMotionY >= 0 then plOMotionY = 0; end
	local dirX, dirY = helpers.normalize(
		player.posX + (plMotionX * STATS.B_PREDICT_TIME) - self.posX,
		player.posY --[[+ (plMotionY * STATS.B_PREDICT_TIME)--]] - self.posY);
	local mdirX, mdirY = helpers.normalize(
		player.posX + (plMotionX * STATS.PREDICT_TIME) - self.posX,
		player.posY + (plMotionY * STATS.PREDICT_TIME) - self.posY);
	if self.fireRecov > 0 then
		self.fireRecov = self.fireRecov - dt;
	else
		self.fireRecov = 0;
	end
	local normalizedHitRecov = self.hitRecov / STATS.HIT_RECOV;
	if (self.agro) then
		if self.hitRecov > 0 then
			self.hitRecov = self.hitRecov - dt;
		else
			self.hitRecov = 0;
		end

		local movementSpeed = STATS.MOVEMENT_SPEED;
		self.quad = ASSETS.ALIEN_DRONE_QUADS[1];
		if math.abs(player.posX - self.posX) < STATS.SB_AREA then
			movementSpeed = movementSpeed * STATS.SPEED_BOOST;
			--self.quad = ASSETS.ALIEN_DRONE_QUADS[2];
			lightingSystem.addLight(self.posX, self.posY,STATS.LIGHT_RADIUS, STATS.LIGHT_COLOR_R, STATS.LIGHT_COLOR_G, STATS.LIGHT_COLOR_B);
		else
			if (self.fireRecov <= 0) then
				self.fireRecov = STATS.FIRE_RECOV;
				local bullet = gameWorld.add(entityTypes.bullet, self.posX, self.posY);
				bullet.creator = self;
				bullet.motionX = mdirX * STATS.BULLET_SPEED;
				bullet.motionY = mdirY * STATS.BULLET_SPEED;
				audioHelpers.playAudio(ASSETS.ENEMY_SHOOT_SFX);
			end
		end

		self.motionX = mdirX * movementSpeed * (1 - normalizedHitRecov);
		self.motionY = mdirY * movementSpeed * (1 - normalizedHitRecov);

	end
	self.quadScaleX, self.quadScaleY = helpers.squish(STATS.QUAD_SCALE, normalizedHitRecov, 0.5);
	self:moveAndCollide(gameWorld.exposedWalls, dt);
end

function drone:onMessage (m,x,y)
	if m == "hit" then
		self.hitRecov = STATS.HIT_RECOV;

		--self.motionX = 0;
		--self.motionY = 0;
		if self:hit(x) then
			particalFuncs.enemyDeath(self.posX, self.posY)
		end
		return true;
	end
end