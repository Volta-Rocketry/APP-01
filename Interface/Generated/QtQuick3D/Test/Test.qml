import QtQuick
import QtQuick3D

Node {
    id: node

    // Resources

    // Nodes:
    Node {
        id: test_obj
        objectName: "Test.obj"
        Model {
            id: body1
            objectName: "Body1"
            source: "meshes/body1_mesh.mesh"
            materials: [
                steel___Satin_material
            ]
        }
    }

    Node {
        id: __materialLibrary__

        PrincipledMaterial {
            id: steel___Satin_material
            objectName: "Steel_-_Satin"
            baseColor: "#ffa0a0a0"
            indexOfRefraction: 1
        }
    }

    // Animations:
}
