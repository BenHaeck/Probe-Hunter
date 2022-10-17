local STATS = {
	BLOW_SPEED = 800;

	WIND_AREA_X = 64;
	WIND_AREA_Y = 64 + 32;

	PARTICAL_IMPULSE = 200;
	PARTICAL_SPEED = 90;

	WIND_RECOV = 0.6;
	QUAD_SCALE = 4;
	QUAD_SQUISH = 0.5;
	LIGHT_RADIUS = 64 + 32;
	LIGHT_RADIUS_HIT_BOOST = 64 + 32;
	--LIGHT_COLOR_R = 0.55,
	--LIGHT_COLOR_G = 0.20,
	LIGHT_COLOR_R = 1.1;
	LIGHT_COLOR_G = 0.1;
	LIGHT_COLOR_B = 1.1,
}

local windPlant = {
	quad = ASSETS.WIND_PLANT_QUAD;
	quadScaleX = 4;
	quadScaleY = 4;

	windRecov = 0;
}
collision.makeCollider (0,0, 20, 12, windPlant);

entityTypes.windPlant = windPlant;

function windPlant:start ()
	table.insert(gameWorld.hittable, self)
	table.insert(gameWorld.mainLayer2, self)
	self.windArea = collision.makeCollider (
		self.posX, self.posY-(STATS.WIND_AREA_Y * 0.5), STATS.WIND_AREA_X, STATS.WIND_AREA_Y);

end

function windPlant:update (dt)
	if gameWorld.player == nil then return; end

	--if gameWorld.player:collide(self) then
	--	gameWorld.player:moveToEdgeX (self);
	--end
	local recovRatio = self.windRecov / STATS.WIND_RECOV;
	self.windRecov = helpers.linearReduce(self.windRecov, dt);
	self.quadScaleX, self.quadScaleY = helpers.squish(4, recovRatio, -0.5);
	self.quadOffsetY = (STATS.QUAD_SCALE - self.quadScaleX) * -4;

	lightingSystem.addLight(self.posX, self.posY,
	STATS.LIGHT_RADIUS + (STATS.LIGHT_RADIUS_HIT_BOOST * (recovRatio * recovRatio)),
	STATS.LIGHT_COLOR_R, STATS.LIGHT_COLOR_G, STATS.LIGHT_COLOR_B);
end

function windPlant:onMessage (m, x, y)
	if m == "hit" then
		for i = 1, #gameWorld.hittable do
			if gameWorld.hittable[i] ~= self and self.windArea:collide(gameWorld.hittable[i]) then
				entitySystem.message(gameWorld.hittable[i], "bounce", STATS.BLOW_SPEED);
			end
			audioHelpers.playAudio(ASSETS.PLANT_PUSH_SFX);
		end

		self.windRecov = STATS.WIND_RECOV;

		particalFuncs.windParticals(self.posX, self.posY, STATS.PARTICAL_SPEED, 0, -STATS.PARTICAL_IMPULSE);
		return true;
	end

	return false;
end