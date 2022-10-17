local spike = {
	quad = ASSETS.SPIKE_QUAD;
	quadScaleX = 4;
	quadScaleY = 4;
}

collision.makeCollider (0,0,4 * 3, 4 * 2, spike);
entityTypes.spike = spike;

function spike:start ()
	table.insert( gameWorld.bulletLayer, self);
end

function spike:update (dt)
	--if gameWorld.player == nil then return; end
	--if self:collide(gameWorld.player) then
	--	entitySystem.message(gameWorld.player, "hit", 1000);
	--end


	for i = 1, #gameWorld.hittable do
		if self:collide (gameWorld.hittable[i]) then
			entitySystem.message(gameWorld.hittable[i], "hit", 1000);
		end
	end
end