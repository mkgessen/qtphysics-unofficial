import Qt3D 2.0
import Qt3D.Renderer 2.0
import QtPhysics.unofficial 1.0
import QtQuick 2.0 as QQ2
import Qt3D.Input 2.0




Entity {
    id: sceneRoot
    objectName: "Root"
    Camera {
        id: camera
        projectionType: CameraLens.PerspectiveProjection
        fieldOfView: 45
        aspectRatio: 16/9
        nearPlane : 0.1
        farPlane : 1000.0
        position: Qt.vector3d( 0.0, 0.0, -40.0 )
        upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
        viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
    }

    Configuration  {
        controlledCamera: camera
    }

    MouseController {
        id: mouseController
    }
    components: [
        FrameGraph {
            activeFrameGraph: Viewport {
                id: viewport
                rect: Qt.rect(0, 0.0, 1.0, 1.0) // From Top Left
                clearColor: Qt.rgba(0, 0.5, 1, 1)

                CameraSelector {
                    id : cameraSelector
                    camera: camera

                    ClearBuffer {
                        buffers : ClearBuffer.ColorDepthBuffer
                    }
                }
            }
        },
        PhysicsWorldInfo{
          gravity: Qt.vector3d(0,-10,0)
          debug:true
        }
    ]

    CylinderMesh {
        id: torusMesh
        /*radius: 2
        minorRadius: 1
        rings: 50
        slices: 50*/
        radius:4
        length: 10
    }

    Transform {
        id: torusTransform
        /*Rotate{
            axis: Qt.vector3d(1,0,0)
            angle: 2
        }*/
        Translate{
            id:torusTranslate
        }
    }

    PhysicsBodyInfo{
        id:torusBodyinfo
        mass:1
        restitution: 1
        inputTransform: torusTransform
        onCollided: {console.log(event.contactPointOnBody)}

    }

    Entity {
        id: torusEntity
        objectName: "torus"

        property MouseInput mouseInput : MouseInput {
                    controller: mouseController

                    onReleased: {
                        switch (mouse.button) {
                        case Qt.LeftButton:
                            torusTranslate.setDy(10+Math.random());
                            break;
                        }
                    }
                }


        components: [ torusMesh, torusBodyinfo, torusBodyinfo.outputTransform,mouseInput ]
    }

    Transform {
        id: torusTransform2
       Translate{
           //dx:20
           dy:50
           dz:0.5
       }
    }
    TorusMesh {
        id: torusMesh2
        radius: 2
        minorRadius: 1
        rings: 100
        slices: 20
    }

    PhysicsBodyInfo{
        id:torusBodyinfo2
        mass:1
        restitution: 1
        inputTransform: torusTransform2
    }

    SphereMesh {
        id: sphereMesh
        radius: 3
    }

    Transform {
        id: sphereTransform
        Translate{
            dx:20
            dy:-5
        }
    }
    PhysicsBodyInfo{
        id:sphereBody
        restitution: 1
        kinematic:false
        mass:1
        inputTransform: sphereTransform
    }

    Entity {
        objectName: "Sphere"
        id: sphereEntity
        components: [ sphereMesh, sphereBody, sphereBody.outputTransform ]
        Entity{
            id: torusEntity2
            objectName: "torus2"
            components: [ torusMesh, torusBodyinfo2, torusBodyinfo2.outputTransform ]
        }
    }


    /*Floor is an entity non renderable
    but defined by the shape details*/
    Entity{
        objectName: "Floor"
        Transform{
            id:transformFloor
            Translate{
                dy: -10
            }
        }
        PhysicsBodyInfo{
            id:floorBodyInfo
            restitution: 1
            inputTransform: transformFloor
            shapeDetails:{"Type":"StaticPlane","PlaneConstant":0,"PlaneNormal": Qt.vector3d(0, 1, 0) }
        }
        components: [transformFloor,floorBodyInfo]
    }



}
