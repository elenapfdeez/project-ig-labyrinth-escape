shader_type canvas_item;

uniform float radio : hint_range(0.0, 1.0) = 0.8;
uniform float suavizado : hint_range(0.0, 1.0) = 0.6;

void fragment() { //funcion por cada pixel
    float dist = distance(UV, vec2(0.5)); //distancia respecto al centro
    
    float vigneta = smoothstep(radio, radio - suavizado, dist);
    
    COLOR = vec4(0.0, 0.0, 0.0, 1.0 - vigneta); //calculamos transparencias
}