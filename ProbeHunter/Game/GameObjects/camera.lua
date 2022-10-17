local camera = {
	renderer = nil;
}

entityTypes.camera = camera;

function camera:start ()
	self.collider = collision.makeCollider (0,0,screenSize / 2, screenSize / 2)

end

function camera:update (dt)
	if gameWorld.player == nil or self.renderer == nil then return; end
	local player = gameWorld.player
	self.collider.posX, self.collider.posY = player.posX, player.posY;
	gameWorld.keepInBounds (self.collider);
	self.renderer.cameraX, self.renderer.cameraY = self.collider.posX, self.collider.posY;
end