shader_type canvas_item;

uniform vec4 color : source_color;
uniform float flashState : hint_range(-1.0, 1.0, 0.01) = 0.5;

void fragment() {
	// Place fragment code here.
	vec4 pixelColor = texture(TEXTURE, UV);
	float brightness = (pixelColor.r + pixelColor.g + pixelColor.b) / 4.0;
	vec4 grayScale = vec4(brightness, brightness, brightness, pixelColor.a);
	COLOR = mix(pixelColor, color, flashState);
}
