
ASSETS.CANVAS_SHADER = love.graphics.newShader ([[
	vec3 changeS (vec3 col, float am) {
		float deSat = (col.r + col.g + col.b)/3;
		return (col*(am)) + (vec3(deSat, deSat, deSat) * (1-am));
	}

	vec4 effect (vec4 color, Image tex, vec2 texCoords, vec2 screenCoords) {
		vec4 tCol = Texel(tex, texCoords) * color;

		float v = 0.5 - texCoords.x;
		v *= 2;
		v *= v;
		v *= 1 + 0.4 * texCoords.y;// * texCoords.y * texCoords.y;
		v *= v;
		v *= 0.4;
		tCol.rgb = changeS(tCol.rgb,0.5*v+1);
		v *= 1.2;
		if (v < 0) v = 0;
		
		tCol.rgb *= 1 - (v*(1 - vec3(1,0.5,1)));
		return tCol;
	}
]]);

ASSETS.BLUR_SHADER = love.graphics.newShader([[
	vec4 effect (vec4 color, Image tex, vec2 texCoords, vec2 screenCoords) {
		vec4 tCol = vec4(0,0,0,1);//Texel(tex, texCoords) * color;
		float iter = 1/4.0;
		for (float x = -1; x <= 1; x += iter) {
			for (float y = -1; y <= 1; y += iter) {
				tCol.rgb += Texel(tex, texCoords + vec2(x,y) * 0.02).rgb;
			}
		}
		tCol.rgb *= (iter * iter)/8;
		return tCol;
	}
]])