helpers = require ("EngineStuff/helpers");
require ("EngineStuff/collision");
require ("EngineStuff/rendering");
require ("EngineStuff/simpleEntitySystem");
require ("EngineStuff/gameWorld");
require ("EngineStuff/lightingSystem");
require ("EngineStuff/audioHelpers");
--lightingSystem.setShadowColor(1,1,1);
lightingSystem.setShadowColor(0.6,0.6,0.6);

require ("Assets/AssetLoading");

entityTypes = {}
require ("Game/HUDObjects");

require ("Game/GameObjects/objectSuperTypes");
require ("Game/GameObjects/player");
require ("Game/GameObjects/camera");

require ("Game/GameObjects/Enemies/enemy");
require ("Game/GameObjects/Enemies/bugEnemy");
require ("Game/GameObjects/Enemies/alienDrone");
require ("Game/GameObjects/bullet");

require ("Game/GameObjects/EnvObjs/goal");
require ("Game/GameObjects/EnvObjs/walls");
require ("Game/GameObjects/EnvObjs/spike");
require ("Game/GameObjects/EnvObjs/lightCrystal");
require ("Game/GameObjects/EnvObjs/windPlant");

require ("Game/GameObjects/smallObjects");
require ("Game/GameObjects/probe");

require ("Game/ShaderStuff");
require "Game/particalSystem";

gameWorld.levels = require ("Game/levels");

love.window.setTitle ("ProbeHunter");
love.window.setMode (640,640, {resizable = true});

screenSize = 640
canv = love.graphics.newCanvas(screenSize,screenSize);
canv:setFilter("nearest", "nearest");

gameWorld.setSize(screenSize, screenSize);

local screenRenderer = rendering.makeScreenRenderer (canv);
lightingSystem.screenRenderer = screenRenderer;

function gameWorld.preLoad ()
	gameWorld.setSize (screenSize,screenSize);

end

function gameWorld.postLoad ()
	local cam = gameWorld.add (entityTypes.camera,0,0);
	cam.renderer = screenRenderer;
	local pop = gameWorld.add(entityTypes.prompt, screenSize * 0.95, screenSize * 0.1);
	pop.key = "l";
	pop = gameWorld.add(entityTypes.prompt, screenSize * 0.85, screenSize * 0.05);
	pop.key = "k";
	entitySystem.updateAll(gameWorld.walls, 0)
end

-- 
gameWorld.timeFreeze = 0;

-- setup the gameWorld
gameWorld.hittable = {};
gameWorld.walls = {};
gameWorld.exposedWalls = {};

gameWorld.background = {};
gameWorld.mainLayer2 = {};
gameWorld.mainLayer = {};
gameWorld.bulletLayer = {};
gameWorld.particals = {};

gameWorld.hud = {entityTypes.playerHealthBar,}

local SPRITE_BATCH = love.graphics.newSpriteBatch(ASSETS.FORGROUND_SPRITES);
local paused = true;

function gameWorld.onClean ()
	if gameWorld.player._shouldRemove == true then gameWorld.player = nil; end
	entitySystem.cleanList(gameWorld.hittable);
	entitySystem.cleanList(gameWorld.walls);
	entitySystem.cleanList(gameWorld.exposedWalls);

	entitySystem.cleanList(gameWorld.background);
	entitySystem.cleanList(gameWorld.mainLayer2);
	entitySystem.cleanList(gameWorld.mainLayer);
	entitySystem.cleanList(gameWorld.bulletLayer);
	entitySystem.cleanList(gameWorld.particals);
	entitySystem.cleanList(gameWorld.hud);
end

function gameWorld:levelBuilder (c,x,y)
	x = x * 32;
	y = y * 32;

	
	if c == "p" then
		gameWorld.add (entityTypes.player,x,y - 2);
	end

	if c == "w" then
		local w = gameWorld.add (entityTypes.wall, x, y);
		table.insert(gameWorld.walls, w);
	end

	if c == "d" then
		local w = gameWorld.add (entityTypes.destructableWall,x,y);
		table.insert(gameWorld.walls, w);
	end

	if c == "^" then
		gameWorld.add (entityTypes.windPlant,x,y);
	end

	if c == "s" then
		gameWorld.add (entityTypes.spike, x, y);
	end

	if c == "e" then
		gameWorld.add(entityTypes.enemy,x,y-20);
	end

	if c == "$" then
		gameWorld.add(entityTypes.alienDrone,x,y);
	end

	if c == "b" then
		gameWorld.add(entityTypes.bugEnemy,x,y);
	end

	if c == "x" then
		gameWorld.add(entityTypes.goal,x,y);
	end

	if c == "c" then
		gameWorld.add(entityTypes.lightCrystal,x,y + (4 * 2));
	end

	if c == "|" then
		local bg = gameWorld.add({
			quadScaleX = 1*4;
			quadScaleY = 5*4;
			quad = ASSETS.BACKGROUND_ROCK_QUAD;
		},x,y);
		table.insert(gameWorld.background, bg);
	end

	if c == "-" then
		local bg = gameWorld.add({
			quadScaleX = 1*4;
			quadScaleY = 7*4;
			rotation = math.pi * 0.5;
			quad = ASSETS.BACKGROUND_ROCK_QUAD;
		},x,y);
		table.insert(gameWorld.background, bg);
	end

	if c == "!" then
		gameWorld.add(entityTypes.probe,x,y);
	end
	
	if c == "." then
		gameWorld.setSize (x - 16, y + 16);
	end

	if c == "t" then
		gameWorld.add(entityTypes.titleScreen, x, y);

	end
end

gameWorld.nextWorld = 0;

function love.load()

end

local fps = 0
function love.update(dt)
	if dt > 1/16 then dt = 1/30; end
	if dt ~= 0 then fps = 1/dt; end

	if gameWorld.timeFreeze >= 0 then gameWorld.timeFreeze = gameWorld.timeFreeze - dt; end
	if gameWorld.timeFreeze > 0 or paused then return; end
	--dt = dt / 2;
	gameWorld.update(dt);
	
	if gameWorld.nextWorld ~= nil then
		gameWorld.nextWorld = nil;
		loadWorld();
	end
	
	lightingSystem.updateLights();
end

function love.keypressed (key, scanCode, isRepeating)
	-- gameWorld.player:keyPressed (key);
	if key == "escape" then
		paused = not paused;
	end
	if key == "]" then
		gameWorld.nextWorld = gameWorld.currentWorld + 1;
	end
	if key == "[" then
		gameWorld.nextWorld = gameWorld.currentWorld - 1;
	end
end
screenRenderer:update();

function love.resize()
	
	screenRenderer:update();
end

function love.draw()
	love.graphics.clear(0.05,0.05,0.05);

	love.graphics.setCanvas (canv);
	love.graphics.clear(0,0,0);
	
	love.graphics.setColor(1,1,1)
	--local objs = gameWorld.allObjects;
	
	--love.graphics.setShader ();
	love.graphics.setShader(lightingSystem.lightingShader);
	
	SPRITE_BATCH:setTexture(ASSETS.FORGROUND_SPRITES);
	
	entitySystem.addObjectsToBatch(SPRITE_BATCH, gameWorld.background);
	entitySystem.addObjectsToBatch(SPRITE_BATCH, gameWorld.mainLayer2)
	entitySystem.addObjectsToBatch(SPRITE_BATCH, gameWorld.mainLayer);
	entitySystem.addObjectsToBatch(SPRITE_BATCH, gameWorld.bulletLayer);
	entitySystem.addObjectsToBatch(SPRITE_BATCH, gameWorld.particals);
	entitySystem.addObjectsToBatch(SPRITE_BATCH, gameWorld.walls);
	
	love.graphics.draw(SPRITE_BATCH, screenRenderer:getCamOffsetX(), screenRenderer:getCamOffsetY());
	SPRITE_BATCH:clear();
	
	love.graphics.setShader();
	SPRITE_BATCH:setTexture(ASSETS.HUD_SPRITES);

	entitySystem.addObjectsToBatch(SPRITE_BATCH, gameWorld.hud)
	love.graphics.draw(SPRITE_BATCH);
	SPRITE_BATCH:clear();




	--love.graphics.setColor(1,0.25,0.25)
	--love.graphics.print("fps: "..fps)
	-- Draws the screen
	love.graphics.setCanvas ();
	love.graphics.setColor(1,1,1)
	local ssX, ssY = love.window.getMode();
	love.graphics.setColor(1,1,1,0.25);
	love.graphics.setShader(ASSETS.BLUR_SHADER);
	screenRenderer:drawFill()
	love.graphics.setShader (ASSETS.CANVAS_SHADER);
	love.graphics.setColor(1,1,1);
	screenRenderer:draw();
end