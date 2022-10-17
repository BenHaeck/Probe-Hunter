entitySystem = {};
-- Entity events start(), update(dt), onDestroy()

function entitySystem.makePhysicsBody (obj, sizeX, sizeY)
	collision.makeCollider(0,0, sizeX, sizeY, obj);
	obj.motionX = 0;
	obj.motionY = 0;
end

function entitySystem.giveEntityVars (obj, sizeX, sizeY)
	-- Physics stuff
	collision.makeCollider(0,0, sizeX, sizeY, obj);
	obj.motionX = 0;
	obj.motionY = 0;

	obj.tag = "";

	-- Rendering
	obj.quad = nil;
	obj.quadRotation = 0;
	obj.quadScaleX = 1;
	obj.quadScaleY = 1;
end

function entitySystem.addObjectsToBatch (spriteBatch, entities)
	for i = 1, #entities do
		if entities[i].quad ~= nil and entities[i].posX ~= nil and entities[i].posY ~= nil then
			local entity = entities[i];

			local qx, qy, qw, qh = entity.quad:getViewport();

			local scaleX, scaleY = 1,1;
			local offsetX, offsetY = 0,0;
			if entity.quadScaleX ~= nil then scaleX = entity.quadScaleX; end
			if entity.quadScaleY ~= nil then scaleY = entity.quadScaleY; end
			if entity.quadOffsetX ~= nil then offsetX = entity.quadOffsetX; end
			if entity.quadOffsetY ~= nil then offsetY = entity.quadOffsetY; end

			local rot = 0;
			if entity.rotation ~= nil then rot = entity.rotation; end

			spriteBatch:add(entity.quad, entity.posX + offsetX, entity.posY + offsetY,
				rot, scaleX, scaleY,
				qw * 0.5, qh * 0.5);
		end
	end
end

function entitySystem.rectDraw (objList, defWidth, defHeight, screenRenderer)
	local coX, coY = 0,0;
	if screenRenderer ~= nil then
		coX,coY = screenRenderer:getCamOffsetX(), screenRenderer:getCamOffsetY();
	end
	for i = 1, #objList do
		local w, h = defWidth, defHeight;
		if objList[i].sizeX ~= nil then w = objList[i].sizeX; end
		if objList[i].sizeY ~= nil then h = objList[i].sizeY; end

		if objList[i].posX ~= nil and objList[i].posY then
			love.graphics.rectangle("fill", objList[i].posX + coX - w, objList[i].posY + coY - h, w * 2, h * 2);
		end
	end
end

function entitySystem.drawObjects (objList, renderer)
	for i = 1, #objList do
		objList[i].render(renderer);
	end
end

function entitySystem.updateAll (objList,dt)
	for i = 1, #objList do
		if objList[i].start ~= nil and objList[i]._firstUpdate ~= true then
			objList[i]:start();
			objList[i]._firstUpdate = true;
		end
		
		if objList[i].update ~= nil then
			objList[i]:update (dt);
		end
	end
end

function entitySystem.destroy (obj)
	if obj._shouldRemove ~= true and obj.onDestroy then
		obj:onDestroy();
	end
	obj._shouldRemove = true;
end

function entitySystem.message (obj, message, x, y)
	if x == nil then x = 0; end
	if y == nil then y = 0; end
	
	if obj.onMessage ~= nil then
		return obj:onMessage (message, x, y);
	end

	return false;
end

function entitySystem.destroyAll (objList, immediateClean)
	for i = 1, #objList do
		entitySystem.destroy(objList[i]);
	end
end

function entitySystem.cleanList (objList)
	local removedObject = false;
	for i = #objList, 1, -1 do
		if objList[i]._shouldRemove == true then
			table.remove(objList,i);
			removedObject = true;
		end
	end
	return removedObject;
end
