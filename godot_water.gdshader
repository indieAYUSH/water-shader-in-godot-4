shader_type spatial;

uniform vec3 albedo : source_color;
uniform float metallic : hint_range(0.0, 1.0, 0.1) = 0.0;
uniform float roughness : hint_range(0.0, 1.0, 0.1) = 0.2;
uniform sampler2D texture_normal;
uniform sampler2D texture_normal1;


void vertex() {
	
}

void fragment() {
	vec3 normal_blend = mix(texture(texture_normal , UV).rgb , texture(texture_normal1 , UV).rgb , 0.5);
	ALBEDO = albedo;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	NORMAL_MAP = normal_blend;
}
