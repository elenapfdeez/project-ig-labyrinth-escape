shader_type spatial;

uniform sampler2D textura_original : source_color;
uniform float intensidad_brillo : hint_range(0.0, 5.0) = 0.05;
uniform float velocidad : hint_range(0.0, 5.0) = 1.0;

void fragment() {
	vec4 color_base = texture(textura_original, UV);
	ALBEDO = color_base.rgb;

	//valor base para que no se quede negra
	float pulso = (sin(TIME * velocidad) * 0.5 + 0.5);

	EMISSION = color_base.rgb * pulso * intensidad_brillo;

	METALLIC = 0.8;
	ROUGHNESS = 0.2;
}