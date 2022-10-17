local hitFlash = {
	LIFETIME = 0.5;
	FLASH_SIZE = 64;
	lifeTime = 0.5;
}
entityTypes.hitFlash = hitFlash;
function hitFlash:update (dt)

	self.lifeTime = self.lifeTime - dt;
	lightingSystem.addLight(self.posX, self.posY, (self.lifeTime / self.LIFETIME) * self.FLASH_SIZE, 1,0,0);
	if self.lifeTime < 0 then
		entitySystem.destroy(self);
	end
end

--local tutorial = {
--	quad = ASSETS.WALL_QUADS[3];
--	quadScaleX = 4;
--	quadScaleY = 4;
--}
--function tutorial:start()
--	table.insert(gameWorld.mainLayer2, self);
--end
--
--function tutorial:update(dt)
--	if gameWorld.player == nil then return end
--	
--end

