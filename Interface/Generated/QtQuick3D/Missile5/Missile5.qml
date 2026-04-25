import QtQuick
import QtQuick3D
import Generated.QtQuick3D.Final_Assembly_OBJ

Node {
    id: node

    // Resources
    PrincipledMaterial {
        id: wire_177026088_material
        objectName: "wire_177026088"
        baseColor: "#ff999999"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: wire_214228153_material
        objectName: "wire_214228153"
        baseColor: "#ff999999"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: wire_196088225_material
        objectName: "wire_196088225"
        baseColor: "#ff999999"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: wire_229166215_material
        objectName: "wire_229166215"
        baseColor: "#ff999999"
        indexOfRefraction: 1
    }
    PrincipledMaterial {
        id: wire_134110008_material
        objectName: "wire_134110008"
        baseColor: "#ff999999"
        indexOfRefraction: 1
    }

    // Nodes:
    Node {
        id: missile5_obj
        objectName: "missile5.obj"
        Model {
            id: support02
            objectName: "support02"
            source: "meshes/support02_mesh.mesh"
            materials: [
                wire_177026088_material
            ]
        }
        Model {
            id: gear
            objectName: "gear"
            source: "meshes/gear_mesh.mesh"
            materials: [
                wire_214228153_material
            ]
        }
        Model {
            id: wing_A
            objectName: "wing_A"
            source: "meshes/wing_A_mesh.mesh"
            materials: [
                wire_196088225_material
            ]
        }
        Model {
            id: wing_02
            objectName: "wing_02"
            source: "meshes/wing_02_mesh.mesh"
            materials: [
                wire_229166215_material
            ]
        }
        Model {
            id: gear01
            objectName: "gear01"
            source: "meshes/gear01_mesh.mesh"
            materials: [
                wire_214228153_material
            ]
        }
        Model {
            id: wing_1
            objectName: "wing_1"
            source: "meshes/wing_1_mesh.mesh"
            materials: [
                wire_229166215_material
            ]
        }
        Model {
            id: wing_D
            objectName: "wing_D"
            source: "meshes/wing_D_mesh.mesh"
            materials: [
                wire_196088225_material
            ]
        }
        Model {
            id: support
            objectName: "support"
            source: "meshes/support_mesh.mesh"
            materials: [
                wire_177026088_material
            ]
        }
        Model {
            id: support01
            objectName: "support01"
            source: "meshes/support01_mesh.mesh"
            materials: [
                wire_177026088_material
            ]
        }
        Model {
            id: wing_C
            objectName: "wing_C"
            source: "meshes/wing_C_mesh.mesh"
            materials: [
                wire_196088225_material
            ]
        }
        Model {
            id: wing_B
            objectName: "wing_B"
            source: "meshes/wing_B_mesh.mesh"
            materials: [
                wire_196088225_material
            ]
        }
        Model {
            id: sphere01
            objectName: "Sphere01"
            source: "meshes/sphere01_mesh.mesh"
            materials: [
                wire_134110008_material
            ]
        }
        Model {
            id: body
            y: -10
            objectName: "body"
            source: "meshes/body_mesh.mesh"
            materials: [
                wire_177026088_material
            ]
        }
        Model {
            id: wing_03
            objectName: "wing_03"
            source: "meshes/wing_03_mesh.mesh"
            materials: [
                wire_229166215_material
            ]
        }
        Model {
            id: gear02
            objectName: "gear02"
            source: "meshes/gear02_mesh.mesh"
            materials: [
                wire_214228153_material
            ]
        }
        Model {
            id: wing_04
            objectName: "wing_04"
            source: "meshes/wing_04_mesh.mesh"
            materials: [
                wire_229166215_material
            ]
        }
        Model {
            id: gear03
            objectName: "gear03"
            source: "meshes/gear03_mesh.mesh"
            materials: [
                wire_214228153_material
            ]
        }
    }

    Node {
        id: __materialLibrary__
    }

    // Animations:
}
