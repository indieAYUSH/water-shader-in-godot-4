shader_type spatial;

uniform vec3 albedo : source_color;
uniform float metallic : hint_range(0.0, 1.0, 0.1) = 0.0;
uniform float roughness : hint_range(0.0, 1.0, 0.1) = 0.2;
uniform sampler2D texture_normal;
uniform sampler2D texture_normal1;
uniform vec2 wave_dir = vec2(2.0,0.0);
uniform vec2 wave_dir1 = vec2(0.0 , 1.0);
uniform float time_scale : hint_range(0.0, 1.0, 0.1) = 0.5;


void vertex() {
	
}

void fragment() {
	vec2 offset1 = (TIME*wave_dir)*time_scale;
	vec2 offset2 = (TIME*wave_dir1)*time_scale;
	vec3 normal_blend = mix(texture(texture_normal , UV).rgb , texture(texture_normal1 , UV).rgb , 0.5);
	
	ALBEDO = albedo;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	NORMAL_MAP = normal_blend;
}
