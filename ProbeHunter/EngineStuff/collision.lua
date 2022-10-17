collision = {}

local collider = {
	solid = true;
	posX = 0;
	posY = 0;
	sizeX = 32;
	sizeY = 32;
}

function collider:collide(coll)
	if self.solid == false or coll.solid == false then return false; end
	return helpers.collideRect(self.posX, self.posY, coll.posX, coll.posY,
	self.sizeX + coll.sizeX, self.sizeY + coll.sizeY);
end

function collider:multiCollide (colliders)
	for i = 1, #colliders do
		if self:collide(colliders[i]) then
			return true;
		end
	end

	return false;
end

function collider:moveToEdgeX (coll)
	local dir = helpers.getDir(coll.posX - self.posX);
	self.posX = coll.posX - (dir * (self.sizeX + coll.sizeX));
end

function collider:moveToEdgeY (coll)
	local dir = helpers.getDir(coll.posY - self.posY);
	self.posY = coll.posY - (dir * (self.sizeY + coll.sizeY));
end

function collider:moveAndCollide (colliders, moveX, moveY)
	if moveY == nil and self.motionX ~= nil and self.motionY ~= nil then
		local dt = moveX;
		moveX, moveY = self.motionX * dt, self.motionY * dt;
	elseif moveX == nil or moveY == nil then
		moveX, moveY = 0,0;
	end
	-- X
	local collideX = false;
	self.posX = self.posX + moveX;
	for i = 1, #colliders do
		if self:collide(colliders[i]) then
			self:moveToEdgeX (colliders[i]);
			collideX = true;
		end
	end

	-- Y
	local collideY = false;
	self.posY = self.posY + moveY;
	for i = 1, #colliders do
		if self:collide(colliders[i]) then
			self:moveToEdgeY (colliders[i]);
			collideY = true;
		end
	end

	return collideX, collideY;
end


function collision.makeCollider (posX,posY,sizeX,sizeY, obj)
	local coll = helpers.copy (collider, obj);
	
	coll.posX = posX;
	coll.posY = posY;
	coll.sizeX = sizeX;
	coll.sizeY = sizeY;
	
	return coll;
end

function collision.pointInCollider(x,y, collider)
	return helpers.collideRect(x,y, collider.posX, collider.posY, collider.sizeX, collider.sizeY);
end

function collision.pointInColliders (x,y,colliders)
	for i = 1, #colliders do
		if collision.pointInCollider(x,y, colliders[i]) then
			return true;
		end
	end
	return false;
end