shader_type spatial;
render_mode blend_mix;

uniform sampler2D tex;

void fragment()
{
	vec4 col =texture(tex,UV);
	ALPHA = col.a * .9;
	if (col.a == 0.0)
	{
		ALBEDO = vec3(255,255,255);
	}
	else
	{
		ALBEDO = vec3(.9,.9,.9) * col.rgb;
	}
}