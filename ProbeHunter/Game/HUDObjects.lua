local playerHealthBar = {
	posX = 16 + 32;
	posY = 16 + 16;
	quad = ASSETS.PLAYER_HEALTH_BAR[1];
	quadScaleX = 4;
	quadScaleY = 4;
}
--table.insert(gameWorld.hud, playerHealthBar);

entityTypes.playerHealthBar = playerHealthBar;

function playerHealthBar:onMessage (m, x, y)
	if m == "playerHealth" then
		x = (x % 4) + 1
		--print (x);
		self.quad = ASSETS.PLAYER_HEALTH_BAR[x];
		return true
	end
end

local prompt = {
	quad = ASSETS.TUTORIALS[1];
	key = "k";
	quadScaleX = 4;
	quadScaleY = 4;
	QUAD_SCALE = 4;
	INFLATION = 2;
	INFLATION_SPEED = 20;
	inflation = 0;
}
entityTypes.prompt = prompt;

function prompt:start()
	table.insert (gameWorld.hud, self);

	local ind = 1;
	local level = gameWorld.currentWorld;
	if self.key == "k" then
		self.quad = ASSETS.TUTORIALS[1];
	elseif self.key == "l" then
		self.quad = ASSETS.TUTORIALS[2];
	else
		entitySystem.destroy(self);
	end
	
	--self.posX = screenSize * 0.25;
	--self.posY = screenSize * 0.95;
end

function prompt:update (dt)
	local scale = 0;
	if love.keyboard.isDown(self.key) then
		--scale = scale + self.INFLATION;
		self.inflation = self.inflation + (self.INFLATION_SPEED * dt);
	else
		self.inflation = self.inflation - (self.INFLATION_SPEED * dt);
	end
	if self.inflation < 0 then self.inflation = 0; end
	if self.inflation > 1 then self.inflation = 1; end

	local inflationFunc = self.inflation;
	inflationFunc = inflationFunc * inflationFunc;
	inflationFunc = inflationFunc * inflationFunc;

	
	
	self.quadScaleX = self.QUAD_SCALE + (inflationFunc * self.INFLATION);
	self.quadScaleY = self.QUAD_SCALE + (inflationFunc * self.INFLATION);
	
end

local titleScreen = {
	quad = ASSETS.TITLE_SCREEN_QUAD;
	quadScaleX = 8;
	quadScaleY = 8;
}
collision.makeCollider (0,0, 12 * 8, 12 * 8, titleScreen);
entityTypes.titleScreen = titleScreen;

function titleScreen:start ()
	table.insert(gameWorld.hud, self);
	table.insert(gameWorld.hittable, self);
end

function titleScreen:update (dt)

end

function titleScreen:onMessage (message, x, y)
	if message == "hit" then
		gameWorld.nextWorld = gameWorld.currentWorld + 1;
		return true;
	end
end
