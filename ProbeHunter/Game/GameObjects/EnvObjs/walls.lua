local coll = collision.makeCollider(0,0,4,4);

--local coll2 = collision.makeCollider(0,0,8,8);
local wall = {
	quad = ASSETS.WALL_QUADS[1];
	quadScaleX = 4;
	quadScaleY = 4;
}
collision.makeCollider (0,0, 16,16, wall);

entityTypes.wall = wall;

local function checkForWall (x, y)
	for i = 1, #gameWorld.walls do
		local wall = gameWorld.walls[i];
		if helpers.collideRect(x,y,wall.posX,wall.posY, wall.sizeX, wall.sizeY) then
			if not (entitySystem.message(wall,"hit",0)) then
				return true;
			end
		end
	end
	return false;
end

function wall:start ()
	local xo, yo = 0, 0;

	if not checkForWall (self.posX + (self.sizeX * 2), self.posY) then
		xo = xo + 1;
	end

	if not checkForWall (self.posX - (self.sizeX * 2), self.posY) then
		xo = xo + 1;
	end

	if not checkForWall (self.posX, self.posY + (self.sizeY * 2)) then
		yo = yo + 1;
	end

	if not checkForWall (self.posX, self.posY - (self.sizeY * 2)) then
		yo = yo + 1;
	end
	self.solid = false;
	-- vertical
	if xo > yo then
		self.quad = ASSETS.WALL_QUADS[2];
		self.solid = true;
	end
	
	-- horizontal
	if yo > xo then
		self.quad = ASSETS.WALL_QUADS[3];
		self.solid = true;
	end

	
	-- corner
	if xo > 0 and yo > 0 and xo + yo >= 2 then
		self.quad = ASSETS.WALL_QUADS[4];
		local a = self.posX + self.posY - 16;
		a = a % 64;
		a = 32 - a;
		self.quadScaleX = self.quadScaleX * helpers.getDir(a);
		self.solid = true;
	end
	
	if self.solid == true then
		table.insert(gameWorld.exposedWalls, self);
	end
end

local destructableWall = {
	quad = ASSETS.WALL_QUADS[5];
	quadScaleX = 4;
	quadScaleY = 4;
};

collision.makeCollider(0,0,16,16, destructableWall);

entityTypes.destructableWall = destructableWall;



function destructableWall:start ()
	table.insert(gameWorld.hittable, self);
	table.insert(gameWorld.exposedWalls, self);
end

function destructableWall:onMessage (m, x, y)
	if m == "hit" then
		if x > 0 then
			entitySystem.destroy(self);
			particalFuncs.groundParticals(self.posX,self.posY, 80);
			audioHelpers.playAudio(ASSETS.GROUND_DESTROY_SFX);
		end
		return true;
	end
	return false;
end

