local PLAYER_BOUNCE = 500;

local goal = {
	quad = ASSETS.GOAL_QUADS[1];
	quadScaleX = 4;
	quadScaleY = 4;
	open = false;
	timeTillEnter = 0.5;
	collider = collision.makeCollider (0,0,128, 64+32);
};
collision.makeCollider(0,0,16,16,goal);

function goal:start ()
	table.insert (gameWorld.mainLayer2, self);
	table.insert (gameWorld.hittable, self);
	self.collider.posX = self.posX;
	self.collider.posY = self.posY;
end

function goal:update (dt)
	if gameWorld.player == nil then return end
	
	if self.open then
		self.timeTillEnter = self.timeTillEnter - dt;
		if self:collide (gameWorld.player) and self.timeTillEnter < 0 then
			
			gameWorld.nextWorld = gameWorld.currentWorld + 1;
		end
	end

	lightingSystem.addLight(self.posX, self.posY, 128, 1.1, 1.1, 1.1);
end

function goal:onMessage (m, x, y)
	if m == "hit" then
		if not self.open then
			particalFuncs.groundParticals (self.posX,self.posY, 120);
			audioHelpers.playAudio(ASSETS.DOOR_BREAK_SFX);
			for i = 1, #gameWorld.hittable do
				if self.collider:collide(gameWorld.hittable[i]) then
					entitySystem.message(gameWorld.hittable[i], "bounce", PLAYER_BOUNCE);
				end
			end
		end
		self.open = true;
		self.quad = ASSETS.GOAL_QUADS[2];
		return true;
	end
	return false;
end

entityTypes.goal = goal