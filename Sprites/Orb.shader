shader_type spatial;
render_mode unshaded;
uniform vec2 uv_size = vec2(0.5,0.5);
uniform float original_radius = 0.5; //should be equal to radius
uniform float radius = 0.4;
uniform vec4 color : hint_color;
uniform vec2 scale = vec2(2.0, 2.0);

void vertex() {
	//billboard mode
	MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat4(CAMERA_MATRIX[0],CAMERA_MATRIX[1],CAMERA_MATRIX[2],WORLD_MATRIX[3]);
	VERTEX = vec3(VERTEX.x*scale.x, VERTEX.y*scale.y, 0.0);

}

void fragment() {
	//Set albedo
	ALBEDO = color.rgb;
	//Find x and y, align center
	float x = UV.x - uv_size.x;
	float y = UV.y - uv_size.y;
	//If point inside circle
	if(pow(x, 2) + pow(y, 2)<pow(radius, 2))
	{
		ALPHA = 1.0;
	}
	else
	{
		ALPHA = 0.0;
	}

}