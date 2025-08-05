shader_type canvas_item;

void vertex() {
	if (VERTEX.y < 0.0){
		VERTEX = VERTEX + vec2(sin(TIME * 0.5) * 15.0, 0.0);
	}
}

