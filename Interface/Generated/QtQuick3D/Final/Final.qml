import QtQuick
import QtQuick3D

Node {
    id: node

    // Resources
    PrincipledMaterial {
        id: node248_247_237_material
        objectName: "248,247,237"
        baseColor: "#fff8f7ed"
        indexOfRefraction: 1
    }

    // Nodes:
    Node {
        id: final_obj
        objectName: "Final.obj"
        Model {
            id: aleta
            objectName: "Aleta"
            source: "meshes/aleta_mesh.mesh"
            materials: [
                node248_247_237_material
            ]
        }
        Model {
            id: node1
            objectName: "1"
            source: "meshes/node1_mesh.mesh"
            materials: [
                node248_247_237_material
            ]
        }
        Model {
            id: node2
            objectName: "2"
            source: "meshes/node2_mesh.mesh"
            materials: [
                node248_247_237_material
            ]
        }
        Model {
            id: node3
            objectName: "3"
            source: "meshes/node3_mesh.mesh"
            materials: [
                node248_247_237_material
            ]
        }
        Model {
            id: body1
            objectName: "Body1"
            source: "meshes/body1_mesh.mesh"
            materials: [
                node248_247_237_material
            ]
        }
        Model {
            id: node1__1_
            objectName: "1 (1)"
            source: "meshes/node1__1__mesh.mesh"
            materials: [
                node248_247_237_material
            ]
        }
        Model {
            id: node2__1_
            objectName: "2 (1)"
            source: "meshes/node2__1__mesh.mesh"
            materials: [
                node248_247_237_material
            ]
        }
        Model {
            id: body2
            objectName: "Body2"
            source: "meshes/body2_mesh.mesh"
            materials: [
                node248_247_237_material
            ]
        }
    }

    // Animations:
}
