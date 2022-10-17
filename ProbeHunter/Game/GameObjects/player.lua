local isDown = love.keyboard.isDown;

local PL_CONTROLS = {
	JUMP = "space";
	DASH = "l", SHOOT = "k";
	RIGHT = "d", LEFT = "a";
	UP = "w", DOWN = "s";
}



local STATS = {
	GRAVITY = 1480 * 0.5;
	GRAVITY_DOWN = 1800;
	JUMP_SPEED = 570;
	JUMP_CANCEL_SPEED = 170;
	HEALTH_MAX = 3;
	
	COYOTE_TIME = 0.18;

	MOVEMENT_SPEED = 240;
	RUN_LOOP_SPEED = 6;

	MOVE_CHANGE = 1.8;--0.8;
	AIR_CHANGE = 0.45;--0.26;
	CD_MULT = 2;--1.2;
	MOVE_SNAP = 8;

	
	HIT_BOUNCE = 400;
	
	BULLET_SPEED = 900;
	BULLET_OFFSET = 4;
	FIRE_MOTION_MULT = 0.75;
	BK_X = 125;
	BK_Y = 260;

	BP_SPEED = 90;
	BP_IMPULSE = 250;
	
	DASH_X = 165;
	DASH_Y = 390;

	DASH_FREEZE = 0.02;

	DP_SPEED = 30;
	DP_IMPULSE_X = 150;
	DP_IMPULSE_Y = 50;
	
	
	MAX_MOTION_Y = 600;

	QUAD_SCALE = 4;
	QUAD_OFFSET_Y = -4;
	QUAD_MOTION_SCALE_MULT = 0.003;

	LIGHT_SIZE = 128 + 64;
	LIGHT_COLOR_R = 0.7;
	LIGHT_COLOR_G = 0.7;
	LIGHT_COLOR_B = 0.7;

	DEATH_TIME = 0.5;
}



local player = {
	motionX = 0;
	motionY = STATS.MAX_MOTION_Y * 0.5;

	motion2X = 0;

	currentCoyoteTime = 0;
	lmdir = 1;

	cmChange = 0;
	
	grounded = false;

	
	
	shouldJump = false;
	stateTime = 0;
	state = "aerial";

	collidedX = false;
	collidedY = false;

	--jumpWasPressed = false;
	shouldJump = false;
	shouldDash = false;
	shouldShoot = false;

	health = 3;

	quad = ASSETS.PLAYER_QUAD;
	quadScaleX = 4;
	quadScaleY = 4;
	quadOffsetY = -4;
};
collision.makeCollider (0,0, 2*4, 3*4, player);



-- action Functions
local function movePlayer (self, dir, dt, changeOn0)
	if changeOn0 == nil then changeOn0 = true end
	
	if changeOn0 or dir ~=0 then
		self.motionX =
			helpers.moveTo(self.motionX, dir * STATS.MOVEMENT_SPEED, self.cmChange, dt, STATS.MOVE_SNAP);
	end
end

local function resetMotion2X (self) 
	self.motionX = self.motionX + self.motion2X;
	self.motion2X = 0;
end

local function tryJump (self)
	if isDown(PL_CONTROLS.JUMP) and self.shouldJump then
		self.motionY = -STATS.JUMP_SPEED;
		self.currentCoyoteTime = 0;
		self.shouldJump = false;

		audioHelpers.playAudio(ASSETS.PLAYER_JUMP_SFX);
	end
end

local function resetOnLand (self, stopOnLand)
	if self.grounded then
		self.state = "walking";
		
		if helpers.getDir(self.motionX) == -self.lmdir or stopOnLand then
			--self.motionX = 0;
		end
		resetMotion2X(self);

		return true;
	end

	return false;
end

local function updateLMDir (self, dirX)
	if dirX ~= 0 then
		self.lmdir = dirX;
		self.quadScaleX = dirX * STATS.QUAD_SCALE;
	end
	
end

local function tryDash (self)
	if isDown("l") and self.shouldDash then
		--updateLMDir(self,dirX);
		--self.pushDir = self.lmdir;
		audioHelpers.playAudio(ASSETS.PLAYER_DASH_SFX);
		self.motionY = -STATS.DASH_Y;
		self.motion2X = STATS.DASH_X * self.lmdir;
		self.motionX = STATS.MOVEMENT_SPEED * self.lmdir;
		gameWorld.timeFreeze = STATS.DASH_FREEZE;

		particalFuncs.windParticals(self.posX, self.posY, STATS.DP_SPEED, STATS.DP_IMPULSE_X * -self.lmdir, STATS.DP_IMPULSE_Y);

		self.shouldDash = false;
		self.state = "dash";
	end
end

local function tryFire (self, dirX, dirY)
	if isDown (PL_CONTROLS.SHOOT) and self.shouldShoot then
		self.shouldShoot = false;
		updateLMDir(self, dirX);
		resetMotion2X(self);

		audioHelpers.playAudio(ASSETS.PLAYER_SHOOT_SFX)

		self.motionX = self.motionX * STATS.FIRE_MOTION_MULT;
		
		if dirX == 0 and dirY == 0 then
			dirX = self.lmdir;
		end
		
		self.motionY = -STATS.BK_Y;
		self.motion2X = STATS.BK_X * -dirX;

		dirX, dirY = helpers.normalize(dirX,dirY);
		
		local bpx, bpy = self.posX + (dirX * STATS.BULLET_OFFSET), self.posY + (dirY * STATS.BULLET_OFFSET)
		local bul = gameWorld.add (entityTypes.bullet, bpx, bpy);

		particalFuncs.bulletParticals(bpx,bpy, STATS.BP_SPEED, STATS.BP_IMPULSE * dirX, STATS.BP_IMPULSE * dirY);

		bul.motionX = STATS.BULLET_SPEED * dirX;
		bul.motionY = STATS.BULLET_SPEED *dirY;

		bul.creator = self;

		self.grounded = false;
		self.state = "fireRecov";
		self.quad = ASSETS.PLAYER_QUADS[6];
	end
end

local function updateHealthBar (health)
	for i = 1, #gameWorld.hud do
		entitySystem.message (gameWorld.hud[i], "playerHealth", health);
	end
end

-- Events
function player:start ()
	gameWorld.player = self;
	table.insert (gameWorld.hittable, self);
	table.insert (gameWorld.mainLayer, self);

	updateHealthBar(self.health);
end

function player:update (dt)
	local dirX, dirY =
		helpers.inputDir(PL_CONTROLS.LEFT,PL_CONTROLS.RIGHT),
		helpers.inputDir(PL_CONTROLS.UP,PL_CONTROLS.DOWN);

	--local uGravity = STATS.GRAVITY;
	
	if self.grounded then
		self.cmChange = STATS.MOVE_CHANGE;
		self.currentCoyoteTime = STATS.COYOTE_TIME;
	else
		self.cmChange = STATS.AIR_CHANGE;
		if self.currentCoyoteTime >= 0 then self.currentCoyoteTime = self.currentCoyoteTime - dt; end
	end

	if helpers.getDir(self.motionX + self.motion2X) ~= dirX then
		self.cmChange = self.cmChange * STATS.CD_MULT;
	end

	self.shouldJump = self.shouldJump or not isDown(PL_CONTROLS.JUMP);

	self.shouldDash = self.shouldDash or not isDown(PL_CONTROLS.DASH);
	self.shouldShoot = self.shouldShoot or not isDown(PL_CONTROLS.SHOOT);

	if self.state == "walking" then -- walk state
		-- Resets the motion2X value.
		self.motion2X = 0;

		-- State Changing
		if not self.grounded then self.state = "aerial"; end

		-- SpriteChanging
		if dirX == 0 then
			self.quad = ASSETS.PLAYER_QUADS[1];
			self.stateTime = 0;
		else
			local animSpeedMult = 1;
			if self.stateTime > 1 then animSpeedMult = 1/2; end
			self.stateTime = (self.stateTime%2) + (dt * STATS.RUN_LOOP_SPEED * animSpeedMult);
			self.quad = ASSETS.PLAYER_QUADS[1 + helpers.animateLoop(self.stateTime, 2)];
		end

		updateLMDir(self, dirX);
		movePlayer (self, dirX, dt);
		tryJump(self, dirX);
		tryFire(self,dirX,dirY);
		tryDash(self);
		

	elseif self.state == "aerial" then -- aerial state
		if self.currentCoyoteTime > 0 then tryJump(self); end
		if self.collidedX then self.motionX = 0 end
		movePlayer(self,dirX, dt);

		--if self.motionY > 0 then uGravity = STATS.

		if not isDown (PL_CONTROLS.JUMP) and self.motionY < -STATS.JUMP_CANCEL_SPEED then
			self.motionY = -STATS.JUMP_CANCEL_SPEED;
		end

		if self.motionY < 0 then -- Sprite Changing
			self.quad = ASSETS.PLAYER_QUADS[4];
		else
			self.quad = ASSETS.PLAYER_QUADS[5];
		end
		
		updateLMDir(self, dirX);
		tryFire(self, dirX, dirY);


		tryDash(self);


		resetOnLand(self)
	elseif self.state == "bounce" then
		movePlayer(self, dirX, dt);
		updateLMDir(self,dirX);
		tryDash(self);
		tryFire(self,dirX,dirY);
		self.quad = ASSETS.PLAYER_QUADS[4];
		if self.motionY > 0 then self.state = "aerial"; end

	elseif self.state == "dash" then
		--if dirX == -self.lmdir then self.motionX = STATS.CANCEL_DASH_X * self.lmdir end
		self.quad = ASSETS.PLAYER_QUADS[7]; -- Change sprite

		movePlayer(self, dirX, dt, false);
		tryFire(self,dirX,dirY);

		resetOnLand(self);

	elseif self.state == "fireRecov" then
		movePlayer(self, dirX, dt, false);

		resetOnLand(self, true)
		self.quad = ASSETS.PLAYER_QUADS[6];

	elseif self.state == "hitRecov" then
		movePlayer(self, dirX, dt, false);
		self.quad = ASSETS.PLAYER_QUADS[8];
		resetOnLand(self);
	elseif self.state == "dead" then
		self.quad = nil;
		self.motionX = 0;
		self.motionY = 0;
		self.stateTime = self.stateTime - dt;
		--particalFuncs.enemyDeath(self.posX,self.posY);
		self.health = 0;
		if (isDown(PL_CONTROLS.JUMP) and self.shouldJump) or self.stateTime < 0 then
			gameWorld.nextWorld = gameWorld.currentWorld;
		end
		self.posY = self.posY - (STATS.GRAVITY_DOWN * dt * dt);
		--self.posX = -64;
	end

	
	
	
	local uGravity = STATS.GRAVITY; 

	if self.motionY > STATS.MAX_MOTION_Y then
		self.motionY = STATS.MAX_MOTION_Y;
		uGravity = 0;
	end
	self.collidedX, self.collidedY =
		--self:moveAndCollide(gameWorld.walls,
		--(self.motionX + self.motion2X) * dt, self.motionY * dt);
		self:moveAndCollide(gameWorld.exposedWalls,
		(self.motionX + self.motion2X) * dt, helpers.parabola(dt, uGravity, self.motionY, 0));
	--self.motionY = self.motionY + (STATS.GRAVITY*dt);
	self.motionY = helpers.parabolaDerivative(dt,uGravity, self.motionY);
		
	self.grounded = self.collidedY and self.motionY > 0
	if self.collidedX then
		self.motionX = -self.motion2X;
	end
	if self.collidedY then
		self.motionY = 0;
	end

	--self.quadScaleY = STATS.QUAD_SCALE + (math.abs(self.motionY) * STATS.QUAD_MOTION_SCALE_MULT);
	--self.quadOffsetY = STATS.QUAD_OFFSET_Y - (STATS.QUAD_SCALE * 0.5 * self.motionY * STATS.QUAD_MOTION_SCALE_MULT);

	if gameWorld.keepInBounds(self) then
		self:onMessage ("hit", 1000);
	end

	--self.jumpWasPressed = isDown (PL_CONTROLS.JUMP);

	lightingSystem.addLight(self.posX, self.posY, STATS.LIGHT_SIZE,
		STATS.LIGHT_COLOR_R, STATS.LIGHT_COLOR_G, STATS.LIGHT_COLOR_B, 1);
end

function player:onMessage (m,x,y)
	if self.state == "dead" then return false; end
	if m == "hit" then
		self.health = self.health - x;

		self.motionY = -STATS.HIT_BOUNCE;
		
		self.motionX = 0;
		self.motion2X = 0;

		resetMotion2X(self);
		
		
		if self.state ~= "dead" then
			self.state = "hitRecov";
			
			--print (x);
			if self.health <= 0 then
				--gameWorld.nextWorld = gameWorld.currentWorld;
				self.state = "dead";
				self.stateTime = STATS.DEATH_TIME;
				self.health = 0;
				updateHealthBar(self.health);
				
				particalFuncs.enemyDeath(self.posX, self.posY);
				audioHelpers.playAudio(ASSETS.PLAYER_DEATH_SFX);
				return false;
			end

			audioHelpers.playAudio(ASSETS.PLAYER_HIT_SFX)
		else
			self.health = 0;
		end
		updateHealthBar(self.health);
		return true;
	elseif m == "bounce" then
		--print ("bounce");
		self.motionY = -x;
		resetMotion2X(self);
		--self.motion2X = 0;
		self.state = "bounce"
	end

	return false;
end

entityTypes.player = player;

--[[
local function tryJump (self)
	if self.shouldJump and not self.grounded and self.doubleJump then
		self.motionY = -STATS.JUMP_SPEED;
		self.doubleJump = false;
		self.shouldJump = false;
		self.state = "walking";
	end

	if self.grounded then
		if self.shouldJump then 
			self.motionY = -STATS.JUMP_SPEED;	
			self.grounded = false;
			self.shouldJump = false;
			self.state = "walking";
		end
	end
end

local function tryFire (self, dirX, dirY)
	if isDown("k") and (self.state ~= "fireRecov" or self.stateTime <= 0) and self.ammo > 0 then
		self.ammo = self.ammo - 1;

		local bul = gameWorld.add(entityTypes.bullet, self.posX, self.posY);
		if dirY > 0 and self.grounded then -- stops the player from shooting down if grounded
			dirY = 0;
		end

		if self.grounded then self.doubleJump = true; end
		-- If no direction is pressed then fire in a default direction
		local bdirX = dirX;
		if dirX == 0 and dirY == 0 then
			bdirX = self.lmdir;
		end
		
		-- adds the recoil
		self.motionY = -STATS.BK_Y;
		self.motion2X = -STATS.BK_X * bdirX;

		-- sets the bullet motion
		bul.motionX = bdirX * STATS.BULLET_SPEED * (1 - math.abs(STATS.bdirXDownMult * dirY));
		bul.motionY = dirY * STATS.BULLET_SPEED;

		bul.creator = self; -- sets the bullet creator to self so that the player won't collide with its own bullets
		self.state = "fireRecov"; -- sets the players state to "fireRecov"
		self.stateTime = STATS.bulletRecovery;
	end
end

function player:update (dt)
	local moveSpeed = STATS.MOVEMENT_SPEED;

	local dirX = helpers.inputDir("a","d");
	local dirY = helpers.inputDir("w","s");

	local motion2X = 0;

	self.shouldJump = isDown("space") and (not jumpWasPressed or self.shouldJump);
	
	self.doubleJump = self.grounded or self.doubleJump;

	if self.grounded then self.ammo = STATS.maxAmmo; end

	self.stateTime = self.stateTime - dt;
	if self.stateTime <= 0 then self.stateTime = 0; end

	if self.state == "walking" then -- walk state
		if dirX ~= 0 then self.lmdir = dirX; end
		
		self.motion2X = 0;

		movePlayer(self, dirX, STATS.MOVEMENT_SPEED);
		
		if not isDown("space") and self.motionY < -STATS.JUMP_CANCEL_SPEED then
			self.motionY = -STATS.JUMP_CANCEL_SPEED;
		end
		
		
		tryJump(self);

		-- checks if the fires if the fire button is pressed
		tryFire(self,dirX,dirY);		

		if isDown("l") and not self.grounded then
			self.motion2X = STATS.DASH_X * self.lmdir;
			
			if dirY ~= 1 then
				self.motionY = -STATS.DASH_Y
			else
				self.motionY = STATS.DASH_Y;
			end

			self.state = "dash";
		end
	elseif self.state == "dash" then -- dash state
		movePlayer(self, dirX, STATS.slowSpeed);

		-- checks if the fires if the fire button is pressed
		tryJump(self);
		tryFire(self,dirX,dirY);

		-- returns to the walking state if grounded
		if self.grounded then
			self.state = "walking";
		end
	elseif self.state == "fireRecov" then
		
		movePlayer(self,dirX, STATS.slowSpeed);

		tryJump(self);
		tryFire(self,dirX,dirY)
		-- returns to the walking state if grounded
		if self.grounded then
			self.state = "walking"
		end
	end

	if self.posY > 1000 then gameWorld.nextWorld = gameWorld.currentWorld; end


	-- motionStuff
	self.motionY = self.motionY + (STATS.GRAVITY * dt);

	self.collidedX, self.collidedY = self:moveAndCollide(gameWorld.walls,
	(self.motionX + self.motion2X) * dt, self.motionY * dt);
	self.grounded = self.collidedY and self.motionY >= 0;
	
	--if self.collidedX then
	--	self.motion2X = 0;
	--end

	if self.collidedY then
		--self.posY = groundLevel;
		self.motionY = 0;
	end
	jumpWasPressed = isDown("space");
end--]]
