//
//  Ramp.swift
//  ramp-up-arkit
//
//  Created by Arsalan majlesi on 7/9/21.
//

import Foundation
import SceneKit

enum RampType: String{
    case pipe = "pipe"
    case pyramid = "pyramid"
    case quarter = "quarter"
}

class Ramp {
    
    class func getRamp(byName name:String) -> SCNNode {
        switch name {
        case "pipe":
            return nodeObject(withSceneName: "art.scnassets/pipe.dae", andObjName: "pipe", withPosition: SCNVector3Make(1, 0.5, -1), andScale: SCNVector3Make(0.0022, 0.0022, 0.002))
        case "pyramid":
            return nodeObject(withSceneName: "art.scnassets/pyramid.dae", andObjName: "pyramid", withPosition: SCNVector3Make(1, -0.85, -1), andScale: SCNVector3Make(0.0065, 0.0065, 0.0065))
        case "quarter":
            return nodeObject(withSceneName: "art.scnassets/quarter.dae", andObjName: "quarter", withPosition: SCNVector3Make(1, -2.55, -1), andScale: SCNVector3Make(0.0055, 0.0055, 0.0055))
        default :
            return SCNNode()
        }
    }
    
    class func nodeObject(withSceneName sceneName:String,andObjName objName:String,withPosition position:SCNVector3,andScale scale:SCNVector3) -> SCNNode{
        let obj = SCNScene(named: sceneName)!
        let node = obj.rootNode.childNode(withName: objName, recursively: true)!
        node.scale = scale
        node.position = position
        return node
    }
    
    class func rotateObject(object :SCNNode){
        let rotateAnim = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.1 * Double.pi), z: 0, duration: 0.5))
        object.runAction(rotateAnim)
    }
}
