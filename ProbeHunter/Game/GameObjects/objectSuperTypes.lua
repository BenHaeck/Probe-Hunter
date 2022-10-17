local ost = {}
objectSuperTypes = ost;

local enemy = {
	agro = false;
	health = 3;
}

function enemy:updateAgro (agroRangeX, agroRangeY)
	local player = gameWorld.player;
	if player == nil then return; end
	self.agro = self.agro or
		helpers.collideRect(self.posX, self.posY, player.posX, player.posY,
		agroRangeX + player.sizeX, agroRangeY + player.sizeY)
end

function enemy:tryHitPlayer (am)
	if self:collide(gameWorld.player) then
		return entitySystem.message(gameWorld.player,"hit",am);
	end
	return false;
end

function enemy:hit(am)
	
	self.health = self.health - am;
	self.agro = true;
	if self.health <= 0 then
		entitySystem.destroy(self);
		audioHelpers.playAudio(ASSETS.ENEMY_DEATH_SFX);
		return true;
	else
		audioHelpers.playAudio(ASSETS.ENEMY_HIT_SFX);
	end
	return false;
end

function ost.makeEnemy(health, obj)
	helpers.copy(enemy, obj);
	obj.health = health;
end