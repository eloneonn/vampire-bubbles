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