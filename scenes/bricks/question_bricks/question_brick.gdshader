shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
    float epsilon = 0.04;
    vec4 min_color = vec4(0.945,0.741,0.04,1.0);
    vec4 max_color = vec4(0.753,0.412,0.047, 1.0);
    if(distance(COLOR, min_color) < epsilon){
        COLOR = mix(min_color, max_color, (sin(TIME*5.0) + 1.0) * 0.5);
    }
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
