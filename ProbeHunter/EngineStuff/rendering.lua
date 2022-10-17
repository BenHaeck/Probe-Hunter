rendering = {
	
};

local screenRenderer = {
	canvas = nil;

	posX = 0;
	posY = 0;
	scaleX = 0;
	scaleY = 0;

	cameraX = 0;
	cameraY = 0;
};

function screenRenderer:getMouseX ()
	return -(self.posX - love.mouse.getX()) / self.scaleX;

end

function screenRenderer:getMouseY ()
	return -(self.posY - love.mouse.getY()) / self.scaleY;
end

function screenRenderer:getCamOffsetX ()
	return (self.canvas:getWidth() * 0.5) - self.cameraX;
end

function screenRenderer:getCamOffsetY ()
	return (self.canvas:getHeight() * 0.5) - self.cameraY;
end

function screenRenderer:update ()
	
	local canvasSize = self.canvas:getWidth();
	local screenSizeX, screenSizeY = love.window.getMode ();
	--self.posX2, self.posY2, self.scaleX2, self.scaleY2 = helpers.centerCanvasFill(screenSizeX, screenSizeY,
	--canvasSize);
	self.posX, self.posY, self.scaleX, self.scaleY = helpers.centerCanvas(screenSizeX, screenSizeY, canvasSize);
end

function screenRenderer:drawFill ()
	local canvas = self.canvas;
	local ssX, ssY = love.window.getMode();
	love.graphics.draw (canvas, 0, 0, 0, ssX / canvas:getWidth(),
	ssY / canvas:getHeight());
end

function screenRenderer:draw ()
	
	
	love.graphics.draw (self.canvas, self.posX, self.posY, 0, self.scaleX, self.scaleY);
end

function rendering.makeScreenRenderer (canvas)
	local obj = helpers.copy(screenRenderer);
	obj.canvas = canvas;
	obj.cameraX = canvas:getWidth() / 2;
	obj.cameraY = canvas:getHeight() / 2;
	return obj;
end

