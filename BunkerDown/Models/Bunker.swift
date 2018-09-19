//
//  Bunker.swift
//  BunkerDown
//
//  Created by Andre Burgoyne on 2018-09-19.
//  Copyright © 2018 Andre Burgoyne. All rights reserved.
//

import Foundation
import SceneKit

class Bunker {
    
    class func getBunkerForName(bunkerName: String) -> SCNNode {
        switch bunkerName {
        case "race":
            return Bunker.getRace()
        case "miniRace":
            return Bunker.getMiniRace()
        case "cakeTall":
            return Bunker.getCakeTall()
        case "cakeSmall":
            return Bunker.getCakeSmall()
        default:
            return Bunker.getRace()
        }
    }
    
    class func getRace() -> SCNNode {
        let obj = SCNScene(named: "art.scnassets/PSP.dae")
        let node = obj?.rootNode.childNode(withName: "race", recursively: true)!
        node?.scale = SCNVector3Make(0.10, 0.10, 0.10)
        node?.position = SCNVector3Make(-1.7, 0.8, -1)
        return node!
    }
    
    class func getMiniRace() -> SCNNode {
        let obj = SCNScene(named: "art.scnassets/MiniRace.dae")
        let node = obj?.rootNode.childNode(withName: "miniRace", recursively: true)!
        node?.scale = SCNVector3Make(0.185, 0.185, 0.185)
        node?.position = SCNVector3Make(-0.35, 0.85, -1)
        return node!
    }
    
    class func getCakeTall() -> SCNNode {
        let obj = SCNScene(named: "art.scnassets/CakeTall.dae")
        let node = obj?.rootNode.childNode(withName: "cakeTall", recursively: true)!
        node?.scale = SCNVector3Make(0.185, 0.185, 0.185)
        node?.position = SCNVector3Make(-1.7, 0.05, -1)
        return node!
    }
    
    class func getCakeSmall() -> SCNNode {
        let obj = SCNScene(named: "art.scnassets/CakeSmall.dae")
        let node = obj?.rootNode.childNode(withName: "cakeSmall", recursively: true)!
        node?.scale = SCNVector3Make(0.185, 0.185, 0.185)
        node?.position = SCNVector3Make(-0.35, 0.24, -1)
        return node!
    }
    
    class func startRotation(node: SCNNode) {
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.01 * Double.pi), z: 0, duration: 0.1))
        node.runAction(rotate)
    }
}
