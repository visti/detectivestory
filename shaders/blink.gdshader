shader_type canvas_item;

uniform float fade_speed : hint_range(0.1, 10.0) = 2.0;

void fragment() {
    // Calculate alpha based on a sine wave
    float alpha = abs(sin(TIME * fade_speed));
    COLOR.a = alpha;
}

