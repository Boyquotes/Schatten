shader_type canvas_item;
//Take in the position of what the texture rect and underlying bar, then mask with it offset
uniform sampler2D mask;
uniform sampler2D tex;
uniform float fac;
uniform float lightness;

void fragment()
{
	float val = clamp(fac,0.007,1.2);
	vec2 newUV = UV;
	newUV.x += (1.0 * val);
	if (newUV.x > val)
	{
		//COLOR = 
		vec4 Col = vec4(0,0,0,0);
		if (texture(mask,UV).a != 0.0)
		{
			Col.rgb = Col.rgb * lightness;
			Col = texture(tex, newUV * vec2(0.8,1.0)).rgba;
		}
		else
		{
			Col = texture(mask,UV).rgba;
		}
		if (Col.a !=  1.0)
		{
			Col = texture(mask,UV).rgba;
		}
		if (length(Col) < 1.0)
		{
			Col = vec4(0.0);
		}
		COLOR = Col;
	}
}