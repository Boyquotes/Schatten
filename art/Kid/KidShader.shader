shader_type spatial;

render_mode depth_draw_alpha_prepass;

uniform sampler2D Diffuse;
uniform float transparency;
uniform float tint;

void fragment()
{
	vec3 red = texture(Diffuse, UV).xyz;
	red.r *= tint;
	ALBEDO = red;
	ALPHA = transparency;

}
