gameWorld = {
	allObjects = {};
	currentWorld = nil;
	nextWorld = nil;

	levels = {};

	
	-- events onClean(), preLoad(), postLoad(), levelBuilder (self, c, x, y)
}

function gameWorld.setSize (width, height)
	gameWorld.width = width;
	gameWorld.height = height;
end

function gameWorld.add (obj, x, y)
	local nObj = helpers.copy(obj);
	if x ~= nil and y ~= nil then
		nObj.posX, nObj.posY = x, y;
	end
	table.insert (gameWorld.allObjects, nObj);
	return nObj;
end

function gameWorld.update (dt)
	entitySystem.updateAll(gameWorld.allObjects,dt);
	gameWorld.clean();
	

	-- loads new levels
	if gameWorld.nextWorld ~= nil and gameWorld.levelBuilder ~= nil then
		entitySystem.destroyAll(gameWorld.allObjects);
		gameWorld.clean();
		
		gameWorld.currentWorld = gameWorld.nextWorld;
		gameWorld.preLoad();

		if type(gameWorld.nextWorld) == "number" then
			gameWorld.nextWorld = gameWorld.levels[(gameWorld.nextWorld % #gameWorld.levels) + 1];
		end
		
		helpers.formatLevel (gameWorld, gameWorld.nextWorld, gameWorld.levelBuilder);
		entitySystem.updateAll(gameWorld.allObjects,0)
		gameWorld.nextWorld = nil;
		gameWorld.postLoad();
	end
end

function gameWorld.clean ()
	if entitySystem.cleanList(gameWorld.allObjects) then
		if gameWorld.onClean ~= nil then
			gameWorld.onClean();
		end
	end
end

function gameWorld.keepInBounds (coll)
	local sizeX, sizeY = coll.sizeX, coll.sizeY;
	if sizeX == nil then sizeX = 0; end
	if sizeY == nil then sizeY = 0; end
	local opX, opY = coll.posX, coll.posY;

	-- topLeft
	if coll.posX < sizeX then coll.posX = sizeX; end
	if coll.posY < sizeY then coll.posY = sizeY; end

	-- topRight
	if coll.posX > gameWorld.width - sizeX then coll.posX = gameWorld.width - sizeX; end
	if coll.posY > gameWorld.height - sizeY then coll.posY = gameWorld.height - sizeY; end

	return not (opX == coll.posX and opY == coll.posY);
end