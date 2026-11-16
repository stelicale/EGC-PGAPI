#include "lab_m2/lab3/lab3.h"

#include <vector>
#include <iostream>

using namespace std;
using namespace m2;


/*
 *  To find out more about `FrameStart`, `Update`, `FrameEnd`
 *  and the order in which they are called, see `world.cpp`.
 */


Lab3::Lab3()
{
}


Lab3::~Lab3()
{
}


void Lab3::Init()
{
    // Two columns with four bamboo plants each are visible from startup.
    nrInstances = 8;
    maxInstances = 50;
    shrink = 0;

    auto camera = GetSceneCamera();
    camera->SetPositionAndRotation(glm::vec3(0, 5, 4), glm::quat(glm::vec3(-30 * TO_RADIANS, 0, 0)));
    camera->Update();

    // Load a mesh from file into GPU memory
    {
        Mesh* mesh = new Mesh("bamboo");
        mesh->LoadMesh(PATH_JOIN(window->props.selfDir, RESOURCE_PATH::MODELS, "vegetation", "bamboo"), "bamboo.obj");
        meshes[mesh->GetMeshID()] = mesh;
    }

    // Create a shader program for rendering to texture
    {
        Shader *shader = new Shader("Instances");
        shader->AddShader(PATH_JOIN(window->props.selfDir, SOURCE_PATH::M2, "lab3", "shaders", "VertexShader.glsl"), GL_VERTEX_SHADER);
        shader->AddShader(PATH_JOIN(window->props.selfDir, SOURCE_PATH::M2, "lab3", "shaders", "GeometryShader.glsl"), GL_GEOMETRY_SHADER);
        shader->AddShader(PATH_JOIN(window->props.selfDir, SOURCE_PATH::M2, "lab3", "shaders", "FragmentShader.glsl"), GL_FRAGMENT_SHADER);
        shader->CreateAndLink();
        shaders[shader->GetName()] = shader;
    }
}


void Lab3::FrameStart()
{
}


void Lab3::Update(float deltaTimeSeconds)
{
    ClearScreen();

    {
        auto shader = shaders["Instances"];

        shader->Use();

        int loc_instances = shader->GetUniformLocation("instances");
        glUniform1i(loc_instances, nrInstances);

        // TODO(student): Add a shrinking parameter for scaling each
        // triangle in the geometry shader
        int loc_shrink = shader->GetUniformLocation("shrink");
        glUniform1f(loc_shrink, shrink);

        // Mesh::Render binds its diffuse texture on texture unit 0.
        glUniform1i(shader->GetUniformLocation("texture_1"), 0);

        // Note that we only render a single mesh!
        // The first bamboo starts at the XZ origin; the geometry shader
        // offsets subsequent instances from this point.
        RenderMesh(meshes["bamboo"], shaders["Instances"], glm::vec3(1, 1, 0), glm::vec3(0.1f));
    }
}


void Lab3::FrameEnd()
{
    DrawCoordinateSystem();
}


/*
 *  These are callback functions. To find more about callbacks and
 *  how they behave, see `input_controller.h`.
 */


void Lab3::OnInputUpdate(float deltaTime, int mods)
{
    // Treat continuous update based on input with window->KeyHold()

    // TODO(student): Add events for modifying the shrinking parameter
    constexpr float shrinkSpeed = 0.5f;
    constexpr float maxShrink = 0.9f;

    // Z shrinks every triangle towards its centroid; X restores it.
    if (window->KeyHold(GLFW_KEY_Z)) {
        shrink += shrinkSpeed * deltaTime;
    }
    if (window->KeyHold(GLFW_KEY_X)) {
        shrink -= shrinkSpeed * deltaTime;
    }

    // Do not allow degenerate or inverted triangles.
    shrink = glm::clamp(shrink, 0.0f, maxShrink);

}


void Lab3::OnKeyPress(int key, int mods)
{
    // Add key press event

    if ((key == GLFW_KEY_EQUAL || key == GLFW_KEY_KP_ADD) && nrInstances < maxInstances)
    {
        nrInstances++;
    }

    // Keep at least eight instances: two complete columns of four.
    if ((key == GLFW_KEY_MINUS || key == GLFW_KEY_KP_SUBTRACT) && nrInstances > 8)
    {
        nrInstances--;
    }
}


void Lab3::OnKeyRelease(int key, int mods)
{
    // Add key release event
}


void Lab3::OnMouseMove(int mouseX, int mouseY, int deltaX, int deltaY)
{
    // Add mouse move event
}


void Lab3::OnMouseBtnPress(int mouseX, int mouseY, int button, int mods)
{
    // Add mouse button press event
}


void Lab3::OnMouseBtnRelease(int mouseX, int mouseY, int button, int mods)
{
    // Add mouse button release event
}


void Lab3::OnMouseScroll(int mouseX, int mouseY, int offsetX, int offsetY)
{
    // Treat mouse scroll event
}


void Lab3::OnWindowResize(int width, int height)
{
    // Treat window resize event
}
