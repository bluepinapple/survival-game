shader_type canvas_item;

uniform vec4 glow_color : source_color;
uniform float glow_amount : hint_range(0.0, 2.0);

void fragment() {
	vec4 color = texture(TEXTURE, UV);
    vec4 final_color = color * glow_color * glow_amount;
    final_color.a = color.a;
    COLOR = final_color;
}
