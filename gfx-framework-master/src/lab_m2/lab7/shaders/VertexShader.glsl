#version 330

// Input
layout(location = 0) in vec3 v_position;
layout(location = 1) in vec3 v_normal;
layout(location = 2) in vec2 v_texture_coord;
// TODO (student): Add the new attributes neccessary for skinning
// Each vertex is influenced by up to 4 bones.
// v_bone_ids   = the indices of those 4 bones (index into the Bones array below)
// v_bone_weights = how much each of those 4 bones influences this vertex
//                  (the 4 weights sum up to 1.0)
layout(location = 3) in ivec4 v_bone_ids;
layout(location = 4) in vec4 v_bone_weights;


const int MAX_BONES = 200;

// Uniform properties
uniform mat4 Model;
uniform mat4 View;
uniform mat4 Projection;
// TODO (student): Declare a new uniform variable array, which will
// receive the bone transformations
// One final transformation matrix per bone, computed on the CPU (in lab7.cpp)
uniform mat4 Bones[MAX_BONES];


// Output
out vec2 texture_coord;
// TODO (student): Send the normal to the fragment shader
out vec3 normal;


void main()
{
    // TODO (student): Compute the final bone transformation
    // The final transformation of a vertex is the weighted sum of the
    // transformations of the (up to) 4 bones that influence it.
    mat4 boneTransform = Bones[v_bone_ids[0]] * v_bone_weights[0];
    boneTransform     += Bones[v_bone_ids[1]] * v_bone_weights[1];
    boneTransform     += Bones[v_bone_ids[2]] * v_bone_weights[2];
    boneTransform     += Bones[v_bone_ids[3]] * v_bone_weights[3];

    texture_coord = v_texture_coord;
    // TODO (student): Compute the normal
    // The normal must be rotated by the same bone transformation as the vertex.
    // We use only the upper-left 3x3 part of the matrix, because a normal is a
    // direction (it must not be translated).
    normal = normalize(mat3(boneTransform) * v_normal);

    // TODO (student): Apply the bone transformation on the vertex position
    // First move the vertex to its animated position (skinning),
    // then apply the usual Model -> View -> Projection transformations.
    vec4 skinnedPosition = boneTransform * vec4(v_position, 1.0);
    gl_Position = Projection * View * Model * skinnedPosition;
}
