local function formatSheet (image, x,y,w,h, num)
	local sheet = {};
	for i = 0, num - 1 do
		sheet[i+1] = love.graphics.newQuad(x + (w*i),y,w,h,image);
	end
	return sheet;
end

ASSETS = {}


ASSETS.FORGROUND_SPRITES = love.graphics.newImage("Assets/ForgroundSprites.png");


ASSETS.PLAYER_QUAD = love.graphics.newQuad(0,0,8,8, ASSETS.FORGROUND_SPRITES);
ASSETS.PLAYER_QUADS = formatSheet(ASSETS.FORGROUND_SPRITES, 0,0, 8,8, 8);

ASSETS.WALL_QUAD = love.graphics.newQuad(24,8,8,8, ASSETS.FORGROUND_SPRITES);
ASSETS.WALL_QUADS = formatSheet(ASSETS.FORGROUND_SPRITES, 0,8, 8,8, 5);
ASSETS.SPIKE_QUAD = love.graphics.newQuad(48, 24, 8, 8, ASSETS.FORGROUND_SPRITES);
ASSETS.GOAL_QUADS = formatSheet (ASSETS.FORGROUND_SPRITES, 48,8, 8,8, 2);
ASSETS.WIND_PLANT_QUAD = love.graphics.newQuad (40,24, 8,8, ASSETS.FORGROUND_SPRITES);

ASSETS.ENEMY_QUAD = love.graphics.newQuad(0,16,12,8, ASSETS.FORGROUND_SPRITES);
--ASSETS.ENEMY_QUADS = formatSheet(ASSETS.FORGROUND_SPRITES, 0, 16, 8, 8, 2);
ASSETS.BUG_ENEMY_QUADS = formatSheet(ASSETS.FORGROUND_SPRITES, 0, 24, 8,8, 2);
ASSETS.ALIEN_DRONE_QUADS = formatSheet(ASSETS.FORGROUND_SPRITES, 16,24, 8,8, 2);
ASSETS.PROBE_QUAD = love.graphics.newQuad(32,24,8,8, ASSETS.FORGROUND_SPRITES);

ASSETS.LIGHT_CRYSTAL = love.graphics.newQuad(56, 32, 8, 8, ASSETS.FORGROUND_SPRITES);
ASSETS.BULLET_QUAD = love.graphics.newQuad(60,28,4,4, ASSETS.FORGROUND_SPRITES);

ASSETS.PARTICAL_QUADS = formatSheet (ASSETS.FORGROUND_SPRITES, 48,16, 4,3.95, 4);

ASSETS.BACKGROUND_ROCK_QUAD = love.graphics.newQuad(0,32,8,8,ASSETS.FORGROUND_SPRITES);

ASSETS.FORGROUND_SPRITES:setFilter("nearest", "nearest");
ASSETS.ANIMATION_FPS = 4;

ASSETS.HUD_SPRITES = love.graphics.newImage("Assets/HUDSprites.png");

ASSETS.PLAYER_HEALTH_BAR = formatSheet(ASSETS.HUD_SPRITES, 0,0, 12, 8, 4);
ASSETS.TUTORIALS = formatSheet(ASSETS.HUD_SPRITES, 0,8, 12, 8, 2);
ASSETS.TITLE_SCREEN_QUAD = love.graphics.newQuad(0,20, 24, 24, ASSETS.HUD_SPRITES);


ASSETS.HUD_SPRITES:setFilter("nearest", "nearest");

-- sounds

ASSETS.PLAYER_SHOOT_SFX = love.audio.newSource("Assets/Sounds/PlayerShoot.wav", "static");
ASSETS.PLAYER_JUMP_SFX = love.audio.newSource("Assets/Sounds/PlayerJump.wav", "static");
ASSETS.PLAYER_JUMP_SFX:setVolume(0.4);
ASSETS.PLAYER_JUMP_SFX:setPitch(0.9);
ASSETS.PLAYER_DASH_SFX = love.audio.newSource("Assets/Sounds/PlayerDash.wav", "static");
ASSETS.PLAYER_DASH_SFX:setVolume(0.5);
ASSETS.PLAYER_HIT_SFX = love.audio.newSource("Assets/Sounds/Hit.wav", "static");
ASSETS.PLAYER_HIT_SFX:setPitch(0.5);

ASSETS.PLAYER_DEATH_SFX = love.audio.newSource("Assets/Sounds/Destruct.wav", "static");
ASSETS.PLAYER_DEATH_SFX:setPitch(1.5);

ASSETS.ENEMY_JUMP_SFX = love.audio.newSource("Assets/Sounds/PlayerJump.wav", "static");
ASSETS.ENEMY_JUMP_SFX:setPitch(0.5);


ASSETS.PLANT_PUSH_SFX = love.audio.newSource("Assets/Sounds/PlayerDash.wav", "static");
ASSETS.PLANT_PUSH_SFX:setVolume(0.8);
ASSETS.PLANT_PUSH_SFX:setPitch(0.5);

ASSETS.ENEMY_SHOOT_SFX = love.audio.newSource("Assets/Sounds/PlayerShoot.wav", "static");
ASSETS.ENEMY_SHOOT_SFX:setPitch(1.2);

ASSETS.ENEMY_HIT_SFX = love.audio.newSource("Assets/Sounds/Hit.wav", "static");
ASSETS.ENEMY_HIT_SFX:setPitch(1.2);
ASSETS.ENEMY_DEATH_SFX = love.audio.newSource("Assets/Sounds/Death.wav", "static");
ASSETS.ENEMY_DEATH_SFX:setPitch(0.8);
--ASSETS.PLAYER_JUMP_SFX:setVolume(0.5);

ASSETS.GROUND_DESTROY_SFX = love.audio.newSource("Assets/Sounds/Destruct.wav", "stream");
ASSETS.GROUND_DESTROY_SFX:setVolume(0.4);

ASSETS.DOOR_BREAK_SFX = love.audio.newSource("Assets/Sounds/Destruct.wav", "stream");
ASSETS.DOOR_BREAK_SFX:setVolume(0.8);
ASSETS.DOOR_BREAK_SFX:setPitch(0.6);

ASSETS.PROBE_LIFTOFF_SFX = love.audio.newSource("Assets/Sounds/Destruct.wav", "stream");
ASSETS.PROBE_LIFTOFF_SFX:setPitch(0.4);

