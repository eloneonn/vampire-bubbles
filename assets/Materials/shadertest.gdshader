shader_type canvas_item;

uniform float time_offset;
uniform float time_speed : hint_range(0.1, 5.0) = 3.2;
uniform float scale_y : hint_range(0.5, 2.0) = 1.066;

void vertex() {
    // Criando um valor oscilante baseado no tempo, mas com um deslocamento aleatório
    float squash = sin((TIME + time_offset) * time_speed);

    // Aplicando a escala dinâmica no eixo Y
    float stretch_y = mix(1.0, scale_y, squash);

    // Ajustando a escala em X para manter o volume proporcional
    float scale_x = 1.0 / stretch_y;

    // Modificando a posição do vértice
    VERTEX.y *= stretch_y;
    VERTEX.x *= scale_x;
}

render_mode blend_mix;

uniform bool BooleanParameter = false;
uniform vec4 Tint : source_color = vec4(1.000000, 1.000000, 1.000000, 1.000000);



void fragment() {
// BooleanParameter:3
	bool n_out3p0 = BooleanParameter;


// ColorParameter:2
	vec4 n_out2p0 = Tint;


// Input:5
	vec4 n_out5p0 = COLOR;


	vec3 n_out4p0;
// If:4
	float n_in4p1 = 1.00000;
	float n_in4p2 = 0.00001;
	if(abs((n_out3p0 ? 1.0 : 0.0) - n_in4p1) < n_in4p2)
	{
		n_out4p0 = vec3(n_out2p0.xyz);
	}
	else if((n_out3p0 ? 1.0 : 0.0) < n_in4p1)
	{
		n_out4p0 = vec3(n_out5p0.xyz);
	}
	else
	{
		n_out4p0 = vec3(n_out5p0.xyz);
	}


// Output:0
	COLOR.rgb = n_out4p0;


}