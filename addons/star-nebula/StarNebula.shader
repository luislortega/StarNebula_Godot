shader_type spatial;
render_mode depth_draw_never, cull_back, unshaded, shadows_disabled;

uniform float seed = 0.0;
uniform vec4 star_color : hint_color = vec4( 1.0, 1.0, 1.0, 1.0 );
uniform float star_aperture = 7.0;

uniform vec4 nebula_1_color : hint_color = vec4( 1.0, 0.4, 0.0, 1.0 );
uniform float nebula_1_aperture = 3.0;
uniform float nebula_1_power = 130.0;
uniform vec4 nebula_2_color : hint_color = vec4( 0.8, 0.67, 0.0, 1.0 );
uniform float nebula_2_aperture = 3.0;
uniform float nebula_2_power = 80.0;
uniform vec4 nebula_3_color : hint_color = vec4( 0.2, 0.2, 1.0, 1.0 );
uniform float nebula_3_aperture = 3.0;
uniform float nebula_3_power = 90.0;

float random( vec3 pos )
{ 
	return fract(sin(dot(pos, vec3(12.9898,78.233,53.532532))) * 43758.5453);
}

float value_noise( vec3 pos )
{
	vec3 p = floor( pos );
	vec3 f = fract( pos );

	float v000 = random( p/*+ vec3( 0.0, 0.0, 0.0 )*/ );
	float v100 = random( p + vec3( 1.0, 0.0, 0.0 ) );
	float v010 = random( p + vec3( 0.0, 1.0, 0.0 ) );
	float v110 = random( p + vec3( 1.0, 1.0, 0.0 ) );
	float v001 = random( p + vec3( 0.0, 0.0, 1.0 ) );
	float v101 = random( p + vec3( 1.0, 0.0, 1.0 ) );
	float v011 = random( p + vec3( 0.0, 1.0, 1.0 ) );
	float v111 = random( p + vec3( 1.0, 1.0, 1.0 ) );

	vec3 u = f * f * ( 3.0 - 2.0 * f );

	return mix(
		mix(
			mix( v000, v100, u.x )
		,	mix( v010, v110, u.x )
		,	u.y
		)
	,	mix(
			mix( v001, v101, u.x )
		,	mix( v011, v111, u.x )
		,	u.y
		)
	,	u.z
	);
}

float calc_nebula_value( vec3 v, float aperture )
{
	return clamp(
		pow(
			(
				(
					value_noise( v * 5.45432 ) * 0.5
				+	value_noise( v * 15.754824 ) * 0.25
				+	value_noise( v * 35.4274729 ) * 0.125
				+	value_noise( v * 95.65347829 ) * 0.0625
				+	value_noise( v * 285.528934 ) * 0.03125
				+	value_noise( v * 585.495328 ) * 0.015625
				+	value_noise( v * 880.553426553 ) * 0.0078125
				+	value_noise( v * 2080.5483905843 ) * 0.00390625
				) - 0.5
			) * 2.0 * value_noise( v * 1.365 )
			,	aperture
		)
	,	0.0
	,	1.0
	);
}

void fragment( )
{
	vec3 camera_pos = ( CAMERA_MATRIX * vec4( 0.0, 0.0, 0.0, 1.0 ) ).xyz;

	// カメラ -> 描画する点への単位ベクトル
	vec3 v = -( vec4( VIEW, 1.0 ) * INV_CAMERA_MATRIX ).xyz;
	v.x += seed;

	// 星
	float star_alpha = pow( value_noise( v * 786.54315543 ) * value_noise( v * 452.53254328 ), star_aperture );

	// 星雲
	float nebula_1_alpha = calc_nebula_value( v, nebula_1_aperture );
	float nebula_2_alpha = calc_nebula_value( v + vec3( 135.43278943, -643.1862486, 5245.15154 ), nebula_2_aperture );
	float nebula_3_alpha = calc_nebula_value( v + vec3( 55.154454, 474.85644, -127.45864684 ), nebula_3_aperture );

	// 合成
	ALPHA = min( star_alpha + nebula_1_alpha + nebula_2_alpha + nebula_3_alpha, 1.0 );
	ALBEDO = mix(
		star_color.rgb
	,	max(
			( nebula_1_color * nebula_1_alpha * nebula_1_power ).rgb
		+	( nebula_2_color * nebula_2_alpha * nebula_2_power ).rgb
		+	( nebula_3_color * nebula_3_alpha * nebula_3_power ).rgb
		,	vec3( 1.0, 1.0, 1.0 )
		)
	,	min(
			nebula_1_alpha * nebula_1_power
		+	nebula_2_alpha * nebula_2_power
		+	nebula_3_alpha * nebula_3_power
		,	1.0
		)
	);
	DEPTH = 1.0;
}
