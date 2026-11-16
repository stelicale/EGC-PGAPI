#version 330

// Input
in vec3 world_position;
in vec3 world_normal;

// Uniform properties
uniform samplerCube texture_cubemap;
uniform int type;

uniform vec3 camera_position;

// Output
layout(location = 0) out vec4 out_color;


vec3 myReflect()
{
    // TODO(student): Compute the reflection color value
    // View direction: from the camera towards the point on the surface (world space)
    vec3 view_dir = normalize(world_position - camera_position);

    // reflect(I, N) mirrors the incident vector I around the normal N.
    // The normal is re-normalized because interpolation can change its length
    vec3 reflected_dir = reflect(view_dir, normalize(world_normal));

    // A cubemap is sampled with a direction: it returns the color the ray hits on the cube
    return texture(texture_cubemap, reflected_dir).xyz;

}


vec3 myRefract(float refractive_index)
{
    // TODO(student): Compute the refraction color value
    // View direction: from the camera towards the point on the surface (world space)
    vec3 view_dir = normalize(world_position - camera_position);

    // refract(I, N, eta) bends the ray when it enters another medium.
    // eta = (refractive index of the first medium) / (refractive index of the second one):
    // we go from air (index 1.0) into the material
    vec3 refracted_dir = refract(view_dir, normalize(world_normal), 1.0 / refractive_index);

    // Sample the cubemap with the bent direction
    return texture(texture_cubemap, refracted_dir).xyz;

}


void main()
{

    if (type == 0)
    {
        out_color = vec4(myReflect(), 0);
    }
    else
    {
        out_color = vec4(myRefract(1.33), 0);
    }
}