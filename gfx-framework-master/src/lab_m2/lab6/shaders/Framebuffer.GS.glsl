#version 330

layout(triangles) in;
// TODO(student): Update max_vertices
// Each input triangle is emitted once per cubemap face: 6 faces * 3 vertices = 18 vertices
layout(triangle_strip, max_vertices = 18) out;

uniform mat4 View;
uniform mat4 Projection;
uniform mat4 viewMatrices[6];

in vec3 geom_position[3];
in vec2 geom_texture_coord[3];

out vec3 frag_position;
out vec2 frag_texture_coord;

void main()
{
    int i, layer;

    // TODO(student): Update the code to compute the position from each camera view 
    // in order to render a cubemap in one pass using gl_Layer. Use the "viewMatrices"
    // attribute according to the corresponding layer.

    // Single-pass cubemap rendering: for every input triangle we generate 6 copies,
    // one for each face of the cubemap, and send each copy to its own layer
    // (the framebuffer attachment is a layered texture: layer 0..5 = +X, -X, +Y, -Y, +Z, -Z)
    for (layer = 0; layer < 6; layer++) {
        // gl_Layer selects the face of the cubemap on which the next primitive is rasterized
        gl_Layer = layer;

        for (i = 0; i < gl_in.length(); i++) {
             frag_position = geom_position[i];
             frag_texture_coord = geom_texture_coord[i];
             // gl_in[i].gl_Position is already in world space (Model applied in the vertex shader),
             // so we apply the view matrix of the current face and then the projection
             gl_Position = Projection * viewMatrices[layer] * gl_in[i].gl_Position;
             EmitVertex();
        }
        // Finish this triangle; the next loop iteration starts a new one on the next layer
        EndPrimitive();
    }
    
}