import QtQuick
import QtQuick3D

Node {
    id: node

    // Resources

    // Nodes:
    Node {
        id: cohete11_obj
        objectName: "cohete11.obj"
        Model {
            id: rocket14
            objectName: "rocket14"
            source: "meshes/rocket14_mesh.mesh"
            materials: [
                material_001_material
            ]
        }
    }

    Node {
        id: __materialLibrary__

        Texture {
            id: c__Users_usuario_negativo_Interface_InterfaceContent_images_skincohete_jpeg_texture
            objectName: "C:/Users/usuario/negativo/Interface/InterfaceContent/images/skincohete.jpeg"
            generateMipmaps: true
            mipFilter: Texture.Linear
            source: "maps/skincohete.jpeg"
        }

        PrincipledMaterial {
            id: material_001_material
            objectName: "Material.001"
            baseColor: "#ff999999"
            baseColorMap: c__Users_usuario_negativo_Interface_InterfaceContent_images_skincohete_jpeg_texture
        }
    }

    // Animations:
}
