lightingSystem = {
	MAX_LIGHTS = 20;
	lightNumber = 0;
	lights = {};
	lightColors = {};
	screenRenderer = nil;
};

local ls = lightingSystem;

-- creates the lights
for i = 1, lightingSystem.MAX_LIGHTS+1 do
	lightingSystem.lights[i] = {0,0,0,0};
	lightingSystem.lightColors[i] = {1,1,1,1};
end

print (#ls.lights .. " " .. #ls.lightColors);


function lightingSystem.setShadowColor (r,g,b)
	-- sets the shadow color
	lightingSystem.lightingShader:send("shadowColor", {r,g,b});
end

-- adds a light that only lasts 1 frame,
-- takes in the lights x,y position, the radius and the color (r,g,b,a)
function lightingSystem.addLight (x,y,radius, r, g, b, a)
	ls.lightNumber = ls.lightNumber + 1; -- increases the number of lights
	--print (ls.lightNumber);
	if ls.lightNumber >= ls.MAX_LIGHTS then -- caps the number of lights to be less then or equal to MAX_LIGHTS
		ls.lightNumber = ls.MAX_LIGHTS;
		return;
	end

	-- if a screen renderer is given, this will update the x and y to take the cameras position into account
	if ls.screenRenderer ~= nil then
		x = x + ls.screenRenderer:getCamOffsetX();
		y = y + ls.screenRenderer:getCamOffsetY();		

	end

	if a == nil then a = 0; end -- maxs sure a is not nil, because a is optional
	local i = ls.lightNumber;
	local light, lightColor = ls.lights[i], ls.lightColors[i]; -- gets the ptrs of the light and its color
	light[1], light[2], light[3] = x, y, radius; -- sets up the light

	lightColor[1], lightColor[2], lightColor[3], lightColor[4] = r,g,b,a; -- sets the light color
end

function lightingSystem.updateLights ()
	
	-- sends the light values to the shader
	ls.lightingShader:send("lightVals",
		ls.lights[1], ls.lights[2], ls.lights[3], ls.lights[4], ls.lights[5],
		ls.lights[6], ls.lights[7], ls.lights[8], ls.lights[9], ls.lights[10],
		ls.lights[11], ls.lights[12], ls.lights[13], ls.lights[14], ls.lights[15],
		ls.lights[16], ls.lights[17], ls.lights[18], ls.lights[19], ls.lights[20]); 

	-- sends the light colors to the shader
	ls.lightingShader:send("lightColors",
	ls.lightColors[1], ls.lightColors[2], ls.lightColors[3], ls.lightColors[4], ls.lightColors[5],
	ls.lightColors[6], ls.lightColors[7], ls.lightColors[8], ls.lightColors[9], ls.lightColors[10],
	ls.lightColors[11], ls.lightColors[12], ls.lightColors[13], ls.lightColors[14], ls.lightColors[15],
	ls.lightColors[16], ls.lightColors[17], ls.lightColors[18], ls.lightColors[19], ls.lightColors[20]);

	-- sends the number of lights to the shader
	ls.lightingShader:send("lightNum", ls.lightNumber);
	ls.lightNumber = 0;
end

lightingSystem.lightingShader = love.graphics.newShader([[
	#define LIGHT_NUMBER 20

	uniform vec3 shadowColor;
	uniform int lightNum = 0;
	uniform vec3 lightVals[LIGHT_NUMBER];
	uniform vec4 lightColors[LIGHT_NUMBER];

	vec4 effect (vec4 color, Image tex, vec2 texCoords, vec2 screenCoords) {
		vec4 col = Texel (tex, texCoords); // gets the color of the pixel

		float shinyness = col.a; // calculates the shinyness based on the alpha

		if (col.a >= 0.01){ col.a = 1;} // makes sure less shiny regens are visible
		
		vec3 pixLight = shadowColor; // sets the pixel light to the shadow color
		vec3 lightMult = 1 - shadowColor;//(shadowColor.r + shadowColor.g + shadowColor.b) / 3;

		float tln = LIGHT_NUMBER;
		if (LIGHT_NUMBER > lightNum) tln = lightNum;

		for (int i = 0; i < tln; i++) {
			vec2 ldI = vec2 (lightVals[i].x - screenCoords.x, lightVals[i].y - screenCoords.y);
			//ldI *= 1 - shinyness;

			float lightDist2 = ldI.x * ldI.x + ldI.y * ldI.y; 
			float lr2 = lightVals[i].z;
			lr2 *= lr2;
			//lr2 *= shinyness;

			if (lightDist2 < lr2) {
				float lightAm = 1 - (lightDist2 / lr2);
				//pixLight *= (1 - (lightColors[i].rgb * lightAm * shinyness));
				pixLight += lightColors[i].rgb * lightAm * shinyness;
			}
		}

		//pixLight = 1 - pixLight;

		col.rgb *= (pixLight * lightMult);

		//col.rgb = col.rgr;

		return col;
	}
]]);

lightingSystem.setShadowColor(0.5, 0.5, 0.5);
