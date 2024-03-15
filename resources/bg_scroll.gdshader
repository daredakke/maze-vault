// https://forum.godotengine.org/t/how-to-make-an-infinite-scrolling-background/24114/2
shader_type canvas_item;

varying vec4 v_vertex_color;
uniform vec2 direction = vec2(0.4, -1.0);
uniform float speed_scale = 0.05;

void vertex() {
	v_vertex_color = COLOR;
}

void fragment() {
	vec2 move = direction * TIME * speed_scale;
	COLOR = v_vertex_color * texture(TEXTURE, UV + move);
}
