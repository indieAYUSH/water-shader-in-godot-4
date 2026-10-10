shader_type spatial;

uniform vec3 albedo : source_color;
uniform vec3 fernsal_rim : source_color;
uniform float metallic : hint_range(0.0, 1.0, 0.1) = 0.0;
uniform float roughness : hint_range(0.0, 1.0, 0.01) = 0.2;
uniform float alpha : hint_range(0.0, 1.0, 0.01) = 0.3;
uniform sampler2D texture_normal;
uniform sampler2D texture_normal1;
uniform vec2 wave_dir = vec2(2.0,0.0);
uniform vec2 wave_dir1 = vec2(0.0 , 1.0);
uniform float time_scale : hint_range(0.0, 1.0, 0.001) = 0.025;
uniform sampler2D wave_noise;
uniform float noise_scale = 10.0;
uniform float height_scale = 0.15;
varying vec3 word_pos;
varying float height;

uniform vec4 shallow_color : source_color;
uniform vec4 deep_color : source_color;
uniform float beers_cofficient = 2.0;
uniform float depth_offset  = -0.75;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture , filter_linear_mipmap;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture , filter_linear_mipmap;


uniform float edge_scale = 0.1;
uniform float near = 1.0;
uniform float far = 100.0;
uniform vec4 edge_color : source_color;

float fresnel(float amount , vec3 normal , vec3 view){
	return pow(1.0 - clamp(max(dot(normal , view) ,0.0) , 0.0 , 1.0) , amount);
}

float edge(float depth){
	depth = 1.0 - 2.0 * depth ;
	return near * far/(far + depth * (near - far));
}

void vertex() {
	word_pos = (MODEL_MATRIX * vec4(VERTEX , 1.0)).xyz;
	height = texture(wave_noise , word_pos.xz/noise_scale+TIME*time_scale).r;
	VERTEX.y = height * height_scale;
}



void fragment() {
	float depth_tex = texture(DEPTH_TEXTURE , SCREEN_UV).r * 2.0 -1.0;
	float depth = PROJECTION_MATRIX[3][2] / (depth_tex + PROJECTION_MATRIX[2][2]);
	float depth_blend = exp((depth + VERTEX.z + depth_offset ) * -beers_cofficient);
	depth_blend = clamp(1.0 - depth_blend , 0.0 , 1.0);
	float depth_blend_power = clamp(pow(1.0 - depth_blend , 2.5) , 0.0 , 1.0);
	vec3 screen_color = textureLod(SCREEN_TEXTURE , SCREEN_UV , depth_blend_power*2.5).rgb;
	vec3 depth_color = mix(shallow_color.rgb , deep_color.rgb , depth_blend_power);
	vec3 color = mix(depth_color * screen_color , depth_color * 0.25 , depth_blend_power*0.5);
	
	float z_depth = edge(texture(DEPTH_TEXTURE , SCREEN_UV).x);
	float z_pos = edge(FRAGCOORD.z);
	float z_differ = z_depth - z_pos;
	
	vec3 final_col = mix(edge_color.rgb , color , step(edge_scale , z_differ));
	
	vec2 offset1 = (TIME*wave_dir)*time_scale;
	vec2 offset2 = (TIME*wave_dir1)*time_scale;
	vec3 normal_blend = mix(texture(texture_normal , word_pos.xz+offset1).rgb , texture(texture_normal1 , word_pos.xz+offset2).rgb , 0.5);
	vec3 N = normalize(NORMAL);
	vec3 V = normalize(VIEW);
	float fresnel = fresnel(5.5 , NORMAL , VIEW);
	vec3 source_albedo = mix(albedo , fernsal_rim , fresnel);
	ALBEDO = clamp(source_albedo + final_col , vec3(0.0) , vec3(1.0));
	METALLIC = metallic;
	ROUGHNESS = roughness;
	NORMAL_MAP = normal_blend;
	ALPHA = alpha;
}
