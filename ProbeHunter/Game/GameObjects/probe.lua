local probe = {
	quad = ASSETS.PROBE_QUAD;--ASSETS.WALL_QUADS[3];
	quadScaleX = 4;
	quadScaleY = 4;
	motionY = 0;

	timer = 4;
	liftOffTimer = 0.5;
	liftOff = false;

	playerRange = 128;
	fireRecov = 0;
	FIRE_RECOV = 0.2;
}
collision.makeCollider(0,0,16,16,probe);
entityTypes.probe = probe;

function probe:start ()
	table.insert(gameWorld.mainLayer, self);
	table.insert(gameWorld.hittable, self);
end

function probe:update (dt)
	if gameWorld.player == nil then return; end
	local player = gameWorld.player;
	if helpers.distance(self.posX-player.posX,self.posY-player.posY)< self.playerRange and self.fireRecov <= 0 then 
		self.fireRecov = self.FIRE_RECOV;
		local bmX, bmY = helpers.normalize(player.posX - self.posX, player.posY - self.posY);
		bmX = bmX * 200;
		bmY = bmY * 200;
		local b = gameWorld.add(entityTypes.bullet, self.posX, self.posY);
		b.motionX = bmX;
		b.motionY = bmY;
		b.creator = self;
	end

	if self.fireRecov > 0 then self.fireRecov = self.fireRecov - dt; end
	
	if self.liftOff then
		self.liftOffTimer = self.liftOffTimer - dt;

		if self.liftOffTimer > 0 then
			self.rotation = math.sin(self.liftOffTimer * math.pi * 8) * 0.5;
		else self.rotation = 0; end
		lightingSystem.addLight(self.posX, self.posY, 256, 1,1,1);
		if self.liftOffTimer < 0 then self.motionY = -400; end
	end
	self.posY = self.posY + (self.motionY * dt);
	if self.motionY < -1 then
		self.timer = self.timer - dt;
	end
	if self.timer < 0 then
		gameWorld.nextWorld = gameWorld.currentWorld + 1;
	end
end

function probe:onMessage(m,x,y)
	if (m == "hit") then
		--self.motionY = -400
		if not self.liftOff then
			audioHelpers.playAudio(ASSETS.PROBE_LIFTOFF_SFX);
		end
		self.liftOff = true;
		return true;
	end
end